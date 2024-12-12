
import 'package:get/get.dart';
import 'package:skana_pica/api/comic_sources/picacg/pica_api.dart';
import 'package:skana_pica/api/comic_sources/picacg/pica_models.dart';
import 'package:skana_pica/api/comic_sources/picacg/pica_source.dart';
import 'package:skana_pica/config/setting.dart';
import 'package:skana_pica/controller/favourite.dart';
import 'package:skana_pica/util/leaders.dart';

late ProfileController profileController;

class ProfileController extends GetxController {
  Rx<PicaProfile> profile = PicaProfile.error().obs;
  RxBool loading = false.obs;
  RxBool isLogin = false.obs;
  RxBool isFirstLaunch = appdata.isFirstLaunch().obs;

  void fetch() {
    isLogin.value = picacg.data['token'] != null && picacg.data['token'].isNotEmpty;
    loading.value = true;
    if (picacg.data['token'] == null || picacg.data['token'].isEmpty) {
      loading.value = false;
      return;
    }
    picaClient.getProfile().then((value) {
      if (value.error) {
        loading.value = false;
        return;
      }
      profile.value = value.data;
      loading.value = false;
    });
    loading.value = false;
    profile.refresh();
  }

  void updateSlogan(String slogan) {
    picaClient.changeSlogan(slogan).then((value) {
      if (!value) {
        toast("Failed to update slogan".tr);
        return;
      }
      profile.value.slogan = slogan;
      profile.refresh();
    });
  }

  void updatePassword(String old, String password) {
    String? oldPassword = picacg.data['password'];
    if(oldPassword!= null && oldPassword.isNotEmpty && oldPassword != old){
      toast("Old password is incorrect".tr);
      return;
    }
    if(old == password){
      toast("New password is the same as the old password".tr);
      return;
    }
    picaClient.changePassword(old,password).then((value) {
      if (!value.data) {
        toast("Failed to update password".tr);
        return;
      }
      toast("Password updated".tr);
    });
  }
  
  void logout() {
    picacg.data['token'] = null;
    picacg.data['account'] = null;
    picacg.data['password'] = null;
    isLogin.value = false;
    loading.value = false;
    appdata.logout();
    profile.value = PicaProfile.error();
    profile.refresh();
    favorController.clear();
  }

  void firstLaunchFinished() {
    isFirstLaunch.value = false;
    appdata.firstLaunch();
  }
}