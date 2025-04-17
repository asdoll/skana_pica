import 'package:get/get.dart';
import 'package:skana_pica/config/setting.dart';

late Blocker blocker;

class Blocker extends GetxController {
  RxList<String> blockedKeywords = <String>[].obs;
  RxList blockedCategories = <String>[].obs;

  void init() {
    blockedKeywords.clear();
    blockedKeywords.addAll(settings.blockingKeyword);
    blockedKeywords.refresh();
  }

  void removeKeyword(String keyword) {
    blockedKeywords.remove(keyword);
    settings.blockingKeyword.remove(keyword);
    settings.setBlockingKeyword();
    blockedKeywords.refresh();
  }

  void addKeyword(String keyword) {
    if (blockedKeywords.contains(keyword)) {
      blockedKeywords.remove(keyword);
      settings.blockingKeyword.remove(keyword);
    }
    blockedKeywords.add(keyword);
    settings.blockingKeyword.add(keyword);
    settings.setBlockingKeyword();
    blockedKeywords.refresh();
  }

  void addBlockedCategory(String category) {
    if (blockedCategories.contains(category)) {
      blockedCategories.remove(category);
    } else {
      blockedCategories.add(category);
    }
    settings.pica[5] = blockedCategories.join(";");
    settings.updateSettings("picacg");
  }

  void removeBlockedCategory(String category) {
    if (blockedCategories.contains(category)) {
      blockedCategories.remove(category);
    }
    settings.pica[5] = blockedCategories.join(";");
    settings.updateSettings("picacg");
  }

  void toggleBlockedCategory(String category) {
    if (blockedCategories.contains(category)) {
      blockedCategories.remove(category);
    } else {
      blockedCategories.add(category);
    }
    settings.pica[5] = blockedCategories.join(";");
    settings.updateSettings("picacg");
    blockedCategories.refresh();
  }

  void fetchCategories() {
    if (blockedCategories.isEmpty) {
      blockedCategories.value = settings.pica[5].split(";").toList();
    }
    blockedCategories.refresh();
  }
}