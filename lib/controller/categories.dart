import 'package:get/get.dart';
import 'package:skana_pica/api/comic_sources/picacg/pica_source.dart';
import 'package:skana_pica/config/setting.dart';
import 'package:skana_pica/util/tool.dart';

class CategoriesController extends GetxController {
  var categories = List<String>.empty(growable: true).obs;
  var blockedCategories = List<int>.empty(growable: true).obs;

  void fetchCategories() async {
    if (blockedCategories.isEmpty) {
      blockedCategories.addAll(appdata.pica[5].stringToIntList(null));
    }
    blockedCategories.refresh();
    categories.clear();
    for (int i = 0; i < picacg.categories.length; i++) {
      if (!blockedCategories.contains(i)) {
        categories.add(picacg.categories[i]);
      }
    }
    categories.refresh();
  }

  void blockCategory(int index) async {
    if (blockedCategories.contains(index)) {
      blockedCategories.remove(index);
    } else {
      blockedCategories.add(index);
    }
    appdata.pica[5] = blockedCategories.listToString(null);
    appdata.updateSettings("picacg");
    fetchCategories();
  }

  String getCoverImg(String category) {
    String path = picacg.cateMap[category] ?? "";
    return "assets/images/categories/$path";
  }
}
