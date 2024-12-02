import 'package:get/get.dart';
import 'package:skana_pica/api/comic_sources/picacg/pica_source.dart';
import 'package:skana_pica/config/setting.dart';

class CategoriesController extends GetxController {
  var categories = List<String>.empty(growable: true).obs;
  var blockedCategories = List<String>.empty(growable: true).obs;

  void fetchCategories() async {
    if (blockedCategories.isEmpty) {
      blockedCategories.value = appdata.pica[5].split(";").toList();
    }
    blockedCategories.refresh();
    categories.clear();
    for (int i = 0; i < picacg.categories.length; i++) {
      if (!blockedCategories.contains(picacg.categories[i])) {
        categories.add(picacg.categories[i]);
      }
    }
    categories.refresh();
  }

  void blockCategory(String index) async {
    if (blockedCategories.contains(index)) {
      blockedCategories.remove(index);
    } else {
      blockedCategories.add(index);
    }
    appdata.pica[5] = blockedCategories.join(";");
    appdata.updateSettings("picacg");
    fetchCategories();
  }

  String getCoverImg(String category) {
    String path = picacg.cateMap[category] ?? "";
    return "assets/images/categories/$path";
  }
}
