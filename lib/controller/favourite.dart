import 'package:get/get.dart';
import 'package:skana_pica/api/comic_sources/picacg/pica_api.dart';
import 'package:skana_pica/api/comic_sources/picacg/pica_models.dart';
import 'package:skana_pica/config/setting.dart';
import 'package:skana_pica/controller/comicstore.dart';
import 'package:skana_pica/controller/comment.dart';
import 'package:skana_pica/util/leaders.dart';
import 'package:skana_pica/util/log.dart';

late FavorController favorController;

class FavorController extends GetxController {
  RxList<String> favorComics = <String>[].obs;
  RxBool isLoading = false.obs;
  RxString lastId = "".obs;
  String sort = appdata.pica[4] == "da" ? "da" : "dd";

  void addFavor(String id) {
    if (favorComics.contains(id)) {
      return;
    }
    favorComics.add(id);
    favorComics.refresh();
  }

  void removeFavor(String id) {
    favorComics.remove(id);
    favorComics.refresh();
  }

  void favorCall(String id) {
    if (isLoading.value && lastId.value == id) {
      return;
    }
    isLoading.value = true;
    lastId.value = id;
    bool isFavor = favorComics.contains(id);
    picaClient.favouriteOrUnfavouriteComic(id).then((value) {
      if (value) {
        if (isFavor) {
          removeFavor(id);
        } else {
          addFavor(id);
        }
        isLoading.value = false;
        return;
      }
      toast("Network Error".tr);
      isLoading.value = false;
    });
  }

  Future<void> fetch() async {
    favorComics.clear();
    int pages = 1;
    picaClient.getFavorites(1, appdata.pica[4] != "da").then((value) {
      if (value.error) {
        return;
      }
      pages = value.subData ?? 1;
      for (var e in value.data) {
        favorComics.add(e.id);
      }
      for (int i = 2; i <= pages; i++) {
        picaClient.getFavorites(i, appdata.pica[4] != "da").then((value) {
          if (value.error) {
            return;
          }
          for (var e in value.data) {
            favorComics.add(e.id);
          }
        });
      }
      favorComics.refresh();
    });
  }

  void addList(List<PicaComicItemBrief> list) {
    for (var e in list) {
      favorComics.add(e.id);
    }
    favorComics.refresh();
  }

  void clear() {
    favorComics.clear();
    favorComics.refresh();
    isLoading.value = false;
    lastId.value = "";
    sort = appdata.pica[4] == "da" ? "da" : "dd";
  }
}

class BookmarksController extends GetxController {
  RxList<PicaComicItemBrief> bookmarks = <PicaComicItemBrief>[].obs;
  RxBool isLoading = false.obs;
  RxString lastId = "".obs;

  void addBookmark(PicaComicItemBrief comic) {
    if (bookmarks.contains(comic)) {
      return;
    }
    bookmarks.add(comic);
    bookmarks.refresh();
  }

  void removeBookmark(PicaComicItemBrief comic) {
    bookmarks.remove(comic);
    bookmarks.refresh();
  }

  void favorCall(PicaComicItemBrief comic) {
    String id = comic.id;
    if (isLoading.value && lastId.value == id) {
      return;
    }
    isLoading.value = true;
    lastId.value = id;
    bool isFavor = favorController.favorComics.contains(id);
    picaClient.favouriteOrUnfavouriteComic(id).then((value) {
      if (value) {
        if (isFavor) {
          favorController.removeFavor(id);
          removeBookmark(comic);
        } else {
          favorController.addFavor(id);
          addBookmark(comic);
        }
        isLoading.value = false;
        return;
      }
      toast("Network Error".tr);
      isLoading.value = false;
    });
  }

  void fetch() {
    if (isLoading.value && lastId.value == "bookmarks") {
      return;
    }
    isLoading.value = true;
    lastId.value = "bookmarks";
    bookmarks.clear();
    int pages = 1;
    picaClient.getFavorites(1, appdata.pica[4] != "da").then((value) {
      if (value.error) {
        isLoading.value = false;
        return;
      }
      pages = value.subData ?? 1;
      bookmarks.addAll(value.data);
      for (int i = 2; i <= pages; i++) {
        picaClient.getFavorites(i, appdata.pica[4] != "da").then((value) {
          if (value.error) {
            isLoading.value = false;
            return;
          }
          bookmarks.addAll(value.data);
        });
      }
      bookmarks.refresh();
    });
    favorController.addList(bookmarks);
    isLoading.value = false;
  }
}

class LikeController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLike = false.obs;
  RxInt likes = 0.obs;

  bool likeCall(String id) {
    if (isLoading.value) {
      return false;
    }
    isLoading.value = true;
    picaClient.likeOrUnlikeComic(id).then((value) {
      if (!value) {
        toast("Network Error".tr);
        isLoading.value = false;
        return false;
      }
      isLike.value = !isLike.value;
      isLoading.value = false;
    });
    return true;
  }

  bool commentLikeCall(String id, {String? commentComicId, String? commentId}) {
    if (isLoading.value) {
      return false;
    }
    isLoading.value = true;
    picaClient.likeOrUnlikeComment(id).then((value) {
      if (!value) {
        toast("Network Error".tr);
        isLoading.value = false;
        return false;
      }
      isLike.value = !isLike.value;
      if (commentComicId != null) {
        try {
          ComicStore store = Get.find<ComicStore>(tag: commentComicId);
          store.fetchComments();
        } catch (e) {
          log.e(e);
        }
      }
      if (commentId != null) {
        try {
          CommentController controller =
              Get.find<CommentController>(tag: commentId);
          controller.fetch();
        } catch (e) {
          log.e(e);
        }
      }
      isLoading.value = false;
    });

    return true;
  }
}
