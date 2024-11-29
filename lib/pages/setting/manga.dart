import 'package:flutter/material.dart';
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
  late AutoCheckInController autoCheckInController;

  @override
  void initState() {
    super.initState();
    autoCheckInController = Get.put(AutoCheckInController());
  }

  @override
  void dispose() {
    super.dispose();
    Get.delete<AutoCheckInController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manga sources".tr),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          _buildPica(context).padding(EdgeInsets.only(top: 20)),
        ],
      ),
    );
  }

  Widget _buildPica(BuildContext context) {
    return ListTileTheme(
      contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Picacg".tr),
          ListTile(
            leading: Icon(Icons.compare_arrows),
            title: Text("Set stream".tr),
            trailing: DropdownButton<int>(
              value: int.parse(appdata.pica[0]),
              items: [
                DropdownMenuItem(value: 0, child: Text('Stream 1'.tr)),
                DropdownMenuItem(value: 1, child: Text('Stream 2'.tr)),
                DropdownMenuItem(value: 2, child: Text('Stream 3'.tr)),
              ],
              onChanged: (value) {
                if (value != null) {
                  appdata.pica[0] = value.toString();
                  appdata.updateSettings("pica");
                  picacg.data['appChannel'] = (value + 1).toString();
                }
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.image),
            title: Text("Set image quality".tr),
            trailing: DropdownButton<String>(
              value: appdata.picaImageQuality,
              items: [
                DropdownMenuItem(value: 'low', child: Text('Low'.tr)),
                DropdownMenuItem(value: 'medium', child: Text('Medium'.tr)),
                DropdownMenuItem(value: 'high', child: Text('High'.tr)),
                DropdownMenuItem(
                    value: 'original', child: Text('Original image'.tr)),
              ],
              onChanged: (value) {
                if (value != null) {
                  appdata.picaImageQuality = value;
                  picacg.data['imageQuality'] = value;
                }
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.search),
            title: Text("Set search and category sorting mode".tr),
            trailing: DropdownButton<int>(
              value: appdata.picaSearchMode,
              items: [
                DropdownMenuItem(value: 0, child: Text('New to Old'.tr)),
                DropdownMenuItem(value: 1, child: Text('Old to New'.tr)),
                DropdownMenuItem(value: 2, child: Text('Most Likes'.tr)),
                DropdownMenuItem(value: 3, child: Text('Most Viewed'.tr)),
              ],
              onChanged: (value) {
                if (value != null) {
                  appdata.picaSearchMode = value;
                }
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.view_agenda_outlined),
            title: Text("Set page view mode".tr),
            trailing: DropdownButton<String>(
              value: appdata.pica[6],
              items: [
                DropdownMenuItem(value: "0", child: Text('Infinite Scroll'.tr)),
                DropdownMenuItem(value: "1", child: Text('Page View'.tr)),
              ],
              onChanged: (value) {
                if (value != null) {
                  appdata.pica[6] = value;
                  appdata.updateSettings("pica");
                }
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text("Auto check-in".tr),
            trailing: Obx(() {
              return Switch(
                value: autoCheckInController.autoCheckIn.value,
                onChanged: (value) {
                  autoCheckInController.toggleAutoCheckIn();
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

class AutoCheckInController extends GetxController {
  final autoCheckIn = (appdata.pica[2] == "1").obs;
  void toggleAutoCheckIn() {
    autoCheckIn.value = !autoCheckIn.value;
    appdata.pica[2] = autoCheckIn.value ? "1" : "0";
    appdata.updateSettings("pica");
  }
}
