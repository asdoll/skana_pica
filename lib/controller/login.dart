import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skana_pica/api/comic_sources/picacg/pica_api.dart';
import 'package:skana_pica/api/comic_sources/picacg/pica_source.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;
  var isLogin = false.obs;
  var error = "".obs;

  Future<bool> picalogin(String account, String password, BuildContext context) async {
    if(account.isEmpty || password.isEmpty) {
      error.value = "Please enter account and password";
      return false;
    }
    isLoading.value = true;
    picaClient.login(account, password).then((value) {
      if (value.error) {
        isLoading.value = false;
        isLogin.value = false;
        error.value = handleError(value.errorMessageWithoutNull);
        BotToast.showText(text: "Login failed".tr);
        return false;
      } else {
        picacg.data['token'] = value.data;
        picacg.data['account'] = account;
        picacg.data['password'] = password;
        picaClient.updateProfile().then((value) {});
        isLoading.value = false;
        isLogin.value = true;
        error.value = "";
        BotToast.showText(text: "Login success".tr);
        Get.back();
        return true;
      }
    });
    isLoading.value = false;
    isLogin.value = true;
    return false;
  }

  String handleError(String error) {
    if(error.contains("400")){
      return "Incorrect account or password";
    }
    if(error.contains("host")){
      return "Connection Failed. Please check your network";
    }
    if(error.contains("timeout")){
      return "Connection Timeout";
    }
    if(error.isEmpty){
      return "Unknown Error";
    }
    return error;
  }
}
