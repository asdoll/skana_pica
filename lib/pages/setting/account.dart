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
                                      ).paddingBottom(16),
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
                                                FocusManager
                                                    .instance.primaryFocus
                                                    ?.unfocus();
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
                      showMoonModal(
                          context: context,
                          builder: (context) {
                            TextEditingController oldPasswordController =
                                TextEditingController();
                            TextEditingController newPasswordController =
                                TextEditingController();
                            TextEditingController confirmPasswordController =
                                TextEditingController();
                            return Obx(() => Dialog(
                                child: ListView(shrinkWrap: true, children: [
                              MoonAlert(
                                label: Text("Change Password".tr).header(),
                                verticalGap: 16,
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    MoonTextInput(
                                      controller: oldPasswordController,
                                      hintText: "Old Password".tr,
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      obscureText: loginController.hideOldPassword.value,
                                      hasFloatingLabel: true,
                                      onTapOutside: (PointerDownEvent _) =>
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus(),
                                      leading: const Icon(
                                        MoonIcons.security_password_24_light,
                                        size: 24,
                                      ),
                                      trailing: MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: GestureDetector(
                                          child: IntrinsicWidth(
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                loginController.hideOldPassword.value
                                                    ? "Show".tr
                                                    : "Hide".tr,
                                                style: TextStyle(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  color: Colors.grey,
                                                ),
                                              ).underlineSmall(),
                                            ),
                                          ),
                                          onTap: () => setState(() =>
                                              loginController.hideOldPassword.value =
                                                  !loginController.hideOldPassword.value),
                                        ),
                                      ),
                                    ).paddingBottom(8),
                                    MoonTextInput(
                                      controller: newPasswordController,
                                      hintText: "New Password".tr,
                                      obscureText: loginController.hideNewPassword.value,
                                      leading: const Icon(
                                        MoonIcons.security_password_24_light,
                                        size: 24,
                                      ),
                                      trailing: MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: GestureDetector(
                                          child: IntrinsicWidth(
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                loginController.hideNewPassword.value
                                                    ? "Show".tr
                                                    : "Hide".tr,
                                                style: TextStyle(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  color: Colors.grey,
                                                ),
                                              ).underlineSmall(),
                                            ),
                                          ),
                                          onTap: () => setState(() =>
                                              loginController.hideNewPassword.value =
                                                  !loginController.hideNewPassword.value),
                                        ),
                                      ),
                                    ).paddingBottom(8),
                                    MoonTextInput(
                                      controller: confirmPasswordController,
                                      hintText: "Confirm Password".tr,
                                      obscureText: loginController.hideConfirmPassword.value,
                                      leading: const Icon(
                                        MoonIcons.security_password_24_light,
                                        size: 24,
                                      ),
                                      trailing: MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: GestureDetector(
                                          child: IntrinsicWidth(
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                loginController.hideConfirmPassword.value
                                                    ? "Show".tr
                                                    : "Hide".tr,
                                                style: TextStyle(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  color: Colors.grey,
                                                ),
                                              ).underlineSmall(),
                                            ),
                                          ),
                                          onTap: () => setState(() =>
                                              loginController.hideConfirmPassword.value =
                                                  !loginController.hideConfirmPassword.value),
                                        ),
                                      ),
                                    ).paddingBottom(16),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        outlinedButton(
                                          onPressed: () {
                                            Get.back();
                                          },
                                          label: "Cancel".tr,
                                        ).paddingRight(8),
                                        filledButton(
                                          onPressed: () {
                                            if (oldPasswordController.text.isEmpty ||
                                                newPasswordController
                                                    .text.isEmpty ||
                                                confirmPasswordController
                                                    .text.isEmpty) {
                                              showToast(
                                                  "Password can't be empty".tr);
                                              return;
                                            }
                                            if (newPasswordController.text !=
                                                confirmPasswordController
                                                    .text) {
                                              showToast(
                                                  "Password not match".tr);
                                              return;
                                            }
                                            Get.back();
                                            profileController.updatePassword(
                                                oldPasswordController.text,
                                                newPasswordController.text);
                                          },
                                          label: "Change".tr,
                                        ).paddingRight(8),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ])));
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
