import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skana_pica/api/comic_sources/picacg/pica_source.dart';
import 'package:skana_pica/controller/categories.dart';
import 'package:skana_pica/pages/leaderboard.dart';
import 'package:skana_pica/pages/mainscreen.dart';
import 'package:skana_pica/pages/setting/manga.dart';
import 'package:skana_pica/util/leaders.dart';
import 'package:skana_pica/widgets/pica_comic_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final HomePageController homePageController = Get.put(HomePageController());

  @override
  void initState() {
    super.initState();
    homePageController.reload();
  }

  @override
  void dispose() {
    Get.delete<HomePageController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => categoriesController
                    .mainPageTags[homePageController.tabIndex.value] ==
                "Leaderboard"
            ? Row(
                children: [
                  Icon(Icons.leaderboard),
                  Expanded(
                    child: Text("Leaderboard".tr),
                  ),
                  DropdownButton<String>(
                      items: leaderboardController.items.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        leaderboardController.type.value = value!;
                        Leader.mainScreenEasyRefreshController.callRefresh();
                      },
                      value: leaderboardController.type.value),
                ],
              )
            : Text(categoriesController
                .mainPageTags[homePageController.tabIndex.value].tr)),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              showMenu(
                  context: context,
                  position: RelativeRect.fromLTRB(100, 100, 0, 0),
                  items: [
                    PopupMenuItem(
                      child: ListTile(
                        title: Text("Manage".tr),
                        onTap: () {
                          Get.back();
                          mainScreenIndex.index.value = 2;
                          Get.to(MangaSettingPage(
                            fromMain: true,
                          ));
                        },
                      ),
                    ),
                  ]);
            },
          ),
        ],
      ),
      body: buildTabs(),
    );
  }

  Widget buildTabs() {
    return Obx(() => DefaultTabController(
          length: homePageController.tabs.length,
          child: Column(
            children: [
              TabBar(
                tabs: homePageController.tabs,
                isScrollable: true,
                onTap: (index) {
                  homePageController.tabIndex.value = index;
                },
              ),
              Expanded(
                child: TabBarView(
                  children: homePageController.pages,
                ),
              )
            ],
          ),
        ));
  }
}

class HomePageController extends GetxController {
  RxInt tabIndex = 0.obs;
  RxList<Tab> tabs = <Tab>[].obs;
  RxList<Widget> pages = <Widget>[].obs;

  void reload({bool callback = false}) {
    tabs.clear();
    for (int i = 0; i < categoriesController.mainPageTags.length; i++) {
      tabs.add(Tab(
        text: categoriesController.mainPageTags[i].tr,
      ));
      if (categoriesController.mainPageTags[i] == "Leaderboard") {
        pages.add(PicaComicsPage(
            keyword: "leaderboard",
            type: leaderboardController.type.value,
            isMain: true,
            easyRefreshController: Leader.mainScreenEasyRefreshController));
      } else if (categoriesController.mainPageTags[i] == "Random") {
        pages.add(PicaComicsPage(
          keyword: "random",
          type: "fixed",
          addToHistory: false,
          isMain: true,
          easyRefreshController: Leader.mainScreenEasyRefreshController,
        ));
      } else if (categoriesController.mainPageTags[i] == "Latest") {
        pages.add(PicaComicsPage(
          keyword: "latest",
          type: "fixed",
          addToHistory: false,
          isMain: true,
          easyRefreshController: Leader.mainScreenEasyRefreshController,
        ));
      } else if (categoriesController.mainPageTags[i] == "Bookmarks") {
        pages.add(PicaComicsPage(
          keyword: "bookmarks",
          type: "fixed",
          addToHistory: false,
          isMain: true,
          easyRefreshController: Leader.mainScreenEasyRefreshController,
        ));
      } else if (picacg.categories
          .contains(categoriesController.mainPageTags[i])) {
        pages.add(PicaComicsPage(
          keyword: categoriesController.mainPageTags[i],
          type: "category",
          addToHistory: false,
          isMain: true,
          easyRefreshController: Leader.mainScreenEasyRefreshController,
        ));
      } else {
        pages.add(PicaComicsPage(
          keyword: categoriesController.mainPageTags[i],
          type: "search",
          addToHistory: false,
          isMain: true,
          easyRefreshController: Leader.mainScreenEasyRefreshController,
        ));
      }
    }
    pages.refresh();
    tabs.refresh();
  }
}
