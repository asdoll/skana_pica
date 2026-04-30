import 'dart:math';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:easy_localization/easy_localization.dart'
    show StringTranslateExtension, BuildContextEasyLocalizationExtension;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:intl/intl.dart';
import 'package:moon_design/moon_design.dart';
import 'package:skana_pica/api/comic_sources/picacg/pica_models.dart';
import 'package:skana_pica/api/managers/image_cache_manager.dart';
import 'package:skana_pica/api/models/objectbox_models.dart' show DownloadTask;
import 'package:skana_pica/controller/comicstore.dart';
import 'package:skana_pica/pages/pica_comments.dart';
import 'package:skana_pica/pages/pica_list_comics.dart';
import 'package:skana_pica/pages/pica_read.dart';
import 'package:skana_pica/util/leaders.dart';
import 'package:skana_pica/util/tool.dart' show StringExtension;
import 'package:skana_pica/util/widgetplugin.dart';
import 'package:skana_pica/widgets/icons.dart';
import 'package:skana_pica/widgets/pica_comic_card.dart';
import 'package:skana_pica/widgets/pica_comment_bar.dart';
import 'package:skana_pica/widgets/pica_comment_tile.dart';
import 'package:skana_pica/widgets/pica_image.dart';
import 'package:skana_pica/widgets/pica_like.dart';
import 'package:skana_pica/widgets/pica_tagchip.dart';

class PicacgComicPage extends StatefulHookConsumerWidget {
  static const route = "/pica_comic";
  final PicaComicItemBrief? comic;
  final DownloadTask? task;
  const PicacgComicPage(this.comic, this.task, {super.key});

  @override
  ConsumerState<PicacgComicPage> createState() => _PicacgComicPageState();
}

class _PicacgComicPageState extends ConsumerState<PicacgComicPage>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isLocal = widget.task != null;
    ComicStoreSource source = isLocal? ComicStoreSource.local : ComicStoreSource.online;
    final comicStore = comicStoreProvider(widget.comic!.id,
        widget.task != null ? ComicStoreSource.local : ComicStoreSource.online);
    ref.read(comicStore.notifier).fetch(comic: widget.comic, t: widget.task);
    Color bgColor =
        context.moonTheme?.tokens.colors.frieza60 ?? Colors.deepPurpleAccent;
    Color bgColor2 =
        context.moonTheme?.tokens.colors.chichi60 ?? Colors.deepPurpleAccent;

    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: appBar(title: ref.watch(comicStore).comic.title),
        backgroundColor: context.moonTheme?.tokens.colors.gohan,
        body: (ref.watch(comicStore).isLoading)
            ? Center(child: progressIndicator(context))
            : ListView(children: [
                SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 8,
                    ),
                    PicaImage(
                      ref.watch(comicStore).comic.cover,
                      width: MediaQuery.of(context).size.width / 3,
                      height: MediaQuery.of(context).size.width / 3 * 1.5,
                      fit: BoxFit.cover,
                      downloaded: isLocal,
                    ).rounded(8.0),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(ref.watch(comicStore).comic.title).appHeader(),
                          SizedBox(
                            height: 4,
                          ),
                          InkWell(
                            onLongPress: () => blockDialog(context,
                                ref.watch(comicStore).comic.author, ref),
                            onTap: () {
                              Go.to(PicaCatComicsPage(
                                  id: ref.watch(comicStore).comic.author,
                                  type: "author"));
                            },
                            child: Text(ref.watch(comicStore).comic.author,
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
                                ref.watch(comicStore).comic.likes.toString(),
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
                                ref
                                    .watch(comicStore)
                                    .comic
                                    .totalViews
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
                                '${ref.watch(comicStore).comic.epsCount}E/${ref.watch(comicStore).comic.pagesCount}P',
                                strutStyle: const StrutStyle(
                                    forceStrutHeight: true, leading: 0),
                              ).small(),
                              const SizedBox(
                                width: 8,
                              ),
                              if (ref.watch(comicStore).comic.finished == true)
                                TagFinished()
                              else
                                Container(),
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          isLocal
                              ? Row(
                                  children: [
                                    filledButton(
                                        onPressed: () => Go.to(PicacgComicPage(
                                            ref
                                                .watch(comicStore)
                                                .comic
                                                .toBrief(),
                                            null)),
                                        label: "comic_page".tr()),
                                  ],
                                )
                              : Row(
                                  children: [
                                    PicaLikeButton(
                                        ref.watch(comicStore).comic.id,
                                        isLike: ref
                                            .watch(comicStore)
                                            .comic
                                            .isLiked),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    PicaFavorButton(
                                        ref.watch(comicStore).comic.id,
                                        filled: false),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    MoonButton.icon(
                                        icon: Icon(BootstrapIcons.download,
                                            size: iconSize),
                                        onTap: () {
                                          showMoonModalBottomSheet(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8)),
                                            context: context,
                                            transitionDuration: const Duration(
                                                milliseconds: 200),
                                            builder: (context) {
                                              return SafeArea(
                                                  child: SizedBox(
                                                height: min(
                                                    MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        0.6,
                                                    400),
                                                child: Scaffold(
                                                  body: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text("download".tr())
                                                          .appHeader()
                                                          .paddingVertical(16),
                                                      Expanded(
                                                          child: Scrollbar(
                                                        thumbVisibility: true,
                                                        trackVisibility: true,
                                                        radius:
                                                            Radius.circular(8),
                                                        child: ListView(
                                                            children: [
                                                              Wrap(
                                                                spacing: 4,
                                                                children: [
                                                                  for (int index =
                                                                          0;
                                                                      index <
                                                                          ref
                                                                              .watch(comicStore)
                                                                              .epsList
                                                                              .length;
                                                                      index++)
                                                                    picaChoiceChip(
                                                                      text: ref
                                                                          .watch(
                                                                              comicStore)
                                                                          .epsList[
                                                                              index]
                                                                          .eps,
                                                                      selected: ref
                                                                              .watch(comicStore)
                                                                              .selectDownload[index] ==
                                                                          true,
                                                                      onSelected:
                                                                          (bool
                                                                              value) {
                                                                        ref.read(comicStore.notifier).selectDownloads(
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
                                                                if (ref
                                                                    .read(
                                                                        comicStore)
                                                                    .selectDownload
                                                                    .isEmpty) {
                                                                  showToast(
                                                                      "please_select_at_least_one_episode"
                                                                          .tr(),
                                                                      const Duration(
                                                                          seconds:
                                                                              2));
                                                                  return;
                                                                }
                                                                ref
                                                                    .read(comicStore
                                                                        .notifier)
                                                                    .download();
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              label:
                                                                  "download_selected"
                                                                      .tr()),
                                                          SizedBox(
                                                            width: 16,
                                                          ),
                                                          filledButton(
                                                              onPressed: () {
                                                                ref
                                                                    .read(comicStore
                                                                        .notifier)
                                                                    .selectDownloadsAll();
                                                                ref
                                                                    .read(comicStore
                                                                        .notifier)
                                                                    .download();
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              label:
                                                                  "download_all"
                                                                      .tr()),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 30,
                                                      )
                                                    ],
                                                  ).paddingHorizontal(16),
                                                ),
                                              ));
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
                      text: "category".tr(),
                      type: '',
                      backgroundColor: bgColor,
                    ),
                    ...ref
                        .watch(comicStore)
                        .comic
                        .categories
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
                if (ref
                    .watch(comicStore)
                    .comic
                    .chineseTeam
                    .removeAllBlank
                    .isNotEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      PicaTag(
                        text: "chinese".tr(),
                        type: '',
                        backgroundColor:
                            context.moonTheme?.tokens.colors.cell60 ??
                                Colors.deepPurpleAccent,
                      ),
                      PicaTag(
                        text: ref.watch(comicStore).comic.chineseTeam,
                        type: 'tag',
                        backgroundColor:
                            context.moonTheme?.tokens.colors.cell60 ??
                                Colors.deepPurpleAccent,
                      )
                    ],
                  ).paddingHorizontal(16),
                if (ref
                    .watch(comicStore)
                    .comic
                    .chineseTeam
                    .removeAllBlank
                    .isNotEmpty)
                  SizedBox(
                    height: 8,
                  ),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    PicaTag(
                      text: "tags".tr(),
                      type: '',
                      backgroundColor: bgColor2,
                    ),
                    ...ref.watch(comicStore).comic.tags.map((e) => PicaTag(
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
                            ref.watch(comicStore).comic.creator.avatarUrl,
                            isLocal),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(ref.watch(comicStore).comic.creator.name)
                              .header(),
                          Text(
                            "${DateFormat.yMd(context.locale.toString()).add_jm().format(DateTime.parse(ref.watch(comicStore).comic.time))} ${"updated".tr()}",
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
                if (ref
                    .watch(comicStore)
                    .comic
                    .description
                    .removeAllBlank
                    .isNotEmpty)
                  Divider(
                      indent: 8,
                      endIndent: 8,
                      color: context.moonTheme?.tokens.colors.bulma
                          .withValues(alpha: 0.2)),
                if (ref
                    .watch(comicStore)
                    .comic
                    .description
                    .removeAllBlank
                    .isNotEmpty)
                  SizedBox(
                    height: 8,
                  ),
                if (ref
                    .watch(comicStore)
                    .comic
                    .description
                    .removeAllBlank
                    .isNotEmpty)
                  Text("${"description".tr()}:\n      ${ref.watch(comicStore).comic.description}")
                      .subHeader()
                      .paddingHorizontal(16),
                if (ref
                    .watch(comicStore)
                    .comic
                    .description
                    .removeAllBlank
                    .isNotEmpty)
                  SizedBox(
                    height: 8,
                  ),
                Divider(
                    color: context.moonTheme?.tokens.colors.bulma
                        .withValues(alpha: 0.2)),
                isLocal
                    ? Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 2,
                        children: [
                          if (ref.watch(comicStore).currentEps != 0 ||
                              ref.watch(comicStore).currentIndex != 0)
                            picaChoiceChip(
                              backgroundColor:
                                  context.moonTheme?.tokens.colors.chichi60,
                              selectedColor:
                                  context.moonTheme?.tokens.colors.chichi,
                              disabledColor:
                                  context.moonTheme?.tokens.colors.chichi60,
                              text: "continue_page".tr(args: [
                                ref
                                    .watch(comicStore)
                                    .comic
                                    .eps[ref.watch(comicStore).currentEps],
                                (ref.watch(comicStore).currentIndex + 1)
                                    .toString()
                              ]),
                              selected: false,
                              onSelected: (bool value) {
                                ref.read(comicStore.notifier).setPage(
                                    ref.read(comicStore).currentEps,
                                    ref.read(comicStore).currentIndex);
                                Go.to(PicaReadPage(
                                    id: ref.read(comicStore).comic.id,source: source));
                              },
                            ),
                          for (int index = 0;
                              index < ref.watch(comicStore).comic.eps.length;
                              index++)
                            picaChoiceChip(
                              text: ref.watch(comicStore).comic.eps[index],
                              selected: false,
                              onSelected: (bool value) {
                                ref.read(comicStore.notifier).setPage(index, 0);
                                Go.to(PicaReadPage(
                                    id: ref.read(comicStore).comic.id,source: source));
                              },
                            ),
                        ],
                      )
                    : MoonTabBar(
                        tabController: tabController,
                        tabs: [
                          MoonTab(
                            label: Text(
                                "${"episodes".tr()}(${ref.watch(comicStore).comic.epsCount})"),
                          ),
                          MoonTab(
                            label: Text(
                              "comments".tr() +
                                  (ref.watch(comicStore).comments.total > 0
                                      ? "(${ref.watch(comicStore).comments.total})"
                                      : ""),
                            ),
                          ),
                          MoonTab(
                            label: Text("related".tr()),
                          ),
                        ],
                      ),
                if (!isLocal)
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
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
                                if (ref.watch(comicStore).currentEps != 0 ||
                                    ref.watch(comicStore).currentIndex != 0)
                                  picaChoiceChip(
                                    backgroundColor: context
                                        .moonTheme?.tokens.colors.chichi60,
                                    selectedColor:
                                        context.moonTheme?.tokens.colors.chichi,
                                    disabledColor: context
                                        .moonTheme?.tokens.colors.chichi60,
                                    text: "continue_page".tr(args: [
                                      ref.watch(comicStore).comic.eps[
                                          ref.watch(comicStore).currentEps],
                                      (ref.watch(comicStore).currentIndex + 1)
                                          .toString()
                                    ]),
                                    selected: false,
                                    onSelected: (bool value) {
                                      ref.read(comicStore.notifier).setPage(
                                          ref.read(comicStore).currentEps,
                                          ref.read(comicStore).currentIndex);
                                      Go.to(PicaReadPage(
                                          id: ref.read(comicStore).comic.id,source: source));
                                    },
                                  ),
                                for (int index = 0;
                                    index <
                                        ref.watch(comicStore).comic.eps.length;
                                    index++)
                                  picaChoiceChip(
                                    text:
                                        ref.watch(comicStore).comic.eps[index],
                                    selected: false,
                                    onSelected: (bool value) {
                                      ref
                                          .read(comicStore.notifier)
                                          .setPage(index, 0);
                                      Go.to(PicaReadPage(
                                          id: ref.watch(comicStore).comic.id,source: source));
                                    },
                                  ),
                              ],
                            )
                          ],
                        )).paddingAll(16),
                        ListView(
                          children: [
                            SizedBox(height: 16),
                            PicaCommentBar(ref.watch(comicStore).comic.id,
                                isComic: true),
                            for (int index = 0;
                                index <
                                    min(
                                        ref
                                            .watch(comicStore)
                                            .comments
                                            .comments
                                            .length,
                                        5);
                                index++)
                              PicaCommentTile(
                                  comment: ref
                                      .watch(comicStore)
                                      .comments
                                      .comments[index],
                                  comicId: ref.watch(comicStore).comic.id),
                            if (ref.watch(comicStore).comments.total == 0)
                              Center(
                                      child:
                                          Text("no_comments".tr()).subHeader())
                                  .paddingAll(20),
                            if (ref.watch(comicStore).comments.total > 5)
                              InkWell(
                                onTap: () => Go.to(PicaCommentsPage(
                                    ref.watch(comicStore).comic.id)),
                                child: Center(
                                  child: Text("load_more".tr()).subHeader(),
                                ).paddingAll(20),
                              ),
                          ],
                        ),
                        ListView(
                          children: [
                            for (int index = 0;
                                index <
                                    ref
                                        .watch(comicStore)
                                        .comic
                                        .recommendation
                                        .length;
                                index++)
                              PicaComicCard(ref
                                  .watch(comicStore)
                                  .comic
                                  .recommendation[index]),
                            if (ref
                                .watch(comicStore)
                                .comic
                                .recommendation
                                .isEmpty)
                              Center(child: Text("no_related".tr()).subHeader())
                                  .paddingAll(20),
                            SizedBox(height: 30),
                          ],
                        )
                      ],
                    ),
                  ),
              ]));
  }
}
