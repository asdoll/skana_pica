import 'package:bootstrap_icons/bootstrap_icons.dart' show BootstrapIcons;
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moon_design/moon_design.dart';
import 'package:skana_pica/config/setting.dart';
import 'package:skana_pica/controller/history.dart';
import 'package:skana_pica/controller/profile.dart';
import 'package:skana_pica/util/leaders.dart';
import 'package:skana_pica/util/widgetplugin.dart';
import 'package:skana_pica/widgets/icons.dart';
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
      floatingActionButton: MoonButton.icon(
        buttonSize: MoonButtonSize.lg,
        showBorder: true,
        borderColor: Get.context?.moonTheme?.buttonTheme.colors.borderColor
            .withValues(alpha: 0.5),
        backgroundColor: Get.context?.moonTheme?.tokens.colors.zeno,
        onTap: () {
          alertDialog(context, 'Clear History'.tr, 'Clear all history?'.tr, [
            outlinedButton(label: 'Cancel'.tr, onPressed: () => Get.back()),
            filledButton(
                label: 'Clear'.tr,
                onPressed: () {
                  controller.removeHistory();
                  Get.back();
                })
          ]);
        },
        icon: Icon(
          BootstrapIcons.trash3,
          color: Colors.white,
        ),
      ),
      body: Obx(
        () => Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: controller.totalPage.value <= 1
                        ? null
                        : () {
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
                                                  int? pageNumber =
                                                      int.tryParse(value);
                                                  if (pageNumber != null &&
                                                      pageNumber >= 0 &&
                                                      pageNumber <
                                                          controller.totalPage
                                                              .value) {
                                                    scrollController.animateTo(
                                                        0,
                                                        duration:
                                                            const Duration(
                                                                microseconds:
                                                                    200),
                                                        curve: Curves.ease);
                                                    controller.toPage(
                                                        index: pageNumber);
                                                    Get.back();
                                                  } else {
                                                    showToast(
                                                        'Invalid Page Number'
                                                            .tr);
                                                  }
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
                                                        int? pageNumber =
                                                            int.tryParse(
                                                                pageJumpController
                                                                    .value
                                                                    .text);
                                                        if (pageNumber !=
                                                                null &&
                                                            pageNumber >= 0 &&
                                                            pageNumber <
                                                                controller
                                                                    .totalPage
                                                                    .value) {
                                                          scrollController.animateTo(
                                                              0,
                                                              duration:
                                                                  const Duration(
                                                                      microseconds:
                                                                          200),
                                                              curve:
                                                                  Curves.ease);
                                                          controller.toPage(
                                                              index:
                                                                  pageNumber);
                                                          Get.back();
                                                        } else {
                                                          showToast(
                                                              'Invalid Page Number'
                                                                  .tr);
                                                        }
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
                      'page': (controller.page.value + 1).toString(),
                      'total': controller.totalPage.toString()
                    })).subHeader()),
                Expanded(child: SizedBox()),
                filledButton(
                  color: context.moonTheme?.tokens.colors.cell60,
                  label: "Prev Page".tr,
                  applyDarkMode: true,
                  onPressed: (controller.page.value <= 1)
                      ? null
                      : () {
                          scrollController.animateTo(0,
                              duration: const Duration(microseconds: 200),
                              curve: Curves.ease);
                          controller.toPage(index: controller.page.value - 1);
                        },
                ),
                SizedBox(width: 4),
                filledButton(
                  color: context.moonTheme?.tokens.colors.cell60,
                  label: "Next Page".tr,
                  applyDarkMode: true,
                  onPressed: (controller.page.value + 1 >=
                          controller.totalPage.value)
                      ? null
                      : () {
                          scrollController.animateTo(0,
                              duration: const Duration(microseconds: 200),
                              curve: Curves.ease);
                          controller.toPage(index: controller.page.value + 1);
                        },
                ),
                SizedBox(width: 16),
              ],
            ),
            SizedBox(
              height: 4,
            ),
            Expanded(
              child: EasyRefresh(
                header: DefaultHeaderFooter.header(context),
                footer: DefaultHeaderFooter.footer(context),
                refreshOnStartHeader:
                    DefaultHeaderFooter.refreshHeader(context),
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
                    if (!profileController.isLogin.value) {
                      return InkWell(
                        onTap: () => showToast("Not Logged In".tr),
                        child: IgnorePointer(
                          child: PicaComicCard(
                            controller.comics[index],
                            type: "history",
                          ),
                        ),
                      );
                    }
                    return PicaComicCard(controller.comics[index],
                        type: "history");
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
