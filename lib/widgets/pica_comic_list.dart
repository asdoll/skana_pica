import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moon_design/moon_design.dart';
import 'package:skana_pica/controller/comiclist.dart';
import 'package:skana_pica/controller/favourite.dart';
import 'package:skana_pica/controller/main_controller.dart';
import 'package:skana_pica/controller/profile.dart';
import 'package:skana_pica/util/leaders.dart';
import 'package:skana_pica/util/widgetplugin.dart';
import 'package:skana_pica/widgets/error_loading.dart';
import 'package:skana_pica/widgets/headfoot.dart';
import 'package:skana_pica/widgets/pica_comic_card.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class PicaComicsPage extends StatefulWidget {
  final String keyword;
  final String type;
  final bool? addToHistory;
  final String? sort;
  final EasyRefreshController? easyRefreshController;
  final bool fromDrawer;
  final ScrollController? scrollController;

  const PicaComicsPage(
      {super.key,
      required this.keyword,
      required this.type,
      this.addToHistory,
      this.sort,
      this.easyRefreshController,
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
    EasyRefreshController easyRefreshController =
        widget.easyRefreshController ??
            EasyRefreshController(
              controlFinishRefresh: true,
              controlFinishLoad: true,
            );
    controller = Get.put(
        ComicListController(
            keyword: widget.keyword,
            type: widget.type,
            isSearch: widget.type == "search",
            isAuthor: widget.type == "author",
            addToHistory: widget.addToHistory ?? false,
            sortByDefault: widget.sort ?? "",
            easyRefreshController: easyRefreshController),
        tag: tag);
    if (widget.fromDrawer) {
      controller.reset();
    }
    ScrollController scrollController =
        widget.scrollController ?? globalScrollController;
    return Obx(
      () => !profileController.isLogin.value
          ? ErrorLoading(text: "Not Logged In".tr)
          : Column(
              children: [
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
                    if (controller.total.value > 1)
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
                                                        FocusManager.instance.primaryFocus?.unfocus();
                                                        if (int.tryParse(pageJumpController.text) == null) {
                                                          showToast("Invalid Page Number".tr);
                                                          return;
                                                        }
                                                        int pageNumber =
                                                            int.tryParse(pageJumpController.text)!;
                                                        if (pageNumber < 1 || pageNumber > controller.total.value) {
                                                          showToast("Invalid Page Number".tr);
                                                          return;
                                                        }
                                                        controller
                                                            .pageFetch(pageNumber);
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
                    if (controller.total.value > 1)
                      filledButton(
                        color: context.moonTheme?.tokens.colors.cell60,
                        label: "Prev Page".tr,
                        applyDarkMode: true,
                        onPressed: (controller.page.value == 1)
                            ? null
                            : () {
                                scrollController.animateTo(0,
                                    duration: const Duration(microseconds: 200),
                                    curve: Curves.ease);
                                controller.pageFetch(controller.page.value - 1);
                              },
                      ),
                    if (controller.total.value > 1) SizedBox(width: 4),
                    if (controller.total.value > 1)
                      filledButton(
                        color: context.moonTheme?.tokens.colors.cell60,
                        label: "Next Page".tr,
                        applyDarkMode: true,
                        onPressed: (controller.page.value ==
                                controller.total.value)
                            ? null
                            : () {
                                scrollController.animateTo(0,
                                    duration: const Duration(microseconds: 200),
                                    curve: Curves.ease);
                                controller.pageFetch(controller.page.value + 1);
                              },
                      ),
                    if (controller.total.value > 1) SizedBox(width: 16),
                  ],
                ),
                Expanded(
                  child: EasyRefresh(
                      controller: easyRefreshController,
                      scrollController: scrollController,
                      onRefresh: () {
                        scrollController.jumpTo(0);
                        controller.reset();
                      },
                      refreshOnStart:
                          controller.comics.isEmpty && !widget.fromDrawer,
                      header: DefaultHeaderFooter.header(context),
                      footer: DefaultHeaderFooter.footer(context),
                      refreshOnStartHeader:
                          DefaultHeaderFooter.refreshHeader(context),
                      child: Obx(
                        () => ListView.builder(
                          controller: scrollController,
                          itemCount: controller.comics.length + 1,
                          itemBuilder: (context, index) {
                            if (index == controller.comics.length) {
                              if ((controller.page.value <
                                      controller.total.value) &&
                                  !controller.isLoading.value) {
                                return Center(
                                  child: MoonButton.icon(
                                      onTap: () {
                                        scrollController.animateTo(0,
                                            duration: const Duration(
                                                microseconds: 200),
                                            curve: Curves.ease);
                                        controller.pageFetch(
                                            controller.page.value + 1);
                                      },
                                      icon: Icon(
                                        BootstrapIcons.chevron_compact_down,
                                        size: 40,
                                      )),
                                );
                              } else {
                                // if (controller.isLoading.value && controller.comics.isEmpty) {
                                // return SizedBox(
                                //     height: Get.height * 0.8,
                                //     child: Center(
                                //       child: Text("[ ]").h1(),
                                //     ));
                                // }
                                return Container();
                              }
                            }
                            if (widget.keyword == "bookmarks" &&
                                widget.type == "me") {
                              return Slidable(
                                endActionPane: ActionPane(
                                    motion: const ScrollMotion(),
                                    extentRatio: 0.2,
                                    children: [
                                      SlidableAction(
                                        backgroundColor: Colors.red,
                                        icon: Icons.delete,
                                        borderRadius: BorderRadius.circular(8),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        onPressed: (context) {
                                          favorController.favorCall(
                                              controller.comics[index].id);
                                          controller.comics.removeAt(index);
                                          controller.comics.refresh();
                                        },
                                      ),
                                    ]),
                                child: PicaComicCard(
                                  controller.comics[index],
                                  type: "bookmarks",
                                ),
                              );
                            }

                            return PicaComicCard(
                              controller.comics[index],
                              type: widget.keyword == "bookmarks"
                                  ? "bookmarks"
                                  : "comic",
                            );
                          },
                        ),
                      )),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
    );
  }
}
