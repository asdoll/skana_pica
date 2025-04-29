import 'package:get/get.dart';
import 'package:skana_pica/api/comic_sources/picacg/pica_api.dart';
import 'package:skana_pica/api/comic_sources/picacg/pica_models.dart';
import 'package:skana_pica/api/managers/history_manager.dart';
import 'package:skana_pica/api/models/objectbox_models.dart';
import 'package:skana_pica/controller/comiclist.dart';
import 'package:skana_pica/controller/setting_controller.dart';

class HistoryController extends GetxController {
  RxList<VisitHistory> history = <VisitHistory>[].obs;
  RxList<PicaComicItemBrief> comics = <PicaComicItemBrief>[].obs;
  RxInt total = 0.obs;
  RxBool isLoading = false.obs;

  int perPage = 10;
  RxInt page = 0.obs;
  RxInt totalPage = 0.obs;

  Future<bool> init() async {
    if (isLoading.value) {
      return false;
    }
    isLoading.value = true;
    await M.o.getVisitHistoryCount().then((value) async {
      total.value = value;
      totalPage.value = (total.value / perPage).ceil();
      page.value = 0;
      history.clear();
      var val =
          await M.o.getVisitHistoryByOffset(page.value * perPage, perPage);
      history.addAll(val);
      history.refresh();
      comics.clear();
      await fetchComic();
      comics.refresh();
    });
    isLoading.value = false;
    return true;
  }

  // next page if index is -1
  Future<bool> toPage({int index = -1}) async {
    //log.d("index: $index, totalPage: ${totalPage.value}");
    if (isLoading.value) {
      return false;
    }
    if (index >= totalPage.value) {
      return false;
    }
    if (index != -1) {
      page.value = index;
    } else {
      if (page.value + 1 >= totalPage.value) {
        return false;
      }
      page++;
    }
    isLoading.value = true;
    history.clear();
    var value =
        await M.o.getVisitHistoryByOffset(page.value * perPage, perPage);
    history.addAll(value);
    history.refresh();
    await fetchComic();
    isLoading.value = false;
    comics.refresh();
    return true;
  }

  Future<bool> fetchComic() async {
    if (mangaSettingsController.picaPageViewMode.value) comics.clear();
    for (int i = 0; i < history.length; i++) {
      var item = await M.o.getComicHistory(history[i].comicid);
      if (item != null) {
        comics.add(item.toBrief());
        continue;
      }
      var res = await picaClient.getBriefComicInfo(history[i].comicid);
      if (!res.error) {
        comics.add(res.data);
      } else {
        comics.add(PicaComicItemBrief.error());
      }
    }
    return true;
  }

  Future<void> removeHistory() async {
    M.o.removeAllHistory();
    M.o.removeAllHistoryItem();
    comics.clear();
    history.clear();
    visitHistoryController.clear();
    comics.refresh();
    history.refresh();
  }
}

class VisitHistoryController extends GetxController {
  RxMap<String, VisitHistory> history = <String, VisitHistory>{}.obs;

  void fallback() {
    Get.find<ComicListController>();
  }

  void init() {
    M.o.getVisitHistory().then((value) {
      history.clear();
      for (var e in value) {
        history[e.comicid] = e;
      }
      history.refresh();
    });
  }

  Future<VisitHistory?> fetchVisitHistory(String id) async {
    var item = await M.o.getVisitHistoryByComic(id);
    if (item != null) {
      history[id] = item;
      return item;
    } else {
      return null;
    }
  }

  void updateVisitHistory(String id, int eps, int index) {
    VisitHistory? item = history[id];
    if (item != null) {
      item.lastEps = eps;
      item.lastIndex = index;
      M.o.addVisitHistory(item);
    } else {
      item = VisitHistory(
          comicid: id,
          lastEps: eps,
          lastIndex: index,
          timestamp: DateTime.now().millisecondsSinceEpoch.toString());
      M.o.addVisitHistory(item);
    }
    history[id] = item;
  }

  void clear() {
    history.clear();
    history.refresh();
  }
}

late VisitHistoryController visitHistoryController;
