import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:skana_pica/api/comic_sources/picacg/pica_api.dart';
import 'package:skana_pica/api/comic_sources/picacg/pica_source.dart';
import 'package:skana_pica/util/leaders.dart';
import 'package:skana_pica/util/translate.dart';

part 'login_store.g.dart';

class LoginStore = _LoginStore with _$LoginStore;

abstract class _LoginStore with Store {
  @observable
  bool isLoading = false;

  @observable
  bool isLogin = false;

  @action
  Future<bool> picalogin(String account, String password, BuildContext context) async {
    isLoading = true;
    picaClient.login(account, password).then((value) {
      if (value.error) {
        isLoading = false;
        isLogin = false;
        BotToast.showText(text: S.of(context).loginFailed);
        return false;
      } else {
        picacg.data['token'] = value.data;
        picacg.data['account'] = account;
        picacg.data['password'] = password;
        picaClient.updateProfile().then((value) {});
        isLoading = false;
        isLogin = true;
        BotToast.showText(text: S.of(context).loginSuccess);
        Leader.pop(context);
        return true;
      }
    });
    isLoading = false;
    isLogin = true;
    return false;
  }
}
