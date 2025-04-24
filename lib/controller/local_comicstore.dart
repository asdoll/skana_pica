import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:skana_pica/api/comic_sources/picacg/pica_models.dart';
import 'package:skana_pica/api/models/objectbox_models.dart';
import 'package:skana_pica/config/setting.dart';
import 'package:skana_pica/controller/history.dart';
import 'package:skana_pica/util/leaders.dart';
import 'package:skana_pica/controller/log.dart';

class LocalComicStore extends GetxController {
  Rx<DownloadTask> task = DownloadTask(0).obs;
  Rx<PicaHistoryItem> comic = PicaHistoryItem.withItem(PicaComicItem.error("")).obs;
  RxList<DownloadEps> eps = <DownloadEps>[].obs;
  RxInt dldEps = 0.obs;
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

  void fetch(DownloadTask t){
    task.value = t;
    comic.value = t.comic.target!;
    eps.value = t.taskEps;
    fetchVisitHistory().then((value) {
      dldEps.listen((value) {
        visitHistoryController.updateVisitHistory(comic.value.comicid, eps[value].eps, currentIndex.value);
      });
      currentIndex.listen((value) {
        visitHistoryController.updateVisitHistory(comic.value.comicid, eps[dldEps.value].eps, value);
      });
    });
  }

  Future<void> fetchVisitHistory() async {
    var history =
        await visitHistoryController.fetchVisitHistory(comic.value.comicid);
    if (history == null) return;
    for(int i = 0; i < eps.length; i++){
      if(eps[i].eps == history.lastEps){
        dldEps.value = i;
        currentIndex.value = history.lastIndex;
        break;
      }
    }
  }

  void setPage(int dldEps, int currentIndex){
    this.dldEps.value = dldEps;
    this.currentIndex.value = currentIndex;
  }

  
  void nextChapter({PageController? controller, bool duo = false}) {
    if (dldEps.value < eps.length - 1) {
      dldEps.value++;
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
    if (dldEps.value > 0) {
      dldEps.value--;
      currentIndex.value = eps[dldEps.value].url.length - 1;
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
    int count = eps[dldEps.value].url.length ~/ 2;
    if (eps[dldEps.value].url.length % 2 != 0) {
      count++;
    }
    return count;
  }

  void nextPage({PageController? controller, bool duo = false}) {
    if (currentIndex.value < eps[dldEps.value].url.length - 1) {
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
    if (currentIndex.value < eps[dldEps.value].url.length - 1) {
      currentIndex.value++;
      controller?.scrollTo(
          index: currentIndex.value + 1,
          duration: Duration(milliseconds: animationDuration.value),
          curve: Curves.easeInOut);
    } else {
      nextChapter();
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
    autoPageTurningTask();
  }

  void autoPageTurningTask() async {
    if (currentIndex.value == eps[dldEps.value].url.length - 1) {
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
  }
}