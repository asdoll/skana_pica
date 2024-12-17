import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:skana_pica/controller/downloadstore.dart';
import 'package:skana_pica/util/leaders.dart';
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
    DownloadPageController dc = DownloadPageController();
    TextEditingController pageJumpController = TextEditingController();
    ScrollController scrollController = ScrollController();

    return Scaffold(
      appBar: AppBar(
        title: Text("My Downloads".tr),
      ),
      body: Obx(() => Column(
            children: [
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
                                            (downloadStore.tasks.length /
                                                    dc.perPage)
                                                .ceil()) {
                                      scrollController.animateTo(0,
                                          duration:
                                              const Duration(microseconds: 200),
                                          curve: Curves.ease);
                                      dc.page.value = pageNumber;
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
                                          pageNumber >= 0 &&
                                          pageNumber <
                                              (downloadStore.tasks.length /
                                                      dc.perPage)
                                                  .ceil()) {
                                        scrollController.animateTo(0,
                                            duration: const Duration(
                                                microseconds: 200),
                                            curve: Curves.ease);
                                        dc.page.value = pageNumber;
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
                            'page': (dc.page.value + 1).toString(),
                            'total': (downloadStore.tasks.length / dc.perPage)
                                .ceil()
                                .toString()
                          }),
                          style: Get.textTheme.bodyMedium)),
                  TextButton(
                      onPressed: (dc.page.value == 0)
                          ? null
                          : () {
                              scrollController.animateTo(0,
                                  duration: const Duration(microseconds: 200),
                                  curve: Curves.ease);
                              dc.page.value--;
                            },
                      child: Text("Prev Page".tr)),
                  TextButton(
                      onPressed: (dc.page.value ==
                              (downloadStore.tasks.length ~/ dc.perPage))
                          ? null
                          : () {
                              scrollController.animateTo(0,
                                  duration: const Duration(microseconds: 200),
                                  curve: Curves.ease);
                              dc.page.value++;
                            },
                      child: Text("Next Page".tr)),
                ],
              ),
              SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                    itemBuilder: (context, index) {
                      return Slidable(
                        startActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            extentRatio: 0.2,
                            children: [
                              SlidableAction(
                                backgroundColor: Colors.blue,
                                icon: Icons.download,
                                borderRadius: BorderRadius.circular(8),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                onPressed: (context) {
                                  downloadStore.continueTask(downloadStore
                                      .tasks[index + dc.page.value * dc.perPage]
                                      .id);
                                },
                              ),
                            ]),
                        endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            extentRatio: 0.2,
                            children: [
                              SlidableAction(
                                backgroundColor: Colors.red,
                                icon: Icons.delete,
                                borderRadius: BorderRadius.circular(8),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                onPressed: (context) {
                                  downloadStore.stopTask(downloadStore
                                      .tasks[index + dc.page.value * dc.perPage]
                                      .id);
                                },
                              ),
                            ]),
                        child: DownloadComicCard(downloadStore
                            .tasks[index + dc.page.value * dc.perPage]),
                      );
                    },
                    itemCount: min(
                        dc.perPage,
                        downloadStore.tasks.length -
                            dc.page.value * dc.perPage),
                    controller: scrollController),
              ),
            ],
          )),
    );
  }
}
