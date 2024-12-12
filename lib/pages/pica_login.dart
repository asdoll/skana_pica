import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skana_pica/controller/login.dart';
import 'package:skana_pica/pages/mainscreen.dart';

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

  @override
  Widget build(BuildContext context) {
    LoginController loginController = Get.put(LoginController());
    return Scaffold(
      appBar: AppBar(
        title: Text("Login".tr),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (loginController.isLoading.isTrue) {
          return Center(
            child: CircularProgressIndicator(
              color: Get.theme.colorScheme.onPrimary,
            ),
          );
        } else {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          "Login".tr,
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Login to your Pica Account".tr,
                        ),
                        SizedBox(height: 16),
                        TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Account".tr,
                          ),
                          controller: accountController,
                        ),
                        SizedBox(height: 8),
                        TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Password".tr,
                          ),
                          controller: passwordController,
                          obscureText: true,
                          maxLines: 1,
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            loginController.picalogin(accountController.text,
                                passwordController.text, start: widget.start);
                          },
                          child: Text("Login".tr),
                        ),
                        SizedBox(height: 8),
                        if (loginController.error.isNotEmpty)
                          Text(
                            loginController.error.value.tr,
                            style: TextStyle(color: Colors.red),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      }),
    );
  }
}
