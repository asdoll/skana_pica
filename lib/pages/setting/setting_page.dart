import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skana_pica/pages/mainscreen.dart';
import 'package:skana_pica/pages/setting/manga.dart';
import 'package:skana_pica/pages/setting/theme.dart';
import 'package:skana_pica/util/leaders.dart';
import 'package:skana_pica/util/widget_utils.dart';

class SettingPage extends StatefulWidget {
  static const route = "${Mains.route}settings";
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings".tr),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: _buildContent(context).padding(EdgeInsets.only(top: 20)),
    );
  }

  Widget _buildContent(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: Icon(Icons.person),
          title: Text('Account'.tr),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.palette),
          title: Text('Appearance'.tr),
          onTap: () {
            Go.to(AppearancePage());
          },
        ),
        ListTile(
          leading: Icon(Icons.image),
          title: Text('Manga sources'.tr),
          onTap: () {
            Go.to(MangaSettingPage());
          },
        ),
      ],
    );
  }
}
