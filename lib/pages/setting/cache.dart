import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moon_design/moon_design.dart';
import 'package:skana_pica/config/setting.dart';
import 'package:skana_pica/controller/setting_controller.dart';
import 'package:skana_pica/pages/setting/setting_page.dart';
import 'package:skana_pica/util/leaders.dart';
import 'package:skana_pica/util/widgetplugin.dart';

class CacheSetting extends StatelessWidget {
  static const route = "${SettingPage.route}/cache";
  const CacheSetting({super.key});

  @override
  Widget build(BuildContext context) {
    CacheController cacheController = Get.put(CacheController());
    return Scaffold(
      appBar: appBar(
        title: "Cache & Restore".tr,
      ),
      body: Obx(
        () => ListView(
          children: [
            moonListTile(
              title: "Clear Cache Period".tr,
              trailing: MoonDropdown(
                show: cacheController.cacheMenu.value,
                onTapOutside: () => cacheController.cacheMenu.value = false,
                content: Column(
                  children: [
                    MoonMenuItem(
                      onTap: () {
                        cacheController.cacheMenu.value = false;
                        cacheController.setCachePeriod("1");
                      },
                      label: Text('1 ${"Day".tr}'),
                    ),
                    MoonMenuItem(
                      onTap: () {
                        cacheController.cacheMenu.value = false;
                        cacheController.setCachePeriod("3");
                      },
                      label: Text('3 ${"Days".tr}'),
                    ),
                    MoonMenuItem(
                      onTap: () {
                        cacheController.cacheMenu.value = false;
                        cacheController.setCachePeriod("7");
                      },
                      label: Text('7 ${"Days".tr}'),
                    ),
                    MoonMenuItem(
                      onTap: () {
                        cacheController.cacheMenu.value = false;
                        cacheController.setCachePeriod("30");
                      },
                      label: Text('30 ${"Days".tr}'),
                    ),
                  ],
                ),
                child: filledButton(
                  label: "${cacheController.cachePeriod.value} ${"Days".tr}",
                  onPressed: () => cacheController.cacheMenu.value =
                      !cacheController.cacheMenu.value,
                ),
              ),
            ),
            moonListTile(
              title: "Clear Cache".tr,
              leading: Icon(BootstrapIcons.trash3),
              onTap: () {
                alertDialog(context, "Clear Cache".tr,
                    "Are you sure to clear cache?".tr, [
                  outlinedButton(
                      onPressed: () => Get.back(), label: "Cancel".tr),
                  filledButton(
                      onPressed: () {
                        cacheController.clearCache();
                        showToast("Cache Cleared".tr);
                        Get.back();
                      },
                      label: "Ok".tr)
                ]);
              },
            ),
            moonListTile(
              title: "Restore Settings".tr,
              leading: Icon(BootstrapIcons.clock_history),
              onTap: () {
                alertDialog(context, "Restore Settings".tr,
                    "Are you sure to restore settings?".tr, [
                  outlinedButton(
                      onPressed: () => Get.back(), label: "Cancel".tr),
                  filledButton(
                      onPressed: () {
                        cacheController.restore("general");
                        cacheController.restore("pica");
                        cacheController.restore("read");
                        showToast("Restored".tr);
                        Get.back();
                      },
                      label: "Ok".tr)
                ]);
              },
            ),
            moonListTile(
              title: "Initialize App".tr,
              leading: Icon(BootstrapIcons.exclamation_circle),
              onTap: () {
                alertDialog(context, "Initialize App".tr,
                    "Are you sure to initialize app?".tr, [
                  outlinedButton(
                      onPressed: () => Get.back(), label: "Cancel".tr),
                  filledButton(
                      onPressed: () {
                        clearAppdata();
                        showToast("App Initialized".tr);
                        Get.back();
                      },
                      label: "Ok".tr)
                ]);
              },
            ),
          ],
        ),
      ),
    );
  }
}
