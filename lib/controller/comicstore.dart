import 'dart:math';

import 'package:bot_toast/bot_toast.dart';
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
    for (int i = 0; i < comic.eps.length; i++) {
      {
        picaClient.getComicContent(comic.id, i + 1).then((value) {
          if (value.error) {
            log.e(
                "Failed to load comic content: ${comic.title}/${comic.eps[i]}");
            epsList.refresh();
            isLoading.value = false;
            return;
          }
          epsList.add(PicaEpsImages(comic.eps[i], value.data));
        });
      }
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
      if(value.error){
        isLoading.value = false;
        return false;
      }
      if (value.data) comments.refresh();
    });
    isLoading.value = false;
    return true;
  }

  void preLoad(String eps) {
    int index = findIndex(eps);
    if (index == -1) {
      return;
    }
    if (epsList[index].imageUrl.isEmpty) {
      return;
    }
    if (epsList[index].loaded == null) {
      epsList[index].loaded = 0;
    }
    int loaded = epsList[index].loaded ?? 0;
    int preLength = int.parse(appdata.pica[7]);
    for (int i = loaded;
        i < min(epsList[index].imageUrl.length, loaded + preLength);
        i++) {
      imagesCacheManager
          .getImageFile(epsList[index].imageUrl[loaded], withProgress: true)
          .listen((event) {
        if (event is FileInfo) {
          log.i("Image loaded: comic${epsList[index].eps}/$loaded");
        }
      });
      epsList[index].loaded = loaded + 1;
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
}
