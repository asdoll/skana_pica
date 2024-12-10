import 'package:get/get.dart';
import 'package:skana_pica/config/setting.dart';

late Blocker blocker;

class Blocker extends GetxController {
  RxList<String> blockedKeywords = <String>[].obs;
  RxList blockedCategories = <String>[].obs;

  void init() {
    blockedKeywords.clear();
    blockedKeywords.addAll(appdata.blockingKeyword);
    blockedKeywords.refresh();
  }

  void removeKeyword(String keyword) {
    blockedKeywords.remove(keyword);
    appdata.blockingKeyword.remove(keyword);
    appdata.setBlockingKeyword();
    blockedKeywords.refresh();
  }

  void addKeyword(String keyword) {
    if (blockedKeywords.contains(keyword)) {
      blockedKeywords.remove(keyword);
      appdata.blockingKeyword.remove(keyword);
    }
    blockedKeywords.add(keyword);
    appdata.blockingKeyword.add(keyword);
    appdata.setBlockingKeyword();
    blockedKeywords.refresh();
  }

  void addBlockedCategory(String category) {
    if (blockedCategories.contains(category)) {
      blockedCategories.remove(category);
    } else {
      blockedCategories.add(category);
    }
    appdata.pica[5] = blockedCategories.join(";");
    appdata.updateSettings("picacg");
  }

  void removeBlockedCategory(String category) {
    if (blockedCategories.contains(category)) {
      blockedCategories.remove(category);
    }
    appdata.pica[5] = blockedCategories.join(";");
    appdata.updateSettings("picacg");
  }

  void toggleBlockedCategory(String category) {
    if (blockedCategories.contains(category)) {
      blockedCategories.remove(category);
    } else {
      blockedCategories.add(category);
    }
    appdata.pica[5] = blockedCategories.join(";");
    appdata.updateSettings("picacg");
    blockedCategories.refresh();
  }

  void fetchCategories() {
    if (blockedCategories.isEmpty) {
      blockedCategories.value = appdata.pica[5].split(";").toList();
    }
    blockedCategories.refresh();
  }
}