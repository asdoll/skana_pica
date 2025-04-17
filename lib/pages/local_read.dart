import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:skana_pica/api/managers/image_cache_manager.dart';
import 'package:skana_pica/controller/local_comicstore.dart';
import 'package:skana_pica/pages/mainscreen.dart';
import 'package:skana_pica/pages/pica_comic.dart';
import 'package:skana_pica/util/leaders.dart';
import 'package:skana_pica/controller/log.dart';
import 'package:skana_pica/util/tool.dart';
import 'package:skana_pica/widgets/custom_slider.dart';
import 'package:skana_pica/widgets/pica_image.dart';
import 'package:photo_view/photo_view.dart';

class LocalReadPage extends StatefulWidget {
  static const route = "${PicacgComicPage.route}pica_read";
  final int id;

  const LocalReadPage({
    super.key,
    required this.id,
  });

  @override
  State<LocalReadPage> createState() => _LocalReadPageState();
}

class _LocalReadPageState extends State<LocalReadPage> {
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
    LocalComicStore localComicStore;
    try {
      localComicStore = Get.find<LocalComicStore>(tag: widget.id.toString());
      localComicStore.barVisible.value = false;
      if (localComicStore.readMode.value > 4) {
        pageController = PageController(
            initialPage: (localComicStore.currentIndex.value ~/ 2) + 1);
      } else {
        pageController = PageController(
            initialPage: localComicStore.currentIndex.value + 1,
            viewportFraction: 1.0,
            keepPage: true);
      }
    } catch (e) {
      showToast( "Internal Error".tr);
      Get.until((route) => Get.currentRoute == Mains.route);
      pageController = PageController(initialPage: 1);
      return const SizedBox();
    }

    localComicStore.autoPagingPageController = pageController;
    localComicStore.autoPagingScrollController = itemScrollController;
    localComicStore.autoPageTurning.value = false;
    localComicStore.orientationChanged();

    return Scaffold(
      body: Obx(
        () => Stack(
          children: [
            buildComicView(localComicStore, context),
            buildPageInfoText(localComicStore, context),
            buildTopToolBar(localComicStore, context),
            buildBottomToolBar(localComicStore, context),
          ],
        ),
      ),
    );
  }

  Widget buildBottomToolBar(LocalComicStore localComicStore, BuildContext context) {
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
        child: localComicStore.barVisible.value
            ? Material(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16)),
                surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
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
                          IconButton.filledTonal(
                              onPressed: localComicStore.dldEps.value == 0 ||
                                      localComicStore.eps.length < 2
                                  ? null
                                  : () => localComicStore.prevPage(
                                      controller: pageController,
                                      duo: localComicStore.readMode.value > 4),
                              icon: const Icon(Icons.first_page)),
                          Expanded(
                            child: buildSlider(localComicStore),
                          ),
                          IconButton.filledTonal(
                              onPressed: localComicStore.dldEps.value ==
                                          localComicStore.eps.length - 1 ||
                                      localComicStore.eps.length < 2
                                  ? null
                                  : () => localComicStore.nextChapter(
                                      controller: pageController,
                                      duo: localComicStore.readMode.value > 4),
                              icon: const Icon(Icons.last_page)),
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
                              child: IconButton(
                                icon: Icon(
                                  localComicStore.orientation.value == 0
                                      ? Icons.screen_rotation
                                      : localComicStore.orientation.value == 1
                                          ? Icons.screen_lock_portrait
                                          : Icons.screen_lock_landscape,
                                ),
                                onPressed: () {
                                  localComicStore.setOrientation();
                                },
                              ),
                            ),
                          Tooltip(
                            message: "Auto next page".tr,
                            child: IconButton(
                              icon: localComicStore.autoPageTurning.value
                                  ? const Icon(Icons.timer)
                                  : const Icon(Icons.timer_sharp),
                              onPressed: () => localComicStore.setAutoPageTurning(),
                            ),
                          ),
                          if (localComicStore.eps.length > 1)
                            Tooltip(
                              message: "Episodes".tr,
                              child: IconButton(
                                icon: const Icon(Icons.library_books),
                                onPressed: () => openEpsDrawer(localComicStore),
                              ),
                            ),
                          Tooltip(
                            message: "Save".tr,
                            child: IconButton(
                              icon: const Icon(Icons.download),
                              onPressed: () => saveCurrentImage(localComicStore),
                            ),
                          ),
                          Tooltip(
                            message: "Share".tr,
                            child: IconButton(
                              icon: const Icon(Icons.share),
                              onPressed: () => share(localComicStore),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
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

  void openEpsDrawer(LocalComicStore comicStore) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Obx(() => SizedBox(
                height: 300,
                child: ListView.builder(
                  itemCount: comicStore.eps.length,
                  itemBuilder: (context, i) {
                    return ListTile(
                      title: Text(comicStore.comic.value.eps[comicStore.eps[i].eps]),
                      subtitle: Text(
                          "${comicStore.eps[i].url.length} ${"Pages".tr}"),
                      trailing: comicStore.dldEps.value == i
                          ? const Icon(Icons.check)
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
              ));
        });
  }

  void saveCurrentImage(LocalComicStore comicStore) {
    saveImage(comicStore.eps[comicStore.dldEps.value]
        .url[comicStore.currentIndex.value], fromDld: true);
  }

  void share(LocalComicStore comicStore) {
    shareImage(comicStore.eps[comicStore.dldEps.value]
        .url[comicStore.currentIndex.value], fromDld: true);
  }

  Widget buildSlider(LocalComicStore comicStore) {
    if (pageController.hasClients &&
        pageController.page != null &&
        comicStore.currentIndex.value >= 0 &&
        comicStore.currentIndex.value <
            comicStore.eps[comicStore.dldEps.value].url.length) {
      return CustomSlider(
        key: ValueKey("read_slider"),
        value: comicStore.currentIndex.value.toDouble() + 1,
        min: 1,
        reversed:
            comicStore.readMode.value == 6 || comicStore.readMode.value == 2,
        max: comicStore.eps[comicStore.dldEps.value].url.length
                .toDouble() +
            1,
        divisions:
            comicStore.eps[comicStore.dldEps.value].url.length - 1,
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

  Widget buildTopToolBar(LocalComicStore comicStore, BuildContext context) {
    return Positioned(
      top: 0,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 150),
        reverseDuration: const Duration(milliseconds: 150),
        switchInCurve: Curves.fastOutSlowIn,
        key: ValueKey("top_tool_bar_switcher"),
        child: comicStore.barVisible.value
            ? Material(
                surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
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
                        child: Tooltip(
                          message: "Back".tr,
                          child: IconButton(
                            iconSize: 25,
                            icon: const Icon(Icons.arrow_back_outlined),
                            onPressed: () => Get.back(),
                          ),
                        ),
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
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 25,
                        padding: const EdgeInsets.fromLTRB(6, 2, 6, 0),
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).colorScheme.tertiaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(comicStore.eps.length > 1
                            ? "E${comicStore.eps[comicStore.dldEps.value].eps + 1}:P${comicStore.currentIndex.value + 1}"
                            : "P${comicStore.currentIndex.value + 1}"),
                      ),
                      //const Spacer(),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Tooltip(
                          message: "Read Settings".tr,
                          child: IconButton(
                            iconSize: 25,
                            icon: const Icon(Icons.settings),
                            onPressed: () => showSettings(context, comicStore),
                          ),
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

  void showSettings(BuildContext context, LocalComicStore comicStore) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Obx(
          () => SizedBox(
            height: 300,
            child: ListView(
              children: [
                ListTile(
                  title: Text("Read Mode".tr),
                  trailing: DropdownButton<int>(
                      items: [
                        DropdownMenuItem(
                          value: 1,
                          child: Text("Left to Right".tr),
                        ),
                        DropdownMenuItem(
                          value: 2,
                          child: Text("Right to Left".tr),
                        ),
                        DropdownMenuItem(
                          value: 3,
                          child: Text("Top to Bottom".tr),
                        ),
                        DropdownMenuItem(
                          value: 4,
                          child: Text("Top to Bottom(Scroll view)".tr),
                        ),
                        DropdownMenuItem(
                          value: 5,
                          child: Text("Duo Page".tr),
                        ),
                        DropdownMenuItem(
                          value: 6,
                          child: Text("Duo Page(reversed)".tr),
                        ),
                      ],
                      value: comicStore.readMode.value,
                      onChanged: (i) {
                        comicStore.setReadMode(i as int);
                        if (i < 4) {
                          pageController = PageController(
                              initialPage: comicStore.currentIndex.value + 1);
                        } else if (i == 4) {
                          itemScrollController.scrollTo(
                              index: comicStore.currentIndex.value + 1,
                              duration: Duration(
                                  milliseconds:
                                      comicStore.animationDuration.value),
                              curve: Curves.easeInOut);
                        } else {
                          pageController = PageController(
                              initialPage:
                                  (comicStore.currentIndex.value ~/ 2) + 1);
                        }
                      }),
                ),
                ListTile(
                  title: Text("Auto Page Turning Interval".tr),
                  subtitle: SizedBox(
                    height: 105,
                    child: Row(
                      children: [
                        Expanded(
                          child: Slider(
                            key: ValueKey("auto_page_turning_interval_slider"),
                            value: comicStore.autoPageTurningInterval.value
                                .toDouble(),
                            min: 1,
                            max: 20,
                            divisions: 19,
                            onChanged: (i) {
                              comicStore.setAutoPageTurningInterval(i.toInt());
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  trailing: Text(
                      "${comicStore.autoPageTurningInterval.value} ${"s".tr}"),
                ),
                ListTile(
                  title: Text("Image Layout".tr),
                  subtitle: Text(comicStore.imageLayout.value == 0
                      ? "Contained".tr
                      : "Covered".tr),
                  trailing: Switch(
                    value: comicStore.imageLayout.value == 1,
                    onChanged: (value) {
                      comicStore.setImageLayout(value ? 1 : 0);
                    },
                  ),
                ),
                ListTile(
                  title: Text("Limit Image Width".tr),
                  subtitle: Text(comicStore.limitImageWidth.value
                      ? "Enabled".tr
                      : "Disabled".tr),
                  trailing: Switch(
                    value: comicStore.limitImageWidth.value,
                    onChanged: (value) {
                      comicStore.setLimitImageWidth(value);
                    },
                  ),
                ),
                ListTile(
                  title: Text("Tap to Next Page Threshold".tr),
                  subtitle: SizedBox(
                    height: 105,
                    child: Row(
                      children: [
                        Expanded(
                          child: Slider(
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
                  trailing: Text("${comicStore.tapThreshold.value}%"),
                ),
                ListTile(
                  title: Text("Dark Background".tr),
                  subtitle: Text(comicStore.useDarkBackground.value
                      ? "Enabled".tr
                      : "Disabled".tr),
                  trailing: Switch(
                    value: comicStore.useDarkBackground.value,
                    onChanged: (value) {
                      comicStore.setDarkBackground(value);
                    },
                  ),
                ),
                ListTile(
                  title: Text("Animation Duration".tr),
                  subtitle: SizedBox(
                    height: 105,
                    child: Row(
                      children: [
                        Expanded(
                          child: Slider(
                            key: ValueKey("animation_duration_slider"),
                            value: comicStore.animationDuration.value.toDouble(),
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
                      "${comicStore.animationDuration.value} ${"ms".tr}"),
                )
              ],
            ).paddingOnly(top: 16),
          ),
        );
      },
    );
  }

  Widget buildPageInfoText(LocalComicStore comicStore, BuildContext context) {
    var epName = comicStore.comic.value.eps[comicStore.eps[comicStore.dldEps.value].eps].isEmpty
        ? "E1"
        : comicStore.comic.value.eps[comicStore.eps[comicStore.dldEps.value].eps];
    if (epName.length > 8) {
      epName = "${epName.substring(0, 8)}...";
    }
    var text = comicStore.eps.length > 1
        ? "$epName : ${comicStore.currentIndex.value + 1}/${comicStore.eps[comicStore.dldEps.value].url.length}"
        : "${comicStore.currentIndex.value + 1}/${comicStore.eps[comicStore.dldEps.value].url.length}";
    return Positioned(
      bottom: 25,
      left: 25,
      child: Stack(
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
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
            style: TextStyle(
              fontSize: 14,
              color: comicStore.useDarkBackground.value ? Colors.white : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildComicView(LocalComicStore comicStore, BuildContext context) {
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
                        .eps[comicStore.dldEps.value].url.length +
                    1) {
          comicStore.currentIndex.value = positions.first.index - 1;
        }
      });

      return ScrollablePositionedList.builder(
        itemScrollController: itemScrollController,
        itemPositionsListener: itemPositionsListener,
        itemCount:
            comicStore.eps[comicStore.dldEps.value].url.length + 2,
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
            if (comicStore.dldEps.value > 0) {
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
              comicStore.eps[comicStore.dldEps.value].url.length +
                  1) {
            if (comicStore.dldEps.value < comicStore.eps.length) {
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
            comicStore.eps[comicStore.dldEps.value].url[i - 1],
            width: imageWidth,
            fit: BoxFit.contain,
            downloaded: true,
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
            comicStore.eps[comicStore.dldEps.value].url.length + 2,
        builder: (BuildContext context, int index) {
          if (index == 0 ||
              index ==
                  comicStore.eps[comicStore.dldEps.value].url
                          .length +
                      1) {
            return PhotoViewGalleryPageOptions.customChild(
              child: const SizedBox(),
            );
          }

          return PhotoViewGalleryPageOptions(
            filterQuality: FilterQuality.medium,
            imageProvider: localProvider(comicStore
                .eps[comicStore.dldEps.value].url[index - 1]),
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
                    "$index/${comicStore.eps[comicStore.dldEps.value].url.length}"),
          );
        },
        pageController: pageController,
        loadingBuilder: (context, event) => Center(
          child: SizedBox(
            width: 20.0,
            height: 20.0,
            child: CircularProgressIndicator(
              backgroundColor: Get.theme.colorScheme.surfaceContainerHigh,
              value: event == null || event.expectedTotalBytes == null
                  ? null
                  : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
            ),
          ),
        ),
        onPageChanged: (i) {
          if (i == 0) {
            comicStore.prevChapter(controller: pageController);
          } else if (i ==
              comicStore.eps[comicStore.dldEps.value].url.length +
                  1) {
            comicStore.nextChapter(controller: pageController);
          } else {
            comicStore.setPage(comicStore.dldEps.value, i - 1);
          }
        },
      );
    }

    Widget buildComicImageOrEmpty(
        {required int imageIndex, required BoxFit fit}) {
      if (imageIndex < 0 ||
          imageIndex >=
              comicStore.eps[comicStore.dldEps.value].url.length) {
        return const SizedBox();
      }

      return PicaImage(
        comicStore.eps[comicStore.dldEps.value].url[imageIndex],
        fit: fit,
        useProgressIndicator: true,
        downloaded: true,
      );
    }

    Widget buildType56() {
      int calcItemCount() {
        int count =
            comicStore.eps[comicStore.dldEps.value].url.length ~/
                2;
        if (comicStore.eps[comicStore.dldEps.value].url.length %
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
              comicStore.setPage(comicStore.dldEps.value, (i - 1) * 2);
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
