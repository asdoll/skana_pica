import 'package:get/get.dart';
import 'package:skana_pica/api/comic_sources/picacg/pica_api.dart';
import 'package:skana_pica/api/comic_sources/picacg/pica_models.dart';
import 'package:skana_pica/config/setting.dart';
import 'package:skana_pica/controller/blocker.dart';
import 'package:skana_pica/controller/history.dart';
import 'package:skana_pica/util/leaders.dart';
import 'package:skana_pica/util/log.dart';

get errorUrl => errorLoadingUrl;

class ComicListController extends GetxController {
  RxList<PicaComicItemBrief> comics = <PicaComicItemBrief>[].obs;
  RxBool isLoading = false.obs;
  RxInt page = 1.obs;
  RxInt total = 0.obs;
  bool isAuthor = false;
  String keyword = "";
  RxString sort = "".obs;
  bool isSearch = false;
  bool addToHistory = true;
  RxString type = "".obs;

  bool fetch() {
    if (isLoading.value) {
      return true;
    }
    isLoading.value = true;
    sort.value = sort.value.isEmpty ? appdata.pica[4] : sort.value;
    if (isSearch) {
      picaClient
          .search(keyword, sort.value, page.value, addToHistory: addToHistory)
          .then((value) {
        if (value.error) {
          isLoading.value = false;
          toast("Failed to load data".tr);
          return false;
        }
        total.value = value.subData;
        addWithFilter(value.data);
        isLoading.value = false;
      });
      comics.refresh();
      return true;
    }
    log.d("keyword: $keyword, page: ${page.value}, sort: ${sort.value}, type: ${type.value}");
    picaClient
        .getCategoryComics(
            keyword,
            page.value,
            sort.value,
            isAuthor
                ? "a"
                : keyword == "leaderboard"
                    ? type.value
                    : "c")
        .then((value) {
      if (value.error) {
        isLoading.value = false;
        toast("Failed to load data".tr);
        return false;
      }
      total.value = value.subData;
      addWithFilter(value.data);
      isLoading.value = false;
    });
    comics.refresh();
    return true;
  }

  void addWithFilter(List<PicaComicItemBrief> list) {
    list.removeWhere((element) => blocked(element));
    addHistory(list);
    comics.addAll(list);
    comics.refresh();
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

  bool onLoad() {
    if (isLoading.value) {
      return true;
    }
    page.value++;
    return fetch();
  }

  bool init(String keyword,
      {String sort = "",
      bool isAuthor = false,
      int page = 1,
      bool addToHistory = false,
      bool isSearch = false,
      String type = ""}) {
    this.keyword = keyword;
    this.isAuthor = isAuthor;
    this.addToHistory = addToHistory;
    this.isSearch = isSearch;
    sort.isEmpty ? this.sort.value = appdata.pica[4] : this.sort.value = sort;
    this.page.value = page;
    this.type.value = type;
    comics.clear();
    return fetch();
  }

  bool pageFetch(int page) {
    if (isLoading.value) {
      return true;
    }
    if (page > total.value || page < 1) {
      return false;
    }
    this.page.value = page;
    comics.clear();
    return fetch();
  }

  bool reload(bool pageReset) {
    comics.clear();
    if (pageReset) page.value = 1;
    isLoading.value = false;
    return fetch();
  }
}
