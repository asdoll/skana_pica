import 'package:easy_localization/easy_localization.dart'
    show StringTranslateExtension;
import 'package:skana_pica/api/comic_sources/picacg/pica_api.dart';
import 'package:skana_pica/api/comic_sources/picacg/pica_models.dart';
import 'package:skana_pica/api/models/res.dart';
import 'package:skana_pica/config/setting.dart';
import 'package:skana_pica/controller/history.dart';
import 'package:skana_pica/util/leaders.dart';
import 'package:skana_pica/controller/log.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'comiclist.g.dart';
part 'comiclist.freezed.dart';

String get errorUrl => errorLoadingUrl;

@freezed
abstract class ComicListState with _$ComicListState {
  const factory ComicListState({
    @Default([]) List<PicaComicItemBrief> comics,
    @Default(false) bool isLoading,
    @Default(1) int page,
    @Default(0) int total,
    @Default(false) bool isDrag,
    @Default(0) int loadedPage,
    @Default(0) int lastFetchTime,
    @Default(0) int sort,
    @Default(false) bool filterMenu,
  }) = _ComicListState;
}

@riverpod
class Leaderboard extends _$Leaderboard {
  static const items = ["H24", "D7", "D30"];
  @override
  String build() {
    return "H24";
  }

  void setType(String value) {
    state = value;
  }
}

@riverpod
class ComicList extends _$ComicList {
  @override
  ComicListState build({
    required String keyword,
    bool isAuthor = false,
    bool isSearch = false,
    bool addToHistory = true,
    String type = "",
    required String sortByDefault,
  }) {
    return const ComicListState();
  }

  void closeMenu() {
    state = state.copyWith(filterMenu: false);
  }

  void toggleMenu() {
    state = state.copyWith(filterMenu: !state.filterMenu);
  }

  bool isLoadin() {
    return state.isLoading &&
        DateTime.now().millisecondsSinceEpoch - state.lastFetchTime < 5000;
  }

  String getSort() {
    return state.sort == 0
        ? "dd"
        : state.sort == 1
            ? "da"
            : state.sort == 2
                ? "ld"
                : "vd";
  }

  Future<void> loadData() async {
    if (isLoadin()) {
      return;
    }

    state = state.copyWith(
      isLoading: true,
      lastFetchTime: DateTime.now().millisecondsSinceEpoch,
    );

    final currentPage = state.page;
    final currentKeyword = keyword;
    final currentSort = getSort();

    Future<Res<List<PicaComicItemBrief>>> future;

    if (isSearch) {
      log.d("search: $currentKeyword, page: $currentPage, sort: ${state.sort}");
      future = picaClient.search(
        currentKeyword,
        currentSort,
        currentPage,
        addToHistory: addToHistory,
      );
    } else {
      var currentType = type;
      log.d(
          "keyword: $currentKeyword, page: $currentPage, sort: ${state.sort}, type: $currentType");

      if (currentKeyword == "leaderboard") {
        try {
          currentType = ref.read(leaderboardProvider);
        } catch (e) {
          currentType = "";
        }
      }

      future = picaClient.getCategoryComics(
        currentKeyword,
        currentPage,
        currentSort,
        isAuthor
            ? "a"
            : currentKeyword == "leaderboard"
                ? currentType
                : "c",
      );
    }

    try {
      final value = await future;

      if (!value.success) {
        showToast("failed_to_load_data".tr());
        state = state.copyWith(
          isLoading: false,
          isDrag: false,
        );
        return;
      }

      state = state.copyWith(
        total: value.subData,
        loadedPage: currentPage,
        isLoading: false,
        isDrag: false,
      );

      addWithFilter(value.data);
    } catch (e) {
      showToast("failed_to_load_data".tr());
      state = state.copyWith(
        isLoading: false,
        isDrag: false,
      );
    }
  }

  void addWithFilter(List<PicaComicItemBrief> list) {
    final comics = List<PicaComicItemBrief>.from(state.comics);

    for (var comic in list) {
      if (blocked(comic)) {
        continue;
      }
      if (containsComic(comic)) {
        continue;
      }
      ref
          .read(visitHistoryControllerProvider.notifier)
          .fetchVisitHistory(comic.id);
      comics.add(comic);
    }

    state = state.copyWith(comics: comics);
  }

  bool containsComic(PicaComicItemBrief comic) {
    for (var item in state.comics) {
      if (item.id == comic.id) return true;
    }
    return false;
  }

  void addHistory(List<PicaComicItemBrief> list) {
    for (var item in list) {
      ref
          .read(visitHistoryControllerProvider.notifier)
          .fetchVisitHistory(item.id);
    }
  }

  bool blocked(PicaComicItemBrief comic) {
    if (settings.blockingKeyword.contains(comic.author)) return true;
    for (var tag in comic.tags) {
      if (settings.blockingKeyword.contains(tag)) return true;
    }
    for (var tag in comic.tags) {
      if (settings.blockedCategory.contains(tag)) return true;
    }
    for (var kw in settings.blockingKeyword) {
      if (comic.title.contains(kw)) return true;
    }
    return false;
  }

  void onLoad() {
    state = state.copyWith(isDrag: true);

    log.d(
        "keyword: $keyword, page: ${state.page}, total: ${state.total}, isLoading: ${state.isLoading}");

    if (state.page == state.total) {
      log.d("No more data");
      return;
    }

    if (isLoadin()) {
      return;
    }

    if (state.page <= state.loadedPage) {
      state = state.copyWith(page: state.page + 1);
    }

    loadData();
  }

  Future<void> reset({bool drag = false}) async {
    state = state.copyWith(isDrag: drag);

    if (keyword == "leaderboard" || !settings.isPageView) {
      state = state.copyWith(
        page: 1,
        total: 0,
        loadedPage: 0,
      );
    }

    state = state.copyWith(
      isLoading: false,
      comics: const [],
    );

    await loadData();
  }

  void resetWithSort(int sort) {
    state = state.copyWith(sort: sort);
    reset();
  }

  void pageFetch(int page) {
    if (isLoadin()) {
      return;
    }
    if (page > state.total || page < 1) {
      return;
    }

    state = state.copyWith(page: page);
    reset();
  }
}
