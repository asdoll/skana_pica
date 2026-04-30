import 'dart:io';
import 'dart:math';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:easy_localization/easy_localization.dart'
    show StringTranslateExtension;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:moon_design/moon_design.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:skana_pica/api/managers/image_cache_manager.dart';
import 'package:skana_pica/controller/comicstore.dart';
import 'package:skana_pica/controller/history.dart' show visitHistoryControllerProvider;
import 'package:skana_pica/pages/pica_comic.dart';
import 'package:skana_pica/controller/log.dart';
import 'package:skana_pica/util/tool.dart';
import 'package:skana_pica/util/widgetplugin.dart';
import 'package:skana_pica/widgets/custom_slider.dart';
import 'package:skana_pica/widgets/icons.dart';
import 'package:skana_pica/widgets/pica_image.dart';
import 'package:photo_view/photo_view.dart';

class PicaReadPage extends StatefulHookConsumerWidget {
  static const route = "${PicacgComicPage.route}pica_read";
  final String id;
  final ComicStoreSource source;

  const PicaReadPage({
    super.key,
    required this.id,
    required this.source,
  });

  @override
  ConsumerState<PicaReadPage> createState() => _PicaReadPageState();
}

class _PicaReadPageState extends ConsumerState<PicaReadPage> {
  late ScrollController scrollController;
  late ItemScrollController itemScrollController;
  late ItemPositionsListener itemPositionsListener;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    itemScrollController = ItemScrollController();
    itemPositionsListener = ItemPositionsListener.create();
  }

  @override
  void dispose() {
    scrollController.dispose();
    pageController.dispose();
    super.dispose();
    resetOrientation();
  }

  @override
  Widget build(BuildContext context) {
    var comicStore = comicStoreProvider(widget.id, widget.source);
    ref.listen(comicStore, (prev, next) {
      if (prev == null || prev.isLoading) return;

      if (prev.currentEps != next.currentEps ||
          prev.currentIndex != next.currentIndex) {
        final comic = next.comic;

        ref.read(visitHistoryControllerProvider.notifier).updateVisitHistory(
              comic.id,
              next.currentEps,
              next.currentIndex,
            );
      }
    });
    ref.read(comicStore.notifier).readInit(pageController,itemScrollController);

    return Scaffold(
      body: Stack(
          children: [
            buildComicView(comicStore, context),
            buildPageInfoText(comicStore, context),
            buildTopToolBar(comicStore, context),
            buildBottomToolBar(comicStore, context),
          ],
        ),
    );
  }

  Widget buildBottomToolBar(ComicStoreProvider comicStore, BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: AnimatedSwitcher(
        key: ValueKey("bottom_tool_bar_switcher"),
        duration: const Duration(milliseconds: 150),
        reverseDuration: const Duration(milliseconds: 150),
        switchInCurve: Curves.fastOutSlowIn,
        transitionBuilder: (Widget child, Animation<double> animation) {
          var tween =
              Tween<Offset>(begin: const Offset(0, 1), end: const Offset(0, 0));
          return SlideTransition(
            position: tween.animate(animation),
            child: child,
          );
        },
        child: ref.watch(comicStore).barVisible
            ? Material(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12)),
                surfaceTintColor: context.moonTheme?.tokens.colors.beerus,
                elevation: 3,
                key: const ValueKey("bottom_tool_bar"),
                child: SizedBox(
                  height: 105 + MediaQuery.of(context).padding.bottom,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 8,
                          ),
                          MoonButton.icon(
                              backgroundColor:
                                  context.moonTheme?.tokens.colors.piccolo,
                              onTap: ref.watch(comicStore).currentEps == 0 ||
                                      ref.watch(comicStore).epsList.length < 2
                                  ? null
                                  : () => ref.read(comicStore.notifier).prevPage(
                                      controller: pageController,
                                      duo: ref.read(comicStore).readMode > 4),
                              icon:
                                  const Icon(BootstrapIcons.chevron_bar_left)),
                          Expanded(
                            child: buildSlider(comicStore),
                          ),
                          MoonButton.icon(
                              backgroundColor:
                                  context.moonTheme?.tokens.colors.piccolo,
                              onTap: ref.watch(comicStore).currentEps ==
                                          ref.watch(comicStore).epsList.length - 1 ||
                                      ref.watch(comicStore).epsList.length < 2
                                  ? null
                                  : () => ref.read(comicStore.notifier).nextChapter(
                                      controller: pageController,
                                      duo: ref.read(comicStore).readMode > 4),
                              icon:
                                  const Icon(BootstrapIcons.chevron_bar_right)),
                          const SizedBox(
                            width: 8,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 16,
                          ),
                          const Spacer(),
                          if (Platform.isAndroid)
                            Tooltip(
                              message: "orientation".tr(),
                              child: MoonButton.icon(
                                icon: Icon(
                                  ref.watch(comicStore).orientation == 0
                                      ? Icons.screen_rotation
                                      : ref.watch(comicStore).orientation == 1
                                          ? Icons.screen_lock_portrait
                                          : Icons.screen_lock_landscape,
                                ),
                                onTap: () => ref.read(comicStore.notifier).setOrientation(),
                              ),
                            ),
                          Tooltip(
                            message: "auto_next_page".tr(),
                            child: MoonButton.icon(
                              icon: ref.watch(comicStore).autoPageTurning
                                  ? const Icon(BootstrapIcons.stopwatch_fill)
                                  : const Icon(BootstrapIcons.stopwatch),
                              onTap: () => ref.read(comicStore.notifier).setAutoPageTurning(),
                            ),
                          ),
                          if (ref.watch(comicStore).epsList.length > 1)
                            Tooltip(
                              message: "episodes".tr(),
                              child: MoonButton.icon(
                                icon: const Icon(BootstrapIcons.collection),
                                onTap: () => openEpsDrawer(comicStore),
                              ),
                            ),
                          Tooltip(
                            message: "save".tr(),
                            child: MoonButton.icon(
                              icon: const Icon(BootstrapIcons.floppy),
                              onTap: () => saveCurrentImage(comicStore),
                            ),
                          ),
                          Tooltip(
                            message: "share".tr(),
                            child: MoonButton.icon(
                              icon: const Icon(BootstrapIcons.share),
                              onTap: () => share(comicStore),
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
            : const SizedBox(
                key: ValueKey("not visible bottom bar"),
                width: 0,
                height: 0,
              ),
      ),
    );
  }

  void openEpsDrawer(ComicStoreProvider comicStore) {
    showMoonModalBottomSheet(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        context: context,
        builder: (context) {
          return SafeArea(
                  child: SizedBox(
                height: max(300, MediaQuery.of(context).size.height / 3),
                child: Scaffold(
                  body: ListView.builder(
                    itemCount: ref.watch(comicStore).epsList.length + 1,
                    itemBuilder: (context, i) {
                      if (i == ref.watch(comicStore).epsList.length) {
                        return SizedBox(height: 32);
                      }
                      return moonListTile(
                        title: ref.watch(comicStore).epsList[i].eps,
                        subtitle:
                            "${ref.watch(comicStore).epsList[i].imageUrl.length} ${"pages".tr()}",
                        trailing: ref.watch(comicStore).currentEps == i
                            ? const Icon(BootstrapIcons.check_lg)
                            : null,
                        onTap: () {
                          ref.read(comicStore.notifier).setPage(i, 0);
                          if (ref.read(comicStore).readMode != 4) {
                            pageController.jumpToPage(1);
                          } else {
                            itemScrollController.scrollTo(
                                index: 1,
                                duration: Duration(
                                    milliseconds:
                                        ref.read(comicStore).animationDuration),
                                curve: Curves.easeInOut);
                          }
                          Navigator.pop(context);
                        },
                      );
                    },
                  ).paddingOnly(top: 16),
                ),
              ));
        });
  }

  void saveCurrentImage(ComicStoreProvider comicStore) {
    saveImage(ref.read(comicStore).epsList[ref.read(comicStore).currentEps]
        .imageUrl[ref.watch(comicStore).currentIndex]);
  }

  void share(ComicStoreProvider comicStore) {
    shareImage(ref.read(comicStore).epsList[ref.read(comicStore).currentEps]
        .imageUrl[ref.read(comicStore).currentIndex]);
  }

  Widget buildSlider(ComicStoreProvider comicStore) {
    if (pageController.hasClients &&
        pageController.page != null &&
        ref.watch(comicStore).currentIndex >= 0 &&
        ref.watch(comicStore).currentIndex <
            ref.watch(comicStore).epsList[ref.watch(comicStore).currentEps].imageUrl.length) {
      return CustomSlider(
        key: ValueKey("read_slider"),
        value: ref.watch(comicStore).currentIndex.toDouble() + 1,
        min: 1,
        reversed:
            ref.watch(comicStore).readMode == 6 || ref.watch(comicStore).readMode == 2,
        max: ref.watch(comicStore).epsList[ref.watch(comicStore).currentEps].imageUrl.length
                .toDouble() +
            1,
        divisions:
            ref.watch(comicStore).epsList[ref.watch(comicStore).currentEps].imageUrl.length - 1,
        onChanged: (i) {
          if (ref.watch(comicStore).readMode == 4) {
            itemScrollController.scrollTo(
                index: i.toInt(),
                duration:
                    Duration(milliseconds: ref.read(comicStore).animationDuration),
                curve: Curves.easeInOut);
          } else if (ref.read(comicStore).readMode < 4) {
            ref.read(comicStore.notifier).setIndex(i.toInt() - 1);
            pageController.jumpToPage(i.toInt());
          } else {
            ref.read(comicStore.notifier).setIndex((i / 2).toInt());
            pageController.jumpToPage(((i - 1) / 2).toInt() + 1);
          }
        },
      );
    } else {
      return const SizedBox(
        height: 0,
      );
    }
  }

  Widget buildTopToolBar(ComicStoreProvider comicStore, BuildContext context) {
    return Positioned(
      top: 0,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 150),
        reverseDuration: const Duration(milliseconds: 150),
        switchInCurve: Curves.fastOutSlowIn,
        key: ValueKey("top_tool_bar_switcher"),
        child: ref.watch(comicStore).barVisible
            ? Material(
                surfaceTintColor: context.moonTheme?.tokens.colors.beerus,
                elevation: 3,
                key: const ValueKey("top_tool_bar"),
                shadowColor:
                    Theme.of(context).colorScheme.shadow.withValues(alpha: 0.3),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: NormalBackButton(),
                      ),
                      Expanded(
                        child: Container(
                          height: 50,
                          constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width - 75),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              ref.watch(comicStore).comic.title,
                              overflow: TextOverflow.ellipsis,
                            ).appHeader(),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Container(
                        height: 25,
                        padding: const EdgeInsets.fromLTRB(6, 2, 6, 0),
                        decoration: BoxDecoration(
                          color: context.moonTheme?.tokens.colors.frieza60,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(ref.watch(comicStore).epsList.length > 1
                                ? "E${ref.watch(comicStore).currentEps + 1}:P${ref.watch(comicStore).currentIndex + 1}"
                                : "P${ref.watch(comicStore).currentIndex + 1}")
                            .subHeader(),
                      ),
                      //const Spacer(),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: MoonButton.icon(
                          icon: const Icon(BootstrapIcons.gear),
                          onTap: () => showSettings(context, comicStore),
                        ),
                      ),
                    ],
                  ),
                ).paddingOnly(top: MediaQuery.of(context).padding.top),
              )
            : const SizedBox(
                key: ValueKey("not visible top bar"),
                width: 0,
                height: 0,
              ),
        transitionBuilder: (Widget child, Animation<double> animation) {
          var tween = Tween<Offset>(
              begin: const Offset(0, -1), end: const Offset(0, 0));
          return SlideTransition(
            position: tween.animate(animation),
            child: child,
          );
        },
      ),
    );
  }

  void showSettings(BuildContext context, ComicStoreProvider comicStore) {
    showMoonModalBottomSheet(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      context: context,
      transitionDuration: const Duration(milliseconds: 200),
      builder: (context) {
        return SafeArea(
                child: SizedBox(
              height: max(300, MediaQuery.of(context).size.height / 3),
              child: Scaffold(
                body: ListView(
                  children: [
                    moonListTile(
                      title: "read_mode".tr(),
                      trailing: MoonDropdown(
                          content: Column(
                            children: [
                              MoonMenuItem(
                                label: Text("left_to_right".tr()),
                                onTap: () {
                                  ref.read(comicStore.notifier).setReadMode(1);
                                  pageController = PageController(
                                      initialPage:
                                          ref.read(comicStore).currentIndex + 1);
                                },
                              ),
                              MoonMenuItem(
                                label: Text("right_to_left".tr()),
                                onTap: () {
                                  ref.read(comicStore.notifier).setReadMode(2);
                                  pageController = PageController(
                                      initialPage:
                                          ref.read(comicStore).currentIndex + 1);
                                },
                              ),
                              MoonMenuItem(
                                label: Text("top_to_bottom".tr()),
                                onTap: () {
                                  ref.read(comicStore.notifier).setReadMode(3);
                                  pageController = PageController(
                                      initialPage:
                                          ref.read(comicStore).currentIndex + 1);
                                },
                              ),
                              MoonMenuItem(
                                label: Text("top_to_bottom_scroll_view".tr()),
                                onTap: () {
                                  ref.read(comicStore.notifier).setReadMode(4);
                                  itemScrollController.scrollTo(
                                      index: ref.read(comicStore).currentIndex + 1,
                                      duration: Duration(
                                          milliseconds: ref.read(comicStore)
                                              .animationDuration),
                                      curve: Curves.easeInOut);
                                },
                              ),
                              MoonMenuItem(
                                label: Text("duo_page".tr()),
                                onTap: () {
                                  ref.read(comicStore.notifier).setReadMode(5);
                                  pageController = PageController(
                                      initialPage:
                                          (ref.read(comicStore).currentIndex ~/ 2) +
                                              1);
                                },
                              ),
                              MoonMenuItem(
                                label: Text("duo_page_reversed".tr()),
                                onTap: () {
                                  ref.read(comicStore.notifier).setReadMode(6);
                                  pageController = PageController(
                                      initialPage:
                                          (ref.read(comicStore).currentIndex ~/ 2) +
                                              1);
                                },
                              ),
                            ],
                          ),
                          show: ref.watch(comicStore).readModeMenu,
                          onTapOutside: () =>
                              ref.read(comicStore.notifier).setMenu(),
                          child: filledButton(
                              label:
                                  readModes[ref.watch(comicStore).readMode - 1].tr(),
                              onPressed: () => ref.read(comicStore.notifier).setMenu(ref.read(comicStore).readModeMenu))),
                    ),
                    moonListTile(
                      title: "auto_page_turning_interval".tr(),
                      subtitleWidget: SizedBox(
                        height: 105,
                        child: Row(
                          children: [
                            Expanded(
                              child: Slider(
                                activeColor:
                                    context.moonTheme?.tokens.colors.piccolo,
                                key: ValueKey(
                                    "auto_page_turning_interval_slider"),
                                value: ref.watch(comicStore).autoPageTurningInterval
                                    .toDouble(),
                                min: 1,
                                max: 20,
                                divisions: 19,
                                onChanged: (i) {
                                  ref.read(comicStore.notifier)
                                      .setAutoPageTurningInterval(i.toInt());
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      trailing: Text(
                              "${ref.watch(comicStore).autoPageTurningInterval} ${"s".tr()}")
                          .small(),
                    ),
                    moonListTile(
                      title: "image_layout".tr(),
                      subtitle: ref.watch(comicStore).imageLayout == 0
                          ? "contained".tr()
                          : "covered".tr(),
                      trailing: MoonSwitch(
                        value: ref.watch(comicStore).imageLayout == 1,
                        onChanged: (value) {
                          ref.read(comicStore.notifier).setImageLayout(value ? 1 : 0);
                        },
                      ),
                    ),
                    moonListTile(
                      title: "limit_image_width".tr(),
                      subtitle: ref.watch(comicStore).limitImageWidth
                          ? "enabled".tr()
                          : "disabled".tr(),
                      trailing: MoonSwitch(
                        value: ref.watch(comicStore).limitImageWidth,
                        onChanged: (value) {
                          ref.read(comicStore.notifier).setLimitImageWidth(value);
                        },
                      ),
                    ),
                    moonListTile(
                      title: "tap_to_next_page_threshold".tr(),
                      subtitleWidget: SizedBox(
                        height: 105,
                        child: Row(
                          children: [
                            Expanded(
                              child: Slider(
                                activeColor:
                                    context.moonTheme?.tokens.colors.piccolo,
                                key: ValueKey("tap_threshold_slider"),
                                value: ref.watch(comicStore).tapThreshold.toDouble(),
                                min: 1,
                                max: 50,
                                divisions: 49,
                                onChanged: (i) {
                                  ref.read(comicStore.notifier).setTapThreshold(i.toInt());
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      trailing:
                          Text("${ref.watch(comicStore).tapThreshold}%").small(),
                    ),
                    moonListTile(
                      title: "dark_background".tr(),
                      subtitle: ref.watch(comicStore).useDarkBackground
                          ? "enabled".tr()
                          : "disabled".tr(),
                      trailing: MoonSwitch(
                        value: ref.watch(comicStore).useDarkBackground,
                        onChanged: (value) {
                          ref.read(comicStore.notifier).setDarkBackground(value);
                        },
                      ),
                    ),
                    moonListTile(
                      title: "animation_duration".tr(),
                      subtitleWidget: SizedBox(
                        height: 105,
                        child: Row(
                          children: [
                            Expanded(
                              child: Slider(
                                activeColor:
                                    context.moonTheme?.tokens.colors.piccolo,
                                key: ValueKey("animation_duration_slider"),
                                value: ref.watch(comicStore).animationDuration
                                    .toDouble(),
                                min: 100,
                                max: 500,
                                divisions: 20,
                                onChanged: (i) {
                                  ref.read(comicStore.notifier).setAnimationDuration(i.toInt());
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      trailing: Text("${ref.watch(comicStore).animationDuration} ms")
                          .small(),
                    ),
                    SizedBox(height: 32),
                  ],
                ).paddingOnly(top: 16),
              ),
            ));
      },
    );
  }

  Widget buildPageInfoText(ComicStoreProvider comicStore, BuildContext context) {
    var epName = ref.watch(comicStore).epsList[ref.watch(comicStore).currentEps].eps.isEmpty
        ? "E1"
        : ref.watch(comicStore).epsList[ref.watch(comicStore).currentEps].eps;
    if (epName.length > 8) {
      epName = "${epName.substring(0, 8)}...";
    }
    var text = ref.watch(comicStore).epsList.length > 1
        ? "$epName : ${ref.watch(comicStore).currentIndex + 1}/${ref.watch(comicStore).epsList[ref.watch(comicStore).currentEps].imageUrl.length}"
        : "${ref.watch(comicStore).currentIndex + 1}/${ref.watch(comicStore).epsList[ref.watch(comicStore).currentEps].imageUrl.length}";
    return Positioned(
      bottom: 25,
      left: 25,
      child: Stack(
        children: [
          Text(
            text,
            style: context.moonTheme?.tokens.typography.heading.text16
                .copyWith(
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 1.4
                ..color = (ref.watch(comicStore).useDarkBackground ||
                        Theme.of(context).brightness == Brightness.dark)
                    ? Colors.black
                    : Colors.white,
            ),
          ),
          Text(
            text,
            style: context.moonTheme?.tokens.typography.heading.text16
                .copyWith(
              color: ref.watch(comicStore).useDarkBackground ? Colors.white : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildComicView(ComicStoreProvider comicStore, BuildContext context) {
    final decoration = BoxDecoration(
      color: ref.watch(comicStore).useDarkBackground
          ? Colors.black
          : Theme.of(context).colorScheme.surface,
    );

    Widget buildType4() {
      itemPositionsListener.itemPositions.addListener(() {
        var positions = itemPositionsListener.itemPositions.value;
        if (positions.isNotEmpty &&
            positions.first.index > 0 &&
            positions.first.index <
                ref.read(comicStore)
                        .epsList[ref.read(comicStore).currentEps].imageUrl.length +
                    1) {
          ref.read(comicStore.notifier).setIndex(positions.first.index - 1);
        }
      });

      return ScrollablePositionedList.builder(
        itemScrollController: itemScrollController,
        itemPositionsListener: itemPositionsListener,
        itemCount:
            ref.watch(comicStore).epsList[ref.watch(comicStore).currentEps].imageUrl.length + 2,
        addSemanticIndexes: false,
        initialScrollIndex: ref.watch(comicStore).currentIndex + 1,
        itemBuilder: (context, i) {
          double width = MediaQuery.of(context).size.width;
          double height = MediaQuery.of(context).size.height;

          double imageWidth = width;

          if (height / width < 1.2 && ref.watch(comicStore).limitImageWidth) {
            imageWidth = height / 1.2;
          }

          if (i == 0) {
            if (ref.watch(comicStore).currentEps > 0) {
              return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () {
                          ref.read(comicStore.notifier).prevChapter();
                        },
                        icon: Icon(
                          Icons.keyboard_arrow_up_rounded,
                          color: ref.watch(comicStore).useDarkBackground ||
                                  Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                          size: 30,
                        )).paddingSymmetric(vertical: 20),
                  ]);
            } else {
              return const SizedBox(
                height: 40,
              );
            }
          }

          if (i ==
              ref.watch(comicStore).epsList[ref.watch(comicStore).currentEps].imageUrl.length +
                  1) {
            if (ref.watch(comicStore).currentEps < ref.watch(comicStore).epsList.length) {
              return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                            onPressed: () {
                              ref.read(comicStore.notifier).nextChapter();
                            },
                            icon: Icon(Icons.keyboard_arrow_down_rounded,
                                color: ref.watch(comicStore).useDarkBackground ||
                                        Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                                size: 30))
                        .paddingSymmetric(vertical: 20),
                  ]);
            } else {
              return const SizedBox(height: 40);
            }
          }
          return PicaImage(
            ref.watch(comicStore).epsList[ref.watch(comicStore).currentEps].imageUrl[i - 1],
            width: imageWidth,
            fit: BoxFit.contain,
            downloaded: widget.source == ComicStoreSource.local,
          );
        },
      );
    }

    Widget buildType123() {
      return PhotoViewGallery.builder(
        backgroundDecoration: decoration,
        reverse: ref.watch(comicStore).readMode == 2,
        scrollDirection:
            ref.watch(comicStore).readMode == 3 ? Axis.vertical : Axis.horizontal,
        itemCount:
            ref.watch(comicStore).epsList[ref.watch(comicStore).currentEps].imageUrl.length + 2,
        builder: (BuildContext context, int index) {
          if (index == 0 ||
              index ==
                  ref.watch(comicStore).epsList[ref.watch(comicStore).currentEps].imageUrl
                          .length +
                      1) {
            return PhotoViewGalleryPageOptions.customChild(
              child: const SizedBox(),
            );
          }
          ref.read(comicStore.notifier).preLoad(index: index - 1);

          return PhotoViewGalleryPageOptions(
            filterQuality: FilterQuality.medium,
            imageProvider: imageProvider(ref.watch(comicStore)
                .epsList[ref.watch(comicStore).currentEps].imageUrl[index - 1],widget.source == ComicStoreSource.local),
            initialScale: ref.watch(comicStore).imageLayout == 0
                ? PhotoViewComputedScale.contained
                : PhotoViewComputedScale.covered,
            errorBuilder: (_, error, s, retry) {
              return Center(
                child: SizedBox(
                  height: 300,
                  width: 400,
                  child: Column(
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            error.toString(),
                            style: TextStyle(
                                color: ref.watch(comicStore).useDarkBackground ||
                                        Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : null),
                            maxLines: 3,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      const SizedBox(
                        width: 84,
                        height: 36,
                        child: Center(
                          child: Icon(
                            Icons.error_outline_rounded,
                            size: 30,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                ),
              );
            },
            heroAttributes: PhotoViewHeroAttributes(
                tag:
                    "$index/${ref.watch(comicStore).epsList[ref.watch(comicStore).currentEps].imageUrl.length}"),
          );
        },
        pageController: pageController,
        loadingBuilder: (context, event) => Center(
          child: SizedBox(
            width: 20.0,
            height: 20.0,
            child: event == null || event.expectedTotalBytes == null
                ? CircularProgressIndicator(
                    color: context.moonTheme?.tokens.colors.piccolo,
                  )
                : MoonCircularProgress(
                    value:
                        event.cumulativeBytesLoaded / event.expectedTotalBytes!,
                  ),
          ),
        ),
        onPageChanged: (i) {
          if (i == 0) {
            ref.read(comicStore.notifier).prevChapter(controller: pageController);
          } else if (i ==
              ref.read(comicStore).epsList[ref.read(comicStore).currentEps].imageUrl.length +
                  1) {
            ref.read(comicStore.notifier).nextChapter(controller: pageController);
          } else {
            ref.read(comicStore.notifier).setPage(ref.read(comicStore).currentEps, i - 1);
          }
        },
      );
    }

    Widget buildComicImageOrEmpty(
        {required int imageIndex, required BoxFit fit}) {
      if (imageIndex < 0 ||
          imageIndex >=
              ref.watch(comicStore).epsList[ref.watch(comicStore).currentEps].imageUrl.length) {
        return const SizedBox();
      }

      return PicaImage(
        ref.watch(comicStore).epsList[ref.watch(comicStore).currentEps].imageUrl[imageIndex],
        fit: fit,
        useProgressIndicator: true,
        downloaded: widget.source == ComicStoreSource.local
      );
    }

    Widget buildType56() {
      int calcItemCount() {
        int count =
            ref.watch(comicStore).epsList[ref.watch(comicStore).currentEps].imageUrl.length ~/
                2;
        if (ref.watch(comicStore).epsList[ref.watch(comicStore).currentEps].imageUrl.length %
                2 !=
            0) {
          count++;
        }
        return count + 2;
      }

      return PhotoViewGallery.builder(
        backgroundDecoration: decoration,
        itemCount: calcItemCount(),
        reverse: ref.watch(comicStore).readMode == 6,
        builder: (BuildContext context, int index) {
          if (index == 0 || index == calcItemCount() - 1) {
            return PhotoViewGalleryPageOptions.customChild(
                child: SizedBox(child: Text(index.toString())));
          }
          ref.read(comicStore.notifier).preLoad(index: 2 * index - 2);

          int firstImage = index * 2 - 2;
          if (firstImage % 2 != 0) {
            firstImage++;
          }
          var images = <int>[firstImage, firstImage + 1];
          if (ref.watch(comicStore).readMode == 6) {
            images = images.reversed.toList();
          }

          return PhotoViewGalleryPageOptions.customChild(
              child: Row(
            children: [
              Expanded(
                child: buildComicImageOrEmpty(
                  imageIndex: images[0],
                  fit: BoxFit.contain,
                ),
              ),
              Expanded(
                child: buildComicImageOrEmpty(
                  imageIndex: images[1],
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ));
        },
        pageController: pageController,
        onPageChanged: (i) {
          if (i == 0) {
            ref.read(comicStore.notifier).prevChapter(controller: pageController, duo: true);
          } else if (i == calcItemCount() - 1) {
            log.i("i=$i}");
            ref.read(comicStore.notifier).nextChapter(controller: pageController);
          } else {
            if (i > 0 && i < calcItemCount() - 1) {
              ref.read(comicStore.notifier).setPage(ref.read(comicStore).currentEps, (i - 1) * 2);
            }
          }
        },
      );
    }

    Widget body;

    if (ref.watch(comicStore).readMode < 4) {
      body = buildType123();
    } else if (ref.watch(comicStore).readMode == 4) {
      body = PhotoView.customChild(
          backgroundDecoration: decoration,
          minScale: 1.0,
          maxScale: 2.5,
          strictScale: true,
          child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: buildType4()));
    } else {
      body = buildType56();
    }

    return Positioned.fill(
      child: GestureDetector(
        onTapUp: (details) {
          switch (ref.read(comicStore).readMode) {
            case 1:
            case 5:
              var threshold = MediaQuery.of(context).size.width *
                  ref.read(comicStore).tapThreshold /
                  100;
              if (details.localPosition.dx < threshold) {
                ref.read(comicStore.notifier).prevPage(
                    controller: pageController,
                    duo: ref.read(comicStore).readMode == 5);
              } else if (details.localPosition.dx >
                  MediaQuery.of(context).size.width - threshold) {
                ref.read(comicStore.notifier).nextPage(
                    controller: pageController,
                    duo: ref.read(comicStore).readMode == 5);
              } else {
                ref.read(comicStore.notifier).setBarVisible();
              }
              break;
            case 2:
            case 6:
              var threshold = MediaQuery.of(context).size.width *
                  ref.read(comicStore).tapThreshold /
                  100;
              if (details.localPosition.dx < threshold) {
                ref.read(comicStore.notifier).nextPage(
                    controller: pageController,
                    duo: ref.read(comicStore).readMode == 6);
              } else if (details.localPosition.dx >
                  MediaQuery.of(context).size.width - threshold) {
                ref.read(comicStore.notifier).prevPage(
                    controller: pageController,
                    duo: ref.read(comicStore).readMode == 6);
              } else {
                ref.read(comicStore.notifier).setBarVisible();
              }
              break;
            case 3:
              var threshold = MediaQuery.of(context).size.height *
                  ref.read(comicStore).tapThreshold /
                  100;
              if (details.localPosition.dy < threshold) {
                ref.read(comicStore.notifier).prevPage(controller: pageController);
              } else if (details.localPosition.dy >
                  MediaQuery.of(context).size.height - threshold) {
                ref.read(comicStore.notifier).nextPage(controller: pageController);
              } else {
                ref.read(comicStore.notifier).setBarVisible();
              }
              break;
            default:
              //case 4:
              var widthThreshold = MediaQuery.of(context).size.width *
                  ref.read(comicStore).tapThreshold /
                  100;
              var heightThreshold = MediaQuery.of(context).size.height *
                  ref.read(comicStore).tapThreshold /
                  100;
              if (details.localPosition.dx > widthThreshold &&
                  details.localPosition.dx <
                      MediaQuery.of(context).size.width - widthThreshold &&
                  details.localPosition.dy > heightThreshold &&
                  details.localPosition.dy <
                      MediaQuery.of(context).size.height - heightThreshold) {
                ref.read(comicStore.notifier).setBarVisible();
              }
          }
        },
        child: body,
      ),
    );
  }
}
