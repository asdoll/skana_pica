import 'dart:math';

import 'package:easy_localization/easy_localization.dart'
    show StringTranslateExtension;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moon_design/moon_design.dart';
import 'package:skana_pica/controller/categories.dart';
import 'package:skana_pica/controller/main_controller.dart';

import 'package:skana_pica/pages/pica_list_comics.dart';
import 'package:skana_pica/util/leaders.dart';
import 'package:skana_pica/util/widgetplugin.dart';

class PicaCatsPage extends StatefulHookConsumerWidget {
  const PicaCatsPage({super.key});

  @override
  ConsumerState<PicaCatsPage> createState() => _PicaCatsPageState();
}

class _PicaCatsPageState extends ConsumerState<PicaCatsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: globalScrollController,
        slivers: [
          SliverPadding(padding: const EdgeInsets.only(top: 8.0)),
          SliverPadding(
            padding: const EdgeInsets.all(8.0),
            sliver: SliverGrid.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: max(3,
                    min(5, (MediaQuery.of(context).size.width / 150).floor())),
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: ref.watch(categoryProvider).categories.length + 3,
              itemBuilder: (context, index) {
                if (index < 3) {
                  return InkWell(
                    onTap: () {
                      if (index == 0) {
                        Go.to(PicaCatComicsPage(id: "random", type: "fixed"));
                      } else if (index == 1) {
                        Go.to(PicaCatComicsPage(id: "latest", type: "fixed"));
                      } else {
                        Go.to(PicaCatComicsPage(
                            id: "leaderboard", type: "fixed"));
                      }
                    },
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      child: Stack(
                        children: <Widget>[
                          Image.asset(
                            ref
                                .read(categoryProvider.notifier)
                                .getCoverImg(fixedCategories[index]),
                            fit: BoxFit.cover,
                            width: 300,
                            height: 300,
                          ),
                          Opacity(
                            opacity: context.isDarkMode ? 0.4 : 0,
                            child: Container(
                              decoration: BoxDecoration(color: Colors.black),
                            ),
                          ),
                          if (!context.isDarkMode)
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
                                    fixedCategories[index].tr(),
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
                  onTap: () => Go.to(PicaCatComicsPage(
                      id: ref.watch(categoryProvider).categories[index - 3],
                      type: "category")),
                  onLongPress: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("block_cate".tr(args: [
                              ref.watch(categoryProvider).categories[index - 3]
                            ])),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("cancel".tr())),
                              TextButton(
                                  onPressed: () {
                                    ref
                                        .read(categoryProvider.notifier)
                                        .blockCategory(ref
                                            .read(categoryProvider)
                                            .categories[index - 3]);
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("ok".tr())),
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
                          ref.read(categoryProvider.notifier).getCoverImg(
                              ref.read(categoryProvider).categories[index - 3]),
                          fit: BoxFit.cover,
                          width: 300,
                          height: 300,
                        ),
                        Opacity(
                          opacity: context.isDarkMode ? 0.4 : 0,
                          child: Container(
                            decoration: BoxDecoration(color: Colors.black),
                          ),
                        ),
                        if (!context.isDarkMode)
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
                                  ref
                                      .watch(categoryProvider)
                                      .categories[index - 3],
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
    );
  }
}
