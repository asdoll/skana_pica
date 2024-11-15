import 'package:flutter/material.dart';

import 'package:forui/forui.dart';
import 'package:skana_pica/controller/login_store.dart';
import 'package:skana_pica/util/leaders.dart';
import 'package:skana_pica/util/translate.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:skana_pica/util/widget_utils.dart';

class PicaLoginPage extends StatelessWidget {
  PicaLoginPage({super.key});

  LoginStore loginStore = LoginStore();
  TextEditingController accountController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader.nested(
        title: Text(S.of(context).pica_login),
        prefixActions: [FHeaderAction.back(onPress: () => Leader.pop(context))],
      ),
      content: Observer(builder: (context) {
        if (loginStore.isLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Column(
            children: [
              FCard(
                title: Text(S.of(context).login),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    FTextField(
                      label: Text(S.of(context).account),
                      controller: accountController,
                    ),
                    const SizedBox(height: 16),
                    FTextField(
                      label: Text(S.of(context).password),
                      controller: passwordController,
                      obscureText: true,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 26),
                    FButton(
                      label: Text(S.of(context).login),
                      onPress: () {
                        loginStore
                            .picalogin(accountController.text,
                                passwordController.text, context);
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 1),
            ],
          );
        }
      }).paddingTop(screenHeight(context) * 0.15),
    );
  }
}
