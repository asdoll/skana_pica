import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
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
    return FScaffold(
      header: FHeader.nested(
        title: Text("Settings".tr),
        prefixActions: [
          FHeaderAction.back(onPress: () => Get.back()),
        ],
      ),
      content: _buildContent(context).paddingTop(20),
    );
  }

  Widget _buildContent(BuildContext context) {
    return FTileGroup(
      semanticLabel: 'Settings',
      divider: FTileDivider.indented,
      children: [
        FTile(
          prefixIcon: FIcon(FAssets.icons.user),
          title: Text('Account'.tr),
          suffixIcon: FIcon(FAssets.icons.chevronRight),
          onPress: () {},
        ),
        FTile(
          prefixIcon: FIcon(FAssets.icons.palette),
          title: Text('Appearance'.tr),
          suffixIcon: FIcon(FAssets.icons.chevronRight),
          onPress: () {
            Go.to(AppearancePage());
          },
        ),
        FTile(
          prefixIcon: FIcon(FAssets.icons.images),
          title: Text('Manga sources'.tr),
          suffixIcon: FIcon(FAssets.icons.chevronRight),
          onPress: () {
            Go.to(MangaSettingPage());
          },
        ),
      ],
    );
  }
}
