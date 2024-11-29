import 'package:bot_toast/bot_toast.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skana_pica/config/setting.dart';
import 'package:skana_pica/controller/comiclist.dart';
import 'package:skana_pica/pages/mainscreen.dart';
import 'package:skana_pica/widgets/pica_comic_card.dart';

class PicaComicsPage extends StatefulWidget {
  final String keyword;
  final String type;
  final bool isMain;

  const PicaComicsPage(
      {super.key,
      this.isMain = false,
      required this.keyword,
      required this.type});

  @override
  State<PicaComicsPage> createState() => _PicaComicsPageState();
}

class _PicaComicsPageState extends State<PicaComicsPage> {
  @override
  Widget build(BuildContext context) {
    String tag = "${widget.type}_${widget.keyword}";
    ComicListController controller;
    TextEditingController pageJumpController = TextEditingController();
    EasyRefreshController easyRefreshController = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );
    try {
      controller = Get.find<ComicListController>(tag: tag);
    } catch (e) {
      controller = Get.put(ComicListController(), tag: tag);
    }
    bool author = widget.type == "author";
    return Obx(
      () => Column(
        children: [
          if (appdata.pica[6] == "0")
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ChoiceChip(
                  selectedColor: Get.theme.primaryColor,
                  labelPadding: EdgeInsets.all(2.0),
                  label: Text('New to Old'.tr, style: Get.textTheme.bodySmall),
                  selected: controller.sort.value == "dd",
                  onSelected: (bool selected) {
                    if (selected) {
                      controller.init(widget.keyword,
                          isAuthor: author, sort: "dd");
                    }
                  },
                ),
                ChoiceChip(
                  selectedColor: Get.theme.primaryColor,
                  label: Text('Old to New'.tr, style: Get.textTheme.bodySmall),
                  selected: controller.sort.value == "da",
                  onSelected: (bool selected) {
                    if (selected) {
                      controller.init(widget.keyword,
                          isAuthor: author, sort: "da");
                    }
                  },
                ),
                ChoiceChip(
                  selectedColor: Get.theme.primaryColor,
                  label: Text('Most Likes'.tr, style: Get.textTheme.bodySmall),
                  selected: controller.sort.value == "ld",
                  onSelected: (bool selected) {
                    if (selected) {
                      controller.init(widget.keyword,
                          isAuthor: author, sort: "ld");
                    }
                  },
                ),
                ChoiceChip(
                  selectedColor: Get.theme.primaryColor,
                  label: Text('Most Viewed'.tr, style: Get.textTheme.bodySmall),
                  selected: controller.sort.value == "vd",
                  onSelected: (bool selected) {
                    if (selected) {
                      controller.init(widget.keyword,
                          isAuthor: author, sort: "vd");
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
                    DropdownMenuItem(value: "dd", child: Text('New to Old'.tr)),
                    DropdownMenuItem(value: "da", child: Text('Old to New'.tr)),
                    DropdownMenuItem(value: "ld", child: Text('Most Likes'.tr)),
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
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    labelText: 'Page Number'.tr),
                                onSubmitted: (value) {
                                  int? pageNumber = int.tryParse(value);
                                  if (pageNumber != null &&
                                      pageNumber > 0 &&
                                      pageNumber <= controller.total.value) {
                                    controller.pageFetch(pageNumber);
                                    Get.back();
                                  } else {
                                    BotToast.showText(
                                        text: 'Invalid Page Number'.tr);
                                  }
                                },
                              ),
                              actions: [
                                FilledButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: Text('Cancel'.tr),
                                ),
                                FilledButton(
                                  onPressed: () {
                                    int? pageNumber = int.tryParse(
                                        pageJumpController.value.text);
                                    if (pageNumber != null &&
                                        pageNumber > 0 &&
                                        pageNumber <= controller.total.value) {
                                      controller.pageFetch(pageNumber);
                                      Get.back();
                                    } else {
                                      BotToast.showText(
                                          text: 'Invalid Page Number'.tr);
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
                        : () => controller.pageFetch(controller.page.value - 1),
                    child: Text("Prev Page".tr)),
                TextButton(
                    onPressed: (controller.page.value == controller.total.value)
                        ? null
                        : () => controller.pageFetch(controller.page.value + 1),
                    child: Text("Next Page".tr)),
              ],
            ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: EasyRefresh(
              controller: easyRefreshController,
              scrollController: widget.isMain ? globalScrollController : null,
              onLoad: (appdata.pica[6] == "1")
                  ? null
                  : () async {
                      if (controller.page.value == controller.total.value) {
                        easyRefreshController
                            .finishLoad(IndicatorResult.noMore);
                        return;
                      }
                      bool res = controller.onLoad();
                      if (res) {
                        easyRefreshController.finishLoad();
                      } else {
                        easyRefreshController.finishLoad(IndicatorResult.fail);
                      }
                    },
              onRefresh: () async {
                bool res;
                if (controller.keyword.isEmpty) {
                  res = controller.init(widget.keyword, isAuthor: author);
                } else {
                  res = controller
                      .reload((appdata.pica[6] == "1") ? false : true);
                }
                if (res) {
                  easyRefreshController.finishRefresh();
                } else {
                  easyRefreshController.finishRefresh(IndicatorResult.fail);
                }
              },
              refreshOnStart: true,
              child: ListView.builder(
                controller: widget.isMain ? globalScrollController : null,
                itemCount: (appdata.pica[6] == "1")
                    ? controller.comics.length + 1
                    : controller.comics.length,
                itemBuilder: (context, index) {
                  if (index == controller.comics.length &&
                      (controller.page.value < controller.total.value)) {
                    return Center(
                      child: TextButton(
                          onPressed: () =>
                              controller.pageFetch(controller.page.value + 1),
                          child: Text("Next Page".tr,
                              style: TextStyle(
                                  fontSize:
                                      Get.textTheme.titleLarge!.fontSize))),
                    );
                  }
                  if (controller.comics.isEmpty) {
                    return Container();
                  }
                  return PicaComicCard(
                    controller.comics[index],
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
