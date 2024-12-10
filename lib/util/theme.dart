import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skana_pica/config/setting.dart';
import 'package:skana_pica/pages/mainscreen.dart';
import 'package:skana_pica/util/log.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

class ThemeManager {
  static ThemeManager? _instance;

  static ThemeManager get instance {
    _instance ??= ThemeManager._init();

    return _instance!;
  }

  static int get colorMode => appdata.darkMode;

  static int get themeColor => appdata.theme;

  static Brightness get brightness =>
      WidgetsBinding.instance.platformDispatcher.platformBrightness;

  static int get currentDarkMode {
    switch (colorMode) {
      case 0:
        return brightness == Brightness.light ? 0 : 1;
      case 1:
        return 0;
      default:
        return 1;
    }
  }

  static ThemeData get themeData =>
      currentDarkMode == 0 ? FlexThemeData.light(scheme: FlexScheme.values[themeColor]):FlexThemeData.dark(scheme: FlexScheme.values[themeColor]);
  
  static ThemeData themeDataByIndex(int index) {
    return currentDarkMode == 0 ? FlexThemeData.light(scheme: FlexScheme.values[index]):FlexThemeData.dark(scheme: FlexScheme.values[index]);
  }

  ThemeManager._init() {
    theme.value = themeData;
    if (colorMode == 0) {
      WidgetsBinding.instance.platformDispatcher.onPlatformBrightnessChanged =
          () {
        updateValue(themeData);
      };
    }
  }

  ValueNotifier<ThemeData> theme =
      ValueNotifier<ThemeData>(ThemeData.light());

  void updateValue(ThemeData t) {
    theme.value = t;
    changeBottumBarColor(t);
    log.d(theme.value);
  }

  void changeBottumBarColor(ThemeData t) {
    MainScreenIndex mainScreenIndex = Get.put(MainScreenIndex());
    mainScreenIndex.changeColor(t);
  }

  static textBrightness(Brightness b) {
    return b == Brightness.light ? Brightness.dark : Brightness.light;
  }

  void toggleDarkMode() {
    switch (currentDarkMode) {
      case 0:
        appdata.darkMode = 2;
        break;
      case 1:
        appdata.darkMode = 1;
        break;
    }
    WidgetsBinding.instance.platformDispatcher.onPlatformBrightnessChanged =
        () {};
    updateValue(themeData);
  }

  void setSystemMode(int value) {
    appdata.darkMode = value;
    if (value == 0) {
      WidgetsBinding.instance.platformDispatcher.onPlatformBrightnessChanged =
          () {
        updateValue(themeData);
      };
    }
    updateValue(themeData);
  }

  void updateTheme() {
    updateValue(themeData);
  }

  void previewTheme(int index) {
    updateValue(themeDataByIndex(index));
  }
}

enum ColorTheme {
  zinc(0),
  slate(1),
  red(2),
  rose(3),
  orange(4),
  green(5),
  blue(6),
  yellow(7),
  violet(8);

  final int value;

  const ColorTheme(this.value);
}
