import 'package:easy_refresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:skana_pica/api/comic_sources/picacg/pica_api.dart';
import 'package:skana_pica/api/comic_sources/picacg/pica_models.dart';
import 'package:skana_pica/api/models/res.dart';
import 'package:skana_pica/config/setting.dart';
import 'package:skana_pica/controller/blocker.dart';
import 'package:skana_pica/controller/history.dart';
import 'package:skana_pica/util/leaders.dart';
import 'package:skana_pica/controller/log.dart';


get errorUrl => errorLoadingUrl;

class ComicListController extends GetxController {
  RxList<PicaComicItemBrief> comics = <PicaComicItemBrief>[].obs;
  RxBool isLoading = false.obs;
  RxInt page = 1.obs;
  RxInt total = 0.obs;
  bool isAuthor;
  String keyword;
  RxInt sort = settings.picaSearchMode.obs;
  String sortByDefault;
  bool isSearch;
  bool addToHistory;
  String type;
  int lastFetchTime = 0;
  EasyRefreshController? easyRefreshController;
  RxBool filterMenu = false.obs;

  get sortType => settings.pica[4];

  ComicListController({
    required this.keyword,
    this.isAuthor = false,
    this.isSearch = false,
    this.addToHistory = true,
    this.type = "",
    required this.sortByDefault,
    this.easyRefreshController,
  });

  bool isLoadin() => isLoading.value && DateTime.now().millisecondsSinceEpoch - lastFetchTime < 5000;

  Future<Res<List<PicaComicItemBrief>>> loadData() async {
    if (isLoadin()) {
      return Res.error("Loading");
    }
    isLoading.value = true;
    lastFetchTime = DateTime.now().millisecondsSinceEpoch;
    if (isSearch) {
      log.d("search: $keyword, page: ${page.value}, sort: ${sort.value}");
      return picaClient
          .search(keyword, getSort(), page.value, addToHistory: addToHistory);
    }
    log.d(
        "keyword: $keyword, page: ${page.value}, sort: ${sort.value}, type: $type");
    if(keyword == "leaderboard") {
      try {
        type = Get.find<LeaderboardController>().type.value;
      } catch (e) {
        type = "";
      }
    }
    return picaClient
        .getCategoryComics(
            keyword,
            page.value,
            getSort(),
            isAuthor
                ? "a"
                : keyword == "leaderboard"
                    ? type
                    : "c");
  }

  String getSort() {
    return sort.value == 0 ? "dd" : sort.value == 1 ? "da" : sort.value == 2 ? "ld" : "vd";
  }

  void addWithFilter(List<PicaComicItemBrief> list) {
    for(var comic in list) {
      if(blocked(comic)) {
        continue;
      }
      if(containsComic(comic)) {
        continue;
      }
      visitHistoryController.fetchVisitHistory(comic.id);
      comics.add(comic);
    }
    comics.refresh();
  }

  bool containsComic(PicaComicItemBrief comic) {
    for(var item in comics) {
      if(item.id == comic.id) return true;
    }
    return false;
  }

  void addHistory(List<PicaComicItemBrief> list) {
    for (var item in list) {
      visitHistoryController.fetchVisitHistory(item.id);
    }
  }

  bool blocked(PicaComicItemBrief comic) {
    if (blocker.blockedKeywords.contains(comic.author)) return true;
    for (var tag in comic.tags) {
      if (blocker.blockedKeywords.contains(tag)) return true;
    }
    for (var tag in comic.tags) {
      if (blocker.blockedCategories.contains(tag)) return true;
    }
    for (var kw in blocker.blockedKeywords) {
      if (comic.title.contains(kw)) return true;
    }
    return false;
  }

  void onLoad() async {
    log.d(
        "keyword: $keyword, page: ${page.value}, total: ${total.value}, isLoading: ${isLoading.value}");
    if (page.value == total.value) {
      log.d("No more data");
      easyRefreshController?.finishLoad(IndicatorResult.noMore);
      return;
    }
    if (isLoadin()) {
      return;
    }
    page.value++;
    easyRefreshController?.finishLoad();
    easyRefreshController?.finishRefresh();
    loadData().then((value) {
      if (value.success) {
        total.value = value.subData;
        addWithFilter(value.data);
        easyRefreshController?.finishLoad();
        isLoading.value = false;
      } else {
        showToast("Failed to load data".tr);
        easyRefreshController?.finishLoad(IndicatorResult.fail);
        isLoading.value = false;
      }
    });
  }

  void reset() {
    comics.clear();
    easyRefreshController?.finishRefresh();
    easyRefreshController?.finishLoad();
    if(keyword == "leaderboard") {
      page.value = 1;
      total.value = 0;
    }
    isLoading.value = false;
    loadData().then((value) {
      if (value.success) {
        total.value = value.subData;
        addWithFilter(value.data);
        easyRefreshController?.finishRefresh();
        isLoading.value = false;
      } else {
        showToast("Failed to load data".tr);
        easyRefreshController?.finishRefresh(IndicatorResult.fail);
        isLoading.value = false;
      }
    });
  }

  void resetWithSort(int sort) {
    this.sort.value = sort;
    reset();
  }

  void pageFetch(int page) {
    if (isLoadin()) {
      return;
    }
    if (page > total.value || page < 1) {
      return;
    }
    this.page.value = page;
    easyRefreshController?.callRefresh();
  }

}

class LeaderboardController extends GetxController {
  var items = ["H24", "D7", "D30"];
  var type = "H24".obs;
}

LeaderboardController leaderboardController = Get.put(LeaderboardController());
