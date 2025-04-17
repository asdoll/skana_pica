import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:skana_pica/api/comic_sources/picacg/pica_source.dart';
import 'package:skana_pica/controller/categories.dart';
import 'package:skana_pica/pages/leaderboard.dart';
import 'package:skana_pica/widgets/pica_comic_list.dart';

class HomeController extends GetxController {
  RxInt pageIndex = 0.obs;
  RxBool showBackArea = false.obs;
  RxBool filterMenu = false.obs;
  RxInt tagIndex = 0.obs;
  Rx<DateTime?> dateTime = Rxn<DateTime>();

  void resetTags() {
    tagIndex.value = 0;
  }

    Widget getCategoryPage(int i){
    if (categoriesController.mainPageTags[i] == "Leaderboard") {
        return PicaComicsPage(
            keyword: "leaderboard",
            type: leaderboardController.type.value);
      } else if (categoriesController.mainPageTags[i] == "Random") {
        return PicaComicsPage(
          keyword: "random",
          type: "fixed",
          addToHistory: false
        );
      } else if (categoriesController.mainPageTags[i] == "Latest") {
        return PicaComicsPage(
          keyword: "latest",
          type: "fixed",
          addToHistory: false
        );
      } else if (categoriesController.mainPageTags[i] == "Bookmarks") {
        return PicaComicsPage(
          keyword: "bookmarks",
          type: "fixed",
          addToHistory: false
        );
      } else if (picacg.categories
          .contains(categoriesController.mainPageTags[i])) {
        return PicaComicsPage(
          keyword: categoriesController.mainPageTags[i],
          type: "category",
          addToHistory: false
        );
      } else {
        return PicaComicsPage(
          keyword: categoriesController.mainPageTags[i],
          type: "search",
          addToHistory: false
        );
      }
  }
}

List<String> pages = [
  "",
  "Search", "Leaderboard", "Bookmarks", "History", "Downloads", "Settings"
];

late HomeController homeController;

ScrollController globalScrollController = ScrollController();
