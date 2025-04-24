import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skana_pica/controller/updater.dart';
import 'package:skana_pica/util/leaders.dart';
import 'package:skana_pica/util/tool.dart';
import 'package:skana_pica/util/widgetplugin.dart';
import 'package:skana_pica/widgets/icons.dart';
import 'package:url_launcher/url_launcher_string.dart';

class UpdatePage extends StatefulWidget {
  const UpdatePage({super.key});

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  @override
  Widget build(BuildContext context) {
    EasyRefreshController controller = EasyRefreshController(
        controlFinishLoad: true, controlFinishRefresh: true);
    updater.controller = controller;
    
    return Scaffold(
      appBar: appBar(
        title: 'Check updates'.tr,
      ),
      body: Obx(() => EasyRefresh(
          controller: controller,
          header: DefaultHeaderFooter.header(context),
          footer: DefaultHeaderFooter.footer(context),
          onRefresh: () async {
            await updater.check();
          },
          refreshOnStart: updater.result.value != Result.yes,
          child: ListView(
            children: [
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
                  controller.callRefresh(force: true);
                },
              ),
            ],
          ))),
    );
  }
}
