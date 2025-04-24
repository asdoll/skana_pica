import 'dart:math';

import 'package:flutter/material.dart';
import 'package:skana_pica/controller/categories.dart';
import 'package:skana_pica/controller/main_controller.dart';
import 'package:get/get.dart';
import 'package:skana_pica/pages/pica_list_comics.dart';
import 'package:skana_pica/util/leaders.dart';
import 'package:skana_pica/util/widgetplugin.dart';

class PicaCatsPage extends StatefulWidget {
  const PicaCatsPage({super.key});

  @override
  State<PicaCatsPage> createState() => _PicaCatsPageState();
}

class _PicaCatsPageState extends State<PicaCatsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Obx(
      () => CustomScrollView(
        controller: globalScrollController,
        slivers: [
          SliverPadding(padding: const EdgeInsets.only(top: 8.0)),
          SliverPadding(
            padding: const EdgeInsets.all(8.0),
            sliver: SliverGrid.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: max(3,min(5, (context.width / 150).floor())),
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: categoriesController.categories.length + 3,
              itemBuilder: (context, index) {
                if (index < 3) {
                  return InkWell(
                    onTap: () {
                      if (index == 0) {
                        Go.to(PicaCatComicsPage(id: "random", type: "fixed"),
                            preventDuplicates: false);
                      } else if (index == 1) {
                        Go.to(PicaCatComicsPage(id: "latest", type: "fixed"),
                            preventDuplicates: false);
                      } else {
                        Go.to(
                            PicaCatComicsPage(id: "leaderboard", type: "fixed"),
                            preventDuplicates: false);
                      }
                    },
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
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
                                children: <Widget>[
                                  Text(
                                    fixedCategories[index].tr,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white),
                                  ).subHeader(),
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
                              "cate": categoriesController.categories[index - 3]
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
                        borderRadius: BorderRadius.all(Radius.circular(8.0))),
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
                                  categoriesController.categories[index - 3],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                ).subHeader()
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
}
