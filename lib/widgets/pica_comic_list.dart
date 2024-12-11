import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skana_pica/config/setting.dart';
import 'package:skana_pica/controller/comiclist.dart';
import 'package:skana_pica/controller/favourite.dart';
import 'package:skana_pica/controller/profile.dart';
import 'package:skana_pica/pages/leaderboard.dart';
import 'package:skana_pica/pages/mainscreen.dart';
import 'package:skana_pica/util/leaders.dart';
import 'package:skana_pica/widgets/error_loading.dart';
import 'package:skana_pica/widgets/pica_comic_card.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class PicaComicsPage extends StatefulWidget {
  final String keyword;
  final String type;
  final bool isMain;
  final bool? addToHistory;
  final String? sort;
  final EasyRefreshController? easyRefreshController;

  const PicaComicsPage(
      {super.key,
      this.isMain = false,
      required this.keyword,
      required this.type,
      this.addToHistory,
      this.sort,
      this.easyRefreshController});

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
    ScrollController scrollController = ScrollController();
    try {
      controller = Get.find<ComicListController>(tag: tag);
    } catch (e) {
      controller = Get.put(ComicListController(), tag: tag);
    }
    controller.type.value = widget.type;
    bool author = widget.type == "author";
    return Obx(
      () => !profileController.isLogin.value
          ? ErrorLoading(text: "Not Logged In".tr)
          : Column(
              children: [
                if (appdata.pica[6] == "0")
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
                            controller.init(widget.keyword,
                                isAuthor: author,
                                sort: "dd",
                                addToHistory: widget.addToHistory ?? false,
                                isSearch: widget.type == "search");
                          }
                        },
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      ChoiceChip(
                        selectedColor: Get.theme.primaryColor,
                        label: Text('Old to New'.tr,
                            style: Get.textTheme.bodySmall),
                        selected: controller.sort.value == "da",
                        onSelected: (bool selected) {
                          if (selected) {
                            controller.init(widget.keyword,
                                isAuthor: author,
                                sort: "da",
                                addToHistory: widget.addToHistory ?? false,
                                isSearch: widget.type == "search");
                          }
                        },
                      ),
                      if (widget.keyword != "bookmarks")
                        SizedBox(
                          width: 8,
                        ),
                      if (widget.keyword != "bookmarks")
                        ChoiceChip(
                          selectedColor: Get.theme.primaryColor,
                          label: Text('Most Likes'.tr,
                              style: Get.textTheme.bodySmall),
                          selected: controller.sort.value == "ld",
                          onSelected: (bool selected) {
                            if (selected) {
                              controller.init(widget.keyword,
                                  isAuthor: author,
                                  sort: "ld",
                                  addToHistory: widget.addToHistory ?? false,
                                  isSearch: widget.type == "search");
                            }
                          },
                        ),
                      if (widget.keyword != "bookmarks")
                        SizedBox(
                          width: 8,
                        ),
                      if (widget.keyword != "bookmarks")
                        ChoiceChip(
                          selectedColor: Get.theme.primaryColor,
                          label: Text('Most Viewed'.tr,
                              style: Get.textTheme.bodySmall),
                          selected: controller.sort.value == "vd",
                          onSelected: (bool selected) {
                            if (selected) {
                              controller.init(widget.keyword,
                                  isAuthor: author,
                                  sort: "vd",
                                  addToHistory: widget.addToHistory ?? false,
                                  isSearch: widget.type == "search");
                            }
                          },
                        ),
                    ],
                  ),
                if (appdata.pica[6] == "1")
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      DropdownButton<String>(
                        elevation: 4,
                        style: Get.textTheme.bodyMedium,
                        value: appdata.pica[4],
                        onChanged: (String? newValue) {
                          if (newValue == null) return;
                          controller.init(widget.keyword,
                              isAuthor: author, sort: newValue);
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
                                          widget.isMain
                                              ? globalScrollController
                                                  .animateTo(0,
                                                      duration: const Duration(
                                                          microseconds: 200),
                                                      curve: Curves.ease)
                                              : scrollController.animateTo(0,
                                                  duration: const Duration(
                                                      microseconds: 200),
                                                  curve: Curves.ease);
                                          controller.pageFetch(pageNumber);
                                          Get.back();
                                        } else {
                                          toast('Invalid Page Number'.tr);
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
                                            widget.isMain
                                                ? globalScrollController
                                                    .animateTo(0,
                                                        duration:
                                                            const Duration(
                                                                microseconds:
                                                                    200),
                                                        curve: Curves.ease)
                                                : scrollController.animateTo(0,
                                                    duration: const Duration(
                                                        microseconds: 200),
                                                    curve: Curves.ease);
                                            controller.pageFetch(pageNumber);
                                            Get.back();
                                          } else {
                                            toast('Invalid Page Number'.tr);
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
                              }),
                              style: Get.textTheme.bodyMedium)),
                      TextButton(
                          onPressed: (controller.page.value == 1)
                              ? null
                              : () {
                                  widget.isMain
                                      ? globalScrollController.animateTo(0,
                                          duration:
                                              const Duration(microseconds: 200),
                                          curve: Curves.ease)
                                      : scrollController.animateTo(0,
                                          duration:
                                              const Duration(microseconds: 200),
                                          curve: Curves.ease);
                                  controller
                                      .pageFetch(controller.page.value - 1);
                                },
                          child: Text("Prev Page".tr)),
                      TextButton(
                          onPressed: (controller.page.value ==
                                  controller.total.value)
                              ? null
                              : () {
                                  widget.isMain
                                      ? globalScrollController.animateTo(0,
                                          duration:
                                              const Duration(microseconds: 200),
                                          curve: Curves.ease)
                                      : scrollController.animateTo(0,
                                          duration:
                                              const Duration(microseconds: 200),
                                          curve: Curves.ease);
                                  controller
                                      .pageFetch(controller.page.value + 1);
                                },
                          child: Text("Next Page".tr)),
                    ],
                  ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: EasyRefresh(
                    controller: easyRefreshController,
                    scrollController: widget.isMain
                        ? globalScrollController
                        : scrollController,
                    onLoad: (appdata.pica[6] == "1")
                        ? null
                        : () async {
                            if (controller.page.value ==
                                controller.total.value) {
                              easyRefreshController
                                  .finishLoad(IndicatorResult.noMore);
                              return;
                            }
                            bool res = controller.onLoad();
                            if (res) {
                              easyRefreshController.finishLoad();
                            } else {
                              easyRefreshController
                                  .finishLoad(IndicatorResult.fail);
                            }
                          },
                    onRefresh: () async {
                      bool res;
                      if (controller.keyword.isEmpty ||
                          controller.keyword == "leaderboard") {
                        res = controller.init(widget.keyword,
                            isAuthor: author,
                            sort: widget.sort ?? "",
                            addToHistory: widget.addToHistory ?? false,
                            isSearch: widget.type == "search",
                            type: controller.keyword == "leaderboard"
                                ? leaderboardController.type.value
                                : widget.type);
                      } else {
                        res = controller
                            .reload((appdata.pica[6] == "1") ? false : true);
                      }
                      if (res) {
                        easyRefreshController.finishRefresh();
                      } else {
                        easyRefreshController
                            .finishRefresh(IndicatorResult.fail);
                      }
                    },
                    refreshOnStart: true,
                    child: ListView.builder(
                      controller: widget.isMain
                          ? globalScrollController
                          : scrollController,
                      itemCount: (appdata.pica[6] == "1")
                          ? controller.comics.length + 1
                          : controller.comics.length,
                      itemBuilder: (context, index) {
                        if (index == controller.comics.length) {
                          if ((controller.page.value <
                                  controller.total.value) &&
                              !controller.isLoading.value) {
                            return Center(
                              child: IconButton(
                                  onPressed: () {
                                    widget.isMain
                                        ? globalScrollController.animateTo(0,
                                            duration: const Duration(
                                                microseconds: 200),
                                            curve: Curves.ease)
                                        : scrollController.animateTo(0,
                                            duration: const Duration(
                                                microseconds: 200),
                                            curve: Curves.ease);
                                    controller
                                        .pageFetch(controller.page.value + 1);
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
                          return Container(
                              height: Get.height * 0.8,
                              child: Center(
                                child: Text(
                                  "[ ]",
                                  style: Get.textTheme.displayLarge?.copyWith(
                                      color: Get.theme.colorScheme.onPrimary
                                          .withOpacity(0.7)),
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
                          type: "bookmarks",
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
    );
  }
}
