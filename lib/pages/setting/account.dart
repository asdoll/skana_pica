import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skana_pica/controller/login.dart';
import 'package:skana_pica/controller/profile.dart';
import 'package:skana_pica/pages/pica_login.dart';
import 'package:skana_pica/util/leaders.dart';

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
      appBar: AppBar(
        title: Text("Account".tr),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
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
                ListTile(
                  title: Text("Login".tr),
                  trailing: Icon(Icons.login),
                  onTap: () {
                    Go.to(PicaLoginPage());
                  },
                ),
              if (loginController.isLogin.value)
                ListTile(
                  title: Text("Username".tr),
                  subtitle: Text(profileController.profile.value.name),
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
                ListTile(
                  title: Text("Email".tr),
                  subtitle: Text(profileController.profile.value.email),
                ),
              if (loginController.isLogin.value)
                ListTile(
                  title: Text("Level".tr),
                  subtitle: Text(
                      "(Lv. ${profileController.profile.value.level}) (${profileController.profile.value.title})"),
                ),
              if (loginController.isLogin.value)
                ListTile(
                  title: Text("${"Slogan".tr}(${"Tap to change".tr})"),
                  subtitle: Text(profileController.profile.value.slogan ?? ""),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          TextEditingController controller =
                              TextEditingController();
                          return AlertDialog(
                            title: Text("Slogan".tr),
                            content: TextField(
                              controller: controller,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "Slogan".tr,
                              ),
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
                                    showToast("Slogan can't be empty".tr);
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
                ),
              if (loginController.isLogin.value)
                ListTile(
                    title: Text("Change Password".tr),
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
                ListTile(
                  title: Text("Logout".tr),
                  trailing: Icon(Icons.logout),
                  onTap: () {
                    loginController.logout();
                  },
                ),
            ],
          );
        }
      }),
    );
  }
}
