import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skana_pica/controller/updater.dart';
import 'package:skana_pica/util/leaders.dart';
import 'package:skana_pica/util/tool.dart';
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
      appBar: AppBar(
        title: Text('Check updates'.tr),
      ),
      body: Obx(() => EasyRefresh(
          controller: controller,
          onRefresh: () async {
            await updater.check();
          },
          refreshOnStart: updater.result.value != Result.yes,
          child: ListView(
            children: [
              ListTile(
                title: Text('Current Version'.tr),
                subtitle: Text(updater.getCurrentVersion()),
              ),
              if (updater.result.value == Result.yes)
                ListTile(
                  title: Text('Latest Version'.tr),
                  subtitle: Text(updater.updateVersion.value),
                ),
              if (updater.result.value == Result.yes)
                ListTile(
                  title: Text('Release Date'.tr),
                  subtitle: Text(updater.updateDate.isNotEmpty
                      ? DateTime.parse(updater.updateDate.value).toShortTime()
                      : ""),
                ),
              if (updater.result.value == Result.yes)
                ListTile(
                  title: Text('Release Notes'.tr),
                  subtitle: Text(updater.updateDescription.value),
                ),
              if (updater.result.value == Result.yes)
                ListTile(
                  title: Text('Download'.tr),
                  onTap: () async {
                    if (updater.updateUrl.isEmpty) {
                      toast('No download link'.tr);
                      return;
                    }
                    await launchUrlString(updater.updateUrl.value);
                  },
                ),
              ListTile(
                title: Text('Check for updates'.tr),
                onTap: () async {
                  await updater.check();
                },
              ),
            ],
          ))),
    );
  }
}
