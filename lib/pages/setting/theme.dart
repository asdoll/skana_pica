import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:skana_pica/config/setting.dart';
import 'package:skana_pica/pages/me_page.dart';
import 'package:skana_pica/pages/setting/setting_page.dart';
import 'package:skana_pica/util/log.dart';
import 'package:skana_pica/util/theme.dart';
import 'package:skana_pica/util/widget_utils.dart';

class AppearancePage extends StatefulWidget {
  static const route = "${SettingPage.route}/appearance";
  const AppearancePage({super.key});

  @override
  State<AppearancePage> createState() => _AppearancePageState();
}

class _AppearancePageState extends State<AppearancePage> {
  late DarkModeController darkModeController;
  late FRadioSelectGroupController<int> controller;
  late FRadioSelectGroupController<int> darkController;

  @override
  void initState() {
    super.initState();
    controller =
        FRadioSelectGroupController<int>(value: appdata.appSettings.theme);
    controller.addListener(() {
      changeTheme(controller.values.first);
    });
    darkController =
        FRadioSelectGroupController<int>(value: appdata.appSettings.darkMode);
    try {
      darkModeController = Get.find();
    } catch (e) {
      darkModeController = Get.put(DarkModeController());
    }
    darkController.addListener(() {
      changeColor(darkController.values.first);
      darkModeController.fallback();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    darkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader.nested(
        title: Text("Appearance".tr),
        prefixActions: [
          FHeaderAction.back(onPress: () => Get.back()),
        ],
      ),
      content: FTileGroup(children: [
        FSelectMenuTile(
          groupController: controller,
          autoHide: true,
          validator: (value) => value == null ? 'Select an item'.tr : null,
          prefixIcon: FIcon(FAssets.icons.palette),
          title: Text('Color Theme'.tr),
          details: ListenableBuilder(
            listenable: controller,
            builder: (context, _) => Text(
              ThemeManager.themeName[controller.values.firstOrNull ?? 0].tr,
            ),
          ),
          menu: _buildThemeList(context),
        ),
        FSelectMenuTile(
          groupController: darkController,
          autoHide: true,
          validator: (value) => value == null ? 'Select an item'.tr : null,
          prefixIcon: FIcon(FAssets.icons.palette),
          title: Text('Dark Mode'.tr),
          details: ListenableBuilder(
            listenable: darkController,
            builder: (context, _) => Text(
              switch (darkController.values.firstOrNull) {
                null || 0 => 'Follow System'.tr,
                1 => 'Light'.tr,
                2 => 'Dark'.tr,
                _ => 'Follow System'.tr,
              },
            ),
          ),
          menu: [
            FSelectTile(title: Text('Follow System'.tr), value: 0),
            FSelectTile(title: Text('Light'.tr), value: 1),
            FSelectTile(title: Text('Dark'.tr), value: 2),
          ],
        )
      ]).paddingTop(20),
    );
  }

  List<FSelectTile> _buildThemeList(context) {
    List<FSelectTile> list = [];
    for (int i = 0; i < ThemeManager.themeName.length; i++) {
      list.add(
          FSelectTile(title: Text(ThemeManager.themeName[i].tr), value: i));
    }
    return list;
  }

  void changeTheme(int index) {
    appdata.appSettings.theme = index;
    ThemeManager.instance.updateTheme();
  }

  void changeColor(int first) {
    appdata.appSettings.darkMode = first;
    darkModeController.setSystemMode(first);
  }
}
