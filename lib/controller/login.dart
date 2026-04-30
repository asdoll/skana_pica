import 'package:easy_localization/easy_localization.dart' show StringTranslateExtension;
import 'package:skana_pica/api/comic_sources/picacg/pica_api.dart';
import 'package:skana_pica/api/comic_sources/picacg/pica_source.dart';
import 'package:skana_pica/controller/favourite.dart';
import 'package:skana_pica/controller/profile.dart';
import 'package:skana_pica/util/leaders.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login.freezed.dart';
part 'login.g.dart';

@freezed
abstract class LogingState with _$LogingState {
  factory LogingState({
    @Default(false) bool isLoading,
    @Default(false) bool isLogin,
    @Default("") String error,
    @Default(false) bool hideOldPassword,
    @Default(false) bool hideNewPassword,
    @Default(false) bool hideConfirmPassword,
  }) = _LogingState;
}

@riverpod
class Login extends _$Login {
  @override
  LogingState build() {
    return LogingState(
        isLogin:
            picacg.data['token'] != null && picacg.data['token'].isNotEmpty);
  }

  void setHideOP() => state = state.copyWith(hideOldPassword: !state.hideOldPassword);
  void setHideNP() => state = state.copyWith(hideNewPassword: !state.hideNewPassword);
  void setHideCP() => state = state.copyWith(hideConfirmPassword: !state.hideConfirmPassword);

  Future<bool> picalogin(String account, String password,
      {bool start = false}) async {
    if (account.isEmpty || password.isEmpty) {
      state = state.copyWith(error: "Please enter account and password");
      return false;
    }
    state = state.copyWith(isLoading: true);
    var value = await picaClient.login(account, password);
    if (value.error) {
      state = state.copyWith(
          isLoading: false,
          isLogin: false,
          error: handleError(value.errorMessageWithoutNull));
      showToast("login_failed".tr());
      return false;
    } else {
      picacg.data['token'] = value.data;
      picacg.data['account'] = account;
      picacg.data['password'] = password;
      picaClient.updateProfile();
      state = state.copyWith(isLoading: false, isLogin: true, error: "");
      showToast("login_success".tr());
      if (start) {
        ref.read(profileProvider.notifier).firstLaunchFinished();
      }
      ref.read(profileProvider.notifier).fetch();
      ref.read(favorProvider.notifier).fetch();
      return true;
    }
  }

  void init() {
    state = build();
  }

  String handleError(String error) {
    if (error.contains("400")) {
      return "Incorrect account or password";
    }
    if (error.contains("host")) {
      return "Connection Failed. Please check your network";
    }
    if (error.contains("timeout")) {
      return "Connection Timeout";
    }
    if (error.isEmpty) {
      return "Unknown Error";
    }
    return error;
  }

  void logout() {
    ref.read(profileProvider.notifier).logout();
    init();
  }
}
