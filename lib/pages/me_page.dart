import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:skana_pica/pages/setting/setting_page.dart';
import 'package:skana_pica/pages/setting/theme.dart';
import 'package:skana_pica/util/leaders.dart';
import 'package:skana_pica/util/log.dart';
import 'package:skana_pica/util/theme.dart';
import 'package:skana_pica/util/widget_utils.dart';

class MePage extends StatefulWidget {
  const MePage({super.key});

  @override
  State<MePage> createState() => _MePageState();
}

class _MePageState extends State<MePage> {
  late DarkModeController themeQuickController;

  @override
  void initState() {
    super.initState();
    try{
      themeQuickController = Get.find();
    }
    catch(e){
      themeQuickController = Get.put(DarkModeController());
    }
  }

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader(
        title: Text("Me".tr),
        actions: [
          Obx(
            () => FButton.icon(
              style: FButtonStyle.ghost,
              child: themeQuickController.isDark > 0
                  ? FIcon(FAssets.icons.moon, size: 24,)
                  : FIcon(FAssets.icons.sun, size: 24),
              onPress: () {
                themeQuickController.toggleDarkMode();
              },
            ),
          ),
          FButton.icon(
            style: FButtonStyle.ghost,
            child: FIcon(FAssets.icons.settings, size: 24),
            onPress: () {
              Go.to(SettingPage());
            },
          ),
        ],
      ),
      content: _buildContent(context).paddingTop(20),
    );
  }

  Widget _buildContent(BuildContext context) {
    return FCard(
      image: Placeholder(),
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
