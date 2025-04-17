import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skana_pica/controller/categories.dart';
import 'package:skana_pica/controller/main_controller.dart';
import 'package:skana_pica/controller/searchhistory.dart';
import 'package:skana_pica/pages/leaderboard.dart';
import 'package:skana_pica/pages/mainscreen.dart';
import 'package:skana_pica/pages/pica_list_comics.dart';
import 'package:skana_pica/pages/pica_results.dart';
import 'package:skana_pica/util/leaders.dart';

class PicaSearchPage extends StatefulWidget {
  static const route = "${Mains.route}search";

  const PicaSearchPage({super.key});

  @override
  State<PicaSearchPage> createState() => _PicaSearchPageState();
}

class _PicaSearchPageState extends State<PicaSearchPage> {
  late SearchController controller;
  bool showDelete = false;

  @override
  void initState() {
    super.initState();
    controller = SearchController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          titleSpacing: 8,
          toolbarHeight: kToolbarHeight + 16,
          title: SearchBar(
            shape: WidgetStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0))),
            hintText: "Search".tr,
            onSubmitted: onSubmitted,
            onChanged: (value) => setState(() {
              showDelete = value.isNotEmpty;
            }),
            controller: controller,
            trailing: [
              if (showDelete)
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    controller.clear();
                  },
                ),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  onSubmitted(controller.text);
                },
              ),
            ],
          ),
        ),
        body: Obx(
          () => CustomScrollView(
            controller: globalScrollController,
            slivers: [
              SliverPadding(padding: const EdgeInsets.only(top: 8.0)),
              SliverToBoxAdapter(
                child: (searchHistoryController.searchHistory.isNotEmpty)
                    ? Text(
                        "Search History".tr,
                        style: TextStyle(fontSize: 16),
                      ).paddingAll(12.0)
                    : Container(),
              ),
              SliverToBoxAdapter(
                child: (searchHistoryController.searchHistory.isNotEmpty)
                    ? Wrap(
                        runSpacing: 0.0,
                        spacing: 5.0,
                        children: searchHistoryController.searchHistory
                            .map(
                              (e) => Chip(
                                label: Text(e),
                                deleteIcon: const Icon(Icons.clear),
                                onDeleted: () {
                                  searchHistoryController.removeHistory(e);
                                },
                              ),
                            )
                            .toList(),
                      ).paddingSymmetric(horizontal: 8.0)
                    : Container(),
              ),
              SliverToBoxAdapter(
                  child: (searchHistoryController.searchHistory.isNotEmpty)
                      ? InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Clean history?".tr),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("Cancel".tr)),
                                      TextButton(
                                          onPressed: () {
                                            searchHistoryController
                                                .clearHistory();
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("Ok".tr)),
                                    ],
                                  );
                                });
                          },
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.delete_outline,
                                    size: 18.0,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .color,
                                  ),
                                  Text(
                                    "Clear search history".tr,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .color),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      : Container()),
              SliverToBoxAdapter(
                child: Text(
                  "Categories".tr,
                  style: TextStyle(fontSize: 16),
                ).paddingSymmetric(horizontal: 12.0, vertical: 8.0),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(8.0),
                sliver: SliverGrid.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: categoriesController.categories.length + 3,
                  itemBuilder: (context, index) {
                    if (index < 3) {
                      return InkWell(
                        onTap: () {
                          if (index == 0) {
                            Go.to(
                                PicaCatComicsPage(id: "random", type: "fixed"),
                                preventDuplicates: false);
                          } else if (index == 1) {
                            Go.to(
                                PicaCatComicsPage(id: "latest", type: "fixed"),
                                preventDuplicates: false);
                          } else {
                            Go.to(LeaderboardPage(), preventDuplicates: false);
                          }
                        },
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0))),
                          child: Stack(
                            children: <Widget>[
                              Image.asset(
                                categoriesController.getCoverImg(
                                    fixedCategories[index].toLowerCase()),
                                fit: BoxFit.cover,
                                width: 300,
                                height: 300,
                              ),
                              Opacity(
                                opacity: Get.isDarkMode ? 0.4 : 0,
                                child: Container(
                                  decoration:
                                      BoxDecoration(color: Colors.black),
                                ),
                              ),
                              if (!Get.isDarkMode)
                                Positioned(
                                  bottom: 0,
                                  child: Container(
                                    width: 300,
                                    height: 60,
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: <Color>[
                                          Colors.transparent,
                                          Colors.black87,
                                        ],
                                        tileMode: TileMode.mirror,
                                      ),
                                    ),
                                  ),
                                ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(
                                        fixedCategories[index].tr,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return InkWell(
                      onTap: () => Go.to(
                          PicaCatComicsPage(
                              id: categoriesController.categories[index - 3],
                              type: "category"),
                          preventDuplicates: false),
                      onLongPress: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("block_cate".trParams({
                                  "cate":
                                      categoriesController.categories[index - 3]
                                })),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("Cancel".tr)),
                                  TextButton(
                                      onPressed: () {
                                        categoriesController.blockCategory(
                                            categoriesController
                                                .categories[index - 3]);
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("Ok".tr)),
                                ],
                              );
                            });
                      },
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0))),
                        child: Stack(
                          children: <Widget>[
                            Image.asset(
                              categoriesController.getCoverImg(
                                  categoriesController.categories[index - 3]),
                              fit: BoxFit.cover,
                              width: 300,
                              height: 300,
                            ),
                            Opacity(
                              opacity: Get.isDarkMode ? 0.4 : 0,
                              child: Container(
                                decoration: BoxDecoration(color: Colors.black),
                              ),
                            ),
                            if (!Get.isDarkMode)
                              Positioned(
                                bottom: 0,
                                child: Container(
                                  width: 300,
                                  height: 60,
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: <Color>[
                                        Colors.transparent,
                                        Colors.black87,
                                      ],
                                      tileMode: TileMode.mirror,
                                    ),
                                  ),
                                ),
                              ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      categoriesController
                                          .categories[index - 3],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ));
  }

  void onSubmitted(String value) {
    searchHistoryController.addHistory(value);
    Go.to(PicaResultsPage(keyword: value), preventDuplicates: false);
  }
}
