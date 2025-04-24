import 'dart:io';
import 'dart:math';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moon_design/moon_design.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:skana_pica/api/managers/image_cache_manager.dart';
import 'package:skana_pica/controller/comicstore.dart';
import 'package:skana_pica/pages/mainscreen.dart';
import 'package:skana_pica/pages/pica_comic.dart';
import 'package:skana_pica/util/leaders.dart';
import 'package:skana_pica/controller/log.dart';
import 'package:skana_pica/util/tool.dart';
import 'package:skana_pica/util/widgetplugin.dart';
import 'package:skana_pica/widgets/custom_slider.dart';
import 'package:skana_pica/widgets/icons.dart';
import 'package:skana_pica/widgets/pica_image.dart';
import 'package:photo_view/photo_view.dart';

class PicaReadPage extends StatefulWidget {
  static const route = "${PicacgComicPage.route}pica_read";
  final String id;

  const PicaReadPage({
    super.key,
    required this.id,
  });

  @override
  State<PicaReadPage> createState() => _PicaReadPageState();
}

class _PicaReadPageState extends State<PicaReadPage> {
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
    ComicStore comicStore;
    try {
      comicStore = Get.find<ComicStore>(tag: widget.id);
      comicStore.barVisible.value = false;
      if (comicStore.readMode.value > 4) {
        pageController = PageController(
            initialPage: (comicStore.currentIndex.value ~/ 2) + 1);
      } else {
        pageController = PageController(
            initialPage: comicStore.currentIndex.value + 1,
            viewportFraction: 1.0,
            keepPage: true);
      }
    } catch (e) {
      showToast("Internal Error".tr);
      Get.until((route) => Get.currentRoute == Mains.route);
      pageController = PageController(initialPage: 1);
      return const SizedBox();
    }

    comicStore.autoPagingPageController = pageController;
    comicStore.autoPagingScrollController = itemScrollController;
    comicStore.autoPageTurning.value = false;
    comicStore.orientationChanged();

    return Scaffold(
      body: Obx(
        () => Stack(
          children: [
            buildComicView(comicStore, context),
            buildPageInfoText(comicStore, context),
            buildTopToolBar(comicStore, context),
            buildBottomToolBar(comicStore, context),
          ],
        ),
      ),
    );
  }

  Widget buildBottomToolBar(ComicStore comicStore, BuildContext context) {
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
        child: comicStore.barVisible.value
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
                              onTap: comicStore.currentEps.value == 0 ||
                                      comicStore.epsList.length < 2
                                  ? null
                                  : () => comicStore.prevPage(
                                      controller: pageController,
                                      duo: comicStore.readMode.value > 4),
                              icon:
                                  const Icon(BootstrapIcons.chevron_bar_left)),
                          Expanded(
                            child: buildSlider(comicStore),
                          ),
                          MoonButton.icon(
                              backgroundColor:
                                  context.moonTheme?.tokens.colors.piccolo,
                              onTap: comicStore.currentEps.value ==
                                          comicStore.epsList.length - 1 ||
                                      comicStore.epsList.length < 2
                                  ? null
                                  : () => comicStore.nextChapter(
                                      controller: pageController,
                                      duo: comicStore.readMode.value > 4),
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
                              message: "Orientation".tr,
                              child: MoonButton.icon(
                                icon: Icon(
                                  comicStore.orientation.value == 0
                                      ? Icons.screen_rotation
                                      : comicStore.orientation.value == 1
                                          ? Icons.screen_lock_portrait
                                          : Icons.screen_lock_landscape,
                                ),
                                onTap: () => comicStore.setOrientation(),
                              ),
                            ),
                          Tooltip(
                            message: "Auto next page".tr,
                            child: MoonButton.icon(
                              icon: comicStore.autoPageTurning.value
                                  ? const Icon(BootstrapIcons.stopwatch_fill)
                                  : const Icon(BootstrapIcons.stopwatch),
                              onTap: () => comicStore.setAutoPageTurning(),
                            ),
                          ),
                          if (comicStore.epsList.length > 1)
                            Tooltip(
                              message: "Episodes".tr,
                              child: MoonButton.icon(
                                icon: const Icon(BootstrapIcons.collection),
                                onTap: () => openEpsDrawer(comicStore),
                              ),
                            ),
                          Tooltip(
                            message: "Save".tr,
                            child: MoonButton.icon(
                              icon: const Icon(BootstrapIcons.floppy),
                              onTap: () => saveCurrentImage(comicStore),
                            ),
                          ),
                          Tooltip(
                            message: "Share".tr,
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

  void openEpsDrawer(ComicStore comicStore) {
    showMoonModalBottomSheet(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        context: context,
        builder: (context) {
          return Obx(() => SafeArea(
                  child: SizedBox(
                height: max(300, context.height / 3),
                child: Scaffold(
                  body: ListView.builder(
                    itemCount: comicStore.epsList.length+1,
                    itemBuilder: (context, i) {
                      if (i == comicStore.epsList.length) {
                        return SizedBox(height: 32);
                      }
                      return moonListTile(
                        title: comicStore.epsList[i].eps,
                        subtitle:
                            "${comicStore.epsList[i].imageUrl.length} ${"Pages".tr}",
                        trailing: comicStore.currentEps.value == i
                            ? const Icon(BootstrapIcons.check_lg)
                            : null,
                        onTap: () {
                          comicStore.setPage(i, 0);
                          if (comicStore.readMode.value != 4) {
                            pageController.jumpToPage(1);
                          } else {
                            itemScrollController.scrollTo(
                                index: 1,
                                duration: Duration(
                                    milliseconds:
                                        comicStore.animationDuration.value),
                                curve: Curves.easeInOut);
                          }
                          Get.back();
                        },
                      );
                    },
                  ).paddingOnly(top: 16),
                ),
              )));
        });
  }

  void saveCurrentImage(ComicStore comicStore) {
    saveImage(comicStore.epsList[comicStore.currentEps.value]
        .imageUrl[comicStore.currentIndex.value]);
  }

  void share(ComicStore comicStore) {
    shareImage(comicStore.epsList[comicStore.currentEps.value]
        .imageUrl[comicStore.currentIndex.value]);
  }

  Widget buildSlider(ComicStore comicStore) {
    if (pageController.hasClients &&
        pageController.page != null &&
        comicStore.currentIndex.value >= 0 &&
        comicStore.currentIndex.value <
            comicStore.epsList[comicStore.currentEps.value].imageUrl.length) {
      return CustomSlider(
        key: ValueKey("read_slider"),
        value: comicStore.currentIndex.value.toDouble() + 1,
        min: 1,
        reversed:
            comicStore.readMode.value == 6 || comicStore.readMode.value == 2,
        max: comicStore.epsList[comicStore.currentEps.value].imageUrl.length
                .toDouble() +
            1,
        divisions:
            comicStore.epsList[comicStore.currentEps.value].imageUrl.length - 1,
        onChanged: (i) {
          if (comicStore.readMode.value == 4) {
            itemScrollController.scrollTo(
                index: i.toInt(),
                duration:
                    Duration(milliseconds: comicStore.animationDuration.value),
                curve: Curves.easeInOut);
          } else if (comicStore.readMode.value < 4) {
            comicStore.currentIndex.value = i.toInt() - 1;
            pageController.jumpToPage(i.toInt());
          } else {
            comicStore.currentIndex.value = (i / 2).toInt();
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

  Widget buildTopToolBar(ComicStore comicStore, BuildContext context) {
    return Positioned(
      top: 0,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 150),
        reverseDuration: const Duration(milliseconds: 150),
        switchInCurve: Curves.fastOutSlowIn,
        key: ValueKey("top_tool_bar_switcher"),
        child: comicStore.barVisible.value
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
                              comicStore.comic.value.title,
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
                        child: Text(comicStore.epsList.length > 1
                                ? "E${comicStore.currentEps.value + 1}:P${comicStore.currentIndex.value + 1}"
                                : "P${comicStore.currentIndex.value + 1}")
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

  void showSettings(BuildContext context, ComicStore comicStore) {
    showMoonModalBottomSheet(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      context: context,
      transitionDuration: const Duration(milliseconds: 200),
      builder: (context) {
        return Obx(() => SafeArea(
                child: SizedBox(
              height: max(300, context.height / 3),
              child: Scaffold(
                body: ListView(
                  children: [
                    moonListTile(
                      title: "Read Mode".tr,
                      trailing: MoonDropdown(
                          content: Column(
                            children: [
                              MoonMenuItem(
                                label: Text("Left to Right".tr),
                                onTap: () {
                                  comicStore.setReadMode(1);
                                  pageController = PageController(
                                      initialPage:
                                          comicStore.currentIndex.value + 1);
                                },
                              ),
                              MoonMenuItem(
                                label: Text("Right to Left".tr),
                                onTap: () {
                                  comicStore.setReadMode(2);
                                  pageController = PageController(
                                      initialPage:
                                          comicStore.currentIndex.value + 1);
                                },
                              ),
                              MoonMenuItem(
                                label: Text("Top to Bottom".tr),
                                onTap: () {
                                  comicStore.setReadMode(3);
                                  pageController = PageController(
                                      initialPage:
                                          comicStore.currentIndex.value + 1);
                                },
                              ),
                              MoonMenuItem(
                                label: Text("Top to Bottom(Scroll view)".tr),
                                onTap: () {
                                  comicStore.setReadMode(4);
                                  itemScrollController.scrollTo(
                                      index: comicStore.currentIndex.value + 1,
                                      duration: Duration(
                                          milliseconds: comicStore
                                              .animationDuration.value),
                                      curve: Curves.easeInOut);
                                },
                              ),
                              MoonMenuItem(
                                label: Text("Duo Page".tr),
                                onTap: () {
                                  comicStore.setReadMode(5);
                                  pageController = PageController(
                                      initialPage:
                                          (comicStore.currentIndex.value ~/ 2) +
                                              1);
                                },
                              ),
                              MoonMenuItem(
                                label: Text("Duo Page(reversed)".tr),
                                onTap: () {
                                  comicStore.setReadMode(6);
                                  pageController = PageController(
                                      initialPage:
                                          (comicStore.currentIndex.value ~/ 2) +
                                              1);
                                },
                              ),
                            ],
                          ),
                          show: comicStore.readModeMenu.value,
                          onTapOutside: () =>
                              comicStore.readModeMenu.value = false,
                          child: filledButton(
                              label:
                                  readModes[comicStore.readMode.value - 1].tr,
                              onPressed: () => comicStore.readModeMenu.value =
                                  !comicStore.readModeMenu.value)),
                    ),
                    moonListTile(
                      title: "Auto Page Turning Interval".tr,
                      subtitleWidget: SizedBox(
                        height: 105,
                        child: Row(
                          children: [
                            Expanded(
                              child: Slider(
                                activeColor: context.moonTheme?.tokens.colors.piccolo,
                                key: ValueKey(
                                    "auto_page_turning_interval_slider"),
                                value: comicStore.autoPageTurningInterval.value
                                    .toDouble(),
                                min: 1,
                                max: 20,
                                divisions: 19,
                                onChanged: (i) {
                                  comicStore
                                      .setAutoPageTurningInterval(i.toInt());
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      trailing: Text(
                              "${comicStore.autoPageTurningInterval.value} ${"s".tr}")
                          .small(),
                    ),
                    moonListTile(
                      title: "Image Layout".tr,
                      subtitle: comicStore.imageLayout.value == 0
                          ? "Contained".tr
                          : "Covered".tr,
                      trailing: MoonSwitch(
                        value: comicStore.imageLayout.value == 1,
                        onChanged: (value) {
                          comicStore.setImageLayout(value ? 1 : 0);
                        },
                      ),
                    ),
                    moonListTile(
                      title: "Limit Image Width".tr,
                      subtitle: comicStore.limitImageWidth.value
                          ? "Enabled".tr
                          : "Disabled".tr,
                      trailing: MoonSwitch(
                        value: comicStore.limitImageWidth.value,
                        onChanged: (value) {
                          comicStore.setLimitImageWidth(value);
                        },
                      ),
                    ),
                    moonListTile(
                      title: "Tap to Next Page Threshold".tr,
                      subtitleWidget: SizedBox(
                        height: 105,
                        child: Row(
                          children: [
                            Expanded(
                              child: Slider(
                                activeColor: context.moonTheme?.tokens.colors.piccolo,
                                key: ValueKey("tap_threshold_slider"),
                                value: comicStore.tapThreshold.value.toDouble(),
                                min: 1,
                                max: 50,
                                divisions: 49,
                                onChanged: (i) {
                                  comicStore.setTapThreshold(i.toInt());
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      trailing:
                          Text("${comicStore.tapThreshold.value}%").small(),
                    ),
                    moonListTile(
                      title: "Dark Background".tr,
                      subtitle: comicStore.useDarkBackground.value
                          ? "Enabled".tr
                          : "Disabled".tr,
                      trailing: MoonSwitch(
                        value: comicStore.useDarkBackground.value,
                        onChanged: (value) {
                          comicStore.setDarkBackground(value);
                        },
                      ),
                    ),
                    moonListTile(
                      title: "Animation Duration".tr,
                      subtitleWidget: SizedBox(
                        height: 105,
                        child: Row(
                          children: [
                            Expanded(
                              child: Slider(
                                activeColor: context.moonTheme?.tokens.colors.piccolo,
                                key: ValueKey("animation_duration_slider"),
                                value: comicStore.animationDuration.value
                                    .toDouble(),
                                min: 100,
                                max: 500,
                                divisions: 20,
                                onChanged: (i) {
                                  comicStore.setAnimationDuration(i.toInt());
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      trailing: Text(
                              "${comicStore.animationDuration.value} ${"ms".tr}")
                          .small(),
                    ),
                    SizedBox(height: 32),
                  ],
                ).paddingOnly(top: 16),
              ),
            )));
      },
    );
  }

  Widget buildPageInfoText(ComicStore comicStore, BuildContext context) {
    var epName = comicStore.epsList[comicStore.currentEps.value].eps.isEmpty
        ? "E1"
        : comicStore.epsList[comicStore.currentEps.value].eps;
    if (epName.length > 8) {
      epName = "${epName.substring(0, 8)}...";
    }
    var text = comicStore.epsList.length > 1
        ? "$epName : ${comicStore.currentIndex.value + 1}/${comicStore.epsList[comicStore.currentEps.value].imageUrl.length}"
        : "${comicStore.currentIndex.value + 1}/${comicStore.epsList[comicStore.currentEps.value].imageUrl.length}";
    return Positioned(
      bottom: 25,
      left: 25,
      child: Stack(
        children: [
          Text(
            text,
            style: Get.context?.moonTheme?.tokens.typography.heading.text16
                .copyWith(
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 1.4
                ..color = (comicStore.useDarkBackground.value ||
                        Get.theme.brightness == Brightness.dark)
                    ? Colors.black
                    : Colors.white,
            ),
          ),
          Text(
            text,
            style: Get.context?.moonTheme?.tokens.typography.heading.text16
                .copyWith(
              color: comicStore.useDarkBackground.value ? Colors.white : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildComicView(ComicStore comicStore, BuildContext context) {
    final decoration = BoxDecoration(
      color: comicStore.useDarkBackground.value
          ? Colors.black
          : Get.theme.colorScheme.surface,
    );

    Widget buildType4() {
      itemPositionsListener.itemPositions.addListener(() {
        var positions = itemPositionsListener.itemPositions.value;
        if (positions.isNotEmpty &&
            positions.first.index > 0 &&
            positions.first.index <
                comicStore
                        .epsList[comicStore.currentEps.value].imageUrl.length +
                    1) {
          comicStore.currentIndex.value = positions.first.index - 1;
        }
      });

      return ScrollablePositionedList.builder(
        itemScrollController: itemScrollController,
        itemPositionsListener: itemPositionsListener,
        itemCount:
            comicStore.epsList[comicStore.currentEps.value].imageUrl.length + 2,
        addSemanticIndexes: false,
        initialScrollIndex: comicStore.currentIndex.value + 1,
        itemBuilder: (context, i) {
          double width = MediaQuery.of(context).size.width;
          double height = MediaQuery.of(context).size.height;

          double imageWidth = width;

          if (height / width < 1.2 && comicStore.limitImageWidth.value) {
            imageWidth = height / 1.2;
          }

          if (i == 0) {
            if (comicStore.currentEps.value > 0) {
              return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () {
                          comicStore.prevChapter();
                        },
                        icon: Icon(
                          Icons.keyboard_arrow_up_rounded,
                          color: comicStore.useDarkBackground.value ||
                                  Get.theme.brightness == Brightness.dark
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
              comicStore.epsList[comicStore.currentEps.value].imageUrl.length +
                  1) {
            if (comicStore.currentEps.value < comicStore.epsList.length) {
              return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                            onPressed: () {
                              comicStore.nextChapter();
                            },
                            icon: Icon(Icons.keyboard_arrow_down_rounded,
                                color: comicStore.useDarkBackground.value ||
                                        Get.theme.brightness == Brightness.dark
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
            comicStore.epsList[comicStore.currentEps.value].imageUrl[i - 1],
            width: imageWidth,
            fit: BoxFit.contain,
          );
        },
      );
    }

    Widget buildType123() {
      return PhotoViewGallery.builder(
        backgroundDecoration: decoration,
        reverse: comicStore.readMode.value == 2,
        scrollDirection:
            comicStore.readMode.value == 3 ? Axis.vertical : Axis.horizontal,
        itemCount:
            comicStore.epsList[comicStore.currentEps.value].imageUrl.length + 2,
        builder: (BuildContext context, int index) {
          if (index == 0 ||
              index ==
                  comicStore.epsList[comicStore.currentEps.value].imageUrl
                          .length +
                      1) {
            return PhotoViewGalleryPageOptions.customChild(
              child: const SizedBox(),
            );
          }
          comicStore.preLoad(index: index - 1);

          return PhotoViewGalleryPageOptions(
            filterQuality: FilterQuality.medium,
            imageProvider: imageProvider(comicStore
                .epsList[comicStore.currentEps.value].imageUrl[index - 1]),
            initialScale: comicStore.imageLayout.value == 0
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
                                color: comicStore.useDarkBackground.value ||
                                        Get.theme.brightness == Brightness.dark
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
                    "$index/${comicStore.epsList[comicStore.currentEps.value].imageUrl.length}"),
          );
        },
        pageController: pageController,
        loadingBuilder: (context, event) => Center(
          child: SizedBox(
            width: 20.0,
            height: 20.0,
            child: event == null || event.expectedTotalBytes == null ? CircularProgressIndicator(
              color: context.moonTheme?.tokens.colors.piccolo,
            ) : MoonCircularProgress(
              value: event.cumulativeBytesLoaded / event.expectedTotalBytes!,
            ),
          ),
        ),
        onPageChanged: (i) {
          if (i == 0) {
            comicStore.prevChapter(controller: pageController);
          } else if (i ==
              comicStore.epsList[comicStore.currentEps.value].imageUrl.length +
                  1) {
            comicStore.nextChapter(controller: pageController);
          } else {
            comicStore.setPage(comicStore.currentEps.value, i - 1);
          }
        },
      );
    }

    Widget buildComicImageOrEmpty(
        {required int imageIndex, required BoxFit fit}) {
      if (imageIndex < 0 ||
          imageIndex >=
              comicStore.epsList[comicStore.currentEps.value].imageUrl.length) {
        return const SizedBox();
      }

      return PicaImage(
        comicStore.epsList[comicStore.currentEps.value].imageUrl[imageIndex],
        fit: fit,
        useProgressIndicator: true,
      );
    }

    Widget buildType56() {
      int calcItemCount() {
        int count =
            comicStore.epsList[comicStore.currentEps.value].imageUrl.length ~/
                2;
        if (comicStore.epsList[comicStore.currentEps.value].imageUrl.length %
                2 !=
            0) {
          count++;
        }
        return count + 2;
      }

      return PhotoViewGallery.builder(
        backgroundDecoration: decoration,
        itemCount: calcItemCount(),
        reverse: comicStore.readMode.value == 6,
        builder: (BuildContext context, int index) {
          if (index == 0 || index == calcItemCount() - 1) {
            return PhotoViewGalleryPageOptions.customChild(
                child: SizedBox(child: Text(index.toString())));
          }
          comicStore.preLoad(index: 2 * index - 2);

          int firstImage = index * 2 - 2;
          if (firstImage % 2 != 0) {
            firstImage++;
          }
          var images = <int>[firstImage, firstImage + 1];
          if (comicStore.readMode.value == 6) {
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
            comicStore.prevChapter(controller: pageController, duo: true);
          } else if (i == calcItemCount() - 1) {
            log.i("i=$i}");
            comicStore.nextChapter(controller: pageController);
          } else {
            if (i > 0 && i < calcItemCount() - 1) {
              comicStore.setPage(comicStore.currentEps.value, (i - 1) * 2);
            }
          }
        },
      );
    }

    Widget body;

    if (comicStore.readMode.value < 4) {
      body = buildType123();
    } else if (comicStore.readMode.value == 4) {
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
          switch (comicStore.readMode.value) {
            case 1:
            case 5:
              var threshold = Get.width * comicStore.tapThreshold.value / 100;
              if (details.localPosition.dx < threshold) {
                comicStore.prevPage(
                    controller: pageController,
                    duo: comicStore.readMode.value == 5);
              } else if (details.localPosition.dx > Get.width - threshold) {
                comicStore.nextPage(
                    controller: pageController,
                    duo: comicStore.readMode.value == 5);
              } else {
                comicStore.setBarVisible();
              }
              break;
            case 2:
            case 6:
              var threshold = Get.width * comicStore.tapThreshold.value / 100;
              if (details.localPosition.dx < threshold) {
                comicStore.nextPage(
                    controller: pageController,
                    duo: comicStore.readMode.value == 6);
              } else if (details.localPosition.dx > Get.width - threshold) {
                comicStore.prevPage(
                    controller: pageController,
                    duo: comicStore.readMode.value == 6);
              } else {
                comicStore.setBarVisible();
              }
              break;
            case 3:
              var threshold = Get.height * comicStore.tapThreshold.value / 100;
              if (details.localPosition.dy < threshold) {
                comicStore.prevPage(controller: pageController);
              } else if (details.localPosition.dy > Get.height - threshold) {
                comicStore.nextPage(controller: pageController);
              } else {
                comicStore.setBarVisible();
              }
              break;
            default:
              //case 4:
              var widthThreshold =
                  Get.width * comicStore.tapThreshold.value / 100;
              var heightThreshold =
                  Get.height * comicStore.tapThreshold.value / 100;
              if (details.localPosition.dx > widthThreshold &&
                  details.localPosition.dx < Get.width - widthThreshold &&
                  details.localPosition.dy > heightThreshold &&
                  details.localPosition.dy < Get.height - heightThreshold) {
                comicStore.setBarVisible();
              }
          }
        },
        child: body,
      ),
    );
  }
}
