import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:skana_pica/api/comic_sources/picacg/pica_models.dart';
import 'package:skana_pica/api/managers/image_cache_manager.dart';
import 'package:skana_pica/controller/comicstore.dart';
import 'package:skana_pica/pages/pica_comments.dart';
import 'package:skana_pica/pages/pica_list_comics.dart';
import 'package:skana_pica/pages/pica_read.dart';
import 'package:skana_pica/pages/pica_results.dart';
import 'package:skana_pica/util/leaders.dart';
import 'package:skana_pica/util/widgetplugin.dart';
import 'package:skana_pica/widgets/pica_comic_card.dart';
import 'package:skana_pica/widgets/pica_comment_bar.dart';
import 'package:skana_pica/widgets/pica_comment_tile.dart';
import 'package:skana_pica/widgets/pica_image.dart';
import 'package:skana_pica/widgets/pica_like.dart';
import 'package:skana_pica/widgets/pica_tagchip.dart';

class PicacgComicPage extends StatefulWidget {
  static const route = "/pica_comic";
  final PicaComicItemBrief comic;
  const PicacgComicPage(this.comic, {super.key});

  @override
  State<StatefulWidget> createState() => _PicacgComicPageState();
}

class _PicacgComicPageState extends State<PicacgComicPage>
    with TickerProviderStateMixin {
  late ComicStore comicDetailController;

  @override
  void initState() {
    super.initState();
    comicDetailController = Get.put(ComicStore(), tag: widget.comic.id);
    comicDetailController.fetch(widget.comic.id);
  }

  @override
  void dispose() {
    Get.delete<ComicStore>(tag: widget.comic.id);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle? tagStyle = Theme.of(context).textTheme.bodyLarge;
    Color bgColor = Theme.of(context).colorScheme.primaryContainer;
    Color bgColor2 = Theme.of(context).colorScheme.primaryContainer;
    TabController tabController = TabController(length: 3, vsync: this);
    TabNumController tabNumController = Get.put(TabNumController());
    tabController.addListener(() {
      if (tabController.indexIsChanging) {
        tabNumController.tabNum.value = tabController.index;
      }
    });

    return Scaffold(
      appBar: appBar(title: widget.comic.title),
      body: Obx(() {
        if (comicDetailController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        return ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 8,
                    ),
                    PicaImage(
                      comicDetailController.comic.value.cover,
                      width: Get.width / 3,
                      height: Get.width / 3 * 1.5,
                      fit: BoxFit.cover,
                    ).rounded(8.0),
                    SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            comicDetailController.comic.value.title,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          InkWell(
                            onLongPress: () => blockDialog(context,
                                comicDetailController.comic.value.author),
                            onTap: () {
                              Go.to(
                                  PicaCatComicsPage(
                                      id: comicDetailController
                                          .comic.value.author,
                                      type: "author"),
                                  preventDuplicates: false);
                            },
                            child: Text(
                              comicDetailController.comic.value.author,
                              maxLines: 1,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      overflow: TextOverflow.ellipsis),
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          InkWell(
                            onLongPress: () => blockDialog(context,
                                comicDetailController.comic.value.chineseTeam),
                            onTap: () {
                              Go.to(
                                  PicaResultsPage(
                                    keyword: comicDetailController
                                        .comic.value.chineseTeam,
                                    addToHistory: false,
                                  ),
                                  preventDuplicates: false);
                            },
                            child: Text(
                              comicDetailController.comic.value.chineseTeam,
                              maxLines: 1,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                      overflow: TextOverflow.ellipsis),
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.favorite,
                                size: 12,
                                color: Colors.pink,
                              ),
                              const SizedBox(
                                width: 2,
                              ),
                              Text(
                                comicDetailController.comic.value.likes
                                    .toString(),
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Icon(Icons.remove_red_eye_rounded,
                                  size: 12,
                                  color: Theme.of(context)
                                      .textTheme
                                      .labelLarge!
                                      .color),
                              const SizedBox(
                                width: 2,
                              ),
                              Text(
                                comicDetailController.comic.value.totalViews
                                    .toString(),
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.sticky_note_2_outlined,
                                size: 12,
                                color: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .color,
                              ),
                              const SizedBox(
                                width: 2,
                              ),
                              Text(
                                '${comicDetailController.comic.value.epsCount}E/${comicDetailController.comic.value.pagesCount}P',
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              if (comicDetailController.comic.value.finished ==
                                  true)
                                TagFinished()
                              else
                                Container(),
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              PicaLikeButton(
                                  comicDetailController.comic.value.id,
                                  isLike: comicDetailController
                                      .comic.value.isLiked),
                              SizedBox(
                                width: 8,
                              ),
                              PicaFavorButton(
                                  comicDetailController.comic.value.id),
                              SizedBox(
                                width: 8,
                              ),
                              IconButton(
                                  icon: Icon(Icons.download_rounded,
                                      size: iconSize),
                                  onPressed: () {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          return Obx(
                                            () => SizedBox(
                                              height: Get.height / 3,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text("Download".tr,
                                                          style: Get
                                                              .theme
                                                              .textTheme
                                                              .titleLarge)
                                                      .paddingAll(16),
                                                  Expanded(child: Wrap(
                                                    spacing: 8,
                                                    runSpacing: 8,
                                                    children: [
                                                      for (int index = 0;
                                                          index <
                                                              comicDetailController
                                                                  .epsList
                                                                  .length;
                                                          index++)
                                                        ChoiceChip(
                                                          label: Text(
                                                              comicDetailController
                                                                  .epsList[
                                                                      index]
                                                                  .eps),
                                                          selected:
                                                              comicDetailController
                                                                          .selectDownload[
                                                                      index] ==
                                                                  true,
                                                          onSelected:
                                                              (bool value) {
                                                            comicDetailController
                                                                .selectDownloads(
                                                                    index);
                                                          },
                                                        )
                                                    ],
                                                  ),
                                                  ),
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      ElevatedButton(
                                                          onPressed: () {
                                                            comicDetailController
                                                                .download();
                                                            Get.back();
                                                          },
                                                          child: Text(
                                                              "Download Selected"
                                                                  .tr)),
                                                      SizedBox( width: 16,),
                                                      ElevatedButton(
                                                          onPressed: () {
                                                            comicDetailController
                                                                .selectDownloadsAll();
                                                            comicDetailController
                                                                .download();
                                                            Get.back();
                                                          },
                                                          child: Text(
                                                              "Download All"
                                                                  .tr)),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 30,
                                                  )
                                                ],
                                              ).paddingHorizontal(16),
                                            ),
                                          );
                                        });
                                  }),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Divider(indent: 8, endIndent: 8),
                SizedBox(
                  height: 8,
                ),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    PicaTag(
                      text: "Category".tr,
                      type: '',
                      style: tagStyle,
                      backgroundColor: bgColor,
                    ),
                    ...comicDetailController.comic.value.categories
                        .map((e) => PicaTag(
                              text: e,
                              type: 'category',
                              style: tagStyle,
                              backgroundColor: bgColor,
                            ))
                  ],
                ).paddingHorizontal(16),
                SizedBox(
                  height: 8,
                ),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    PicaTag(
                      text: "Tags".tr,
                      type: '',
                      style: tagStyle,
                      backgroundColor: bgColor2,
                    ),
                    ...comicDetailController.comic.value.tags
                        .map((e) => PicaTag(
                              text: e,
                              type: 'tag',
                              style: tagStyle,
                              backgroundColor: bgColor2,
                            ))
                  ],
                ).paddingHorizontal(16),
                SizedBox(
                  height: 8,
                ),
                Card(
                  color: bgColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 32,
                      ),
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: imageProvider(comicDetailController
                            .comic.value.creator.avatarUrl),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            comicDetailController.comic.value.creator.name,
                            style: Get.theme.textTheme.bodyLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${DateFormat.yMd(Get.locale.toString()).add_jm().format(DateTime.parse(comicDetailController.comic.value.time))} ${"Updated".tr}",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 32,
                      ),
                    ],
                  ).paddingVertical(8),
                ).paddingHorizontal(16),
                SizedBox(
                  height: 8,
                ),
                Divider(indent: 8, endIndent: 8),
                SizedBox(
                  height: 8,
                ),
                Text(
                  "Description: ".tr +
                      comicDetailController.comic.value.description,
                  style: Theme.of(context).textTheme.titleMedium,
                ).paddingHorizontal(16),
                SizedBox(
                  height: 8,
                ),
                Divider(),
              ],
            ),
            TabBar(
              labelStyle: Get.theme.textTheme.bodyLarge,
              controller: tabController,
              tabs: [
                Tab(
                  height: kToolbarHeight / 1.5,
                  text:
                      "${"Episodes".tr}(${comicDetailController.comic.value.epsCount})",
                ),
                Tab(
                  height: kToolbarHeight / 1.5,
                  text: "Comments".tr +
                      (comicDetailController.comments.value.total > 0
                          ? "(${comicDetailController.comments.value.total})"
                          : ""),
                ),
                Tab(
                  height: kToolbarHeight / 1.5,
                  text: "Related".tr,
                ),
              ],
            ),
            SizedBox(
              height: 8,
              child: TabBarView(
                controller: tabController,
                children: [Container(), Container(), Container()],
              ),
            ),
            if (tabNumController.tabNum.value == 0)
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (comicDetailController.currentEps.value != 0 ||
                      comicDetailController.currentIndex.value != 0)
                    ChoiceChip(
                      label: Text("continue_page".trParams({
                        "eps": comicDetailController.comic.value
                            .eps[comicDetailController.currentEps.value],
                        "page":
                            comicDetailController.currentIndex.value.toString()
                      })),
                      selected: false,
                      onSelected: (bool value) {
                        comicDetailController.setPage(
                            comicDetailController.currentEps.value,
                            comicDetailController.currentIndex.value);
                        Go.to(PicaReadPage(
                            id: comicDetailController.comic.value.id));
                      },
                      backgroundColor: bgColor2,
                    ),
                  for (int index = 0;
                      index < comicDetailController.comic.value.eps.length;
                      index++)
                    ChoiceChip(
                      label: Text(comicDetailController.comic.value.eps[index]),
                      selected: false,
                      onSelected: (bool value) {
                        comicDetailController.setPage(index, 0);
                        Go.to(PicaReadPage(
                            id: comicDetailController.comic.value.id));
                      },
                    ),
                ],
              ).paddingAll(16),
            if (tabNumController.tabNum.value == 1)
              for (int index = 0;
                  index <
                      min(comicDetailController.comments.value.comments.length,
                          5);
                  index++)
                PicaCommentTile(
                    comment:
                        comicDetailController.comments.value.comments[index],
                    comicId: comicDetailController.comic.value.id),
            if (tabNumController.tabNum.value == 1 &&
                comicDetailController.comments.value.total == 0)
              Center(child: Text("No Comments".tr)).paddingAll(20),
            if (tabNumController.tabNum.value == 1 &&
                comicDetailController.comments.value.total > 5)
              InkWell(
                onTap: () => Go.to(
                    PicaCommentsPage(comicDetailController.comic.value.id)),
                child: Center(
                  child: Text("Load More".tr),
                ).paddingAll(20),
              ),
            if (tabNumController.tabNum.value == 1)
              PicaCommentBar(comicDetailController.comic.value.id,
                  isComic: true),
            if (tabNumController.tabNum.value == 2)
              for (int index = 0;
                  index <
                      comicDetailController.comic.value.recommendation.length;
                  index++)
                PicaComicCard(
                    comicDetailController.comic.value.recommendation[index]),
            if (tabNumController.tabNum.value == 2 &&
                comicDetailController.comic.value.recommendation.isEmpty)
              Center(child: Text("No Related".tr)).paddingAll(20),
          ],
        );
      }),
    );
  }
}

class TabNumController extends GetxController {
  var tabNum = 0.obs;
}
