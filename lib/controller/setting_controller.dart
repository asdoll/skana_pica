import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:get/get.dart';
import 'package:skana_pica/api/comic_sources/picacg/pica_source.dart';
import 'package:skana_pica/api/managers/image_cache_manager.dart';
import 'package:skana_pica/config/base.dart';
import 'package:skana_pica/config/setting.dart';
import 'package:skana_pica/util/tool.dart';
import 'package:skana_pica/controller/log.dart';

late MangaSettingsController mangaSettingsController;

class SettingController extends GetxController {
  RxString defaultPage = settings.general[5].obs;
  RxString mainOrientation = settings.general[6].obs;
  RxBool highRefreshRate = settings.highRefreshRate.obs;
  RxString language = settings.general[2].obs;
  RxBool darkMenu = false.obs;
  RxBool langMenu = false.obs;
  RxBool homePageMenu = false.obs;
  RxBool orienMenu = false.obs;

  void changeDefaultPage(String index) {
    defaultPage.value = index;
    settings.general[5] = index;
    settings.updateSettings("general");
  }

  void changeMainOrientation(String index) {
    mainOrientation.value = index;
    settings.general[6] = index;
    settings.updateSettings("general");
    resetOrientation();
  }

  void changeHighRefreshRate(bool value) {
    highRefreshRate.value = value;
    settings.highRefreshRate = value;
    try {
      if (value) {
        FlutterDisplayMode.setHighRefreshRate();
      } else {
        FlutterDisplayMode.setLowRefreshRate();
      }
    } catch (e) {
      log.e(e);
    }
  }

  String getVersion() {
    return settings.getVersion();
  }

  void changeLanguage(String value) {
    settings.general[2] = value;
    settings.updateSettings("general");
    language.value = value;
    Get.updateLocale(Base.locale);
  }
}

class MangaSettingsController extends GetxController {
  final picaStream = int.parse(settings.pica[0]).obs;
  final picaImageQuality = settings.picaImageQuality.obs;
  final picaSearchMode = settings.picaSearchMode.obs;
  final picaPageViewMode = (settings.pica[6] == "1").obs;
  final autoCheckIn = (settings.pica[2] == "1").obs;
  final preloadNumPages =
      (int.parse(settings.pica[7]) > 6 ? '5' : settings.pica[7]).obs;
  final preloadDetailsPage = (settings.pica[8] == "1").obs;
  final mainTrigger = false.obs;
  RxBool streamMenu = false.obs;
  RxBool imageQualityMenu = false.obs;
  RxBool searchModeMenu = false.obs;
  RxBool preloadMenu = false.obs;

  List<String> get categories => picacg.categories;

  void setPicaStream(int value) {
    picaStream.value = value;
    settings.pica[0] = value.toString();
    settings.updateSettings("pica");
    picacg.data['appChannel'] = (value + 1).toString();
  }

  void setPicaImageQuality(String value) {
    picaImageQuality.value = value;
    settings.picaImageQuality = value;
    picacg.data['imageQuality'] = value;
  }

  void setPicaSearchMode(int value) {
    picaSearchMode.value = value;
    settings.picaSearchMode = value;
  }

  void setPicaPageViewMode(bool value) {
    picaPageViewMode.value = value;
    settings.pica[6] = value ? "1" : "0";
    settings.updateSettings("pica");
  }

  void toggleAutoCheckIn() {
    autoCheckIn.value = !autoCheckIn.value;
    settings.pica[2] = autoCheckIn.value ? "1" : "0";
    settings.updateSettings("pica");
  }

  void setPreloadNumPages(String value) {
    preloadNumPages.value = value;
    settings.pica[7] = value;
    settings.updateSettings("pica");
  }

  void setPreloadDetailsPage(bool value) {
    preloadDetailsPage.value = value;
    settings.pica[8] = value ? "1" : "0";
    settings.updateSettings("pica");
  }

  void setMainTrigger() {
    Future.delayed(const Duration(milliseconds: 500), () {
      mainTrigger.value = true;
    });
  }
}

class CacheController extends GetxController {
  RxString cachePeriod = settings.general[7].obs;
  RxList<bool> restores = [false, false, false].obs;
  RxBool cacheMenu = false.obs;

  void setCachePeriod(String period) {
    cachePeriod.value = period;
    settings.general[7] = period;
    settings.updateSettings("general");
  }

  void clearCache() {
    imagesCacheManager.emptyCache();
  }

  void restore(String type) {
    settings.restore(type);
  }
}