import 'package:flutter/material.dart';
import 'package:forui/theme.dart';
import 'package:skana_pica/config/setting.dart';

class ThemeManager {
  static ThemeManager? _instance;

  static ThemeManager get instance {
    _instance ??= ThemeManager._init();

    return _instance!;
  }

  int get colorMode => int.tryParse(appdata.settings[32]) ?? 0;

  int get themeColor => int.tryParse(appdata.settings[27]) ?? 0;

  Brightness get brightness =>
      WidgetsBinding.instance.platformDispatcher.platformBrightness;

  FThemeData get themeData {
    switch (colorMode) {
      case 0:
        return brightness == Brightness.light
            ? themes[themeColor].light
            : themes[themeColor].dark;
      case 1:
        return themes[themeColor].light;
      default:
        return themes[themeColor].dark;
    }
  }

  ThemeManager._init() {
    theme.value = themeData;
    WidgetsBinding.instance.platformDispatcher.onPlatformBrightnessChanged = () {
      updateValue(themeData);
    };
  }

  ValueNotifier<FThemeData> theme = ValueNotifier<FThemeData>(FThemes.zinc.light);

  void updateValue(FThemeData t) {
    theme.value = t;
    print(theme.value);
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
}
