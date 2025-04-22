import 'dart:io';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moon_design/moon_design.dart';
import 'package:skana_pica/controller/setting_controller.dart';
import 'package:skana_pica/controller/theme_controller.dart';
import 'package:skana_pica/pages/mainscreen.dart';
import 'package:skana_pica/pages/setting/account.dart';
import 'package:skana_pica/pages/setting/cache.dart';
import 'package:skana_pica/pages/setting/manga.dart';
import 'package:skana_pica/pages/setting/update.dart';
import 'package:skana_pica/util/leaders.dart';
import 'package:skana_pica/util/widgetplugin.dart';

class SettingPage extends StatefulWidget {
  static const route = "${Mains.route}settings";
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    SettingController settingController = Get.put(SettingController());
    return Obx(() => ListView(
      children: [
        moonListTile(
          leading: Icon(BootstrapIcons.person),
          title: 'Account'.tr,
          onTap: () {
            Go.to(AccountPage());
          },
        ),
        moonListTile(
          leading: Icon(BootstrapIcons.moon),
          title: 'Dark Mode'.tr,
          trailing: MoonDropdown(
            offset: Offset(-10, 0),
            minWidth: 100,
            maxWidth: 100,
            show: settingController.darkMenu.value,
            //constrainWidthToChild: true,
            onTapOutside: () => settingController.darkMenu.value = false,
            content: Column(
              children: [
                    MoonMenuItem(onTap: () {
                      settingController.darkMenu.value = false;
                      tc.changeDarkMode("0");
                    }, label: Text('Follow System'.tr)),
                    MoonMenuItem(onTap: () {
                      settingController.darkMenu.value = false;
                      tc.changeDarkMode("1");
                    }, label: Text('Light'.tr)),
                    MoonMenuItem(onTap: () {
                      settingController.darkMenu.value = false;
                      tc.changeDarkMode("2");
                    }, label: Text('Dark'.tr)),
                  ],
            ),
            child: filledButton(
              label: tc.darkMode.value == "0" ? 'Follow System'.tr : tc.darkMode.value == "1" ? 'Light'.tr : 'Dark'.tr,
              onPressed: () => settingController.darkMenu.value = !settingController.darkMenu.value,
            ),
          ),
        ),
        moonListTile(
          leading: Icon(BootstrapIcons.translate),
          title: 'Language'.tr,
          trailing: MoonDropdown(
            offset: Offset(-10, 0),
            minWidth: 100,
            maxWidth: 100,
            show: settingController.langMenu.value,
            onTapOutside: () => settingController.langMenu.value = false,
            content: Column(
              children: [
                    MoonMenuItem(onTap: () {
                      settingController.langMenu.value = false;
                      settingController.changeLanguage("");
                    }, label: Text('Follow System'.tr)),
                    MoonMenuItem(onTap: () {
                      settingController.langMenu.value = false;
                      settingController.changeLanguage("cn");
                    }, label: Text("中文(简体)")),
                    MoonMenuItem(onTap: () {
                      settingController.langMenu.value = false;
                      settingController.changeLanguage("tw");
                    }, label: Text("中文(繁體)")),
                    MoonMenuItem(onTap: () {
                      settingController.langMenu.value = false;
                      settingController.changeLanguage("en");
                    }, label: Text("English")),
                  ],
            ),
            child: filledButton(
              label: settingController.language.value == "" ? 'Follow System'.tr : settingController.language.value == "cn" ? '中文(简体)'.tr : settingController.language.value == "tw" ? '中文(繁體)'.tr : 'English'.tr,
              onPressed: () => settingController.langMenu.value = !settingController.langMenu.value,
            ),
          ),
        ),
        moonListTile(
            leading: Icon(BootstrapIcons.arrow_counterclockwise),
            title: 'Main orientation'.tr,
            trailing: Obx(
              () => MoonDropdown(
                offset: Offset(-10, 0),
                minWidth: 100,
                maxWidth: 100,
                show: settingController.orienMenu.value,
                onTapOutside: () => settingController.orienMenu.value = false,
                content: Column(
                  children: [
                    MoonMenuItem(onTap: () {
                      settingController.orienMenu.value = false;
                      settingController.changeMainOrientation("0");
                    }, label: Text("Auto".tr)),
                    MoonMenuItem(onTap: () {
                      settingController.orienMenu.value = false;
                      settingController.changeMainOrientation("1");
                    }, label: Text("Portrait".tr)),
                    MoonMenuItem(onTap: () {
                      settingController.orienMenu.value = false;
                      settingController.changeMainOrientation("2");
                    }, label: Text("Landscape".tr)),
                  ],
                ),
                child: filledButton(
                  label: settingController.mainOrientation.value == "0" ? 'Auto'.tr : settingController.mainOrientation.value == "1" ? 'Portrait'.tr : 'Landscape'.tr,
                  onPressed: () => settingController.orienMenu.value = !settingController.orienMenu.value,
                ),
              ),
            )),
          if(Platform.isAndroid)
          moonListTile(
            leading: Icon(BootstrapIcons.arrow_clockwise),
            title: 'High Refresh Rate'.tr,
            trailing: Obx(
              () => MoonSwitch(
                value: settingController.highRefreshRate.value,
                onChanged: settingController.changeHighRefreshRate,
              ),
            ),
          ),
           moonListTile(
            leading: Icon(BootstrapIcons.image),
            title: 'Manga Settings'.tr,
            onTap: () {
              Go.to(MangaSettingPage());
          },
        ),
        moonListTile(
          leading: Icon(BootstrapIcons.database),
          title: 'Cache & Restore'.tr,
          onTap: () {
            Go.to(CacheSetting());
          },
        ),
          moonListTile(
            leading: Icon(BootstrapIcons.info_circle),
            title: 'About'.tr,
            onTap: () {
              alertDialog(
                context,
                "Skana Pica",
                '''Version:${settingController.getVersion()}\n\n© 2024 Skana - Asdoll
                ''',
                [filledButton(
                label: 'Ok'.tr,
                onPressed: () => Get.back(),
              )]
              );
            },
          ),
          moonListTile(
            leading: Icon(BootstrapIcons.download),
            title: 'Update'.tr,
            onTap: () {
              Go.to(UpdatePage());
            },
          ),
      ],
    ));
  }
}
