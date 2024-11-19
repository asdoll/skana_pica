import 'package:flutter/material.dart';
import 'package:skana_pica/config/setting.dart';
import 'package:skana_pica/util/log.dart';
import 'package:skana_pica/util/themejson.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

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

  TDThemeData get themeData =>
      (currentDarkMode == 0 ? TDThemeData.fromJson(themesName[themeColor], lightThemeJson) : TDThemeData.fromJson(themesName[themeColor], darkThemeJson)) ?? TDThemeData.defaultData();

  ThemeManager._init() {
    TDTheme.needMultiTheme();
    theme.value = themeData;
    log.w('theme ${theme.value.name}');
    if (colorMode == 0) {
      WidgetsBinding.instance.platformDispatcher.onPlatformBrightnessChanged =
          () {
        updateValue(themeData);
      };
    }
  }

  ValueNotifier<TDThemeData> theme =
      ValueNotifier<TDThemeData>(TDThemeData.defaultData());

  void updateValue(TDThemeData t) {
    theme.value = t;
    log.d(theme.value);
  }

  static textBrightness(Brightness b) {
    return b == Brightness.light ? Brightness.dark : Brightness.light;
  }

  static final themesName = [
    'green',
    'blue',
    'yellow',
    'black',
    'red',
    'orange',
    'purple',
    'pink',
    'cyan',
    'lightgreen',
    'sky',
    'lightsky',
    'lightpurple',
    'rose',
    'magenta',
  ];

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
