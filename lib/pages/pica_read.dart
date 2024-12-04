import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:skana_pica/api/managers/image_cache_manage.dart';
import 'package:skana_pica/config/setting.dart';
import 'package:skana_pica/controller/comicstore.dart';
import 'package:skana_pica/pages/mainscreen.dart';
import 'package:skana_pica/pages/pica_comic.dart';
import 'package:skana_pica/util/log.dart';
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
  }

  final decoration = BoxDecoration(
    color: appdata.useDarkBackground
        ? Colors.black
        : Get.theme.colorScheme.surface,
  );

  @override
  Widget build(BuildContext context) {
    ComicStore comicStore;
    try {
      comicStore = Get.find<ComicStore>(tag: widget.id);
      if (appdata.read[2] == "6" || appdata.read[2] == "5") {
        pageController = PageController(
            initialPage: (comicStore.currentIndex.value ~/ 2) + 1);
      } else {
        pageController = PageController(
            initialPage: comicStore.currentIndex.value + 1,
            viewportFraction: 1.0,
            keepPage: true);
      }
    } catch (e) {
      BotToast.showText(text: "Internal Error".tr);
      Get.until((route) => Get.currentRoute == Mains.route);
      pageController = PageController(initialPage: 1);
      return const SizedBox();
    }

    return Scaffold(
        body: Obx(
      () => Stack(
        children: [
          buildComicView(comicStore, context),
          //buildAppBar(context, comicStore),
        ],
      ),
    ));
  }

  Widget buildAppBar(BuildContext context, ComicStore comicStore) {
    return AppBar(
      title: Text(comicStore.comic.value.title),
    );
  }

  Widget buildComicView(ComicStore comicStore, BuildContext context) {
    Widget buildType4() {
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

          if (height / width < 1.2 && appdata.read[0] == "1") {
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
                          color: appdata.useDarkBackground
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
                                color: appdata.useDarkBackground
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
        reverse: appdata.read[2] == "2",
        scrollDirection:
            appdata.read[2] != "3" ? Axis.horizontal : Axis.vertical,
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
            initialScale: appdata.read[1] == "0"
                ? PhotoViewComputedScale.contained
                : PhotoViewComputedScale.covered,
            errorBuilder: (_, error, s) {
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
                                color: appdata.useDarkBackground
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
        reverse: appdata.read[2] == "6",
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
          if (appdata.read[2] == "6") {
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

    if (["1", "2", "3"].contains(appdata.read[2])) {
      body = buildType123();
    } else if (appdata.read[2] == "4") {
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
      child: body,
    );
  }
}
