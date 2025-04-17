import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skana_pica/config/setting.dart';
import 'package:skana_pica/controller/history.dart';
import 'package:skana_pica/controller/profile.dart';
import 'package:skana_pica/util/leaders.dart';
import 'package:skana_pica/widgets/pica_comic_card.dart';

import '../controller/setting_controller.dart';

class PicaHistoryPage extends StatefulWidget {
  const PicaHistoryPage({super.key});

  @override
  State<PicaHistoryPage> createState() => _PicaHistoryPageState();
}

class _PicaHistoryPageState extends State<PicaHistoryPage> {
  @override
  Widget build(BuildContext context) {
    HistoryController controller = Get.put(HistoryController());
    TextEditingController pageJumpController = TextEditingController();
    EasyRefreshController easyRefreshController = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );
    ScrollController scrollController = ScrollController();

    return Scaffold(
      appBar: AppBar(
        title: Text("My History".tr),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Clear History'.tr),
                      content: Text('Clear all history?'.tr),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: Text('Cancel'.tr),
                        ),
                        TextButton(
                          onPressed: () {
                            controller.removeHistory();
                            Get.back();
                          },
                          child: Text('Clear'.tr),
                        ),
                      ],
                    );
                  });
            },
          ),
        ],
      ),
      body: Obx(
        () => Column(
          children: [
            if (mangaSettingsController.picaPageViewMode.value)
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
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
                                        pageNumber >= 0 &&
                                        pageNumber <
                                            controller.totalPage.value) {
                                      scrollController.animateTo(0,
                                          duration:
                                              const Duration(microseconds: 200),
                                          curve: Curves.ease);
                                      controller.toPage(index: pageNumber);
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
                                          pageNumber >= 0 &&
                                          pageNumber <
                                              controller.totalPage.value) {
                                        scrollController.animateTo(0,
                                            duration: const Duration(
                                                microseconds: 200),
                                            curve: Curves.ease);
                                        controller.toPage(index: pageNumber);
                                        Get.back();
                                      } else {
                                        showToast('Invalid Page Number'.tr);
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
                            'page': (controller.page.value + 1).toString(),
                            'total': controller.totalPage.toString()
                          }),
                          style: Get.textTheme.bodyMedium)),
                  TextButton(
                      onPressed: (controller.page.value == 0)
                          ? null
                          : () {
                              scrollController.animateTo(0,
                                  duration: const Duration(microseconds: 200),
                                  curve: Curves.ease);
                              controller.toPage(
                                  index: controller.page.value - 1);
                            },
                      child: Text("Prev Page".tr)),
                  TextButton(
                      onPressed: (controller.page.value ==
                              controller.totalPage.value - 1)
                          ? null
                          : () {
                              scrollController.animateTo(0,
                                  duration: const Duration(microseconds: 200),
                                  curve: Curves.ease);
                              controller.toPage(
                                  index: controller.page.value + 1);
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
                scrollController: scrollController,
                onLoad: (mangaSettingsController.picaPageViewMode.value)
                    ? null
                    : () async {
                        if (controller.page.value ==
                            controller.totalPage.value - 1) {
                          easyRefreshController
                              .finishLoad(IndicatorResult.noMore);
                          return;
                        }
                        controller.toPage().then((value) {
                          if (value) {
                            easyRefreshController.finishLoad();
                          } else {
                            easyRefreshController
                                .finishLoad(IndicatorResult.fail);
                          }
                        });
                      },
                onRefresh: () async {
                  if (controller.history.isEmpty) {
                    controller
                        .init(isList: settings.pica[6] == "1")
                        .then((value) {
                      if (value) {
                        easyRefreshController.finishRefresh();
                      } else {
                        easyRefreshController
                            .finishRefresh(IndicatorResult.fail);
                      }
                    });
                  } else {
                    controller
                        .toPage(index: controller.page.value)
                        .then((value) {
                      if (value) {
                        easyRefreshController.finishRefresh();
                      } else {
                        easyRefreshController
                            .finishRefresh(IndicatorResult.fail);
                      }
                    });
                  }
                },
                refreshOnStart: true,
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: (settings.pica[6] == "1")
                      ? controller.comics.length + 1
                      : controller.comics.length,
                  itemBuilder: (context, index) {
                    if (index == controller.comics.length) {
                      if ((controller.page.value + 1 <
                              controller.totalPage.value) &&
                          !controller.isLoading.value) {
                        return Center(
                          child: IconButton(
                              onPressed: () {
                                scrollController.animateTo(0,
                                    duration: const Duration(microseconds: 200),
                                    curve: Curves.ease);
                                controller.toPage(
                                    index: controller.page.value + 1);
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
                              style: Get.textTheme.displayLarge?.copyWith(
                                  color: Get.theme.colorScheme.onPrimary
                                      .withValues(alpha: 0.7)),
                            ),
                          ));
                    }
                    if(!profileController.isLogin.value){
                      return InkWell(
                        onTap: () => showToast("Not Logged In".tr),
                        child: IgnorePointer(
                          child: PicaComicCard(controller.comics[index],type: "history",),
                        ),
                      );
                    }
                    return PicaComicCard(controller.comics[index],type: "history");
                  },
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
