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

import 'setting_controller.dart';

get errorUrl => errorLoadingUrl;

class ComicListController extends GetxController {
  RxList<PicaComicItemBrief> comics = <PicaComicItemBrief>[].obs;
  RxBool isLoading = false.obs;
  RxInt page = 1.obs;
  RxInt total = 0.obs;
  bool isAuthor;
  String keyword;
  RxString sort = "".obs;
  String sortByDefault;
  bool isSearch;
  bool addToHistory;
  String type;
  int lastFetchTime = 0;
  EasyRefreshController? easyRefreshController;
  int loadedPage = 0;

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
    sort.value = sort.value.isEmpty ? settings.pica[4] : sort.value;
    if (isSearch) {
      log.d("search: $keyword, page: ${page.value}, sort: ${sort.value}");
      return picaClient
          .search(keyword, sort.value, page.value, addToHistory: addToHistory);
    }
    log.d(
        "keyword: $keyword, page: ${page.value}, sort: ${sort.value}, type: $type");
    return picaClient
        .getCategoryComics(
            keyword,
            page.value,
            sort.value,
            isAuthor
                ? "a"
                : keyword == "leaderboard"
                    ? type
                    : "c");
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
    if(loadedPage > page.value) {
      page.value = loadedPage;
    }
    if(page.value == loadedPage) {
      page.value++;
    }
    loadData().then((value) {
      isLoading.value = false;
      if (value.success) {
        loadedPage++;
        total.value = value.subData;
        addWithFilter(value.data);
        easyRefreshController?.finishLoad();
      } else {
        showToast("Failed to load data".tr);
        easyRefreshController?.finishLoad(IndicatorResult.fail);
      }
    });
  }

  void reset({String? newSort}) {
    sort.value = newSort ?? sort.value;
    comics.clear();
    if(!mangaSettingsController.picaPageViewMode.value || keyword == "leaderboard") {
      page.value = 1;
      total.value = 0;
    }
    loadedPage = 0;
    isLoading.value = false;
    loadData().then((value) {
      isLoading.value = false;
      if (value.success) {
        total.value = value.subData;
        addWithFilter(value.data);
        easyRefreshController?.finishRefresh();
      } else {
        showToast("Failed to load data".tr);
        easyRefreshController?.finishRefresh(IndicatorResult.fail);
      }
    });
  }

  void pageFetch(int page) {
    if (isLoadin()) {
      return;
    }
    if (page > total.value || page < 1) {
      return;
    }
    this.page.value = page;
    reset();
  }

}
