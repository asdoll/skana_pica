import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skana_pica/api/managers/image_cache_manager.dart';
import 'package:skana_pica/controller/profile.dart';
import 'package:skana_pica/pages/mainscreen.dart';
import 'package:skana_pica/pages/pica_favor.dart';
import 'package:skana_pica/pages/setting/setting_page.dart';
import 'package:skana_pica/util/leaders.dart';
import 'package:skana_pica/util/theme.dart';
import 'package:skana_pica/widgets/pica_image.dart';

class MePage extends StatefulWidget {
  static const route = "${Mains.route}me";

  const MePage({super.key});

  @override
  State<MePage> createState() => _MePageState();
}

class _MePageState extends State<MePage> {
  late ProfileController profileController;
  final _cardHeight = 200.0;

  @override
  void initState() {
    super.initState();
    profileController = Get.put(ProfileController());
    profileController.fetch();
  }

  @override
  void dispose() {
    Get.delete<ProfileController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DarkModeController themeQuickController = Get.put(DarkModeController());
    return Scaffold(
      appBar: AppBar(
        title: Text("Me".tr),
        actions: [
          Obx(
            () => IconButton(
              icon: themeQuickController.isDark.value > 0
                  ? Icon(Icons.nights_stay)
                  : Icon(Icons.wb_sunny_sharp),
              onPressed: () {
                themeQuickController.toggleDarkMode();
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Go.to(SettingPage());
            },
          ),
        ],
      ),
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Obx(() => Column(
          children: [
            if (!profileController.loading.value) _buildNameCard(context),
            InkWell(
              onTap: () {
                Go.to(PicaFavorPage());
              },
              child: Card(
                child: ListTile(
                  title: Text("My Bookmarks".tr).paddingOnly(left: 16),
                ),
              ),
            ),
          ],
        ));
  }

  Widget _buildNameCard(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Stack(
        children: [
          Stack(
            children: [
              Opacity(
                opacity: .25, //
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return PicaImage(
                      profileController.profile.value.avatarUrl,
                      width: constraints.maxWidth,
                      height: _cardHeight,
                    );
                  },
                ),
              ),
              Positioned.fromRect(
                rect: Rect.largest,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                  child: Container(),
                ),
              ),
            ],
          ),
          SizedBox(
            height: _cardHeight,
            child: Column(
              children: [
                Expanded(child: Container()),
                CircleAvatar(
                  radius: 55,
                  backgroundColor: Get.theme.primaryColor,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: imageProvider(
                        profileController.profile.value.avatarUrl),
                  ),
                ),
                Container(height: 5),
                Text(
                  profileController.profile.value.name,
                ),
                Text(
                  "(Lv. ${profileController.profile.value.level}) (${profileController.profile.value.title})",
                ),
                Container(height: 8),
                GestureDetector(
                  onTap: () async {
                    showDialog(
                        context: context,
                        builder: (context) {
                          TextEditingController controller =
                              TextEditingController();
                          return AlertDialog(
                            title: Text("Slogan"),
                            content: TextField(
                              controller: controller,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("Cancel".tr),
                              ),
                              TextButton(
                                onPressed: () {
                                  if (controller.text.trim().isEmpty) {
                                    toast("Slogan can't be empty".tr);
                                    return;
                                  }
                                  profileController
                                      .updateSlogan(controller.text);
                                  Navigator.of(context).pop();
                                },
                                child: Text("Save".tr),
                              ),
                            ],
                          );
                        });
                  },
                  child: Text(
                    profileController.profile.value.slogan == null ||
                            profileController.profile.value.slogan!.isEmpty
                        ? "这个人很懒, 什么也没留下"
                        : profileController.profile.value.slogan!,
                  ),
                ),
                Expanded(child: Container()),
              ],
            ),
          )
        ],
      ),
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
