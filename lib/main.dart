import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:skana_pica/api/models/base_comic.dart';
import 'package:skana_pica/config/base.dart';
import 'package:skana_pica/config/setting.dart';
import 'package:skana_pica/pages/mainscreen.dart';
import 'package:skana_pica/pages/pica_login.dart';
import 'package:skana_pica/pages/setting/theme.dart';
import 'package:skana_pica/pages/setting/setting_page.dart';
import 'package:skana_pica/util/leaders.dart';
import 'package:skana_pica/util/log.dart';
import 'package:skana_pica/util/theme.dart';
import 'package:skana_pica/util/translate.dart';

Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    FlutterError.onError = (details) {
      log.e("Unhandled", error: "${details.exception}\n${details.stack}");
    };
    initLogger();
    await Base.init();
    await appdata.init();
    await ComicSource.init();
    runApp(const MyApp());
  }, (e, s) {
    log.e("Uncaught Error", error: "$e\n$s");
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeManager appValueNotifier = ThemeManager.instance;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: appValueNotifier.theme,
      builder: (context, value, child) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        return GetMaterialApp(
          navigatorKey: Leader.rootNavigatorKey,
          navigatorObservers: [BotToastNavigatorObserver()],
          supportedLocales: [
            Locale('en', 'US'),
            Locale('zh', 'CN'),
            Locale('zh', 'TW'),
          ],
          localizationsDelegates: [
            FLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          locale: Locale('zh', 'CN'),
          builder: (context, child) {
            child = FTheme(data: value, child: child!);
            child = BotToastInit()(context, child);
            return child;
          },
          home: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
                systemNavigationBarColor: Colors.transparent,
                systemNavigationBarDividerColor: Colors.transparent,
                statusBarColor: Colors.transparent,
                statusBarIconBrightness:
                    ThemeManager.textBrightness(value.colorScheme.brightness)),
            child: Mains(),
          ),
          initialRoute: Mains.route,
          getPages: [
            GetPage(name: Mains.route, page: () => Mains()),
            GetPage(name: PicaLoginPage.route, page: () => PicaLoginPage()),
            GetPage(name: SettingPage.route, page: () => SettingPage()),
            GetPage(name: AppearancePage.route, page: () => AppearancePage()),
          ],
          translationsKeys: Messages().keys,
        );
      },
    );
  }
}
