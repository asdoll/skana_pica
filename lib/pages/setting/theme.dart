import 'package:flex_color_scheme/flex_color_scheme.dart' show FlexColor;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skana_pica/config/base.dart';
import 'package:skana_pica/config/setting.dart';
import 'package:skana_pica/pages/me_page.dart';
import 'package:skana_pica/pages/setting/setting_page.dart';
import 'package:skana_pica/util/theme.dart';
import 'package:icon_decoration/icon_decoration.dart';

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
                trailing:
                    Icon(Icons.square_rounded, color: FlexColor.schemesList[appearanceController.theme.value].light.primary),
                title: Text('Color Theme'.tr),
                onTap: () {
                  Get.defaultDialog(
                    titlePadding: EdgeInsets.only(top: 20),
                    title: "Color Theme".tr,
                    content: Container(
                      height: Get.height / 1.5,
                      width: Get.width / 1.2,
                      child: CustomScrollView(
                        slivers: [
                          SliverGrid.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 6,
                              crossAxisSpacing: 4.0,
                              mainAxisSpacing: 4.0,
                            ),
                            itemCount: FlexColor.schemesList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                onTap: () {
                                  appearanceController.previewTheme(index);
                                  appearanceController.changeTheme();
                                  Get.back();
                                },
                                child: DecoratedIcon(
                                  icon: Icon(Icons.square_rounded,
                                      size: (Get.width / 1.2 - 40) / 6,
                                      color: FlexColor
                                          .schemesList[index].light.primary),
                                  decoration:
                                      IconDecoration(border: IconBorder()),
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          appearanceController.restoreTheme();
                          Get.back();
                        },
                        child: Text('Close'.tr),
                      ),
                    ],
                  );
                },
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
                      appearanceController.changeBrightness(value);
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
}

class AppearanceController extends GetxController {
  var theme = appdata.theme.obs;
  var darkMode = appdata.darkMode.obs;
  var language = appdata.general[2].obs;

  void changeTheme() {
    appdata.theme = theme.value;
    ThemeManager.instance.updateTheme();
  }

  void previewTheme(int index) {
    theme.value = index;
    ThemeManager.instance.previewTheme(index);
  }

  void restoreTheme() {
    theme.value = appdata.theme;
    ThemeManager.instance.updateTheme();
  }

  void changeBrightness(int first) {
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
