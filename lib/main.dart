import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:skana_pica/api/managers/history_manager.dart';
import 'package:skana_pica/api/models/base_comic.dart';
import 'package:skana_pica/config/base.dart';
import 'package:skana_pica/config/setting.dart';
import 'package:skana_pica/controller/blocker.dart';
import 'package:skana_pica/controller/categories.dart';
import 'package:skana_pica/controller/downloadstore.dart';
import 'package:skana_pica/controller/favourite.dart';
import 'package:skana_pica/controller/history.dart';
import 'package:skana_pica/controller/main_controller.dart';
import 'package:skana_pica/controller/profile.dart';
import 'package:skana_pica/controller/searchhistory.dart';
import 'package:skana_pica/controller/setting_controller.dart';
import 'package:skana_pica/controller/updater.dart';
import 'package:skana_pica/pages/mainscreen.dart';
import 'package:skana_pica/pages/me_page.dart';
import 'package:skana_pica/pages/pica_list_comics.dart';
import 'package:skana_pica/pages/pica_login.dart';
import 'package:skana_pica/pages/pica_results.dart';
import 'package:skana_pica/pages/pica_search.dart';
import 'package:skana_pica/pages/setting/manga.dart';
import 'package:skana_pica/pages/setting/setting_page.dart';
import 'package:skana_pica/controller/log.dart';
import 'package:skana_pica/controller/theme_controller.dart';
import 'package:skana_pica/util/tool.dart';
import 'package:skana_pica/util/translate.dart';

Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    FlutterError.onError = (details) {
      log.e("Unhandled", error: "${details.exception}\n${details.stack}");
    };
    initLogger();
    await Base.init();
    await settings.init();
    await ComicSource.init();
    await M.init();
    //init global controllers
    favorController = Get.put(FavorController(), permanent: true);
    await favorController.fetch();
    searchHistoryController =
        Get.put(SearchHistoryController(), permanent: true);
    searchHistoryController.init();
    blocker = Get.put(Blocker(), permanent: true);
    blocker.init();
    tc = Get.put(ThemeController(), permanent: true);
    categoriesController = Get.put(CategoriesController(), permanent: true);
    categoriesController.init();
    profileController = Get.put(ProfileController(), permanent: true);
    profileController.fetch();
    visitHistoryController = Get.put(VisitHistoryController(), permanent: true);
    downloadStore = Get.put(DownloadStore(), permanent: true);
    downloadStore.restore();
    updater = Get.put(Updater(), permanent: true);
    updater.init();
    boardController = Get.put(BoardController(), permanent: true);
    boardController.init();
    homeController = Get.put(HomeController(), permanent: true);
    mangaSettingsController = Get.put(MangaSettingsController(), permanent: true);
    runApp(MyApp());
  }, (e, s) {
    log.e("Uncaught Error", error: "$e\n$s");
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  ThemeManager appValueNotifier = ThemeManager.instance;
  
  @override
  void initState() {
    super.initState();
    if(Platform.isAndroid && settings.highRefreshRate) {
      FlutterDisplayMode.setHighRefreshRate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: appValueNotifier.theme,
      builder: (context, value, child) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        resetOrientation();
        return GetMaterialApp(
          supportedLocales: [
            Locale('en', 'US'),
            Locale('zh', 'CN'),
            Locale('zh', 'TW'),
          ],
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
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
          getPages: [
            GetPage(name: Mains.route, page: () => Mains()),
            GetPage(name: PicaLoginPage.route, page: () => PicaLoginPage()),
            GetPage(name: SettingPage.route, page: () => SettingPage()),
            GetPage(name: MePage.route, page: () => MePage()),
            GetPage(name: PicaSearchPage.route, page: () => PicaSearchPage()),
            GetPage(
                name: PicaResultsPage.route,
                page: () =>
                    PicaResultsPage(keyword: Get.parameters['keyword']!)),
            GetPage(
                name: PicaCatComicsPage.route,
                page: () => PicaCatComicsPage(
                    id: Get.parameters['id']!, type: Get.parameters['type']!)),
            GetPage(
                name: MangaSettingPage.route, page: () => MangaSettingPage()),
          ],
          translationsKeys: Messages().keys,
        );
      },
    );
  }
}
