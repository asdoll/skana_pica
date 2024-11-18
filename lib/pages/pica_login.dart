import 'package:flutter/material.dart';

import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:skana_pica/controller/login.dart';
import 'package:skana_pica/pages/mainscreen.dart';
import 'package:skana_pica/util/leaders.dart';
import 'package:skana_pica/util/widget_utils.dart';

class PicaLoginPage extends StatefulWidget {
  static const route = "${Mains.route}picalogin";
  const PicaLoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _PicaLoginPageState();
}

class _PicaLoginPageState extends State<PicaLoginPage> {
  LoginController loginController = LoginController();
  TextEditingController accountController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader.nested(
        title: Text("Pica Login".tr),
        prefixActions: [FHeaderAction.back(onPress: () => Get.back())],
      ),
      content: Obx(() {
        if (loginController.isLoading.isTrue) {
          return Center(
            child: CircularProgressIndicator(
              color: Get.theme.colorScheme.onPrimary,
            ),
          );
        } else {
          return Column(
            children: [
              FCard(
                title: Text("Login".tr),
                subtitle: Text("Login to your Pica Account".tr),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    FTextField(
                      label: Text("Account".tr),
                      controller: accountController,
                    ),
                    const SizedBox(height: 8),
                    FTextField(
                      label: Text("Password".tr),
                      controller: passwordController,
                      obscureText: true,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 16),
                    FButton(
                      label: Text("Login".tr),
                      onPress: () {
                        loginController.picalogin(accountController.text,
                            passwordController.text, context);
                      },
                    ),
                    const SizedBox(height: 8),
                    if (loginController.error.isNotEmpty)
                      Text(
                        loginController.error.value.tr,
                        style: TextStyle(color: Colors.red),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 1),
            ],
          ).paddingTop(screenHeight(context) * 0.2);
        }
      }),
    );
  }
}
