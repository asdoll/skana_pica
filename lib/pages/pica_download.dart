import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moon_design/moon_design.dart';
import 'package:skana_pica/controller/downloadstore.dart';
import 'package:skana_pica/util/leaders.dart';
import 'package:skana_pica/util/widgetplugin.dart';
import 'package:skana_pica/widgets/pica_download_card.dart';

class PicaDownloadPage extends StatefulWidget {
  static const route = "/pica_download";
  const PicaDownloadPage({super.key});

  @override
  State<PicaDownloadPage> createState() => _PicaDownloadPageState();
}

class _PicaDownloadPageState extends State<PicaDownloadPage> {
  @override
  Widget build(BuildContext context) {
    DownloadPageController dc = Get.put(DownloadPageController());
    TextEditingController pageJumpController = TextEditingController();
    ScrollController scrollController = ScrollController();

    return Obx(
      () => Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: downloadStore.tasks.length <= 20
                      ? null
                      : () {
                          showMoonModal(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                    child:
                                        ListView(shrinkWrap: true, children: [
                                  MoonAlert(
                                      borderColor: Get.context?.moonTheme
                                          ?.buttonTheme.colors.borderColor
                                          .withValues(alpha: 0.5),
                                      showBorder: true,
                                      label: Text('Jump to Page'.tr).header(),
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
                                                    int.tryParse(value)! < 1 ||
                                                    int.tryParse(value)! >
                                                        (downloadStore.tasks
                                                                    .length /
                                                                dc.perPage)
                                                            .ceil()) {
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
                                                        (downloadStore.tasks
                                                                    .length /
                                                                dc.perPage)
                                                            .ceil()) {
                                                  scrollController.animateTo(0,
                                                      duration: const Duration(
                                                          microseconds: 200),
                                                      curve: Curves.ease);
                                                  dc.page.value = pageNumber;
                                                  Get.back();
                                                } else {
                                                  showToast(
                                                      'Invalid Page Number'.tr);
                                                }
                                              },
                                            ),
                                            SizedBox(height: 16),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                outlinedButton(
                                                  label: 'Cancel'.tr,
                                                  onPressed: () {
                                                    Get.back();
                                                  },
                                                ),
                                                SizedBox(width: 8),
                                                filledButton(
                                                    label: 'OK'.tr,
                                                    onPressed: () {
                                                      int? pageNumber =
                                                          int.tryParse(
                                                              pageJumpController
                                                                  .value.text);
                                                      if (pageNumber != null &&
                                                          pageNumber >= 0 &&
                                                          pageNumber <
                                                              (downloadStore
                                                                          .tasks
                                                                          .length /
                                                                      dc.perPage)
                                                                  .ceil()) {
                                                        scrollController.animateTo(
                                                            0,
                                                            duration:
                                                                const Duration(
                                                                    microseconds:
                                                                        200),
                                                            curve: Curves.ease);
                                                        dc.page.value =
                                                            pageNumber;
                                                        Get.back();
                                                      } else {
                                                        showToast(
                                                            'Invalid Page Number'
                                                                .tr);
                                                      }
                                                    }),
                                              ],
                                            )
                                          ]))
                                ]));
                              });
                        },
                  child: Text('at_page'.trParams({
                    'page': (dc.page.value + 1).toString(),
                    'total': (downloadStore.tasks.length / dc.perPage)
                        .ceil()
                        .toString()
                  })).subHeader()),
              Expanded(child: SizedBox()),
              filledButton(
                color: context.moonTheme?.tokens.colors.cell60,
                label: "Prev Page".tr,
                applyDarkMode: true,
                onPressed: (dc.page.value == 0)
                    ? null
                    : () {
                        scrollController.animateTo(0,
                            duration: const Duration(microseconds: 200),
                            curve: Curves.ease);
                        dc.page.value--;
                      },
              ),
              SizedBox(width: 4),
              filledButton(
                color: context.moonTheme?.tokens.colors.cell60,
                label: "Next Page".tr,
                applyDarkMode: true,
                onPressed: (dc.page.value ==
                        (downloadStore.tasks.length ~/ dc.perPage))
                    ? null
                    : () {
                        scrollController.animateTo(0,
                            duration: const Duration(microseconds: 200),
                            curve: Curves.ease);
                        dc.page.value++;
                      },
              ),
              SizedBox(width: 16),
            ],
          ),
          SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
                itemBuilder: (context, index) {
                  return DownloadComicCard(
                      downloadStore.tasks[index + dc.page.value * dc.perPage]);
                },
                itemCount: min(dc.perPage,
                    downloadStore.tasks.length - dc.page.value * dc.perPage),
                controller: scrollController),
          ),
        ],
      ),
    );
  }
}
