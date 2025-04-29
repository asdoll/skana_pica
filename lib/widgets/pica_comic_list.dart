import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moon_design/moon_design.dart';
import 'package:skana_pica/controller/comiclist.dart';
import 'package:skana_pica/controller/main_controller.dart';
import 'package:skana_pica/controller/profile.dart';
import 'package:skana_pica/controller/setting_controller.dart';
import 'package:skana_pica/util/leaders.dart';
import 'package:skana_pica/util/widgetplugin.dart';
import 'package:skana_pica/widgets/custom_indicator.dart';
import 'package:skana_pica/widgets/icons.dart';
import 'package:skana_pica/widgets/pica_comic_card.dart';

class PicaComicsPage extends StatefulWidget {
  final String keyword;
  final String type;
  final bool? addToHistory;
  final String? sort;
  final bool fromDrawer;
  final ScrollController? scrollController;

  const PicaComicsPage(
      {super.key,
      required this.keyword,
      required this.type,
      this.addToHistory,
      this.sort,
      this.scrollController,
      this.fromDrawer = false});

  @override
  State<PicaComicsPage> createState() => _PicaComicsPageState();
}

class _PicaComicsPageState extends State<PicaComicsPage> {
  @override
  Widget build(BuildContext context) {
    String tag = widget.type != "search" && widget.type != "author"
        ? widget.keyword
        : "${widget.type}_${widget.keyword}";
    ComicListController controller;
    TextEditingController pageJumpController = TextEditingController();
    late LeaderboardController leaderboardController;
    if (widget.keyword == "leaderboard") {
      leaderboardController = Get.put(LeaderboardController());
    }
    controller = Get.put(
        ComicListController(
            keyword: widget.keyword,
            type: widget.type,
            isSearch: widget.type == "search",
            isAuthor: widget.type == "author",
            addToHistory: widget.addToHistory ?? false,
            sortByDefault: widget.sort ?? ""),
        tag: tag);
    controller.reset();
    GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
        GlobalKey<RefreshIndicatorState>();
    ScrollController scrollController =
        widget.scrollController ?? globalScrollController;
    return Obx(
      () => !profileController.isLogin.value
          ? ErrorLoading(text: "Not Logged In".tr)
          : Column(
              children: [
                if (widget.keyword == "leaderboard")
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: leaderboardController.items.map((String value) {
                      return filledButton(
                        label: value.tr,
                        textColor: context.moonTheme?.tokens.colors.bulma,
                        color: leaderboardController.type.value == value
                            ? context.moonTheme?.tokens.colors.frieza60
                            : context.moonTheme?.tokens.colors.goku,
                        onPressed: () {
                          leaderboardController.type.value = value;
                          controller.reset();
                        },
                      );
                    }).toList(),
                  ).paddingVertical(8),
                if (widget.keyword != "leaderboard" &&
                    widget.keyword != "latest" &&
                    widget.keyword != "random" &&
                    !mangaSettingsController.picaPageViewMode.value)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      filledButton(
                        label: "New to Old".tr,
                        textColor: context.moonTheme?.tokens.colors.bulma,
                        color: controller.sort.value == 0
                            ? context.moonTheme?.tokens.colors.frieza60
                            : context.moonTheme?.tokens.colors.goku,
                        onPressed: () {
                          controller.resetWithSort(0);
                        },
                      ),
                      filledButton(
                        label: "Old to New".tr,
                        textColor: context.moonTheme?.tokens.colors.bulma,
                        color: controller.sort.value == 1
                            ? context.moonTheme?.tokens.colors.frieza60
                            : context.moonTheme?.tokens.colors.goku,
                        onPressed: () {
                          controller.resetWithSort(1);
                        },
                      ),
                      if (widget.keyword != "bookmarks")
                        filledButton(
                          label: 'Most Likes'.tr,
                          textColor: context.moonTheme?.tokens.colors.bulma,
                          color: controller.sort.value == 2
                              ? context.moonTheme?.tokens.colors.frieza60
                              : context.moonTheme?.tokens.colors.goku,
                          onPressed: () {
                            controller.resetWithSort(2);
                          },
                        ),
                      if (widget.keyword != "bookmarks")
                        filledButton(
                          label: 'Most Viewed'.tr,
                          textColor: context.moonTheme?.tokens.colors.bulma,
                          color: controller.sort.value == 3
                              ? context.moonTheme?.tokens.colors.frieza60
                              : context.moonTheme?.tokens.colors.goku,
                          onPressed: () {
                            controller.resetWithSort(3);
                          },
                        ),
                    ],
                  ).paddingVertical(8),
                if (mangaSettingsController.picaPageViewMode.value &&
                    controller.total.value > 1)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 12,
                      ),
                      if (widget.keyword != "leaderboard" &&
                          widget.keyword != "latest" &&
                          widget.keyword != "random")
                        MoonDropdown(
                            show: controller.filterMenu.value,
                            onTapOutside: () =>
                                controller.filterMenu.value = false,
                            offset: Offset(5, 0),
                            minWidth: 80,
                            maxWidth: 80,
                            content: Column(
                              children: [
                                MoonMenuItem(
                                  label: Text('New to Old'.tr).small(),
                                  onTap: () {
                                    controller.filterMenu.value = false;
                                    controller.resetWithSort(0);
                                  },
                                ),
                                MoonMenuItem(
                                  label: Text('Old to New'.tr).small(),
                                  onTap: () {
                                    controller.filterMenu.value = false;
                                    controller.resetWithSort(1);
                                  },
                                ),
                                if (widget.keyword != "bookmarks")
                                  MoonMenuItem(
                                    label: Text('Most Likes'.tr).small(),
                                    onTap: () {
                                      controller.filterMenu.value = false;
                                      controller.resetWithSort(2);
                                    },
                                  ),
                                if (widget.keyword != "bookmarks")
                                  MoonMenuItem(
                                    label: Text('Most Viewed'.tr).small(),
                                    onTap: () {
                                      controller.filterMenu.value = false;
                                      controller.resetWithSort(3);
                                    },
                                  ),
                              ],
                            ),
                            child: filledButton(
                                label: controller.sort.value == 0
                                    ? "New to Old".tr
                                    : controller.sort.value == 1
                                        ? "Old to New".tr
                                        : controller.sort.value == 2
                                            ? "Most Likes".tr
                                            : "Most Viewed".tr,
                                onPressed: () => controller.filterMenu.value =
                                    !controller.filterMenu.value)),
                      TextButton(
                          onPressed: () {
                            showMoonModal(
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                      child: ListView(
                                    shrinkWrap: true,
                                    children: [
                                      MoonAlert(
                                          borderColor: Get.context?.moonTheme
                                              ?.buttonTheme.colors.borderColor
                                              .withValues(alpha: 0.5),
                                          showBorder: true,
                                          label:
                                              Text('Jump to Page'.tr).header(),
                                          verticalGap: 16,
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              MoonFormTextInput(
                                                controller: pageJumpController,
                                                keyboardType:
                                                    TextInputType.number,
                                                hintText: "Page Number".tr,
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty ||
                                                      int.tryParse(value) ==
                                                          null ||
                                                      int.tryParse(value)! <
                                                          1 ||
                                                      int.tryParse(value)! >
                                                          controller
                                                              .total.value) {
                                                    return 'Invalid Page Number'
                                                        .tr;
                                                  }
                                                  return null;
                                                },
                                                onSubmitted: (value) {
                                                  int pageNumber =
                                                      int.parse(value);
                                                  controller
                                                      .pageFetch(pageNumber);
                                                },
                                              ).paddingBottom(16),
                                              Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    filledButton(
                                                      label: "Cancel".tr,
                                                      onPressed: () =>
                                                          Get.back(),
                                                    ).paddingRight(8),
                                                    filledButton(
                                                      label: "Ok".tr,
                                                      onPressed: () {
                                                        FocusManager.instance
                                                            .primaryFocus
                                                            ?.unfocus();
                                                        if (int.tryParse(
                                                                pageJumpController
                                                                    .text) ==
                                                            null) {
                                                          showToast(
                                                              "Invalid Page Number"
                                                                  .tr);
                                                          return;
                                                        }
                                                        int pageNumber =
                                                            int.tryParse(
                                                                pageJumpController
                                                                    .text)!;
                                                        if (pageNumber < 1 ||
                                                            pageNumber >
                                                                controller.total
                                                                    .value) {
                                                          showToast(
                                                              "Invalid Page Number"
                                                                  .tr);
                                                          return;
                                                        }
                                                        controller.pageFetch(
                                                            pageNumber);
                                                        Get.back();
                                                      },
                                                    ).paddingRight(8),
                                                  ]),
                                            ],
                                          )),
                                    ],
                                  ));
                                });
                          },
                          child: Text('at_page'.trParams({
                            'page': controller.page.toString(),
                            'total': controller.total.toString()
                          })).subHeader()),
                      Expanded(child: SizedBox()),
                      filledButton(
                        color: context.moonTheme?.tokens.colors.cell60,
                        label: "Prev Page".tr,
                        applyDarkMode: true,
                        onPressed: (controller.page.value == 1)
                            ? null
                            : () {
                                controller.pageFetch(controller.page.value - 1);
                                scrollController.animateTo(-100,
                                    duration: const Duration(microseconds: 200),
                                    curve: Curves.ease);
                                refreshIndicatorKey.currentState?.show();
                              },
                      ),
                      SizedBox(width: 4),
                      filledButton(
                        color: context.moonTheme?.tokens.colors.cell60,
                        label: "Next Page".tr,
                        applyDarkMode: true,
                        onPressed: (controller.page.value ==
                                controller.total.value)
                            ? null
                            : () {
                                controller.pageFetch(controller.page.value + 1);
                                scrollController.animateTo(-100,
                                    duration: const Duration(microseconds: 200),
                                    curve: Curves.ease);
                                refreshIndicatorKey.currentState?.show();
                              },
                      ),
                      SizedBox(width: 16),
                    ],
                  ),
                Expanded(
                    child: BezierIndicator(
                        onRefresh: () => controller.reset(drag: true),
                        child: Obx(() => Stack(children: [
                              ListView.builder(
                                controller: scrollController,
                                itemCount: controller.comics.length + 1,
                                itemBuilder: (context, index) {
                                  if (index == controller.comics.length) {
                                    if (controller.comics.isEmpty) {
                                      return !controller.isLoading.value
                                          ? SizedBox(
                                              height: Get.height * 0.8,
                                              child: Center(
                                                child: Text("[ ]").h1(),
                                              ))
                                          : Container();
                                    }
                                    if (controller.page.value <
                                        controller.total.value) {
                                      if (mangaSettingsController
                                          .picaPageViewMode.value) {
                                        return !controller.isLoading.value
                                            ? Center(
                                                child: MoonButton.icon(
                                                    onTap: () {
                                                      scrollController.animateTo(
                                                          0,
                                                          duration:
                                                              const Duration(
                                                                  microseconds:
                                                                      200),
                                                          curve: Curves.ease);
                                                      controller.pageFetch(
                                                          controller
                                                                  .page.value +
                                                              1);
                                                    },
                                                    icon: Icon(
                                                      BootstrapIcons
                                                          .chevron_compact_down,
                                                      size: 40,
                                                    )),
                                              )
                                            : Container();
                                      } else {
                                        if (!controller.isLoading.value) {
                                          Future.delayed(
                                              const Duration(microseconds: 100),
                                              () {
                                            controller.onLoad();
                                          });
                                        }
                                        return progressIndicator(context)
                                            .paddingVertical(10);
                                      }
                                    } else {
                                      return Container();
                                    }
                                  }
                                  return PicaComicCard(
                                    controller.comics[index],
                                    type: widget.keyword == "bookmarks"
                                        ? "bookmarks"
                                        : "comic",
                                  );
                                },
                              ),
                              if (!controller.isDrag.value &&
                                  controller.isLoading.value)
                                Center(
                                  child: progressIndicator(context),
                                )
                            ])))),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
    );
  }
}
