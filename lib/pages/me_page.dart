import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skana_pica/pages/mainscreen.dart';
import 'package:skana_pica/pages/setting/setting_page.dart';
import 'package:skana_pica/util/leaders.dart';
import 'package:skana_pica/util/theme.dart';
import 'package:skana_pica/util/widget_utils.dart';

class MePage extends StatefulWidget {
  static const route = "${Mains.route}me";

  const MePage({super.key});

  @override
  State<MePage> createState() => _MePageState();
}

class _MePageState extends State<MePage> {
  @override
  Widget build(BuildContext context) {
    DarkModeController themeQuickController = Get.put(DarkModeController());
    return Scaffold(
      appBar: AppBar(
        title: Text("Me".tr),
        actions: [
          Obx(
            () => IconButton(
              icon: themeQuickController.isDark.value > 0
                  ? Icon(Icons.nights_stay)
                  : Icon(Icons.wb_sunny_sharp),
              onPressed: () {
                themeQuickController.toggleDarkMode();
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Go.to(SettingPage());
            },
          ),
        ],
      ),
      body: _buildContent(context).padding(EdgeInsets.only(top: 20)),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Card(
      child: Placeholder(),
    );
  }
}

class DarkModeController extends GetxController {
  var isDark = ThemeManager.currentDarkMode.obs;
  var isSystem = ThemeManager.colorMode == 0;

  void fallback() {
    isDark.value = ThemeManager.currentDarkMode;
    isSystem = ThemeManager.colorMode == 0;
  }

  void toggleDarkMode() {
    ThemeManager.instance.toggleDarkMode();
    isDark.value = ThemeManager.currentDarkMode;
    isSystem = ThemeManager.colorMode == 0;
  }

  void setSystemMode(int value) {
    ThemeManager.instance.setSystemMode(value);
    isDark.value = ThemeManager.currentDarkMode;
    isSystem = ThemeManager.colorMode == 0;
  }
}
