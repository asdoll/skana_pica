import 'package:bootstrap_icons/bootstrap_icons.dart' show BootstrapIcons;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moon_design/moon_design.dart';
import 'package:skana_pica/controller/login.dart';
import 'package:skana_pica/controller/profile.dart';
import 'package:skana_pica/pages/pica_login.dart';
import 'package:skana_pica/util/leaders.dart';
import 'package:skana_pica/util/widgetplugin.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late LoginController loginController;
  @override
  void initState() {
    super.initState();
    loginController = Get.put(LoginController());
    loginController.init();
    if (loginController.isLogin.value &&
        profileController.profile.value.name.isEmpty) {
      profileController.fetch();
    }
  }

  @override
  void dispose() {
    Get.delete<LoginController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        title: "Account".tr,
      ),
      body: Obx(() {
        if (profileController.loading.value) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView(
            children: [
              if (!loginController.isLogin.value)
                moonListTile(
                  title: "Login".tr,
                  trailing: Icon(BootstrapIcons.box_arrow_in_left),
                  onTap: () {
                    Go.to(PicaLoginPage());
                  },
                ),
              if (loginController.isLogin.value)
                moonListTile(
                  title: "Username".tr,
                  subtitle: profileController.profile.value.name,
                ),
              // TODO: Avatar change
              // if(loginController.isLogin.value)
              //   ListTile(
              //     title: Text("Avatar".tr),
              //     subtitle: Text("Click to change avatar".tr),
              //     trailing: CircleAvatar(
              //       backgroundImage: NetworkImage(profileController.profile.value.avatarUrl),
              //       radius: 20,
              //     ),
              //     onTap: (){

              //     }
              //   ),
              if (loginController.isLogin.value)
                moonListTile(
                  title: "Email".tr,
                  subtitle: profileController.profile.value.email,
                ),
              if (loginController.isLogin.value)
                moonListTile(
                  title: "Level".tr,
                  subtitle:
                      "(Lv. ${profileController.profile.value.level}) (${profileController.profile.value.title})",
                ),
              if (loginController.isLogin.value)
                moonListTile(
                  title: "${"Slogan".tr}(${"Tap to change".tr})",
                  subtitle: profileController.profile.value.slogan ?? "",
                  onTap: () {
                    showMoonModal(
                        context: context,
                        builder: (context) {
                          TextEditingController controller =
                              TextEditingController();
                          return Dialog(
                              child: ListView(
                            shrinkWrap: true,
                            children: [
                              MoonAlert(
                                  borderColor: Get.context?.moonTheme
                                      ?.buttonTheme.colors.borderColor
                                      .withValues(alpha: 0.5),
                                  showBorder: true,
                                  label: Text("Slogan".tr).header(),
                                  verticalGap: 16,
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      MoonTextInput(
                                        controller: controller,
                                        hintText: "Slogan".tr,
                                      ).paddingVertical(8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          outlinedButton(
                                                  label: "Cancel".tr,
                                                  onPressed: () => Get.back())
                                              .paddingRight(8),
                                          filledButton(
                                              label: "Save".tr,
                                              onPressed: () {
                                                FocusManager.instance.primaryFocus?.unfocus();
                                                if (controller.text
                                                    .trim()
                                                    .isEmpty) {
                                                  showToast(
                                                      "Slogan can't be empty"
                                                          .tr);
                                                  return;
                                                }
                                                profileController.updateSlogan(
                                                    controller.text);
                                                Navigator.of(context).pop();
                                              }).paddingRight(8)
                                        ],
                                      ),
                                    ],
                                  )),
                            ],
                          ));
                        });
                  },
                ),
              if (loginController.isLogin.value)
                moonListTile(
                    title: "Change Password".tr,
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            TextEditingController oldPasswordController =
                                TextEditingController();
                            TextEditingController newPasswordController =
                                TextEditingController();
                            TextEditingController confirmPasswordController =
                                TextEditingController();
                            return AlertDialog(
                              title: Text("Change Password".tr),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    controller: oldPasswordController,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: "Old Password".tr),
                                  ),
                                  TextField(
                                    controller: newPasswordController,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: "New Password".tr),
                                  ),
                                  TextField(
                                    controller: confirmPasswordController,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: "Confirm Password".tr),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: Text("Cancel".tr),
                                ),
                                TextButton(
                                  onPressed: () {
                                    if (oldPasswordController.text.isEmpty ||
                                        newPasswordController.text.isEmpty ||
                                        confirmPasswordController
                                            .text.isEmpty) {
                                      showToast("Password can't be empty".tr);
                                      return;
                                    }
                                    if (newPasswordController.text !=
                                        confirmPasswordController.text) {
                                      showToast("Password not match".tr);
                                      return;
                                    }
                                    Get.back();
                                    profileController.updatePassword(
                                        oldPasswordController.text,
                                        newPasswordController.text);
                                  },
                                  child: Text("Change".tr),
                                ),
                              ],
                            );
                          });
                    }),
              if (loginController.isLogin.value)
                moonListTile(
                  title: "Logout".tr,
                  trailing: Icon(BootstrapIcons.box_arrow_in_right),
                  onTap: () {
                    alertDialog(
                        context, "Logout".tr, "Are you sure to logout?".tr, [
                      outlinedButton(
                        label: "Cancel".tr,
                        onPressed: () => Get.back(),
                      ),
                      filledButton(
                        label: "Logout".tr,
                        onPressed: () => loginController.logout(),
                      ),
                    ]);
                  },
                ),
            ],
          );
        }
      }),
    );
  }
}
