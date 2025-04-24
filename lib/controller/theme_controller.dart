
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moon_design/moon_design.dart';
import 'package:flutter/material.dart';
import 'package:skana_pica/config/setting.dart' show settings;
import 'package:skana_pica/controller/log.dart';

class ThemeManager {
  static ThemeManager? _instance;

  static ThemeManager get instance {
    _instance ??= ThemeManager._init();

    return _instance!;
  }

  ThemeData getUpdatedTheme() {
    return getTheme(settings.isDarkMode);
  }

  ThemeManager._init() {
    updateValue(getUpdatedTheme());
    if (settings.darkMode == "0") {
      WidgetsBinding.instance.platformDispatcher.onPlatformBrightnessChanged =
          () {
        updateValue(getUpdatedTheme());
      };
    }
  }

  bool get isDarkMode => settings.isDarkMode;

  ValueNotifier<ThemeData> theme = ValueNotifier<ThemeData>(getTheme(false));

  void updateDarkMode() {
    updateValue(getUpdatedTheme());
    if (settings.darkMode == "0") {
      WidgetsBinding.instance.platformDispatcher.onPlatformBrightnessChanged =
          () {
        updateValue(getUpdatedTheme());
      };
    } else {
      WidgetsBinding.instance.platformDispatcher.onPlatformBrightnessChanged =
          () {
      };
    }
  }

  void updateValue(ThemeData themes) {
    theme.value = themes;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      statusBarBrightness:
          settings.isDarkMode ? Brightness.light : Brightness.dark,
      statusBarIconBrightness:
          settings.isDarkMode ? Brightness.light : Brightness.dark,
    ));
    log.d(theme.value);
  }
}

ThemeData getTheme(bool isDark) {
  return (isDark
          ? ThemeData.dark().copyWith(
            primaryColor: MoonTheme(tokens: MoonTokens.dark).tokens.colors.piccolo,
              textTheme: GoogleFonts.notoSansTextTheme(
                Get.theme.textTheme
              ),
              appBarTheme: AppBarTheme(
                titleSpacing: 0,
                backgroundColor:
                    MoonTheme(tokens: MoonTokens.dark).tokens.colors.popo,
                surfaceTintColor: Colors.transparent,
              ),
              scaffoldBackgroundColor:
                  MoonTheme(tokens: MoonTokens.light).tokens.colors.bulma)
          : ThemeData.light().copyWith(
            primaryColor: MoonTheme(tokens: MoonTokens.light).tokens.colors.piccolo,
              textTheme: GoogleFonts.notoSansTextTheme(
                Get.theme.textTheme
              ),
              appBarTheme: AppBarTheme(
                titleSpacing: 0,
                backgroundColor:
                    MoonTheme(tokens: MoonTokens.dark).tokens.colors.goten,
                surfaceTintColor: Colors.transparent,
              ),
              scaffoldBackgroundColor:
                  MoonTheme(tokens: MoonTokens.light).tokens.colors.goten))
      .copyWith(extensions: <ThemeExtension<dynamic>>[
    MoonTheme(tokens: isDark ? MoonTokens.dark.copyWith(
      typography: MoonTypography.typography.copyWith(
        heading: MoonTypography.typography.heading.apply(
          fontFamily: GoogleFonts.notoSans().fontFamily,
        ),
        body: MoonTypography.typography.body.apply(
          fontFamily: GoogleFonts.notoSans().fontFamily,
        )
      )
    ) : MoonTokens.light.copyWith(
      typography: MoonTypography.typography.copyWith(
        heading: MoonTypography.typography.heading.apply(
          fontFamily: GoogleFonts.notoSans().fontFamily,
        ),
        body: MoonTypography.typography.body.apply(
          fontFamily: GoogleFonts.notoSans().fontFamily,
        )
      )
    ))
  ]);
}

late ThemeController tc;

class ThemeController extends GetxController {
  RxString darkMode = settings.darkMode.obs;
  RxBool dmMenu = false.obs;

  void changeDarkMode(String darkMode) {
    settings.darkMode = darkMode;
    settings.updateSettings("general");
    this.darkMode.value = settings.darkMode;
    ThemeManager.instance.updateDarkMode();
  }
}