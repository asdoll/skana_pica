import 'package:get/get.dart';
import 'package:skana_pica/api/comic_sources/picacg/pica_source.dart';
import 'package:skana_pica/config/setting.dart';
import 'package:skana_pica/controller/blocker.dart';
import 'package:skana_pica/pages/home_page.dart';

late CategoriesController categoriesController;

class CategoriesController extends GetxController {
  var categories = List<String>.empty(growable: true).obs;
  RxList<String> mainPageTags = <String>[].obs;

  void init() {
    fetchCategories();
    fetchMainPageTags();
  }

  void fetchCategories() async {
    blocker.fetchCategories();
    categories.clear();
    for (int i = 0; i < picacg.categories.length; i++) {
      if (!blocker.blockedCategories.contains(picacg.categories[i])) {
        categories.add(picacg.categories[i]);
      }
    }
    categories.refresh();
  }

  void blockCategory(String index) async {
    if (blocker.blockedCategories.contains(index)) {
      blocker.blockedCategories.remove(index);
    } else {
      blocker.blockedCategories.add(index);
    }
    appdata.pica[5] = blocker.blockedCategories.join(";");
    appdata.updateSettings("picacg");
    fetchCategories();
  }

  String getCoverImg(String category) {
    if (category == "leaderboard") {
      return "assets/images/categories/leaderboard.png";
    }
    if (category == "random") {
      return "assets/images/categories/random.png";
    }
    if (category == "latest") {
      return "assets/images/categories/latest.png";
    }

    String path = picacg.cateMap[category] ?? "";
    return "assets/images/categories/$path";
  }

  void fetchMainPageTags() {
    mainPageTags.clear();
    List<String> tags = appdata.pica[9].split(";");
    tags.removeWhere((element) => element.trim().isEmpty);
    mainPageTags.addAll(tags);
    mainPageTags.refresh();
    reloadMainPage();
  }

  void toggleMainPageTag(String tag) {
    if (mainPageTags.contains(tag)) {
      mainPageTags.remove(tag);
    } else {
      mainPageTags.add(tag);
    }
    appdata.pica[9] = mainPageTags.join(";");
    appdata.updateSettings("pica");
    mainPageTags.refresh();
    reloadMainPage();
  }

  void addMainPageTag(String tag) {
    if (mainPageTags.contains(tag)) {
      return;
    } else {
      mainPageTags.add(tag);
    }
    appdata.pica[9] = mainPageTags.join(";");
    appdata.updateSettings("pica");
    mainPageTags.refresh();
    reloadMainPage();
  }

  void removeMainPageTag(String tag) {
    if (mainPageTags.contains(tag)) {
      mainPageTags.remove(tag);
    } else {
      return;
    }
    appdata.pica[9] = mainPageTags.join(";");
    appdata.updateSettings("pica");
    mainPageTags.refresh();
    reloadMainPage();
  }

  void saveMainPageTags() {
    mainPageTags.refresh();
    appdata.pica[9] = mainPageTags.join(";");
    appdata.updateSettings("pica");
    reloadMainPage();
  }

  void reloadMainPage() {
    try {
      HomePageController homePageController = Get.find();
      homePageController.reload( callback: true);
    } catch (e) {
      //just ignore
    }
  }
}

final fixedCategories = ["Random", "Latest", "Leaderboard", "Bookmarks"];
