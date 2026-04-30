import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:easy_localization/easy_localization.dart' show StringTranslateExtension;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:moon_design/moon_design.dart';
import 'package:skana_pica/config/setting.dart';
import 'package:skana_pica/controller/setting_controller.dart';
import 'package:skana_pica/pages/setting/setting_page.dart';
import 'package:skana_pica/util/leaders.dart';
import 'package:skana_pica/util/widgetplugin.dart';

class CacheSetting extends HookConsumerWidget {
  static const route = "${SettingPage.route}/cache";
  const CacheSetting({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Scaffold(
      appBar: appBar(
        title: "cache_restore".tr(),
      ),
      body: ListView(
          children: [
            SizedBox(height: 16),
            moonListTile(
              title: "clear_cache_period".tr(),
              trailing: MoonDropdown(
                show: ref.watch(cacheProvider).cacheMenu,
                onTapOutside: () => ref.read(cacheProvider.notifier).setMenu(),
                content: Column(
                  children: [
                    MoonMenuItem(
                      onTap: () {
                        ref.read(cacheProvider.notifier).setMenu();
                        ref.read(cacheProvider.notifier).setCachePeriod("1");
                      },
                      label: Text('1 ${"day".tr()}'),
                    ),
                    MoonMenuItem(
                      onTap: () {
                        ref.read(cacheProvider.notifier).setMenu();
                        ref.read(cacheProvider.notifier).setCachePeriod("3");
                      },
                      label: Text('3 ${"days".tr()}'),
                    ),
                    MoonMenuItem(
                      onTap: () {
                        ref.read(cacheProvider.notifier).setMenu();
                        ref.read(cacheProvider.notifier).setCachePeriod("7");
                      },
                      label: Text('7 ${"days".tr()}'),
                    ),
                    MoonMenuItem(
                      onTap: () {
                        ref.read(cacheProvider.notifier).setMenu();
                        ref.read(cacheProvider.notifier).setCachePeriod("30");
                      },
                      label: Text('30 ${"days".tr()}'),
                    ),
                  ],
                ),
                child: filledButton(
                  label: "${ref.watch(cacheProvider).cachePeriod} ${"days".tr()}",
                  onPressed: () => ref.read(cacheProvider.notifier).setMenu(!ref.read(cacheProvider).cacheMenu),
                ),
              ),
            ),
            moonListTile(
              title: "clear_cache".tr(),
              leading: Icon(BootstrapIcons.trash3),
              onTap: () {
                alertDialog(context, "clear_cache".tr(),
                    "are_you_sure_to_clear_cache".tr(), [
                  outlinedButton(
                      onPressed: () => Navigator.pop(context), label: "cancel".tr()),
                  filledButton(
                      onPressed: () {
                        ref.read(cacheProvider.notifier).clearCache();
                        showToast("cache_cleared".tr());
                        Navigator.pop(context);
                      },
                      label: "ok".tr())
                ]);
              },
            ),
            moonListTile(
              title: "restore_settings".tr(),
              leading: Icon(BootstrapIcons.clock_history),
              onTap: () {
                alertDialog(context, "restore_settings".tr(),
                    "are_you_sure_to_restore_settings".tr(), [
                  outlinedButton(
                      onPressed: () => Navigator.pop(context), label: "cancel".tr()),
                  filledButton(
                      onPressed: () {
                        ref.read(cacheProvider.notifier).restore("general");
                        ref.read(cacheProvider.notifier).restore("pica");
                        ref.read(cacheProvider.notifier).restore("read");
                        showToast("restored".tr());
                        Navigator.pop(context);
                      },
                      label: "ok".tr())
                ]);
              },
            ),
            moonListTile(
              title: "initialize_app".tr(),
              leading: Icon(BootstrapIcons.exclamation_circle),
              onTap: () {
                alertDialog(context, "initialize_app".tr(),
                    "are_you_sure_to_initialize_app".tr(), [
                  outlinedButton(
                      onPressed: () => Navigator.pop(context), label: "cancel".tr()),
                  filledButton(
                      onPressed: () {
                        clearAppdata(ref);
                        showToast("app_initialized".tr());
                        Navigator.pop(context);
                      },
                      label: "ok".tr())
                ]);
              },
            ),
          ],
        ),
    );
  }
}
