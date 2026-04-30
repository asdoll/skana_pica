import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skana_pica/api/managers/history_manager.dart';
import 'package:skana_pica/api/models/base_comic.dart';
import 'package:skana_pica/config/base.dart';
import 'package:skana_pica/config/setting.dart';
import 'package:skana_pica/controller/downloadstore.dart';
import 'package:skana_pica/controller/favourite.dart';
import 'package:skana_pica/controller/history.dart';
import 'package:skana_pica/controller/profile.dart';
import 'package:skana_pica/controller/updater.dart';
import 'package:skana_pica/pages/mainscreen.dart';
import 'package:skana_pica/pages/pica_list_comics.dart';
import 'package:skana_pica/pages/pica_login.dart';
import 'package:skana_pica/pages/pica_results.dart';
import 'package:skana_pica/pages/pica_search.dart';
import 'package:skana_pica/pages/setting/manga.dart';
import 'package:skana_pica/pages/setting/setting_page.dart';
import 'package:skana_pica/controller/log.dart';
import 'package:skana_pica/controller/theme_controller.dart';
import 'package:skana_pica/util/leaders.dart' show Go;
import 'package:skana_pica/util/tool.dart';
import 'package:easy_localization/easy_localization.dart';

Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    FlutterError.onError = (details) {
      log.e("Unhandled", error: "${details.exception}\n${details.stack}");
    };
    await EasyLocalization.ensureInitialized();
    initLogger();
    await Base.init();
    await settings.init();
    await ComicSource.init();
    await M.init();
    runApp(ProviderScope(child: MyApp()));
  }, (e, s) {
    log.e("Uncaught Error", error: "$e\n$s");
  });
}

class MyApp extends StatefulHookConsumerWidget {
  const MyApp({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  ThemeManager appValueNotifier = ThemeManager.instance;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid && settings.highRefreshRate) {
      FlutterDisplayMode.setHighRefreshRate();
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.read(favorProvider.notifier).fetch();
    ref.read(profileProvider.notifier).fetch();
    ref.read(visitHistoryControllerProvider.notifier).init();
    ref.read(downloadProvider.notifier).restore();
    ref.read(updaterProvider.notifier).init();
    ref.read(boardProvider.notifier).init();
    return ValueListenableBuilder(
      valueListenable: appValueNotifier.theme,
      builder: (context, value, child) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        resetOrientation();
        Go.context = context;
        return EasyLocalization(
            supportedLocales: [
              Locale('en'),
              Locale('zh', 'CN'),
              Locale('zh', 'TW'),
            ],
            path: 'assets/translations',
            fallbackLocale: const Locale('en'),
            child: MaterialApp(
                supportedLocales: context.supportedLocales,
                localizationsDelegates: context.localizationDelegates,
                theme: value,
                locale: Base.locale,
                builder: (context, child) => MediaQuery(
                      data: MediaQuery.of(context)
                          .copyWith(textScaler: TextScaler.linear(1.0)),
                      child: child!,
                    ),
                home: AnnotatedRegion<SystemUiOverlayStyle>(
                  value: SystemUiOverlayStyle(
                    systemNavigationBarColor: Colors.transparent,
                    systemNavigationBarDividerColor: Colors.transparent,
                    statusBarColor: Colors.transparent,
                  ),
                  child: Mains(),
                ),
                initialRoute: Mains.route,
                routes: {
                  Mains.route: (_) => Mains(),
                  PicaLoginPage.route: (_) => PicaLoginPage(),
                  SettingPage.route: (_) => SettingPage(),
                  PicaSearchPage.route: (_) => PicaSearchPage(),
                  MangaSettingPage.route: (_) => MangaSettingPage(),
                },
                onGenerateRoute: (settings) {
                  switch (settings.name) {
                    case PicaResultsPage.route:
                      final args = settings.arguments as Map<String, String>;
                      return MaterialPageRoute(
                        builder: (_) =>
                            PicaResultsPage(keyword: args["keyword"]!),
                      );

                    case PicaCatComicsPage.route:
                      final args = settings.arguments as Map<String, String>;
                      return MaterialPageRoute(
                        builder: (_) => PicaCatComicsPage(
                          id: args['id']!,
                          type: args['type']!,
                        ),
                      );
                  }
                  return null;
                }));
      },
    );
  }
}
