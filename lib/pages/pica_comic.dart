import 'dart:math';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:moon_design/moon_design.dart';
import 'package:skana_pica/api/comic_sources/picacg/pica_models.dart';
import 'package:skana_pica/api/managers/image_cache_manager.dart';
import 'package:skana_pica/controller/comicstore.dart';
import 'package:skana_pica/pages/pica_comments.dart';
import 'package:skana_pica/pages/pica_list_comics.dart';
import 'package:skana_pica/pages/pica_read.dart';
import 'package:skana_pica/util/leaders.dart';
import 'package:skana_pica/util/tool.dart';
import 'package:skana_pica/util/widgetplugin.dart';
import 'package:skana_pica/widgets/icons.dart';
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
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    comicDetailController = Get.put(ComicStore(), tag: widget.comic.id);
    comicDetailController.fetch(widget.comic.id);
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    Get.delete<ComicStore>(tag: widget.comic.id);
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color bgColor =
        context.moonTheme?.tokens.colors.frieza60 ?? Colors.deepPurpleAccent;
    Color bgColor2 =
        context.moonTheme?.tokens.colors.chichi60 ?? Colors.deepPurpleAccent;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: appBar(title: widget.comic.title),
      backgroundColor: context.moonTheme?.tokens.colors.gohan,
      body: Obx(() {
        if (comicDetailController.isLoading.value) {
          return Center(child: progressIndicator(context));
        }
        return ListView(children: [
          SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 8,
              ),
              PicaImage(
                comicDetailController.comic.value.cover,
                width: context.width / 3,
                height: context.width / 3 * 1.5,
                fit: BoxFit.cover,
              ).rounded(8.0),
              SizedBox(
                width: 8,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(comicDetailController.comic.value.title).appHeader(),
                    SizedBox(
                      height: 4,
                    ),
                    InkWell(
                      onLongPress: () => blockDialog(
                          context, comicDetailController.comic.value.author),
                      onTap: () {
                        Go.to(
                            PicaCatComicsPage(
                                id: comicDetailController.comic.value.author,
                                type: "author"),
                            preventDuplicates: false);
                      },
                      child: Text(comicDetailController.comic.value.author,
                          maxLines: 1,
                          style: TextStyle(
                            color: context.moonTheme?.tokens.colors.trunks
                                .applyDarkMode(),
                          )).small(),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Row(
                      children: [
                        Icon(
                          BootstrapIcons.heart,
                          size: 11,
                          color: context.moonTheme?.tokens.colors.piccolo,
                        ).paddingTop(2),
                        const SizedBox(
                          width: 2,
                        ),
                        Text(
                          comicDetailController.comic.value.likes.toString(),
                          strutStyle: const StrutStyle(
                              forceStrutHeight: true, leading: 0),
                        ).small(),
                        const SizedBox(
                          width: 8,
                        ),
                        Icon(
                          BootstrapIcons.eye,
                          size: 11,
                          color: context.moonTheme?.tokens.colors.piccolo,
                        ).paddingTop(2),
                        const SizedBox(
                          width: 2,
                        ),
                        Text(
                          comicDetailController.comic.value.totalViews
                              .toString(),
                          strutStyle: const StrutStyle(
                              forceStrutHeight: true, leading: 0),
                        ).small(),
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
                          BootstrapIcons.journal_text,
                          size: 11,
                          color: context.moonTheme?.tokens.colors.piccolo,
                        ).paddingTop(2),
                        const SizedBox(
                          width: 2,
                        ),
                        Text(
                          '${comicDetailController.comic.value.epsCount}E/${comicDetailController.comic.value.pagesCount}P',
                          strutStyle: const StrutStyle(
                              forceStrutHeight: true, leading: 0),
                        ).small(),
                        const SizedBox(
                          width: 8,
                        ),
                        if (comicDetailController.comic.value.finished == true)
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
                        PicaLikeButton(comicDetailController.comic.value.id,
                            isLike: comicDetailController.comic.value.isLiked),
                        SizedBox(
                          width: 8,
                        ),
                        PicaFavorButton(comicDetailController.comic.value.id, filled: false),
                        SizedBox(
                          width: 8,
                        ),
                        MoonButton.icon(
                            icon: Icon(BootstrapIcons.download, size: iconSize),
                            onTap: () {
                              showMoonModalBottomSheet(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                context: context,
                                transitionDuration:
                                    const Duration(milliseconds: 200),
                                builder: (context) {
                                  return SafeArea(
                                      child: SizedBox(
                                          height: min(
                                              Get.mediaQuery.size.height * 0.6,
                                              400),
                                          child: Scaffold(
                                            body: Obx(
                                              () => Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text("Download".tr)
                                                      .appHeader()
                                                      .paddingVertical(16),
                                                  Expanded(
                                                      child: Scrollbar(
                                                    thumbVisibility: true,
                                                    trackVisibility: true,
                                                    radius: Radius.circular(8),
                                                    child: ListView(children: [
                                                      Wrap(
                                                        spacing: 4,
                                                        children: [
                                                          for (int index = 0;
                                                              index <
                                                                  comicDetailController
                                                                      .epsList
                                                                      .length;
                                                              index++)
                                                            picaChoiceChip(
                                                              text:
                                                                  comicDetailController
                                                                      .epsList[
                                                                          index]
                                                                      .eps,
                                                              selected: comicDetailController
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
                                                    ]),
                                                  )),
                                                  SizedBox(
                                                    height: 16,
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      filledButton(
                                                          onPressed: () {
                                                            if (comicDetailController
                                                                .selectDownload
                                                                .isEmpty) {
                                                              showToast(
                                                                  "Please select at least one episode"
                                                                      .tr,
                                                                  const Duration(
                                                                      seconds:
                                                                          2));
                                                              return;
                                                            }
                                                            comicDetailController
                                                                .download();
                                                            Get.back();
                                                          },
                                                          label:
                                                              "Download Selected"
                                                                  .tr),
                                                      SizedBox(
                                                        width: 16,
                                                      ),
                                                      filledButton(
                                                          onPressed: () {
                                                            comicDetailController
                                                                .selectDownloadsAll();
                                                            comicDetailController
                                                                .download();
                                                            Get.back();
                                                          },
                                                          label: "Download All"
                                                              .tr),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 30,
                                                  )
                                                ],
                                              ).paddingHorizontal(16),
                                            ),
                                          )));
                                },
                              );
                            })
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
          Divider(
              indent: 8,
              endIndent: 8,
              color: context.moonTheme?.tokens.colors.bulma
                  .withValues(alpha: 0.2)),
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
                backgroundColor: bgColor,
              ),
              ...comicDetailController.comic.value.categories
                  .map((e) => PicaTag(
                        text: e,
                        type: 'category',
                        backgroundColor: bgColor,
                      ))
            ],
          ).paddingHorizontal(16),
          SizedBox(
            height: 8,
          ),
          if (comicDetailController
              .comic.value.chineseTeam.removeAllBlank.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                PicaTag(
                  text: "Chinese".tr,
                  type: '',
                  backgroundColor: context.moonTheme?.tokens.colors.cell60 ??
                      Colors.deepPurpleAccent,
                ),
                PicaTag(
                  text: comicDetailController.comic.value.chineseTeam,
                  type: 'tag',
                  backgroundColor: context.moonTheme?.tokens.colors.cell60 ??
                      Colors.deepPurpleAccent,
                )
              ],
            ).paddingHorizontal(16),
          if (comicDetailController
              .comic.value.chineseTeam.removeAllBlank.isNotEmpty)
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
                backgroundColor: bgColor2,
              ),
              ...comicDetailController.comic.value.tags.map((e) => PicaTag(
                    text: e,
                    type: 'tag',
                    backgroundColor: bgColor2,
                  ))
            ],
          ).paddingHorizontal(16),
          SizedBox(
            height: 8,
          ),
          moonCard(
            backgroundColor: bgColor,
            padding: EdgeInsets.only(top: 6, bottom: 12),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 16,
                ),
                CircleAvatar(
                  radius: 30,
                  backgroundImage: imageProvider(
                      comicDetailController.comic.value.creator.avatarUrl),
                ),
                SizedBox(
                  width: 8,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(comicDetailController.comic.value.creator.name)
                        .header(),
                    Text(
                      "${DateFormat.yMd(Get.locale.toString()).add_jm().format(DateTime.parse(comicDetailController.comic.value.time))} ${"Updated".tr}",
                    ).subHeader(),
                  ],
                ),
                SizedBox(
                  width: 32,
                ),
              ],
            ),
          ).paddingHorizontal(16),
          SizedBox(
            height: 8,
          ),
          if (comicDetailController
              .comic.value.description.removeAllBlank.isNotEmpty)
            Divider(
                indent: 8,
                endIndent: 8,
                color: context.moonTheme?.tokens.colors.bulma
                    .withValues(alpha: 0.2)),
          if (comicDetailController
              .comic.value.description.removeAllBlank.isNotEmpty)
            SizedBox(
              height: 8,
            ),
          if (comicDetailController
              .comic.value.description.removeAllBlank.isNotEmpty)
            Text("${"Description: ".tr}\n      ${comicDetailController.comic.value.description}")
                .subHeader()
                .paddingHorizontal(16),
          if (comicDetailController
              .comic.value.description.removeAllBlank.isNotEmpty)
            SizedBox(
              height: 8,
            ),
          Divider(
              color: context.moonTheme?.tokens.colors.bulma
                  .withValues(alpha: 0.2)),
          MoonTabBar(
            tabController: tabController,
            tabs: [
              MoonTab(
                label: Text(
                    "${"Episodes".tr}(${comicDetailController.comic.value.epsCount})"),
              ),
              MoonTab(
                label: Text(
                  "Comments".tr +
                      (comicDetailController.comments.value.total > 0
                          ? "(${comicDetailController.comments.value.total})"
                          : ""),
                ),
              ),
              MoonTab(
                label: Text("Related".tr),
              ),
            ],
          ),
          SizedBox(
            height: context.height * 0.5,
            child: TabBarView(
              controller: tabController,
              children: [
                Scrollbar(
                    child: ListView(
                  children: [
                    Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 2,
                      children: [
                        if (comicDetailController.currentEps.value != 0 ||
                            comicDetailController.currentIndex.value != 0)
                          picaChoiceChip(
                            backgroundColor:
                                Get.context!.moonTheme?.tokens.colors.chichi60,
                            selectedColor:
                                Get.context!.moonTheme?.tokens.colors.chichi,
                            disabledColor:
                                Get.context!.moonTheme?.tokens.colors.chichi60,
                            text: "continue_page".trParams({
                              "eps": comicDetailController.comic.value
                                  .eps[comicDetailController.currentEps.value],
                              "page":
                                  (comicDetailController.currentIndex.value + 1)
                                      .toString()
                            }),
                            selected: false,
                            onSelected: (bool value) {
                              comicDetailController.setPage(
                                  comicDetailController.currentEps.value,
                                  comicDetailController.currentIndex.value);
                              Go.to(PicaReadPage(
                                  id: comicDetailController.comic.value.id));
                            },
                          ),
                        for (int index = 0;
                            index <
                                comicDetailController.comic.value.eps.length;
                            index++)
                          picaChoiceChip(
                            text: comicDetailController.comic.value.eps[index],
                            selected: false,
                            onSelected: (bool value) {
                              comicDetailController.setPage(index, 0);
                              Go.to(PicaReadPage(
                                  id: comicDetailController.comic.value.id));
                            },
                          ),
                      ],
                    )
                  ],
                )).paddingAll(16),
                ListView(
                  children: [
                    SizedBox(height: 16),
                    PicaCommentBar(comicDetailController.comic.value.id,
                        isComic: true),
                    for (int index = 0;
                        index <
                            min(
                                comicDetailController
                                    .comments.value.comments.length,
                                5);
                        index++)
                      PicaCommentTile(
                          comment: comicDetailController
                              .comments.value.comments[index],
                          comicId: comicDetailController.comic.value.id),
                    if (comicDetailController.comments.value.total == 0)
                      Center(child: Text("No Comments".tr).subHeader())
                          .paddingAll(20),
                    if (comicDetailController.comments.value.total > 5)
                      InkWell(
                        onTap: () => Go.to(PicaCommentsPage(
                            comicDetailController.comic.value.id)),
                        child: Center(
                          child: Text("Load More".tr).subHeader(),
                        ).paddingAll(20),
                      ),
                  ],
                ),
                ListView(
                  children: [
                    for (int index = 0;
                        index <
                            comicDetailController
                                .comic.value.recommendation.length;
                        index++)
                      PicaComicCard(comicDetailController
                          .comic.value.recommendation[index]),
                    if (comicDetailController
                        .comic.value.recommendation.isEmpty)
                      Center(child: Text("No Related".tr).subHeader())
                          .paddingAll(20),
                    SizedBox(height: 30),
                  ],
                )
              ],
            ),
          ),
        ]);
      }),
    );
  }
}

class TabNumController extends GetxController {
  var tabNum = 0.obs;
}
