
import 'package:easy_localization/easy_localization.dart' show StringTranslateExtension;
import 'package:skana_pica/api/comic_sources/picacg/pica_api.dart';
import 'package:skana_pica/api/comic_sources/picacg/pica_models.dart';
import 'package:skana_pica/api/comic_sources/picacg/pica_source.dart';
import 'package:skana_pica/config/setting.dart';
import 'package:skana_pica/controller/favourite.dart';
import 'package:skana_pica/util/leaders.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

@freezed
abstract class ProfileState with _$ProfileState {
  factory ProfileState({
    @Default(false) bool isLoading,
    @Default(false) bool isLogin,
    @Default(false) bool isFirstLaunch,
    required PicaProfile profile,
  }) = _ProfileState;
}

@Riverpod(keepAlive: true)
class Profile extends _$Profile {
  @override
  ProfileState build() {
    return ProfileState(profile: PicaProfile.error(),isFirstLaunch: settings.isFirstLaunch());
  }

  void fetch() {
    state = state.copyWith(isLogin: picacg.data['token'] != null && picacg.data['token'].isNotEmpty);
    if (state.isLogin) {
      return;
    }
    state = state.copyWith(isLoading: true);
    picaClient.getProfile().then((value) {
      if (value.error) {
        state = state.copyWith(isLoading: false);
        return;
      }
      state = state.copyWith(profile: value.data, isLoading: false);
    });
  }

  void updateSlogan(String slogan) {
    picaClient.changeSlogan(slogan).then((value) {
      if (!value) {
        showToast("failed_to_update_slogan".tr());
        return;
      }
      var profile = state.profile;
      profile.slogan = slogan;
      state = state.copyWith(profile: profile);
    });
  }

  void updatePassword(String old, String password) {
    String? oldPassword = picacg.data['password'];
    if(oldPassword!= null && oldPassword.isNotEmpty && oldPassword != old){
      showToast("old_password_is_incorrect".tr());
      return;
    }
    if(old == password){
      showToast("new_password_is_the_same_as_the_old_password".tr());
      return;
    }
    picaClient.changePassword(old,password).then((value) {
      if (!value.data) {
        showToast("failed_to_update_password".tr());
        return;
      }
      showToast("password_updated".tr());
    });
  }
  
  void logout() {
    picacg.data['token'] = null;
    picacg.data['account'] = null;
    picacg.data['password'] = null;
    settings.logout();
    state = state.copyWith(profile: PicaProfile.error(),isLoading: false,isLogin: false);
    ref.read(favorProvider.notifier).clear();
  }

  void firstLaunchFinished() {
    state = state.copyWith(isFirstLaunch: false);
    settings.firstLaunch();
  }
}