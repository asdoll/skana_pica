import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skana_pica/api/managers/image_cache_manager.dart';
import 'package:skana_pica/config/setting.dart';
import 'package:skana_pica/pages/setting/setting_page.dart';
import 'package:skana_pica/util/leaders.dart';

class CacheSetting extends StatelessWidget {
  static const route = "${SettingPage.route}/cache";
  const CacheSetting({super.key});

  @override
  Widget build(BuildContext context) {
    CacheController cacheController = Get.put(CacheController());
    return Scaffold(
      appBar: AppBar(
        title: Text('Cache & Restore'.tr),
      ),
      body: Obx(
        () => ListView(
          children: [
            ListTile(
              title: Text('Clear Cache Period'.tr),
              trailing: DropdownButton(
                  items: [
                    DropdownMenuItem(
                      value: '1',
                      child: Text('1 ${"Day".tr}'),
                    ),
                    DropdownMenuItem(
                      value: '3',
                      child: Text('3 ${"Days".tr}'),
                    ),
                    DropdownMenuItem(
                      value: '7',
                      child: Text('7 ${"Days".tr}'),
                    ),
                    DropdownMenuItem(
                      value: '30',
                      child: Text('30 ${"Days".tr}'),
                    ),
                  ],
                  onChanged: (String? value) {
                    if (value != null) {
                      cacheController.setCachePeriod(value);
                    }
                  },
                  value: cacheController.cachePeriod.value),
            ),
            ListTile(
              title: Text('Clear Cache'.tr),
              leading: Icon(Icons.delete),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: Text('Clear Cache'.tr),
                          content: Text('Are you sure to clear cache?'.tr),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: Text('Cancel'.tr),
                            ),
                            TextButton(
                              onPressed: () {
                                cacheController.clearCache();
                                showToast("Cache Cleared".tr);
                                Get.back();
                              },
                              child: Text('Ok'.tr),
                            ),
                          ],
                        ));
              },
            ),
            ListTile(
              title: Text('Restore'.tr),
              leading: Icon(Icons.restore),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: Text('Restore'.tr),
                          content: Obx(() => Wrap(
                                spacing: 3,
                                runSpacing: 3,
                                children: [
                                  ChoiceChip(
                                      label: Text("General Settings".tr),
                                      selected: cacheController.restores[0],
                                      onSelected: (selected) {
                                        cacheController.restores[0] = selected;
                                        cacheController.restores.refresh();
                                      }),
                                  ChoiceChip(
                                      label: Text("Manga Settings".tr),
                                      selected: cacheController.restores[1],
                                      onSelected: (selected) {
                                        cacheController.restores[1] = selected;
                                        cacheController.restores.refresh();
                                      }),
                                  ChoiceChip(
                                      label: Text("Read Settings".tr),
                                      selected: cacheController.restores[2],
                                      onSelected: (selected) {
                                        cacheController.restores[2] = selected;
                                        cacheController.restores.refresh();
                                      }),
                                ],
                              )),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Get.back();
                                cacheController.restores.value = [
                                  false,
                                  false,
                                  false
                                ];
                                cacheController.restores.refresh();
                              },
                              child: Text('Cancel'.tr),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.back();
                                for (int i = 0;
                                    i < cacheController.restores.length;
                                    i++) {
                                  if (cacheController.restores[i]) {
                                    cacheController.restore(
                                        ["general", "pica", "read"][i]);
                                  }
                                }
                                cacheController.restores.value = [
                                  false,
                                  false,
                                  false
                                ];
                                cacheController.restores.refresh();
                                showToast("Restored".tr);
                              },
                              child: Text('Ok'.tr),
                            ),
                          ],
                        ));
              },
            ),
            ListTile(
              title: Text("Initialize App".tr),
              leading: Icon(Icons.warning),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: Text('Initialize App'.tr),
                          content: Text('Are you sure to initialize app?'.tr),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: Text('Cancel'.tr),
                            ),
                            TextButton(
                              onPressed: () {
                                clearAppdata();
                                showToast("App Initialized".tr);
                                Get.back();
                              },
                              child: Text('Ok'.tr),
                            ),
                          ],
                        ));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CacheController extends GetxController {
  RxString cachePeriod = settings.general[7].obs;
  RxList<bool> restores = [false, false, false].obs;

  void setCachePeriod(String period) {
    cachePeriod.value = period;
    settings.general[7] = period;
    settings.updateSettings("general");
  }

  void clearCache() {
    imagesCacheManager.emptyCache();
  }

  void restore(String type) {
    settings.restore(type);
  }
}
