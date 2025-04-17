import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moon_design/moon_design.dart';
import 'package:skana_pica/controller/comiclist.dart';
import 'package:skana_pica/controller/favourite.dart';
import 'package:skana_pica/controller/main_controller.dart';
import 'package:skana_pica/controller/profile.dart';
import 'package:skana_pica/controller/setting_controller.dart';
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
    String tag = "${widget.type}_${widget.keyword}";
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
                if (!mangaSettingsController.picaPageViewMode.value &&
                    widget.keyword != "leaderboard" &&
                    widget.keyword != "latest" &&
                    widget.keyword != "random")
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ChoiceChip(
                        selectedColor: Get.theme.primaryColor,
                        labelPadding: EdgeInsets.all(2.0),
                        label: Text('New to Old'.tr,
                            style: Get.textTheme.bodySmall),
                        selected: controller.sort.value == "dd",
                        onSelected: (bool selected) {
                          if (selected) {
                            controller.reset(newSort: "dd");
                          }
                        },
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      ChoiceChip(
                        selectedColor: Get.theme.primaryColor,
                        label: Text('Old to New'.tr,
                            style: Get.textTheme.bodySmall),
                        selected: controller.sort.value == "da",
                        onSelected: (bool selected) {
                          if (selected) {
                            controller.reset(newSort: "da");
                          }
                        },
                      ),
                      if (widget.keyword != "bookmarks")
                        SizedBox(
                          width: 2,
                        ),
                      if (widget.keyword != "bookmarks")
                        ChoiceChip(
                          selectedColor: Get.theme.primaryColor,
                          label: Text('Most Likes'.tr,
                              style: Get.textTheme.bodySmall),
                          selected: controller.sort.value == "ld",
                          onSelected: (bool selected) {
                            if (selected) {
                              controller.reset(newSort: "ld");
                            }
                          },
                        ),
                      if (widget.keyword != "bookmarks")
                        SizedBox(
                          width: 2,
                        ),
                      if (widget.keyword != "bookmarks")
                        ChoiceChip(
                          selectedColor: Get.theme.primaryColor,
                          label: Text('Most Viewed'.tr,
                              style: Get.textTheme.bodySmall),
                          selected: controller.sort.value == "vd",
                          onSelected: (bool selected) {
                            if (selected) {
                              controller.reset(newSort: "vd");
                            }
                          },
                        ),
                    ],
                  ),
                if (mangaSettingsController.picaPageViewMode.value)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      if (widget.keyword != "leaderboard" &&
                          widget.keyword != "latest" &&
                          widget.keyword != "random")
                        DropdownButton<String>(
                          elevation: 4,
                          style: Get.textTheme.bodyMedium,
                          value: controller.sortType,
                          onChanged: (String? newValue) {
                            if (newValue == null) return;
                            controller.reset(newSort: newValue);
                          },
                          items: [
                            DropdownMenuItem(
                                value: "dd", child: Text('New to Old'.tr)),
                            DropdownMenuItem(
                                value: "da", child: Text('Old to New'.tr)),
                            if (widget.keyword != "bookmarks")
                              DropdownMenuItem(
                                  value: "ld", child: Text('Most Likes'.tr)),
                            if (widget.keyword != "bookmarks")
                              DropdownMenuItem(
                                  value: "vd", child: Text('Most Viewed'.tr)),
                          ],
                        ),
                      if (controller.total.value > 1)
                        TextButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('Jump to Page'.tr),
                                      content: TextField(
                                        controller: pageJumpController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: 'Page Number'.tr),
                                        onSubmitted: (value) {
                                          int? pageNumber = int.tryParse(value);
                                          if (pageNumber != null &&
                                              pageNumber > 0 &&
                                              pageNumber <=
                                                  controller.total.value) {
                                            scrollController.animateTo(0,
                                                duration: const Duration(
                                                    microseconds: 200),
                                                curve: Curves.ease);
                                            controller.pageFetch(pageNumber);
                                            Get.back();
                                          } else {
                                            showToast('Invalid Page Number'.tr);
                                          }
                                        },
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Get.back();
                                          },
                                          child: Text('Cancel'.tr),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            int? pageNumber = int.tryParse(
                                                pageJumpController.value.text);
                                            if (pageNumber != null &&
                                                pageNumber > 0 &&
                                                pageNumber <=
                                                    controller.total.value) {
                                              scrollController.animateTo(0,
                                                  duration: const Duration(
                                                      microseconds: 200),
                                                  curve: Curves.ease);
                                              controller.pageFetch(pageNumber);
                                              Get.back();
                                            } else {
                                              showToast(
                                                  'Invalid Page Number'.tr);
                                            }
                                          },
                                          child: Text('Ok'.tr),
                                        ),
                                      ],
                                    );
                                  });
                            },
                            child: Text(
                                'at_page'.trParams({
                                  'page': controller.page.toString(),
                                  'total': controller.total.toString()
                                })).subHeader()),
                                Expanded(child: SizedBox()),
                      if (controller.total.value > 1)
                        filledButton(
                          color: context.moonTheme?.tokens.colors.cell,
                          label: "Prev Page".tr,
                          textColor: Colors.black,
                          onPressed: (controller.page.value == 1)
                                ? null
                                : () {
                                    scrollController.animateTo(0,
                                        duration:
                                            const Duration(microseconds: 200),
                                        curve: Curves.ease);
                                    controller
                                        .pageFetch(controller.page.value - 1);
                                  },
                            ),
                      if (controller.total.value >1)
                      SizedBox(width: 16),
                      if (controller.total.value > 1)
                        filledButton(
                          color: context.moonTheme?.tokens.colors.cell,
                          label: "Next Page".tr,
                          textColor: Colors.black,
                          onPressed: (controller.page.value ==
                                    controller.total.value)
                                ? null
                                : () {
                                    scrollController.animateTo(0,
                                        duration:
                                            const Duration(microseconds: 200),
                                        curve: Curves.ease);
                                    controller
                                        .pageFetch(controller.page.value + 1);
                                  },
                            ),
                      if (controller.total.value >1)
                      SizedBox(width: 16),
                    ],
                  ),
                Expanded(
                  child: EasyRefresh(
                      controller: easyRefreshController,
                      scrollController: scrollController,
                      onLoad: (mangaSettingsController.picaPageViewMode.value)
                          ? null
                          : controller.onLoad,
                      onRefresh: controller.reset,
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
                              if (!mangaSettingsController
                                  .picaPageViewMode.value) {
                                return Container();
                              }
                              if ((controller.page.value <
                                      controller.total.value) &&
                                  !controller.isLoading.value) {
                                return Center(
                                  child: IconButton(
                                      onPressed: () {
                                        scrollController.animateTo(0,
                                            duration: const Duration(
                                                microseconds: 200),
                                            curve: Curves.ease);
                                        controller.pageFetch(
                                            controller.page.value + 1);
                                      },
                                      icon: Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        size: 40,
                                      )),
                                );
                              } else {
                                return Container();
                              }
                            }
                            if (controller.comics.isEmpty) {
                              return SizedBox(
                                  height: Get.height * 0.8,
                                  child: Center(
                                    child: Text(
                                      "[ ]",
                                      style: Get.textTheme.displayLarge
                                          ?.copyWith(
                                              color: Get
                                                  .theme.colorScheme.onPrimary
                                                  .withValues(alpha: 0.7)),
                                    ),
                                  ));
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
