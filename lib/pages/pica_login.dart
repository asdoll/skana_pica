import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moon_design/moon_design.dart';
import 'package:skana_pica/controller/login.dart';
import 'package:skana_pica/pages/mainscreen.dart';
import 'package:skana_pica/util/widgetplugin.dart';

class PicaLoginPage extends StatefulWidget {
  static const route = "${Mains.route}picalogin";
  final bool start;
  const PicaLoginPage({super.key, this.start = false});

  @override
  State<StatefulWidget> createState() => _PicaLoginPageState();
}

class _PicaLoginPageState extends State<PicaLoginPage> {
  TextEditingController accountController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _hidePassword = true;

  @override
  Widget build(BuildContext context) {
    LoginController loginController = Get.put(LoginController());
    return Scaffold(
      appBar: appBar(title: "Login".tr),
      body: Obx(() {
        if (loginController.isLoading.isTrue) {
          return Center(
            child: CircularProgressIndicator(
              color: Get.theme.colorScheme.onPrimary,
            ),
          );
        } else {
          return Center(
            child: ListView(
              shrinkWrap: true,
              children: [
                Center(
                  child: moonCard(
                    title: "Login to your Pica Account".tr,
                    content: Column(
                      children: [
                        MoonTextInputGroup(
                    children: [
                      MoonFormTextInput(
                        textInputSize: MoonTextInputSize.lg,
                        controller: accountController,
                        hasFloatingLabel: true,
                        hintText: "Account".tr,
                        validator: (String? value) => value?.length != null 
                            ? "Please enter account and password".tr
                            : null,
                        onTapOutside: (PointerDownEvent _) =>
                            FocusManager.instance.primaryFocus?.unfocus(),
                        leading: const Icon(
                          MoonIcons.generic_search_24_light,
                          size: 24,
                        ),
                        trailing: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            child: const Icon(
                              MoonIcons.controls_close_small_24_light,
                              size: 24,
                            ),
                            onTap: () => accountController.clear(),
                          ),
                        ),
                      ),
                      MoonFormTextInput(
                        textInputSize: MoonTextInputSize.lg,
                        controller: passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: _hidePassword,
                        hasFloatingLabel: true,
                        hintText: "Password".tr,
                        validator: (String? value) => value?.length != null 
                            ? "Please enter account and password".tr
                            : null,
                        onTapOutside: (PointerDownEvent _) =>
                            FocusManager.instance.primaryFocus?.unfocus(),
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
                                  _hidePassword ? "Show" : "Hide",
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.grey,
                                  ),
                                ).underlineSmall(),
                              ),
                            ),
                            onTap: () =>
                                setState(() => _hidePassword = !_hidePassword),
                          ),
                        ),
                      ),
                    ],
                  ).paddingTop(16),
                        SizedBox(height: 16),
                        
                      ],
                    ),
                    actions: [filledButton(
                      onPressed: () {
                        loginController.picalogin(accountController.text,
                            passwordController.text, start: widget.start);
                      },
                      label: "Login".tr,
                    )]
                  ),
                ),
              ],
            )
          );
        }
      }),
    );
  }
}
