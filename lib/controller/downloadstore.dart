import 'package:get/get.dart';
import 'package:skana_pica/api/comic_sources/picacg/pica_models.dart';
import 'package:skana_pica/api/managers/history_manager.dart';
import 'package:skana_pica/api/managers/image_cache_manager.dart';
import 'package:skana_pica/api/models/objectbox_models.dart';
import 'package:skana_pica/config/setting.dart';
import 'package:skana_pica/util/leaders.dart';
import 'package:skana_pica/controller/log.dart';

late DownloadStore downloadStore;

class DownloadStore extends GetxController {
  RxList<DownloadTask> tasks = <DownloadTask>[].obs;
  RxMap<int, int> progress = <int, int>{}.obs;
  RxMap<int, int> total = <int, int>{}.obs;

  RxMap<int, bool> stop = <int, bool>{}.obs;
  RxMap<int, bool> working = <int, bool>{}.obs;

  Future<void> restore() async {
    tasks.clear();
    //log.i(await M.o.getDownloadTaskCount());
    var list = await M.o.getDownloadTaskList();
    for (var task in list) {
      tasks.add(task);
      //log.i(task.taskEps.map((e) => e.progress).toList());
      restoreProgress(task);
    }
    tasks.refresh();
    //logAll();
  }

  void logAll() {
    log.t("DownloadStore");
    for (var task in tasks) {
      log.t(task.id);
    }
    for (var p in progress.entries) {
      log.t("progress ${p.key} ${p.value}");
    }
  }

  Future<void> addTask(DownloadTask task) async {
    for (int i = 0; i < tasks.length; i++) {
      if (tasks[i].comic.target!.comicid == task.comic.target!.comicid) {
        mergeTask(i, task);
        await M.o.addDownloadTask(tasks[i]);
        return;
      }
    }

    await M.o.addDownloadTask(task);
    tasks.add(task);
    restoreProgress(task);
    tasks.refresh();
  }

  Future<void> removeTask(int id) async {
    DownloadTask task = tasks.firstWhere((element) => element.id == id);
    for (int i = 0; i < task.taskEps.length; i++) {
      for (int j = 0; j < task.taskEps[i].url.length; j++) {
        await downloadCacheManager.removeFile(task.taskEps[i].url[j]);
      }
    }
    tasks.removeWhere((element) => element.id == id);
    progress.remove(id);
    total.remove(id);
    tasks.refresh();
    await M.o.removeDownloadTask(id);
  }

  void stopTask(int id) {
    stop[id] = true;
    stop.refresh();
    for (var task in tasks) {
      if (task.id == id) {
        removeTask(id);
      }
    }
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
    log.t("mergeTask ${task.id}");
    tasks[index].comic.target = task.comic.target;
    task = tasks[index];
    restoreProgress(task);
    tasks.refresh();
  }

  Future<void> updateTask(DownloadTask task) async {
    int index = tasks.indexWhere((element) => element.id == task.id);
    if (index != -1) {
      tasks[index] = task;
      log.i("updateTask ${tasks[index].taskEps.map((e) => e.progress).toList()}");
      tasks.refresh();
      M.o.updateTaskEps(task);
    }
    if (progress[task.id] == total[task.id]) {
      working.remove(task.id);
      working.refresh();
      showToast('${"Download".tr} "${task.comic.target!.title}" ${"Done".tr}');
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

  void continueTask(int id) {
    download(tasks.firstWhere((element) => element.id == id));
  }

  void restoreProgress(DownloadTask task) {
    int restoredProgress = 0;
    int total = 0;
    for (int i = 0; i < task.taskEps.length; i++) {
      for (int j = 0; j < task.taskEps[i].url.length; j++) {
        if (task.taskEps[i].progress[j] == 1) {
          restoredProgress++;
        }
      }
      total += task.taskEps[i].url.length;
    }
    progress[task.id] = restoredProgress;
    progress.refresh();
    this.total[task.id] = total;
    this.total.refresh();
  }

  void download(DownloadTask task) {
    bool isError = false;
    showToast('${"Download".tr} "${task.comic.target!.title}"');
    {
      working[task.id] = true;
      working.refresh();
      downloadCacheManager.getSingleFile(task.comic.target!.thumbUrl);
      downloadCacheManager.getSingleFile(task.comic.target!.creatorAvatarUrl);
    }
    log.t(task.id);
    for (int i = 0; i < task.taskEps.length; i++) {
      for (int j = 0; j < task.taskEps[i].url.length; j++) {
        if (stop[task.id] == true) {
          stop.remove(task.id);
          working.remove(task.id);
          working.refresh();
          return;
        }
        if (task.taskEps[i].progress[j] == 1) {
          continue;
        }
        downloadCacheManager.getSingleFile(task.taskEps[i].url[j]).then(
            (value) {
          task.taskEps[i].progress[j] = 1;
          if(progress[task.id] == null){
            progress[task.id] = 1;
          } else {
            progress[task.id] = progress[task.id]! + 1;
          }
          progress.refresh();
          updateTask(task);
        }, onError: (e) {
          isError = true;
        });
      }
    }
    if (isError) {
      showToast("Download Error".tr);
    }
  }

  void clear() {
    for (var task in tasks) {
      stopTask(task.id);
    }
    Duration(milliseconds: 20).delay(() {
      tasks.clear();
      progress.clear();
      total.clear();
      stop.clear();
      tasks.refresh();
      progress.refresh();
      total.refresh();
      stop.refresh();
    });
  }
}

class DownloadPageController extends GetxController {
  int perPage = 20;
  RxInt page = 0.obs;
  RxBool isList = (settings.pica[6] == "1").obs;
  
}
