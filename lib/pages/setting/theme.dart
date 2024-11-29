import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skana_pica/config/base.dart';
import 'package:skana_pica/config/setting.dart';
import 'package:skana_pica/pages/me_page.dart';
import 'package:skana_pica/pages/setting/setting_page.dart';
import 'package:skana_pica/util/theme.dart';

class AppearancePage extends StatefulWidget {
  static const route = "${SettingPage.route}/appearance";
  const AppearancePage({super.key});

  @override
  State<AppearancePage> createState() => _AppearancePageState();
}

class _AppearancePageState extends State<AppearancePage> {
  @override
  Widget build(BuildContext context) {
    AppearanceController appearanceController = Get.put(AppearanceController());
    DarkModeController darkModeController;
    try {
      darkModeController = Get.find();
    } catch (e) {
      darkModeController = Get.put(DarkModeController());
    }
    return Scaffold(
        appBar: AppBar(
          title: Text("Appearance".tr),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Get.back(),
          ),
        ),
        body: Obx(() {
          return ListView(
            padding: EdgeInsets.all(20),
            children: [
              ListTile(
                leading: Icon(Icons.palette),
                trailing: DropdownButton<int>(
                  value: appearanceController.theme.value,
                  items: _buildThemeList(context),
                  onChanged: (value) {
                    if (value != null) {
                      appearanceController.changeTheme(value);
                    }
                  },
                ),
                title: Text('Color Theme'.tr),
              ),
              ListTile(
                leading: Icon(Icons.dark_mode_rounded),
                trailing: DropdownButton<int>(
                  value: appearanceController.darkMode.value,
                  items: [
                    DropdownMenuItem(value: 0, child: Text('Follow System'.tr)),
                    DropdownMenuItem(value: 1, child: Text('Light'.tr)),
                    DropdownMenuItem(value: 2, child: Text('Dark'.tr)),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      appearanceController.changeColor(value);
                      darkModeController.setSystemMode(value);
                      darkModeController.fallback();
                    }
                  },
                ),
                title: Text('Dark Mode'.tr),
              ),
              ListTile(
                leading: Icon(Icons.language),
                trailing: DropdownButton<String>(
                  value: appearanceController.language.value,
                  items: [
                    DropdownMenuItem(
                        value: "", child: Text('Follow System'.tr)),
                    DropdownMenuItem(value: "cn", child: Text("中文(简体)")),
                    DropdownMenuItem(value: "tw", child: Text("中文(繁體)")),
                    DropdownMenuItem(value: "en", child: Text("English")),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      appearanceController.changeLanguage(value);
                    }
                  },
                ),
                title: Text("Language".tr),
              ),
            ],
          );
        }));
  }

  List<DropdownMenuItem<int>> _buildThemeList(context) {
    List<DropdownMenuItem<int>> list = [];
    for (int i = 0; i < ThemeManager.themeName.length; i++) {
      list.add(DropdownMenuItem(
        value: i,
        child: Text(ThemeManager.themeName[i].tr),
      ));
    }
    return list;
  }
}

class AppearanceController extends GetxController {
  var theme = appdata.theme.obs;
  var darkMode = appdata.darkMode.obs;
  var language = appdata.general[2].obs;

  void changeTheme(int index) {
    appdata.theme = index;
    ThemeManager.instance.updateTheme();
    theme.value = index;
  }

  void changeColor(int first) {
    appdata.darkMode = first;
    darkMode.value = first;
  }

  void changeLanguage(String value) {
    appdata.general[2] = value;
    appdata.updateSettings("general");
    language.value = value;
    Get.updateLocale(Base.locale);
  }
}
