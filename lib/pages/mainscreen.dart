import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skana_pica/controller/categories.dart';
import 'package:skana_pica/controller/comiclist.dart' show leaderboardController;
import 'package:skana_pica/controller/main_controller.dart';
import 'package:skana_pica/controller/profile.dart';
import 'package:skana_pica/controller/setting_controller.dart'
    show mangaSettingsController;
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

class Mains extends StatefulWidget {
  static const route = "/";

  const Mains({super.key});

  @override
  State<Mains> createState() => _MainsState();
}

class _MainsState extends State<Mains> {
  @override
  Widget build(BuildContext context) {
    globalScrollController.addListener(() {
      if (globalScrollController.offset < context.height) {
        homeController.showBackArea.value = false;
      } else {
        homeController.showBackArea.value = true;
      }
    });
    return Obx(
      () => profileController.isFirstLaunch.value
          ? Scaffold(
              body: Center(
                  child: ListView(shrinkWrap: true, children: [
              Center(
                child: moonCard(
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8),
                        Text("${"The purpose of this App is only for learning, communication, and personal interest. Any content displayed comes from the internet and is not related to the developer".tr}.")
                            .small(),
                        SizedBox(height: 8),
                        Text("${"If you encounter any problems during use, please first confirm whether it is a problem with your device, and then provide feedback".tr}.")
                            .small(),
                        SizedBox(height: 8),
                        Text("${"The developer is not responsible for whether the problem can be solved".tr}.")
                            .small(),
                        SizedBox(height: 20)
                      ],
                    ).paddingAll(16),
                    actions: [
                      filledButton(
                        onPressed: () {
                          Go.to(PicaLoginPage(start: true));
                        },
                        label: "Login".tr,
                      )
                    ]).paddingAll(20),
              )
            ])))
          : Scaffold(
              key: homeKey,
              appBar: appBar(
                  title: (homeController.pageIndex.value == 0)
                      ? categoriesController
                          .mainPageTags[homeController.tagIndex.value].tr
                      : pages[homeController.pageIndex.value].tr,
                  leading: NormalDrawerButton(onTap: () => homeKey.currentState?.openDrawer())),              
              drawer: MoonDrawer(
                  width: context.width > 200 ? 200 : null,
                  child: ListView(children: [
                    for (var i = 0;
                        i < categoriesController.mainPageTags.length;
                        i++)
                      buildDynamicButton(
                          categoriesController.mainPageTags[i], null, i),
                    const Divider(),
                    buildButton('Search'.tr, BootstrapIcons.search, 1),
                    buildButton('Categories'.tr, BootstrapIcons.app, 2),
                    buildButton('Leaderboard'.tr, BootstrapIcons.list_stars, 3),
                    buildButton('Bookmarks'.tr, BootstrapIcons.bookmark, 4),
                    const Divider(),
                    buildButton('History'.tr, BootstrapIcons.clock_history, 5),
                    buildButton('Downloads'.tr, BootstrapIcons.download, 6),
                    buildButton('Settings'.tr, BootstrapIcons.gear, 7),
                  ]).paddingSymmetric(horizontal: 8)),
              floatingActionButton:!mangaSettingsController.picaPageViewMode.value ? GoTop() : null,
              body: (homeController.pageIndex.value == 0 &&
                      categoriesController
                              .mainPageTags[homeController.tagIndex.value] ==
                          "Leaderboard")
                  ? PicaComicsPage(
                      keyword: "leaderboard",
                      type: leaderboardController.type.value,
                      fromDrawer: true,
                    )
                  : (homeController.pageIndex.value == 0 &&
                          categoriesController.mainPageTags[homeController.tagIndex.value] ==
                              "Random")
                      ? PicaComicsPage(
                          keyword: "random",
                          type: "fixed",
                          addToHistory: false,
                          fromDrawer: true)
                      : (homeController.pageIndex.value == 0 &&
                              categoriesController.mainPageTags[homeController.tagIndex.value] ==
                                  "Latest")
                          ? PicaComicsPage(
                              keyword: "latest",
                              type: "fixed",
                              addToHistory: false,
                              fromDrawer: true)
                          : (homeController.pageIndex.value == 0 &&
                                  categoriesController.mainPageTags[
                                          homeController.tagIndex.value] ==
                                      "Bookmarks")
                              ? PicaComicsPage(
                                  keyword: "bookmarks",
                                  type: "fixed",
                                  addToHistory: false,
                                  fromDrawer: true)
                              : (homeController.pageIndex.value == 0 &&
                                      mangaSettingsController.categories.contains(
                                          categoriesController.mainPageTags[homeController.tagIndex.value]))
                                  ? PicaComicsPage(keyword: categoriesController.mainPageTags[homeController.tagIndex.value], type: "category", addToHistory: false, fromDrawer: true)
                                  : (homeController.pageIndex.value == 0)
                                      ? PicaComicsPage(keyword: categoriesController.mainPageTags[homeController.tagIndex.value], type: "search", addToHistory: false, fromDrawer: true)
                                      : switch (homeController.pageIndex.value) {
                                          1 => PicaSearchPage(),
                                          2 => PicaCatsPage(),
                                          3 => PicaComicsPage(keyword: "leaderboard", type: leaderboardController.type.value, fromDrawer: true),
                                          4 => PicaComicsPage(keyword: "bookmarks", type: "me",fromDrawer: true,),
                                          5 => PicaHistoryPage(),
                                          6 => PicaDownloadPage(),
                                          _ => SettingPage(),
                                        },
            ),
    );
  }

  MoonMenuItem buildDynamicButton(String label, [IconData? icon, int? index]) {
    if (index != null) {
      return MoonMenuItem(
        backgroundColor: homeController.pageIndex.value == 0 &&
                homeController.tagIndex.value == index
            ? Get.context?.moonTheme?.tokens.colors.piccolo
            : Colors.transparent,
        label: Text(label.tr,
                style: homeController.pageIndex.value == 0 &&
                        homeController.tagIndex.value == index
                    ? TextStyle(color: MoonColors.light.goku)
                    : null)
            .subHeader(),
        onTap: () {
          closeDrawer();
          homeController.pageIndex.value = 0;
          homeController.tagIndex.value = index;
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
        backgroundColor: homeController.pageIndex.value == index
            ? Get.context?.moonTheme?.tokens.colors.piccolo
            : Colors.transparent,
        label: Text(label,
                style: homeController.pageIndex.value == index
                    ? TextStyle(color: MoonColors.light.goku)
                    : null)
            .subHeader(),
        leading: icon == null
            ? null
            : Icon(
                icon,
                color: homeController.pageIndex.value == index
                    ? MoonColors.light.goku
                    : null,
              ),
        onTap: () {
          closeDrawer();
          homeController.pageIndex.value = index;
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
