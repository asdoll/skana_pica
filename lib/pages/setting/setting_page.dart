import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skana_pica/config/setting.dart';
import 'package:skana_pica/pages/mainscreen.dart';
import 'package:skana_pica/pages/setting/account.dart';
import 'package:skana_pica/pages/setting/manga.dart';
import 'package:skana_pica/pages/setting/theme.dart';
import 'package:skana_pica/util/leaders.dart';
import 'package:skana_pica/util/tool.dart';
import 'package:skana_pica/util/widget_utils.dart';

class SettingPage extends StatefulWidget {
  static const route = "${Mains.route}settings";
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings".tr),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: _buildContent(context).padding(EdgeInsets.only(top: 20)),
    );
  }

  Widget _buildContent(BuildContext context) {
    SettingController settingController = Get.put(SettingController());
    return ListView(
      children: [
        ListTile(
          leading: Icon(Icons.person),
          title: Text('Account'.tr),
          onTap: () {
            Go.to(AccountPage());
          },
        ),
        ListTile(
          leading: Icon(Icons.palette),
          title: Text('Appearance'.tr),
          onTap: () {
            Go.to(AppearancePage());
          },
        ),
        ListTile(
          leading: Icon(Icons.image),
          title: Text('Manga Settings'.tr),
          onTap: () {
            Go.to(MangaSettingPage());
          },
        ),
        ListTile(
            leading: Icon(Icons.switch_access_shortcut_rounded),
            title: Text('Home Page'.tr),
            trailing: Obx(
              () => DropdownButton(
                value: settingController.defaultPage.value,
                items: [
                  DropdownMenuItem(
                    value: "0",
                    child: Text("Main Page".tr),
                  ),
                  DropdownMenuItem(
                    value: "1",
                    child: Text("Search Page".tr),
                  ),
                  DropdownMenuItem(
                    value: "2",
                    child: Text("Me Page".tr),
                  ),
                ],
                onChanged: (String? value) {
                  settingController.changeDefaultPage(value!);
                },
              ),
            )),
        ListTile(
            leading: Icon(Icons.screen_lock_rotation_rounded),
            title: Text('Main orientation'.tr),
            trailing: Obx(
              () => DropdownButton(
                value: settingController.defaultPage.value,
                items: [
                  DropdownMenuItem(
                    value: "0",
                    child: Text("Auto".tr),
                  ),
                  DropdownMenuItem(
                    value: "1",
                    child: Text("Portrait".tr),
                  ),
                  DropdownMenuItem(
                    value: "2",
                    child: Text("Landscape".tr),
                  ),
                ],
                onChanged: (String? value) {
                  settingController.changeMainOrientation(value!);
                },
              ),
            )),
      ],
    );
  }
}

class SettingController extends GetxController {
  RxString defaultPage = appdata.general[5].obs;
  RxString mainOrientation = appdata.general[6].obs;

  void changeDefaultPage(String index) {
    defaultPage.value = index;
    appdata.general[5] = index;
    appdata.updateSettings("general");
  }

  void changeMainOrientation(String index) {
    mainOrientation.value = index;
    appdata.general[6] = index;
    appdata.updateSettings("general");
    resetOrientation();
  }
}
