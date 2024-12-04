import 'dart:math';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:skana_pica/api/comic_sources/picacg/pica_api.dart';
import 'package:skana_pica/api/comic_sources/picacg/pica_models.dart';
import 'package:skana_pica/api/managers/image_cache_manage.dart';
import 'package:skana_pica/config/setting.dart';
import 'package:skana_pica/controller/favourite.dart';
import 'package:skana_pica/util/log.dart';

class ComicStore extends GetxController {
  RxList<PicaEpsImages> epsList = <PicaEpsImages>[].obs;
  RxBool isLoading = false.obs;

  Rx<PicaComicItem> comic = PicaComicItem.error("").obs;

  Rx<PicaComments> comments = PicaComments([], "", 1, 0, 0).obs;

  RxInt currentEps = 0.obs;

  RxInt currentIndex = 0.obs;

  void fetch(String id) async {
    if (isLoading.value) {
      return;
    }
    isLoading.value = true;
    picaClient.getComicInfo(id).then((value) {
      if (value.error) {
        BotToast.showText(text: "Failed to load data".tr);
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
      fetchEps(value.data);
      fetchComments();
    });
  }

  void toggleLike() {
    picaClient.likeOrUnlikeComic(comic.value.id).then((value) {
      if (!value) {
        BotToast.showText(text: "Network Error".tr);
        return;
      }
      comic.value.isLiked = !comic.value.isLiked;
      comic.refresh();
    });
  }

  void toggleFavorite() {
    picaClient.favouriteOrUnfavouriteComic(comic.value.id).then((value) {
      if (!value) {
        BotToast.showText(text: "Network Error".tr);
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
        log.i("Comic eps loaded: $i/${comic.eps[i]}");
        epsList[i] = PicaEpsImages(comic.eps[i], value.data);
      });
    }
    isLoading.value = false;
    epsList.refresh();
  }

  void fetchComments() {
    if (isLoading.value) {
      return;
    }
    isLoading.value = true;
    picaClient.getComments(comic.value.id).then((value) {
      comments.value = value;
      comments.refresh();
    });
    isLoading.value = false;
  }

  void initComments() {
    comments.value = PicaComments([], "", 1, 0, 0);
    fetchComments();
  }

  bool loadMoreComments() {
    if (isLoading.value) {
      return true;
    }
    isLoading.value = true;
    if (comments.value.pages > comments.value.loaded) {
      comments.value.loaded++;
    }
    picaClient.loadMoreComments(comments.value).then((value) {
      if (value.error) {
        isLoading.value = false;
        return false;
      }
      if (value.data) comments.refresh();
    });
    isLoading.value = false;
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
    int preLength = int.parse(appdata.pica[7]);
    if (appdata.read[2] == "5" || appdata.read[2] == "6") {
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
      log.i('next current index: ${currentIndex.value}');
      if (duo) {
        controller?.jumpToPage(1);
      } else {
        controller?.animateToPage(1,
            duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
      }
    }
  }

  void prevChapter({PageController? controller, bool duo = false}) {
    if (currentEps.value > 0) {
      currentEps.value--;
      currentIndex.value = epsList[currentEps.value].imageUrl.length - 1;
      if (duo) {
        currentIndex.value = 0;
        log.i('pre current index: ${currentIndex.value}');
        controller?.jumpToPage(1);
      } else {
        log.i('pre current index: ${currentIndex.value}');
        controller?.animateToPage(currentIndex.value + 1,
            duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
      }
    } else {
      currentIndex.value = 0;
      controller?.animateToPage(1,
          duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
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
      controller?.animateToPage(currentIndex.value,
          duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      nextChapter(controller: controller);
    }
  }

  void prevPage({PageController? controller, bool duo = false}) {
    if (currentIndex.value > 0) {
      if (duo) {
        currentIndex.value -= 2;
      } else {
        currentIndex.value--;
      }
      controller?.animateToPage(currentIndex.value,
          duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      prevChapter(controller: controller);
    }
  }
}
