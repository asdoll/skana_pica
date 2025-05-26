import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moon_design/moon_design.dart';
import 'package:skana_pica/controller/updater.dart';
import 'package:skana_pica/util/leaders.dart';
import 'package:skana_pica/util/tool.dart';
import 'package:skana_pica/util/widgetplugin.dart';
import 'package:skana_pica/widgets/custom_indicator.dart';
import 'package:url_launcher/url_launcher_string.dart';

class UpdatePage extends StatefulWidget {
  const UpdatePage({super.key});

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  @override
  Widget build(BuildContext context) {
    updater.check(showResult: true);
    
    return Scaffold(
      appBar: appBar(
        title: 'Check updates'.tr,
      ),
      body: Obx(() => BezierIndicator(
          onRefresh: () async {
            await updater.check();
          },
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              SizedBox(height: 16),
              moonListTile(
              leading: Icon(BootstrapIcons.download),
              title: "Auto check updates".tr,
              trailing: MoonSwitch(
                value: updater.autoCheck.value,
                onChanged: (value) {
                  updater.setAutoCheck(value);
                },
              ),
            ),
              moonListTile(
                title: 'Current Version'.tr,
                subtitle: updater.getCurrentVersion(),
              ),
              if (updater.result.value == Result.yes)
                moonListTile(
                  title: 'Latest Version'.tr,
                  subtitle: updater.updateVersion.value,
                ),
              if (updater.result.value == Result.yes)
                moonListTile(
                  title: 'Release Date'.tr,
                  subtitle: updater.updateDate.isNotEmpty
                      ? DateTime.parse(updater.updateDate.value).toShortTime()
                      : ""),
              if (updater.result.value == Result.yes)
                moonListTile(
                  title: 'Release Notes'.tr,
                  subtitle: updater.updateDescription.value,
                ),
              if (updater.result.value == Result.yes)
                moonListTile(
                  title: 'Download'.tr,
                  onTap: () async {
                    if (updater.updateUrl.isEmpty) {
                      showToast('No download link'.tr);
                      return;
                    }
                    await launchUrlString(updater.updateUrl.value);
                  },
                ),
              moonListTile(
                title: 'Check for updates'.tr,
                onTap: () async {
                  await updater.check(showResult: true);
                },
              ),
            ],
          ))),
    );
  }
}
