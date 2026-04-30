import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:easy_localization/easy_localization.dart'
    show StringTranslateExtension;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:moon_design/moon_design.dart';
import 'package:skana_pica/controller/updater.dart';
import 'package:skana_pica/util/leaders.dart';
import 'package:skana_pica/util/tool.dart';
import 'package:skana_pica/util/widgetplugin.dart';
import 'package:skana_pica/widgets/custom_indicator.dart';
import 'package:url_launcher/url_launcher_string.dart';

class UpdatePage extends HookConsumerWidget {
  const UpdatePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(updaterProvider.notifier).check(showResult: true);

    return Scaffold(
      appBar: appBar(
        title: 'check_updates'.tr(),
      ),
      body: BezierIndicator(
          onRefresh: ref.read(updaterProvider.notifier).check,
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              SizedBox(height: 16),
              moonListTile(
                leading: Icon(BootstrapIcons.download),
                title: "auto_check_updates".tr(),
                trailing: MoonSwitch(
                  value: ref.watch(updaterProvider).autoCheck,
                  onChanged: (value) {
                    ref.read(updaterProvider.notifier).setAutoCheck(value);
                  },
                ),
              ),
              moonListTile(
                title: 'current_version'.tr(),
                subtitle: ref.read(updaterProvider.notifier).getCurrentVersion(),
              ),
              if (ref.watch(updaterProvider).result == Result.yes)
                moonListTile(
                  title: 'latest_version'.tr(),
                  subtitle: ref.watch(updaterProvider).updateVersion,
                ),
              if (ref.watch(updaterProvider).result == Result.yes)
                moonListTile(
                    title: 'release_date'.tr(),
                    subtitle: ref.watch(updaterProvider).updateDate.isNotEmpty
                        ? DateTime.parse(ref.watch(updaterProvider).updateDate).toShortTime()
                        : ""),
              if (ref.watch(updaterProvider).result == Result.yes)
                moonListTile(
                  title: 'release_notes'.tr(),
                  subtitle: ref.watch(updaterProvider).updateDescription,
                ),
              if (ref.watch(updaterProvider).result == Result.yes)
                moonListTile(
                  title: 'download'.tr(),
                  onTap: () => launchUrlString(updateUrl),
                ),
              moonListTile(
                title: 'check_for_updates'.tr(),
                onTap: () => ref.read(updaterProvider.notifier).check(showResult: true),
              ),
            ],
          )),
    );
  }
}
