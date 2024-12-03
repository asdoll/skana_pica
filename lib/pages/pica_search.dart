import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skana_pica/controller/categories.dart';
import 'package:skana_pica/controller/searchhistory.dart';
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
  late CategoriesController categoriesController;
  bool showDelete = false;

  @override
  void initState() {
    super.initState();
    controller = SearchController();
    categoriesController = Get.put(CategoriesController());
    categoriesController.fetchCategories();
  }

  @override
  void dispose() {
    controller.dispose();
    Get.delete<CategoriesController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          titleSpacing: 8,
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
            slivers: [
              SliverPadding(padding: const EdgeInsets.only(top: 8.0)),
              SliverToBoxAdapter(
                child: (searchHistoryController.searchHistory.isNotEmpty)
                    ? Text("Search History".tr).paddingAll(12.0)
                    : Container(),
              ),
              SliverToBoxAdapter(
                child: (searchHistoryController.searchHistory.isNotEmpty)
                    ? Wrap(
                        runSpacing: 0.0,
                        spacing: 5.0,
                        children: searchHistoryController.searchHistory
                            .map((e) => Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: GestureDetector(
                                  onTap: () {
                                    controller.text = e;
                                    onSubmitted(e);
                                  },
                                  child: Chip(
                                    label: Text(e),
                                    deleteIcon: const Icon(Icons.clear),
                                    onDeleted: () {
                                      searchHistoryController.removeHistory(e);
                                    },
                                  ),
                                )))
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
                child: Text("Categories".tr).paddingAll(12.0),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(8.0),
                sliver: SliverGrid.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: categoriesController.categories.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => Go.to(
                          PicaCatComicsPage(
                              id: categoriesController.categories[index],
                              type: "category"),
                          preventDuplicates: false),
                      onLongPress: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("block_cate".trParams(
                                    {"cate": categoriesController.categories[index]})),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("Cancel".tr)),
                                  TextButton(
                                      onPressed: () {
                                        categoriesController
                                            .blockCategory(categoriesController
                                                .categories[index]);
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
                                  categoriesController.categories[index]),
                              fit: BoxFit.cover,
                              width: 300,
                              height: 300,
                            ),
                            Opacity(
                              opacity: 0.4,
                              child: Container(
                                decoration: BoxDecoration(color: Colors.black),
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
                                      categoriesController.categories[index],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white),
                                    ),
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
