import 'dart:io';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moon_design/moon_design.dart';
import 'package:skana_pica/config/base.dart' show Base;
import 'package:skana_pica/controller/setting_controller.dart';
import 'package:skana_pica/controller/theme_controller.dart';
import 'package:skana_pica/pages/mainscreen.dart';
import 'package:skana_pica/pages/setting/account.dart';
import 'package:skana_pica/pages/setting/cache.dart';
import 'package:skana_pica/pages/setting/manga.dart';
import 'package:skana_pica/pages/setting/update.dart';
import 'package:skana_pica/util/leaders.dart';
import 'package:skana_pica/util/widgetplugin.dart';

class SettingPage extends StatefulHookConsumerWidget {
  static const route = "${Mains.route}settings";
  const SettingPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingPageState();
}

class _SettingPageState extends ConsumerState<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(height: 16),
        moonListTile(
          leading: Icon(BootstrapIcons.person),
          title: 'account'.tr(),
          onTap: () {
            Go.to(AccountPage());
          },
        ),
        moonListTile(
          leading: Icon(BootstrapIcons.moon),
          title: 'dark_mode'.tr(),
          trailing: MoonDropdown(
            offset: Offset(-10, 0),
            minWidth: 100,
            maxWidth: 100,
            show: ref.watch(settingProvider).darkMenu,
            //constrainWidthToChild: true,
            onTapOutside: () =>
                ref.read(settingProvider.notifier).setDarkMenu(),
            content: Column(
              children: [
                MoonMenuItem(
                    onTap: () {
                      ref.read(settingProvider.notifier).setDarkMenu();
                      ref
                          .read(themeControllerProvider.notifier)
                          .changeDarkMode("0");
                    },
                    label: Text('follow_system'.tr())),
                MoonMenuItem(
                    onTap: () {
                      ref.read(settingProvider.notifier).setDarkMenu();
                      ref
                          .read(themeControllerProvider.notifier)
                          .changeDarkMode("1");
                    },
                    label: Text('light'.tr())),
                MoonMenuItem(
                    onTap: () {
                      ref.read(settingProvider.notifier).setDarkMenu();
                      ref
                          .read(themeControllerProvider.notifier)
                          .changeDarkMode("2");
                    },
                    label: Text('dark'.tr())),
              ],
            ),
            child: filledButton(
              label: ref.watch(themeControllerProvider) == "0"
                  ? 'follow_system'.tr()
                  : ref.watch(themeControllerProvider) == "1"
                      ? 'light'.tr()
                      : 'dark'.tr(),
              onPressed: () => ref
                  .read(settingProvider.notifier)
                  .setDarkMenu(ref.read(settingProvider).darkMenu),
            ),
          ),
        ),
        moonListTile(
          leading: Icon(BootstrapIcons.translate),
          title: 'language'.tr(),
          trailing: MoonDropdown(
            offset: Offset(-10, 0),
            minWidth: 100,
            maxWidth: 100,
            show: ref.watch(settingProvider).langMenu,
            onTapOutside: () =>
                ref.read(settingProvider.notifier).setLangMenu(),
            content: Column(
              children: [
                MoonMenuItem(
                    onTap: () {
                      ref.read(settingProvider.notifier).setLangMenu();
                      ref.read(settingProvider.notifier).changeLanguage("");
                      context.setLocale(Base.locale);
                    },
                    label: Text('follow_system'.tr())),
                MoonMenuItem(
                    onTap: () {
                      ref.read(settingProvider.notifier).setLangMenu();
                      ref.read(settingProvider.notifier).changeLanguage("cn");
                      context.setLocale(Base.locale);
                    },
                    label: Text("中文(简体)")),
                MoonMenuItem(
                    onTap: () {
                      ref.read(settingProvider.notifier).setLangMenu();
                      ref.read(settingProvider.notifier).changeLanguage("tw");
                      context.setLocale(Base.locale);
                    },
                    label: Text("中文(繁體)")),
                MoonMenuItem(
                    onTap: () {
                      ref.read(settingProvider.notifier).setLangMenu();
                      ref.read(settingProvider.notifier).changeLanguage("en");
                      context.setLocale(Base.locale);
                    },
                    label: Text("English")),
              ],
            ),
            child: filledButton(
              label: ref.watch(settingProvider).language == ""
                  ? 'follow_system'.tr()
                  : ref.watch(settingProvider).language == "cn"
                      ? '中文(简体)'.tr()
                      : ref.watch(settingProvider).language == "tw"
                          ? '中文(繁體)'.tr()
                          : 'English'.tr(),
              onPressed: () => ref
                  .read(settingProvider.notifier)
                  .setLangMenu(ref.read(settingProvider).langMenu),
            ),
          ),
        ),
        moonListTile(
          leading: Icon(BootstrapIcons.arrow_counterclockwise),
          title: 'main_orientation'.tr(),
          trailing: MoonDropdown(
            offset: Offset(-10, 0),
            minWidth: 100,
            maxWidth: 100,
            show: ref.watch(settingProvider).orienMenu,
            onTapOutside: () =>
                ref.read(settingProvider.notifier).setOrientMenu(),
            content: Column(
              children: [
                MoonMenuItem(
                    onTap: () {
                      ref.read(settingProvider.notifier).setOrientMenu();
                      ref
                          .read(settingProvider.notifier)
                          .changeMainOrientation("0");
                    },
                    label: Text("auto".tr())),
                MoonMenuItem(
                    onTap: () {
                      ref.read(settingProvider.notifier).setOrientMenu();
                      ref
                          .read(settingProvider.notifier)
                          .changeMainOrientation("1");
                    },
                    label: Text("portrait".tr())),
                MoonMenuItem(
                    onTap: () {
                      ref.read(settingProvider.notifier).setOrientMenu();
                      ref
                          .read(settingProvider.notifier)
                          .changeMainOrientation("2");
                    },
                    label: Text("landscape".tr())),
              ],
            ),
            child: filledButton(
              label: ref.watch(settingProvider).mainOrientation == "0"
                  ? 'auto'.tr()
                  : ref.watch(settingProvider).mainOrientation == "1"
                      ? 'portrait'.tr()
                      : 'landscape'.tr(),
              onPressed: () => ref
                  .read(settingProvider.notifier)
                  .setOrientMenu(ref.read(settingProvider).orienMenu),
            ),
          ),
        ),
        if (Platform.isAndroid)
          moonListTile(
            leading: Icon(BootstrapIcons.arrow_clockwise),
            title: 'high_refresh_rate'.tr(),
            trailing: MoonSwitch(
              value: ref.watch(settingProvider).highRefreshRate,
              onChanged:
                  ref.read(settingProvider.notifier).changeHighRefreshRate,
            ),
          ),
        moonListTile(
          leading: Icon(BootstrapIcons.image),
          title: 'manga_settings'.tr(),
          onTap: () {
            Go.to(MangaSettingPage());
          },
        ),
        moonListTile(
          leading: Icon(BootstrapIcons.database),
          title: 'cache_restore'.tr(),
          onTap: () {
            Go.to(CacheSetting());
          },
        ),
        moonListTile(
          leading: Icon(BootstrapIcons.info_circle),
          title: 'about'.tr(),
          onTap: () {
            alertDialog(
                context,
                "Skana Pica",
                '''Version:${ref.watch(settingProvider.notifier).getVersion()}\n\n© 2024 Skana - Asdoll
                ''',
                [
                  filledButton(
                    label: 'ok'.tr(),
                    onPressed: () => Navigator.pop(context),
                  )
                ]);
          },
        ),
        moonListTile(
          leading: Icon(BootstrapIcons.download),
          title: 'update'.tr(),
          onTap: () {
            Go.to(UpdatePage());
          },
        ),
      ],
    );
  }
}
