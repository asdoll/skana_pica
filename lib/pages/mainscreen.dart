import 'package:easy_localization/easy_localization.dart' show StringTranslateExtension;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:skana_pica/controller/categories.dart';
import 'package:skana_pica/controller/comiclist.dart' show leaderboardProvider;
import 'package:skana_pica/controller/main_controller.dart';
import 'package:skana_pica/controller/profile.dart';
import 'package:skana_pica/controller/setting_controller.dart'
    show mangaSettingProvider, categories;
import 'package:skana_pica/pages/pica_cats.dart';
import 'package:skana_pica/pages/pica_download.dart';
import 'package:skana_pica/pages/pica_history.dart';
import 'package:skana_pica/pages/pica_login.dart';
import 'package:moon_design/moon_design.dart';
import 'package:skana_pica/pages/pica_search.dart';
import 'package:skana_pica/pages/setting/setting_page.dart';
import 'package:skana_pica/util/leaders.dart';
import 'package:skana_pica/util/widgetplugin.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:skana_pica/widgets/icons.dart';
import 'package:skana_pica/widgets/pica_comic_list.dart';

class Mains extends StatefulHookConsumerWidget {
  static const route = "/";

  const Mains({super.key});

  @override
  ConsumerState<Mains> createState() => _MainsState();
}

class _MainsState extends ConsumerState<Mains> {
  @override
  Widget build(BuildContext context) {
    globalScrollController.addListener(() {
      if (globalScrollController.offset < MediaQuery.of(context).size.height) {
        ref.read(homeProvider.notifier).setShowBack(false);
      } else {
        ref.read(homeProvider.notifier).setShowBack(true);
      }
    });
    return ref.watch(profileProvider).isFirstLaunch
          ? Scaffold(
              body: Center(
                  child: ListView(shrinkWrap: true, children: [
              Center(
                child: moonCard(
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8),
                        Text("${"app_disclaimer_1".tr()}.")
                            .small(),
                        SizedBox(height: 8),
                        Text("${"app_disclaimer_2".tr()}.")
                            .small(),
                        SizedBox(height: 8),
                        Text("${"app_disclaimer_3".tr()}.")
                            .small(),
                        SizedBox(height: 20)
                      ],
                    ).paddingAll(16),
                    actions: [
                      filledButton(
                        onPressed: () {
                          Go.toNamed(PicaLoginPage.route);
                        },
                        label: "login".tr(),
                      )
                    ]).paddingAll(20),
              )
            ])))
          : Scaffold(
              key: homeKey,
              appBar: appBar(
                  title: (ref.watch(homeProvider).pageIndex == 0)
                      ? ref.watch(categoryProvider)
                          .mainPageTags[ref.watch(homeProvider).tagIndex].tr()
                      : pages[ref.watch(homeProvider).pageIndex].tr(),
                  leading: NormalDrawerButton(onTap: () => homeKey.currentState?.openDrawer())),              
              drawer: MoonDrawer(
                  width: MediaQuery.of(context).size.width > 200 ? 200 : null,
                  child: ListView(children: [
                    for (var i = 0;
                        i < ref.watch(categoryProvider).mainPageTags.length;
                        i++)
                      buildDynamicButton(
                          ref.watch(categoryProvider).mainPageTags[i], null, i),
                    const Divider(),
                    buildButton('search'.tr(), BootstrapIcons.search, 1),
                    buildButton('categories'.tr(), BootstrapIcons.app, 2),
                    buildButton('leaderboard'.tr(), BootstrapIcons.list_stars, 3),
                    buildButton('bookmarks'.tr(), BootstrapIcons.bookmark, 4),
                    const Divider(),
                    buildButton('history'.tr(), BootstrapIcons.clock_history, 5),
                    buildButton('downloads'.tr(), BootstrapIcons.download, 6),
                    buildButton('settings'.tr(), BootstrapIcons.gear, 7),
                  ]).paddingSymmetric(horizontal: 8)),
              floatingActionButton:!ref.watch(mangaSettingProvider).picaPageViewMode ? GoTop() : null,
              body: (ref.watch(homeProvider).pageIndex == 0 &&
                      ref.watch(categoryProvider)
                              .mainPageTags[ref.watch(homeProvider).tagIndex] ==
                          "leaderboard")
                  ? PicaComicsPage(
                      keyword: "leaderboard",
                      type: ref.watch(leaderboardProvider),
                      fromDrawer: true,
                    )
                  : (ref.watch(homeProvider).pageIndex == 0 &&
                          ref.watch(categoryProvider).mainPageTags[ref.watch(homeProvider).tagIndex] ==
                              "random")
                      ? PicaComicsPage(
                          keyword: "random",
                          type: "fixed",
                          addToHistory: false,
                          fromDrawer: true)
                      : (ref.watch(homeProvider).pageIndex == 0 &&
                              ref.watch(categoryProvider).mainPageTags[ref.watch(homeProvider).tagIndex] ==
                                  "latest")
                          ? PicaComicsPage(
                              keyword: "latest",
                              type: "fixed",
                              addToHistory: false,
                              fromDrawer: true)
                          : (ref.watch(homeProvider).pageIndex == 0 &&
                                  ref.watch(categoryProvider).mainPageTags[
                                          ref.watch(homeProvider).tagIndex] ==
                                      "bookmarks")
                              ? PicaComicsPage(
                                  keyword: "bookmarks",
                                  type: "fixed",
                                  addToHistory: false,
                                  fromDrawer: true)
                              : (ref.watch(homeProvider).pageIndex == 0 &&
                                      categories.contains(
                                          ref.watch(categoryProvider).mainPageTags[ref.watch(homeProvider).tagIndex]))
                                  ? PicaComicsPage(keyword: ref.watch(categoryProvider).mainPageTags[ref.watch(homeProvider).tagIndex], type: "category", addToHistory: false, fromDrawer: true)
                                  : (ref.watch(homeProvider).pageIndex == 0)
                                      ? PicaComicsPage(keyword: ref.watch(categoryProvider).mainPageTags[ref.watch(homeProvider).tagIndex], type: "search", addToHistory: false, fromDrawer: true)
                                      : switch (ref.watch(homeProvider).pageIndex) {
                                          1 => PicaSearchPage(),
                                          2 => PicaCatsPage(),
                                          3 => PicaComicsPage(keyword: "leaderboard", type: ref.watch(leaderboardProvider), fromDrawer: true),
                                          4 => PicaComicsPage(keyword: "bookmarks", type: "me",fromDrawer: true,),
                                          5 => PicaHistoryPage(),
                                          6 => PicaDownloadPage(),
                                          _ => SettingPage(),
                                        },
    );
  }

  MoonMenuItem buildDynamicButton(String label, [IconData? icon, int? index]) {
    if (index != null) {
      return MoonMenuItem(
        backgroundColor: ref.watch(homeProvider).pageIndex == 0 &&
                ref.watch(homeProvider).tagIndex == index
            ? context.moonTheme?.tokens.colors.piccolo
            : Colors.transparent,
        label: Text(label.tr(),
                style: ref.watch(homeProvider).pageIndex == 0 &&
                        ref.watch(homeProvider).tagIndex == index
                    ? TextStyle(color: MoonColors.light.goku)
                    : null)
            .subHeader(),
        onTap: () {
          closeDrawer();
          ref.read(homeProvider.notifier).setPage(0);
          ref.read(homeProvider.notifier).setTag(index);
          globalScrollController.jumpTo(0);
        },
      );
    }
    return MoonMenuItem(
      label: Text(label).subHeader(),
      leading: icon == null ? null : Icon(icon),
    );
  }

  MoonMenuItem buildButton(String label, [IconData? icon, int? index]) {
    if (index != null) {
      return MoonMenuItem(
        backgroundColor: ref.watch(homeProvider).pageIndex == index
            ? context.moonTheme?.tokens.colors.piccolo
            : Colors.transparent,
        label: Text(label,
                style: ref.watch(homeProvider).pageIndex == index
                    ? TextStyle(color: MoonColors.light.goku)
                    : null)
            .subHeader(),
        leading: icon == null
            ? null
            : Icon(
                icon,
                color: ref.watch(homeProvider).pageIndex == index
                    ? MoonColors.light.goku
                    : null,
              ),
        onTap: () {
          closeDrawer();
          ref.read(homeProvider.notifier).setPage(index);
          try{
            globalScrollController.jumpTo(0);
          }catch(e){
            //ignore
          }
        },
      );
    }
    return MoonMenuItem(
      label: Text(label).subHeader(),
      leading: icon == null ? null : Icon(icon),
    );
  }

  String getTitle(String s) {
    if (s.contains(":")) {
      return s.split(":")[0];
    }
    return s;
  }

  String getSubtitle(String s) {
    if (s.contains(":")) {
      return s.split(":")[1];
    }
    return "";
  }
}
