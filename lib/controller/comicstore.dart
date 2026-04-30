import 'dart:math';

import 'package:easy_localization/easy_localization.dart'
    show StringTranslateExtension;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:skana_pica/api/comic_sources/picacg/pica_api.dart';
import 'package:skana_pica/api/comic_sources/picacg/pica_models.dart';
import 'package:skana_pica/api/managers/history_manager.dart';
import 'package:skana_pica/api/managers/image_cache_manager.dart';
import 'package:skana_pica/api/models/objectbox_models.dart' show DownloadTask;
import 'package:skana_pica/config/setting.dart';
import 'package:skana_pica/controller/downloadstore.dart';
import 'package:skana_pica/controller/favourite.dart';
import 'package:skana_pica/controller/history.dart';
import 'package:skana_pica/util/leaders.dart';
import 'package:skana_pica/controller/log.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'comicstore.g.dart';
part 'comicstore.freezed.dart';

enum ComicStoreSource {
  online,
  local,
}

@freezed
abstract class ComicStoreState with _$ComicStoreState {
  const factory ComicStoreState(
      {required PicaComicItem comic,
      @Default([]) List<PicaEpsImages> epsList,
      required PicaComments comments,
      DownloadTask? task,
      @Default(false) bool isLoading,
      @Default(false) bool isDrag,
      @Default(false) bool readModeMenu,
      @Default(false) bool barVisible,
      @Default(false) bool disableTap,
      @Default(false) bool useDarkBackground,
      @Default(0) int currentEps,
      @Default(0) int currentIndex,
      @Default(0) int readMode,
      @Default(0) int imageLayout,
      @Default(false) bool limitImageWidth,
      @Default(0) int tapThreshold,
      @Default(0) int autoPageTurningInterval,
      @Default(0) int orientation,
      @Default(0) int animationDuration,
      @Default(false) bool autoPageTurning,
      PageController? autoPagingPageController,
      ItemScrollController? autoPagingScrollController,
      @Default({}) Map<int, bool> selectDownload}) = _ComicStoreState;
}

@riverpod
class ComicStore extends _$ComicStore {
  @override
  ComicStoreState build(String id,
      [ComicStoreSource source = ComicStoreSource.online]) {
    return ComicStoreState(
      comic: PicaComicItem.error(id),
      comments: PicaComments([], id, 1, 0, 0),
      useDarkBackground: settings.useDarkBackground,
      readMode: int.parse(settings.read[2]),
      imageLayout: int.parse(settings.read[1]),
      limitImageWidth: settings.read[0] == "1",
      tapThreshold: int.parse(settings.read[4]),
      autoPageTurningInterval: int.parse(settings.read[6]),
      orientation: int.parse(settings.read[5]),
      animationDuration: int.parse(settings.read[7]),
    );
  }

  void setPage(int eps, int index) {
    state = state.copyWith(
      currentEps: eps,
      currentIndex: index,
    );
  }

  void setIndex(int index){
    state = state.copyWith(
      currentIndex: index,
    );
  }

  void setEps(int index){
    state = state.copyWith(
      currentEps: index,
    );
  }

  void setMenu([bool v = false]) => state = state.copyWith(readModeMenu: v);

  void nextChapter({PageController? controller, bool duo = false}) {
    if (state.currentEps < state.epsList.length - 1) {
      state = state.copyWith(
        currentEps: state.currentEps + 1,
        currentIndex: 0,
      );
      log.t('next current index: ${state.currentIndex}');
      if (duo) {
        controller?.jumpToPage(1);
      } else {
        controller?.animateToPage(
          1,
          duration: Duration(milliseconds: state.animationDuration),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  void prevChapter({PageController? controller, bool duo = false}) {
    if (state.currentEps > 0) {
      state = state.copyWith(
        currentEps: state.currentEps - 1,
        currentIndex: state.epsList[state.currentEps - 1].imageUrl.length - 1,
      );
      if (duo) {
        state = state.copyWith(currentIndex: 0);
        log.t('pre current index: ${state.currentIndex}');
        controller?.jumpToPage(1);
      } else {
        log.t('pre current index: ${state.currentIndex}');
        controller?.animateToPage(
          state.currentIndex + 1,
          duration: Duration(milliseconds: state.animationDuration),
          curve: Curves.easeInOut,
        );
      }
    } else {
      state = state.copyWith(currentIndex: 0);
      controller?.animateToPage(
        1,
        duration: Duration(milliseconds: state.animationDuration),
        curve: Curves.easeInOut,
      );
    }
  }

  int calcItemCount() {
    final len = state.epsList[state.currentEps].imageUrl.length;
    int count = len ~/ 2;
    if (len % 2 != 0) {
      count++;
    }
    return count;
  }

  void nextPage({PageController? controller, bool duo = false}) {
    if (state.currentIndex <
        state.epsList[state.currentEps].imageUrl.length - 1) {
      state = state.copyWith(
        currentIndex: duo ? state.currentIndex + 2 : state.currentIndex + 1,
      );
      controller?.animateToPage(
        controller.page!.round() + 1,
        duration: Duration(milliseconds: state.animationDuration),
        curve: Curves.easeInOut,
      );
    } else {
      nextChapter(controller: controller, duo: duo);
    }
  }

  void prevPage({PageController? controller, bool duo = false}) {
    if (state.currentIndex > 1) {
      state = state.copyWith(
        currentIndex: duo ? state.currentIndex - 2 : state.currentIndex - 1,
      );
      controller?.animateToPage(
        controller.page!.round() - 1,
        duration: Duration(milliseconds: state.animationDuration),
        curve: Curves.easeInOut,
      );
    } else {
      prevChapter(controller: controller, duo: duo);
    }
  }

  void nextScroll({ItemScrollController? controller}) {
    if (state.currentIndex <
        state.epsList[state.currentEps].imageUrl.length - 1) {
      state = state.copyWith(currentIndex: state.currentIndex + 1);
      controller?.scrollTo(
        index: state.currentIndex + 1,
        duration: Duration(milliseconds: state.animationDuration),
        curve: Curves.easeInOut,
      );
    } else {
      nextChapter();
    }
  }

  void setDarkBackground(bool dark) {
    state = state.copyWith(useDarkBackground: dark);
    settings.useDarkBackground = dark;
  }

  void setReadMode(int mode) {
    state = state.copyWith(readMode: mode);
    settings.read[2] = mode.toString();
    settings.updateSettings("read");
  }

  void setImageLayout(int layout) {
    state = state.copyWith(imageLayout: layout);
    settings.read[1] = layout.toString();
    settings.updateSettings("read");
    showToast("re_enter_to_take_effect".tr());
  }

  void setLimitImageWidth(bool limit) {
    state = state.copyWith(limitImageWidth: limit);
    settings.read[0] = limit ? "1" : "0";
    settings.updateSettings("read");
    showToast("re_enter_to_take_effect".tr());
  }

  void setTapThreshold(int threshold) {
    state = state.copyWith(tapThreshold: threshold);
    settings.read[4] = threshold.toString();
    settings.updateSettings("read");
  }

  void readInit(PageController pageController,
      ItemScrollController itemScrollController) {
    if (state.readMode > 4) {
      pageController =
          PageController(initialPage: (state.currentIndex ~/ 2) + 1);
    } else {
      pageController = PageController(
          initialPage: state.currentIndex + 1,
          viewportFraction: 1.0,
          keepPage: true);
    }
    state = state.copyWith(
        autoPageTurning: false,
        barVisible: false,
        autoPagingPageController: pageController,
        autoPagingScrollController: itemScrollController);
    orientationChanged();
  }

  void setAutoPageTurning() {
    state = state.copyWith(autoPageTurning: !state.autoPageTurning);
    if (state.autoPageTurning) {
      autoPageTurningStart();
    } else {
      autoPageTurningStop();
    }
  }

  void setAutoPageTurningInterval(int interval) {
    state = state.copyWith(autoPageTurningInterval: interval);
    settings.read[6] = interval.toString();
    settings.updateSettings("read");
  }

  void setOrientation() {
    state = state.copyWith(orientation: (state.orientation + 1) % 3);
    settings.read[5] = state.orientation.toString();
    settings.updateSettings("read");
    orientationChanged();
  }

  void orientationChanged() {
    if (state.orientation == 0) {
      SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    } else if (state.orientation == 1) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
  }

  void setBarVisible() {
    state = state.copyWith(barVisible: !state.barVisible);
  }

  void setAnimationDuration(int duration) {
    state = state.copyWith(animationDuration: duration);
    settings.read[7] = duration.toString();
    settings.updateSettings("read");
  }

  void autoPageTurningStart() {
    showToast("auto_page_turning_started".tr());
    autoPageTurningTask();
  }

  void autoPageTurningTask() async {
    if (state.epsList.isEmpty) {
      return;
    }
    if (state.currentIndex ==
        state.epsList[state.currentEps].imageUrl.length - 1) {
      autoPageTurningStop();
      return;
    }
    int sec = state.autoPageTurningInterval;
    for (int i = 0; i < sec * 10; i++) {
      await Future.delayed(const Duration(milliseconds: 100));
      if (!state.autoPageTurning) {
        return;
      }
    }
    log.i("Auto page turning");
    if (state.readMode == 4) {
      if (state.autoPagingScrollController != null) {
        nextScroll(controller: state.autoPagingScrollController);
      }
    } else {
      if (state.autoPagingPageController != null) {
        nextPage(
            controller: state.autoPagingPageController,
            duo: state.readMode > 4);
      }
    }
    autoPageTurningTask();
  }

  void autoPageTurningStop() {
    state = state.copyWith(autoPageTurning: false);
    showToast("auto_page_turning_stopped".tr());
  }

  void fetch({PicaComicItemBrief? comic, DownloadTask? t}) {
    if (state.isLoading) {
      return;
    }
    if ((source == ComicStoreSource.local && t == null) ||
        (source == ComicStoreSource.online && comic == null)) {
      log.e("wrong fetch type!");
      return;
    }
    state = state.copyWith(isLoading: true);
    if (source == ComicStoreSource.local) {
      state = state.copyWith(
        task: t,
        comic: t!.comic.target!.toComicItem(),
        epsList: t.taskEps.map((e) => e.toPicaEpsImages()).toList(),
      );
      fetchVisitHistory().then((value) {
        state = state.copyWith(isLoading: false);
      });
    } else {
      picaClient.getComicInfo(id).then((value) {
        if (value.error) {
          showToast("failed_to_load_data".tr());
          state = state.copyWith(
            comic: PicaComicItem.error(id),
            isLoading: false,
          );
          return;
        }
        state = state.copyWith(comic: value.data);

        if (state.comic.isFavourite) {
          ref.read(favorProvider.notifier).addFavor(id);
        } else {
          ref.read(favorProvider.notifier).removeFavor(id);
        }
        M.o.addHistoryWithCheck(value.data);
        fetchVisitHistory().then((e) async {
          state = state.copyWith(isLoading: false);
          await fetchEps(value.data);
          fastPreLoad();
          await fetchComments();
        });
      });
    }
  }

  void toggleLike() {
    picaClient.likeOrUnlikeComic(id).then((value) {
      if (!value) {
        showToast("network_error".tr());
        return;
      }
      final comic = state.comic;
      comic.isLiked = !comic.isLiked;
      state = state.copyWith(comic: comic);
    });
  }

  Future<void> fetchVisitHistory() async {
    final comic = state.comic;

    final history = await ref
        .read(visitHistoryControllerProvider.notifier)
        .fetchVisitHistory(comic.id);
    if (history == null) return;
    state = state.copyWith(
      currentEps: history.lastEps,
      currentIndex: history.lastIndex,
    );
  }

  Future<void> fetchEps(PicaComicItem comic) async {
    if (state.isLoading) {
      return;
    }

    state = state.copyWith(isLoading: true);

    final epsList = List<PicaEpsImages>.generate(
      comic.eps.length,
      (index) => PicaEpsImages("", []),
      growable: false,
    );

    final results = await Future.wait(
      [
        for (int i = 0; i < comic.eps.length; i++)
          picaClient.getComicContent(comic.id, i + 1)
      ],
    );

    for (int i = 0; i < results.length; i++) {
      final value = results[i];

      if (value.error) {
        log.e("Failed to load comic content: ${comic.title}/${comic.eps[i]}");
        continue;
      }

      log.t("Comic eps loaded: $i/${comic.eps[i]}");
      epsList[i] = PicaEpsImages(comic.eps[i], value.data);
    }

    state = state.copyWith(
      epsList: epsList,
      isLoading: false,
    );
  }

  Future<void> fetchComments() async {
    if (state.isLoading) {
      state = state.copyWith(isDrag: false);
      return;
    }

    state = state.copyWith(isLoading: true);

    final value = await picaClient.getComments(id);
    state = state.copyWith(
      comments: value,
      isDrag: false,
      isLoading: false,
    );
  }

  Future<void> initComments({bool dragging = false}) async {
    state = state.copyWith(
      isDrag: dragging,
      comments: PicaComments([], "", 1, 0, 0),
    );
    await fetchComments();
  }

  Future<bool> loadMoreComments() async {
    if (state.isLoading) {
      return true;
    }

    state = state.copyWith(
      isDrag: true,
      isLoading: true,
    );

    final comments = state.comments;
    if (comments.comments.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        isDrag: false,
      );
      return false;
    }

    if (comments.pages > comments.loaded) {
      comments.loaded++;
    }

    final value = await picaClient.loadMoreComments(comments);

    if (value.error) {
      state = state.copyWith(
        isLoading: false,
        isDrag: false,
      );
      return false;
    }

    if (value.data) {
      state = state.copyWith(comments: comments);
    }

    state = state.copyWith(
      isDrag: false,
      isLoading: false,
    );
    return true;
  }

  void preLoad({int? eps, int? index}) {
    eps ??= state.currentEps;
    index ??= state.currentIndex;

    if (state.epsList.isEmpty) {
      return;
    }
    if (eps < 0 || eps >= state.epsList.length) {
      return;
    }
    if (state.epsList[eps].imageUrl.isEmpty) {
      return;
    }

    int preLength = int.parse(settings.pica[7]);
    if (settings.read[2] == "5" || settings.read[2] == "6") {
      preLength *= 2;
    }
    for (int i = index;
        i < min(state.epsList[eps].imageUrl.length, index + preLength);
        i++) {
      imagesCacheManager
          .getImageFile(state.epsList[eps].imageUrl[i])
          .listen((event) {
        if (event is FileInfo) {
          log.t("Image loaded: comic${state.epsList[eps!].eps}, $eps/$i");
        }
      });
    }
  }

  int findIndex(String eps) {
    for (int i = 0; i < state.epsList.length; i++) {
      if (state.epsList[i].eps == eps) {
        return i;
      }
    }
    return -1;
  }

  void fastPreLoad() {
    if (settings.pica[8] == "1") {
      preLoad();
    }
  }

  void selectDownloads(int index) {
    final selected = Map<int, bool>.from(state.selectDownload);

    if (selected.containsKey(index)) {
      selected.remove(index);
    } else {
      selected[index] = true;
    }

    state = state.copyWith(selectDownload: selected);
  }

  void selectDownloadsAll() {
    final selected = Map<int, bool>.from(state.selectDownload);

    if (selected.length == state.epsList.length) {
      selected.clear();
    } else {
      selected.clear();
      for (int i = 0; i < state.epsList.length; i++) {
        selected[i] = true;
      }
    }

    state = state.copyWith(selectDownload: selected);
  }

  void download() {
    final selected = state.selectDownload.keys.toList();

    ref.read(downloadProvider.notifier).download(
          ref.read(downloadProvider.notifier).createTask(
                state.comic,
                selected,
                state.epsList,
              ),
        );
  }
}

final readModes = [
  "Left to Right",
  "Right to Left",
  "Top to Bottom",
  "Top to Bottom(Scroll view)",
  "Duo Page",
  "Duo Page(reversed)"
];
