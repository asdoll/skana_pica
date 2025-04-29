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
  RxBool filterMenu = false.obs;
  RxBool isDrag = false.obs;
  RxInt loadedPage = 0.obs;

  get sortType => settings.pica[4];

  ComicListController({
    required this.keyword,
    this.isAuthor = false,
    this.isSearch = false,
    this.addToHistory = true,
    this.type = "",
    required this.sortByDefault,
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
    await Future.delayed(const Duration(milliseconds: 1000));

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

  Future<void> onLoad() async {
    isDrag.value = true;
    log.d(
        "keyword: $keyword, page: ${page.value}, total: ${total.value}, isLoading: ${isLoading.value}");
    if (page.value == total.value) {
      log.d("No more data");
      return;
    }
    if (isLoadin()) {
      return;
    }
    if(page.value <= loadedPage.value) {
      page.value++;
    }
    await loadData().then((value) async {
      if (value.success) {
        total.value = value.subData;
        addWithFilter(value.data);
        loadedPage.value = page.value;
        isLoading.value = false;
        isDrag.value = false;
      } else {
        showToast("Failed to load data".tr);
        isLoading.value = false;
        isDrag.value = false;
      }
    });
  }

  Future<void> reset({bool drag = false}) async {
    isDrag.value = drag;
    comics.clear();
    if(keyword == "leaderboard") {
      page.value = 1;
      total.value = 0;
      loadedPage.value = 0;
    }
    isLoading.value = false;
    await loadData().then((value) async {
      if (value.success) {
        loadedPage.value = 1;
        total.value = value.subData;
        addWithFilter(value.data);
        isLoading.value = false;
        isDrag.value = drag;
      } else {
        showToast("Failed to load data".tr);
        isLoading.value = false;
        isDrag.value = drag;
      }
    });
  }

  void resetWithSort(int sort) async {
    this.sort.value = sort;
    await reset();
  }

  void pageFetch(int page) async {
    if (isLoadin()) {
      return;
    }
    if (page > total.value || page < 1) {
      return;
    }
    this.page.value = page;
    await reset();
  }

}

class LeaderboardController extends GetxController {
  var items = ["H24", "D7", "D30"];
  var type = "H24".obs;
}

LeaderboardController leaderboardController = Get.put(LeaderboardController());
