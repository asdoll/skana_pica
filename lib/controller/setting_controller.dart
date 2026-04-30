import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:skana_pica/api/comic_sources/picacg/pica_source.dart';
import 'package:skana_pica/api/managers/image_cache_manager.dart';
import 'package:skana_pica/config/setting.dart';
import 'package:skana_pica/controller/categories.dart';
import 'package:skana_pica/util/tool.dart';
import 'package:skana_pica/controller/log.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'setting_controller.freezed.dart';
part 'setting_controller.g.dart';

@freezed
abstract class SettingState with _$SettingState {
  factory SettingState({
    required String defaultPage,
    required String mainOrientation,
    required bool highRefreshRate,
    required String language,
    @Default(false) bool darkMenu,
    @Default(false) bool langMenu,
    @Default(false) bool homePageMenu,
    @Default(false) bool orienMenu,
  }) = _SettingState;
}

@riverpod
class Setting extends _$Setting {
  @override
  SettingState build() {
    return SettingState(
        defaultPage: settings.general[5],
        mainOrientation: settings.general[6],
        highRefreshRate: settings.highRefreshRate,
        language: settings.general[2]);
  }

  void init() {
    state = build();
  }

  void setDarkMenu([bool v = false]) => state = state.copyWith(darkMenu: v);
  void setLangMenu([bool v = false]) => state = state.copyWith(langMenu: v);
  void setHPMenu([bool v = false]) => state = state.copyWith(homePageMenu: v);
  void setOrientMenu([bool v = false]) => state = state.copyWith(orienMenu: v);

  void changeDefaultPage(String index) {
    state = state.copyWith(defaultPage: index);
    settings.general[5] = index;
    settings.updateSettings("general");
  }

  void changeMainOrientation(String index) {
    state = state.copyWith(mainOrientation: index);
    settings.general[6] = index;
    settings.updateSettings("general");
    resetOrientation();
  }

  void changeHighRefreshRate(bool value) {
    state = state.copyWith(highRefreshRate: value);
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
    state = state.copyWith(language: value);
  }
}

  List<String> get categories => picacg.categories;

@freezed
abstract class MangaSettingState with _$MangaSettingState {
  factory MangaSettingState({
    required int picaStream,
    required String picaImageQuality,
    required int picaSearchMode,
    required bool picaPageViewMode,
    required bool autoCheckIn,
    required String preloadNumPages,
    required bool preloadDetailsPage,
    @Default(false) bool mainTrigger,
    @Default(false) bool streamMenu,
    @Default(false) bool imageQualityMenu,
    @Default(false) bool searchModeMenu,
    @Default(false) bool preloadMenu,
  }) = _MangaSettingState;
}

@riverpod
class MangaSetting extends _$MangaSetting {
  @override
  MangaSettingState build() {
    return MangaSettingState(
      picaStream: int.parse(settings.pica[0]),
      picaImageQuality: settings.picaImageQuality,
      picaSearchMode: settings.picaSearchMode,
      picaPageViewMode: (settings.pica[6] == "1"),
      autoCheckIn: (settings.pica[2] == "1"),
      preloadNumPages: (int.parse(settings.pica[7]) > 6 ? '5' : settings.pica[7]),
      preloadDetailsPage: (settings.pica[8] == "1"),
    );
  }

  void init() {
    state = build();
  }

  void setStreamMenu([bool v = false]) => state = state.copyWith(streamMenu: v);
  void setIQMenu([bool v = false]) => state = state.copyWith(imageQualityMenu: v);
  void setSMMenu([bool v = false]) => state = state.copyWith(searchModeMenu: v);
  void setPLMenu([bool v = false]) => state = state.copyWith(preloadMenu: v);

  void setPicaStream(int value) {
    state = state.copyWith(picaStream: value);
    settings.pica[0] = value.toString();
    settings.updateSettings("pica");
    picacg.data['appChannel'] = (value + 1).toString();
  }

  void setPicaImageQuality(String value) {
    state = state.copyWith(picaImageQuality: value);
    settings.picaImageQuality = value;
    picacg.data['imageQuality'] = value;
  }

  void setPicaSearchMode(int value) {
    state = state.copyWith(picaSearchMode: value);
    settings.picaSearchMode = value;
  }

  void setPicaPageViewMode(bool value) {
    state = state.copyWith(picaPageViewMode: value);
    settings.isPageView = value;
  }

  void toggleAutoCheckIn() {
    state = state.copyWith(autoCheckIn: !state.autoCheckIn);
    settings.pica[2] = state.autoCheckIn ? "1" : "0";
    settings.updateSettings("pica");
  }

  void setPreloadNumPages(String value) {
    state = state.copyWith(preloadNumPages: value);
    settings.pica[7] = value;
    settings.updateSettings("pica");
  }

  void setPreloadDetailsPage(bool value) {
    state = state.copyWith(preloadDetailsPage: value);
    settings.pica[8] = value ? "1" : "0";
    settings.updateSettings("pica");
  }

  void setMainTrigger() {
    Future.delayed(const Duration(milliseconds: 500), () {
      state = state.copyWith(mainTrigger: true);
    });
  }
}

@freezed
abstract class CacheState with _$CacheState {

  factory CacheState({
    required String cachePeriod,
    @Default(false) bool cacheMenu
  }) = _CacheState;
}

@riverpod
class Cache extends _$Cache {
  @override
  CacheState build() {
    return CacheState(cachePeriod: settings.general[7]);
  }

  void init() {
    state = build();
  }

  void setMenu([bool v = false]) => state = state.copyWith(cacheMenu: v);

  void setCachePeriod(String period) {
    state = state.copyWith(cachePeriod: period);
    settings.general[7] = period;
    settings.updateSettings("general");
  }

  void clearCache() {
    imagesCacheManager.emptyCache();
  }

  void restore(String type) {
    settings.restore(type);
    if (type == "pica") ref.read(categoryProvider.notifier).init();
  }
}
