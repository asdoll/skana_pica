import 'package:get/get.dart';
import 'package:skana_pica/api/comic_sources/picacg/pica_api.dart';
import 'package:skana_pica/api/comic_sources/picacg/pica_models.dart';
import 'package:skana_pica/util/leaders.dart';

class ProfileController extends GetxController {
  Rx<PicaProfile> profile = PicaProfile.error().obs;
  RxBool loading = false.obs;

  void fetch() {
    loading.value = true;
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
}