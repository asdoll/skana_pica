import 'package:get/get.dart';
import 'package:skana_pica/api/comic_sources/picacg/pica_source.dart';
import 'package:skana_pica/config/setting.dart';
import 'package:skana_pica/controller/blocker.dart';

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
    settings.pica[5] = blocker.blockedCategories.join(";");
    settings.updateSettings("picacg");
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
    List<String> tags = settings.pica[9].split(";");
    tags.removeWhere((element) => element.trim().isEmpty);
    mainPageTags.addAll(tags);
    mainPageTags.refresh();
  }

  void toggleMainPageTag(String tag) {
    if (mainPageTags.contains(tag)) {
      mainPageTags.remove(tag);
    } else {
      mainPageTags.add(tag);
    }
    settings.pica[9] = mainPageTags.join(";");
    settings.updateSettings("pica");
    mainPageTags.refresh();
  }

  void addMainPageTag(String tag) {
    if (mainPageTags.contains(tag)) {
      return;
    } else {
      mainPageTags.add(tag);
    }
    settings.pica[9] = mainPageTags.join(";");
    settings.updateSettings("pica");
    mainPageTags.refresh();
  }

  void removeMainPageTag(String tag) {
    if (mainPageTags.contains(tag)) {
      mainPageTags.remove(tag);
    } else {
      return;
    }
    settings.pica[9] = mainPageTags.join(";");
    settings.updateSettings("pica");
    mainPageTags.refresh();
  }

  void saveMainPageTags() {
    mainPageTags.refresh();
    settings.pica[9] = mainPageTags.join(";");
    settings.updateSettings("pica");
  }

}

final fixedCategories = ["Random", "Latest", "Leaderboard", "Bookmarks"];
