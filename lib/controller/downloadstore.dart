import 'package:get/get.dart';
import 'package:skana_pica/api/comic_sources/picacg/pica_models.dart';
import 'package:skana_pica/api/managers/history_manager.dart';
import 'package:skana_pica/api/managers/image_cache_manager.dart';
import 'package:skana_pica/api/models/objectbox_models.dart';
import 'package:skana_pica/util/leaders.dart';

late DownloadStore downloadStore;

class DownloadStore extends GetxController {
  RxList<DownloadTask> tasks = <DownloadTask>[].obs;
  RxMap<int, int> progress = <int, int>{}.obs;
  RxMap<int, int> total = <int, int>{}.obs;

  RxMap<int, bool> stop = <int, bool>{}.obs;

  Future<void> restore() async {
    tasks.clear();
    var list = await M.o.restoreDownload();
    for (var task in list) {
      tasks.add(task);
      restoreProgress(task);
    }
    tasks.refresh();
  }

  Future<void> addTask(DownloadTask task) async {
    for (int i = 0; i < tasks.length; i++) {
      if (tasks[i].comic.target!.comicid == task.comic.target!.comicid) {
        mergeTask(i, task);
        await M.o.addDownloadTask(task);
        return;
      }
    }
    tasks.add(task);
    restoreProgress(task);
    tasks.refresh();
    await M.o.addDownloadTask(task);
  }

  Future<void> removeTask(int id) async {
    tasks.removeWhere((element) => element.id == id);
    progress.remove(id);
    total.remove(id);
    tasks.refresh();
    await M.o.removeDownloadTask(id);
  }

  void stopTask(int id) {
    for (var task in tasks) {
      if (task.id == id) {
        removeTask(id);
      }
    }
    stop[id] = true;
    stop.refresh();
  }

  void mergeTask(int index, DownloadTask task) {
    for (int i = 0; i < task.taskEps.length; i++) {
      if (tasks[index]
              .taskEps
              .indexWhere((element) => element.eps == task.taskEps[i].eps) ==
          -1) {
        tasks[index].taskEps.add(task.taskEps[i]);
      }
    }
    tasks[index].comic.target = task.comic.target;
    task = tasks[index];
    restoreProgress(task);
    tasks.refresh();
  }

  Future<void> updateTask(DownloadTask task) async {
    int index = tasks.indexWhere((element) => element.id == task.id);
    if (index != -1) {
      tasks[index] = task;
      tasks.refresh();
      await M.o.addDownloadTask(task);
    }
    if (progress[task.id] == total[task.id]) {
      removeTask(task.id);
      toast('${"Download".tr} "${task.comic.target!.title}" ${"Finished".tr}');
    }
  }

  DownloadTask createTask(
      PicaComicItem comic, List<int> tasklist, List<PicaEpsImages> eList) {
    DownloadTask task = DownloadTask(DateTime.now().millisecondsSinceEpoch);
    task.comic.target = PicaHistoryItem.withItem(comic);
    List<DownloadEps> epsList = [];
    for (int e in tasklist) {
      epsList.add(DownloadEps(e, eList[e].imageUrl,
          List.generate(eList[e].imageUrl.length, (_) => 0)));
    }
    task.taskEps.addAll(epsList);
    addTask(task);
    return task;
  }

  void restoreProgress(DownloadTask task) {
    int restoredProgress = 0;
    int total = 0;
    for (int i = 0; i < task.taskEps.length; i++) {
      for (int j = 0; j < task.taskEps[i].url.length; j++) {
        if (task.taskEps[i].progress[j] == 1) {
          restoredProgress++;
        }
        total++;
      }
    }
    progress[task.id] = restoredProgress;
    progress.refresh();
    this.total[task.id] = total;
    this.total.refresh();
  }

  void download(DownloadTask task) {
    bool isError = false;
    toast('${"Download".tr} "${task.comic.target!.title}"');
    for (int i = 0; i < task.taskEps.length; i++) {
      for (int j = 0; j < task.taskEps[i].url.length; j++) {
        if (stop[task.id] == true) {
          stop[task.id] = false;
          return;
        }
        if (task.taskEps[i].progress[j] == 1) {
          continue;
        }
        downloadCacheManager.getSingleFile(task.taskEps[i].url[j]).then(
            (value) {
          task.taskEps[i].progress[j] = 1;
          progress[task.id] = progress[task.id]! + 1;
          progress.refresh();
          updateTask(task);
        }, onError: (e) {
          isError = true;
        });
      }
    }
    if (isError) {
      toast("Download Error".tr);
    }
  }
}

class DownloadController extends GetxController {
  RxList<DownloadTask> tasks = <DownloadTask>[].obs;
  RxBool isLoading = false.obs;
  RxInt total = 0.obs;

  int perPage = 20;
  RxInt page = 0.obs;
  RxInt totalPage = 0.obs;
  RxBool isList = false.obs;

  void fetch() {
    if (isLoading.value) {
      return;
    }
    isLoading.value = true;
    M.o.getDownloadTaskCount().then((value) async {
      total.value = value;
      totalPage.value = (total.value / perPage).ceil();
      page.value = 0;
      tasks.clear();
      var val = await M.o
          .getDownloadTaskListWithOffset(page.value * perPage, perPage);
      tasks.addAll(val);
      tasks.refresh();
    });
    isLoading.value = false;
  }

  void toPage({int index = -1}) {
    if (isLoading.value) {
      return;
    }
    if (index >= totalPage.value) {
      return;
    }
    if (index != -1) {
      page.value = index;
    } else {
      if (page.value + 1 >= totalPage.value) {
        return;
      }
      page++;
    }
    isLoading.value = true;
    tasks.clear();
    M.o
        .getDownloadTaskListWithOffset(page.value * perPage, perPage)
        .then((value) {
      tasks.addAll(value);
      tasks.refresh();
    });
    isLoading.value = false;
  }

  void removeTask(int id) {
    if (downloadStore.progress[id] != null) {
      downloadStore.removeTask(id);
    } else {
      M.o.removeDownloadTask(id);
      tasks.removeWhere((element) => element.id == id);
      tasks.refresh();
    }
  }
}
