import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:skana_pica/api/comic_sources/picacg/pica_source.dart';
import 'package:skana_pica/config/setting.dart';
import 'package:skana_pica/pages/setting/setting_page.dart';
import 'package:skana_pica/util/widget_utils.dart';

class MangaSettingPage extends StatefulWidget {
  static const route = "${SettingPage.route}/manga";
  const MangaSettingPage({super.key});

  @override
  State<MangaSettingPage> createState() => _MangaSettingPageState();
}

class _MangaSettingPageState extends State<MangaSettingPage> {
  late FRadioSelectGroupController<int> picaStreamController;
  late FRadioSelectGroupController<String> picaImageQualityController;
  late FRadioSelectGroupController<int> picaSearchController;
  late AutoCheckInController autoCheckInController;

  @override
  void initState() {
    super.initState();
    picaInit();
  }

  @override
  void dispose() {
    picaStreamController.dispose();
    picaImageQualityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader.nested(
        title: Text("Manga sources".tr),
        prefixActions: [
          FHeaderAction.back(onPress: () => Get.back()),
        ],
      ),
      content: Column(
        children: [
          _buildPica(context).paddingTop(20),
        ],
      ),
    );
  }

  FTileGroup _buildPica(BuildContext context) {
    return FTileGroup(
      label: Text("Picacg".tr),
      children: [
      FSelectMenuTile(
        groupController: picaStreamController,
        autoHide: true,
        validator: (value) => value == null ? 'Select an item'.tr : null,
        prefixIcon: FIcon(FAssets.icons.gitCompareArrows),
        title: Text("Set stream".tr),
        details: ListenableBuilder(
          listenable: picaStreamController,
          builder: (context, _) => Text(
              switch (picaStreamController.values.firstOrNull) {
              0 => 'Stream 1'.tr,
              1 => 'Stream 2'.tr,
              null || 2 => 'Stream 3'.tr,
              _ => 'Stream 3'.tr,
            },
          ),
        ),
        menu: [
          FSelectTile(title: Text('Stream 1'.tr), value: 0),
          FSelectTile(title: Text('Stream 2'.tr), value: 1),
          FSelectTile(title: Text('Stream 3'.tr), value: 2),
        ],
      ),
      FSelectMenuTile(
        groupController: picaImageQualityController,
        autoHide: true,
        validator: (value) => value == null ? 'Select an item'.tr : null,
        prefixIcon: FIcon(FAssets.icons.image),
        title: Text("Set image quality".tr),
        details: ListenableBuilder(
          listenable: picaImageQualityController,
          builder: (context, _) => Text(
            switch (picaImageQualityController.values.firstOrNull) {
              null || "original" => "Original image".tr,
              "low" => 'Low'.tr,
              "medium" => 'Medium'.tr,
              "high" => 'High'.tr,
              _ => 'Original image'.tr,
            },
          ),
        ),
        menu: [
          FSelectTile(title: Text('Low'.tr), value: 'low'),
          FSelectTile(title: Text('Medium'.tr), value: 'medium'),
          FSelectTile(title: Text('High'.tr), value: 'high'),
          FSelectTile(title: Text('Original image'.tr), value: 'original'),
        ],
      ),
            FSelectMenuTile(
        groupController: picaSearchController,
        autoHide: true,
        validator: (value) => value == null ? 'Select an item'.tr : null,
        prefixIcon: FIcon(FAssets.icons.scanSearch),
        title: Text("Set search and category sorting mode".tr),
        details: ListenableBuilder(
          listenable: picaSearchController,
          builder: (context, _) => Text(
            switch (picaSearchController.values.firstOrNull) {
              0 => 'New to Old'.tr,
              1 => 'Old to New'.tr,
              2 => "Most Likes".tr,
              3 => "Most Viewed".tr,
              null || _ => 'New to Old'.tr,
            },
          ),
        ),
        menu: [
          FSelectTile(title: Text('New to Old'.tr), value: 0),
          FSelectTile(title: Text('Old to New'.tr), value: 1),
          FSelectTile(title: Text('Most Likes'.tr), value: 2),
          FSelectTile(title: Text('Most Viewed'.tr), value: 3),
        ],
      ),
      
      FTile(
        prefixIcon: FIcon(FAssets.icons.calendar),
        title: Text("Auto check-in".tr),
        suffixIcon: Obx((){return FSwitch(
                      value: autoCheckInController.autoCheckIn.value,
                      onChange: (value) {
                        autoCheckInController.toggleAutoCheckIn();
                      },
                    );}),
        onPress: () {
        },
      ),
    ]);
  }
  void picaInit() {
    picaStreamController = FRadioSelectGroupController<int>(value:int.parse(appdata.settings[3]));
    picaStreamController.addListener(() {
      if(picaStreamController.values.firstOrNull == null) return;
      appdata.settings[3] = picaStreamController.values.first.toString();
      appdata.updateSettings();
      picacg.data['appChannel'] = (picaStreamController.values.first + 1).toString();
    });
    picaImageQualityController = FRadioSelectGroupController<String>(value: appdata.appSettings.imageQuality);
    picaImageQualityController.addListener(() {
      if(picaImageQualityController.values.firstOrNull == null) return;
      appdata.appSettings.imageQuality = picaImageQualityController.values.first;
      picacg.data['imageQuality'] = picaImageQualityController.values.first;
    });
    picaSearchController = FRadioSelectGroupController<int>(value: appdata.getSearchMode());
    picaSearchController.addListener(() {
      if(picaSearchController.values.firstOrNull == null) return;
      appdata.setSearchMode(picaSearchController.values.first);
    });
    autoCheckInController = AutoCheckInController();
  }

}

class AutoCheckInController extends GetxController {
  final autoCheckIn = (appdata.settings[6] == "1").obs;
  void toggleAutoCheckIn() {
    autoCheckIn.value = !autoCheckIn.value;
    appdata.settings[6] = autoCheckIn.value ? "1" : "0";
    appdata.updateSettings();
  }
}