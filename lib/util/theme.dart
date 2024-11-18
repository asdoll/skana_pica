import 'package:flutter/material.dart';
import 'package:forui/theme.dart';
import 'package:skana_pica/config/setting.dart';
import 'package:skana_pica/util/log.dart';

class ThemeManager {
  static ThemeManager? _instance;

  static ThemeManager get instance {
    _instance ??= ThemeManager._init();

    return _instance!;
  }

  static int get colorMode => appdata.appSettings.darkMode;

  static int get themeColor => appdata.appSettings.theme;

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

  FThemeData get themeData =>
      currentDarkMode == 0 ? themes[themeColor].light : themes[themeColor].dark;

  ThemeManager._init() {
    theme.value = themeData;
    if (colorMode == 0) {
      WidgetsBinding.instance.platformDispatcher.onPlatformBrightnessChanged =
          () {
        updateValue(themeData);
      };
    }
  }

  ValueNotifier<FThemeData> theme =
      ValueNotifier<FThemeData>(FThemes.zinc.light);

  void updateValue(FThemeData t) {
    theme.value = t;
    log.d(theme.value);
  }

  static textBrightness(Brightness b) {
    return b == Brightness.light ? Brightness.dark : Brightness.light;
  }

  static final themeName = [
    "zinc",
    "slate",
    "red",
    "rose",
    "orange",
    "green",
    "blue",
    "yellow",
    "violet",
  ];

  final themes = [
    FThemes.zinc,
    FThemes.slate,
    FThemes.red,
    FThemes.rose,
    FThemes.orange,
    FThemes.green,
    FThemes.blue,
    FThemes.yellow,
    FThemes.violet,
  ];

  void toggleDarkMode() {
    switch (currentDarkMode) {
      case 0:
        appdata.appSettings.darkMode = 2;
        break;
      case 1:
        appdata.appSettings.darkMode = 1;
        break;
    }
    WidgetsBinding.instance.platformDispatcher.onPlatformBrightnessChanged =
        () {};
    updateValue(themeData);
  }

  void setSystemMode(int value) {
    appdata.appSettings.darkMode = value;
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
