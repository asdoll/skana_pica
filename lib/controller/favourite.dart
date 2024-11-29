import 'package:bot_toast/bot_toast.dart';
import 'package:get/get.dart';
import 'package:skana_pica/api/comic_sources/picacg/pica_api.dart';
import 'package:skana_pica/api/comic_sources/picacg/pica_models.dart';
import 'package:skana_pica/config/setting.dart';


late FavorController favorController;

class FavorController extends GetxController {
  RxList<String> favorComics = <String>[].obs;
  RxBool isLoading = false.obs;
  String lastId = "";

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

  void favorCall(PicaComicItemBrief comic) {
    String id = comic.id;
    if (isLoading.value && lastId == id) {
      return;
    }
    isLoading.value = true;
    lastId = id;
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
      BotToast.showText(text: "Network Error".tr);
      isLoading.value = false;
    });
  }

  Future<void> fetch() async {
    favorComics.clear();
    int pages = 1;
    picaClient.getFavorites(1, appdata.pica[4] == "da").then((value) {
      if (value.error) {
        return;
      }
      pages = value.subData ?? 1;
      for (var e in value.data) {
        favorComics.add(e.id);
      }
      for (int i = 2; i <= pages; i++) {
        picaClient.getFavorites(i, appdata.pica[4] == "da").then((value) {
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
}

class BookmarksController extends GetxController {
  RxList<PicaComicItemBrief> bookmarks = <PicaComicItemBrief>[].obs;
  RxBool isLoading = false.obs;
  String lastId = "";

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
    if (isLoading.value && lastId == id) {
      return;
    }
    isLoading.value = true;
    lastId = id;
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
      BotToast.showText(text: "Network Error".tr);
      isLoading.value = false;
    });
  }

  void fetch() {
    if (isLoading.value && lastId == "bookmarks") {
      return;
    }
    isLoading.value = true;
    lastId = "bookmarks";
    bookmarks.clear();
    int pages = 1;
    picaClient.getFavorites(1, appdata.pica[4] == "da").then((value) {
      if (value.error) {
        isLoading.value = false;
        return;
      }
      pages = value.subData ?? 1;
      bookmarks.addAll(value.data);
      for (int i = 2; i <= pages; i++) {
        picaClient.getFavorites(i, appdata.pica[4] == "da").then((value) {
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
