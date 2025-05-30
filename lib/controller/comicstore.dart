import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:skana_pica/api/comic_sources/picacg/pica_api.dart';
import 'package:skana_pica/api/comic_sources/picacg/pica_models.dart';
import 'package:skana_pica/api/managers/history_manager.dart';
import 'package:skana_pica/api/managers/image_cache_manager.dart';
import 'package:skana_pica/config/setting.dart';
import 'package:skana_pica/controller/downloadstore.dart';
import 'package:skana_pica/controller/favourite.dart';
import 'package:skana_pica/controller/history.dart';
import 'package:skana_pica/util/leaders.dart';
import 'package:skana_pica/controller/log.dart';

class ComicStore extends GetxController {
  RxList<PicaEpsImages> epsList = <PicaEpsImages>[].obs;
  RxBool isLoading = false.obs;

  Rx<PicaComicItem> comic = PicaComicItem.error("").obs;

  Rx<PicaComments> comments = PicaComments([], "", 1, 0, 0).obs;

  RxBool isDrag = false.obs;

  RxInt currentEps = 0.obs;

  RxInt currentIndex = 0.obs;

  RxBool useDarkBackground = settings.useDarkBackground.obs;

  RxInt readMode = int.parse(settings.read[2]).obs;

  RxBool readModeMenu = false.obs;

  RxInt imageLayout = int.parse(settings.read[1]).obs;

  RxBool limitImageWidth = (settings.read[0] == "1").obs;

  RxInt tapThreshold = int.parse(settings.read[4]).obs;

  RxBool autoPageTurning = false.obs;

  RxInt autoPageTurningInterval = int.parse(settings.read[6]).obs;

  RxInt orientation = int.parse(settings.read[5]).obs;

  RxBool barVisible = false.obs;

  RxInt animationDuration = int.parse(settings.read[7]).obs;

  PageController? autoPagingPageController;

  ItemScrollController? autoPagingScrollController;

  RxMap<int, bool> selectDownload = <int, bool>{}.obs;

  RxBool disableTap = false.obs;

  void fetch(String id) async {
    if (isLoading.value) {
      return;
    }
    isLoading.value = true;
    picaClient.getComicInfo(id).then((value) {
      if (value.error) {
        showToast("Failed to load data".tr);
        comic.value = PicaComicItem.error(id);
        isLoading.value = false;
        comic.refresh();
        return;
      }
      comic.value = value.data;
      if (comic.value.isFavourite &&
          !favorController.favorComics.contains(value.data.id)) {
        favorController.addFavor(value.data.id);
      }
      if (!comic.value.isFavourite &&
          favorController.favorComics.contains(value.data.id)) {
        favorController.removeFavor(value.data.id);
      }
      comic.refresh();
      isLoading.value = false;
      M.o.addHistoryWithCheck(value.data);
      fetchVisitHistory().then((e) {
        fetchEps(value.data);
        fetchComments();
        fastPreLoad();
        currentEps.listen((value) {
          visitHistoryController.updateVisitHistory(
              comic.value.id, value, currentIndex.value);
        });
        currentIndex.listen((value) {
          visitHistoryController.updateVisitHistory(
              comic.value.id, currentEps.value, value);
        });
      });
    });
  }

  void toggleLike() {
    picaClient.likeOrUnlikeComic(comic.value.id).then((value) {
      if (!value) {
        showToast("Network Error".tr);
        return;
      }
      comic.value.isLiked = !comic.value.isLiked;
      comic.refresh();
    });
  }

  Future<void> fetchVisitHistory() async {
    var history =
        await visitHistoryController.fetchVisitHistory(comic.value.id);
    if (history == null) return;
    currentEps.value = history.lastEps;
    currentIndex.value = history.lastIndex;
  }

  void toggleFavorite() {
    picaClient.favouriteOrUnfavouriteComic(comic.value.id).then((value) {
      if (!value) {
        showToast("Network Error".tr);
        return;
      }
      if (comic.value.isFavourite) {
        favorController.removeFavor(comic.value.id);
      } else {
        favorController.addFavor(comic.value.id);
      }
      comic.value.isFavourite = !comic.value.isFavourite;
      comic.refresh();
    });
  }

  void fetchEps(PicaComicItem comic) async {
    if (isLoading.value) {
      return;
    }
    isLoading.value = true;
    epsList = List.generate(comic.eps.length, (index) => PicaEpsImages("", []),
            growable: false)
        .obs;
    for (int i = 0; i < comic.eps.length; i++) {
      picaClient.getComicContent(comic.id, i + 1).then((value) {
        if (value.error) {
          log.e("Failed to load comic content: ${comic.title}/${comic.eps[i]}");
          epsList.refresh();
          isLoading.value = false;
          return;
        }
        log.t("Comic eps loaded: $i/${comic.eps[i]}");
        epsList[i] = PicaEpsImages(comic.eps[i], value.data);
      });
    }
    isLoading.value = false;
    epsList.refresh();
  }

  Future<void> fetchComments() async {
    if (isLoading.value) {
      isDrag.value = false;
      return;
    }
    isLoading.value = true;
    await picaClient.getComments(comic.value.id).then((value) {
      comments.value = value;
      comments.refresh();
    });
    isDrag.value = false;
    isLoading.value = false;
  }

  Future<void> initComments({bool dragging = false}) async {
    isDrag.value = dragging;
    comments.value = PicaComments([], "", 1, 0, 0);
    await fetchComments();
  }

  Future<bool> loadMoreComments() async {
    if (isLoading.value) {
      return true;
    }
    isDrag.value = true;
    isLoading.value = true;
    if (comments.value.pages > comments.value.loaded) {
      comments.value.loaded++;
    }
    await picaClient.loadMoreComments(comments.value).then((value) {
      if (value.error) {
        isLoading.value = false;
        isDrag.value = false;
        return false;
      }
      if (value.data) comments.refresh();
      isDrag.value = false;
      isLoading.value = false;
    });
    return true;
  }

  void preLoad({int? eps, int? index}) {
    if (eps == null || eps < 0) {
      eps = currentEps.value;
    }
    if (index == null || index < 0) {
      index = currentIndex.value;
    }
    if (epsList[eps].imageUrl.isEmpty) {
      return;
    }
    epsList[eps].loaded = index;
    int preLength = int.parse(settings.pica[7]);
    if (settings.read[2] == "5" || settings.read[2] == "6") {
      preLength *= 2;
    }
    for (int i = index;
        i < min(epsList[eps].imageUrl.length, index + preLength);
        i++) {
      imagesCacheManager.getImageFile(epsList[eps].imageUrl[i]).listen((event) {
        if (event is FileInfo) {
          log.t("Image loaded: comic${epsList[eps!].eps}, $eps/$i");
        }
      });
      epsList[eps].loaded = i;
    }
  }

  int findIndex(String eps) {
    for (int i = 0; i < epsList.length; i++) {
      if (epsList[i].eps == eps) {
        return i;
      }
    }
    return -1;
  }

  void setPage(int eps, int index) {
    currentEps.value = eps;
    currentIndex.value = index;
  }

  void nextChapter({PageController? controller, bool duo = false}) {
    if (currentEps.value < epsList.length - 1) {
      currentEps.value++;
      currentIndex.value = 0;
      log.t('next current index: ${currentIndex.value}');
      if (duo) {
        controller?.jumpToPage(1);
      } else {
        controller?.animateToPage(1,
            duration: Duration(milliseconds: animationDuration.value),
            curve: Curves.easeInOut);
      }
    }
  }

  void prevChapter({PageController? controller, bool duo = false}) {
    if (currentEps.value > 0) {
      currentEps.value--;
      currentIndex.value = epsList[currentEps.value].imageUrl.length - 1;
      if (duo) {
        currentIndex.value = 0;
        log.t('pre current index: ${currentIndex.value}');
        controller?.jumpToPage(1);
      } else {
        log.t('pre current index: ${currentIndex.value}');
        controller?.animateToPage(currentIndex.value + 1,
            duration: Duration(milliseconds: animationDuration.value),
            curve: Curves.easeInOut);
      }
    } else {
      currentIndex.value = 0;
      controller?.animateToPage(1,
          duration: Duration(milliseconds: animationDuration.value),
          curve: Curves.easeInOut);
    }
  }

  int calcItemCount() {
    int count = epsList[currentEps.value].imageUrl.length ~/ 2;
    if (epsList[currentEps.value].imageUrl.length % 2 != 0) {
      count++;
    }
    return count;
  }

  void nextPage({PageController? controller, bool duo = false}) {
    if (currentIndex.value < epsList[currentEps.value].imageUrl.length - 1) {
      if (duo) {
        currentIndex.value += 2;
      } else {
        currentIndex.value++;
      }
      controller?.animateToPage(controller.page!.round() + 1,
          duration: Duration(milliseconds: animationDuration.value),
          curve: Curves.easeInOut);
    } else {
      nextChapter(controller: controller, duo: duo);
    }
  }

  void prevPage({PageController? controller, bool duo = false}) {
    if (currentIndex.value > 1) {
      if (duo) {
        currentIndex.value -= 2;
      } else {
        currentIndex.value--;
      }
      controller?.animateToPage(controller.page!.round() - 1,
          duration: Duration(milliseconds: animationDuration.value),
          curve: Curves.easeInOut);
    } else {
      prevChapter(controller: controller, duo: duo);
    }
  }

  void nextScroll({ItemScrollController? controller}) {
    if (currentIndex.value < epsList[currentEps.value].imageUrl.length - 1) {
      currentIndex.value++;
      controller?.scrollTo(
          index: currentIndex.value + 1,
          duration: Duration(milliseconds: animationDuration.value),
          curve: Curves.easeInOut);
    } else {
      nextChapter();
    }
  }

  void fastPreLoad() {
    if (settings.pica[8] == "1") {
      preLoad();
    }
  }

  void setDarkBackground(bool dark) {
    useDarkBackground.value = dark;
    settings.useDarkBackground = dark;
  }

  void setReadMode(int mode) {
    readMode.value = mode;
    settings.read[2] = mode.toString();
    settings.updateSettings("read");
  }

  void setImageLayout(int layout) {
    imageLayout.value = layout;
    settings.read[1] = layout.toString();
    settings.updateSettings("read");
    showToast("Re-enter to take effect".tr);
  }

  void setLimitImageWidth(bool limit) {
    limitImageWidth.value = limit;
    settings.read[0] = limit ? "1" : "0";
    settings.updateSettings("read");
    showToast("Re-enter to take effect".tr);
  }

  void setTapThreshold(int threshold) {
    tapThreshold.value = threshold;
    settings.read[4] = threshold.toString();
    settings.updateSettings("read");
  }

  void setAutoPageTurning() {
    autoPageTurning.value = !autoPageTurning.value;
    if (autoPageTurning.value) {
      autoPageTurningStart(
          autoPagingPageController, autoPagingScrollController);
    } else {
      autoPageTurningStop();
    }
  }

  void setAutoPageTurningInterval(int interval) {
    autoPageTurningInterval.value = interval;
    settings.read[6] = interval.toString();
    settings.updateSettings("read");
  }

  void setOrientation() {
    orientation.value = (orientation.value + 1) % 3;
    settings.read[5] = orientation.toString();
    settings.updateSettings("read");
    orientationChanged();
  }

  void orientationChanged() {
    if (orientation.value == 0) {
      SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    } else if (orientation.value == 1) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    } else {
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    }
  }

  void setBarVisible() {
    barVisible.value = !barVisible.value;
  }

  void setAnimationDuration(int duration) {
    animationDuration.value = duration;
    settings.read[7] = duration.toString();
    settings.updateSettings("read");
  }

  void autoPageTurningStart(
      PageController? controller, ItemScrollController? scrollController) {
    autoPagingPageController = controller;
    autoPagingScrollController = scrollController;
    showToast("Auto page turning started".tr);
    autoPageTurningTask();
  }

  void autoPageTurningTask() async {
    if (currentIndex.value == epsList[currentEps.value].imageUrl.length - 1) {
      autoPageTurningStop();
      return;
    }
    int sec = autoPageTurningInterval.value;
    for (int i = 0; i < sec * 10; i++) {
      await Future.delayed(const Duration(milliseconds: 100));
      if (!autoPageTurning.value) {
        return;
      }
    }
    log.i("Auto page turning");
    if (readMode.value == 4) {
      if (autoPagingScrollController != null) {
        nextScroll(controller: autoPagingScrollController);
      }
    } else {
      if (autoPagingPageController != null) {
        nextPage(controller: autoPagingPageController, duo: readMode.value > 4);
      }
    }
    autoPageTurningTask();
  }

  void autoPageTurningStop() {
    autoPageTurning.value = false;
    showToast("Auto page turning stopped".tr);
  }

  void selectDownloads(int index) {
    if (selectDownload.containsKey(index)) {
      selectDownload.remove(index);
    } else {
      selectDownload[index] = true;
    }
    selectDownload.refresh();
  }

  void selectDownloadsAll() {
    if (selectDownload.length == epsList.length) {
      selectDownload.clear();
    } else {
      for (int i = 0; i < epsList.length; i++) {
        selectDownload[i] = true;
      }
    }
    selectDownload.refresh();
  }

  void download() {
    List<int> selected = selectDownload.keys.toList();
    downloadStore
        .download(downloadStore.createTask(comic.value, selected, epsList));
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
