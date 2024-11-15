import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:forui/forui.dart';
import 'package:skana_pica/api/models/base_comic.dart';
import 'package:skana_pica/config/base.dart';
import 'package:skana_pica/config/setting.dart';
import 'package:skana_pica/pages/home.dart';
import 'package:skana_pica/util/leaders.dart';
import 'package:skana_pica/util/log.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:skana_pica/util/theme.dart';

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
    runApp(MyApp());
  }, (e, s) {
    log.e("Uncaught Error", error: "$e\n$s");
  });
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  ThemeManager appValueNotifier = ThemeManager.instance;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: appValueNotifier.theme,
      builder: (context, value, child) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        return MaterialApp(
          navigatorKey: Leader.rootNavigatorKey,
          navigatorObservers: [BotToastNavigatorObserver()],
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
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
                statusBarIconBrightness: ThemeManager.textBrightness(value.colorScheme.brightness)),
            child: HomePage(),
          ),
        );
      },
    );
  }
}
