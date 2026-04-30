import 'package:easy_localization/easy_localization.dart'
    show StringTranslateExtension;
import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moon_design/moon_design.dart';
import 'package:skana_pica/controller/login.dart';
import 'package:skana_pica/pages/mainscreen.dart';
import 'package:skana_pica/util/leaders.dart';
import 'package:skana_pica/util/widgetplugin.dart';
import 'package:skana_pica/widgets/icons.dart';

class PicaLoginPage extends StatefulHookConsumerWidget {
  static const route = "${Mains.route}picalogin";
  final bool start;
  const PicaLoginPage({super.key, this.start = false});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PicaLoginPageState();
}

class _PicaLoginPageState extends ConsumerState<PicaLoginPage> {
  TextEditingController accountController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _hidePassword = true;

  @override
  Widget build(BuildContext context) {
    ref.listen(loginProvider, (prev, next) {
      if (next.isLogin) {
        Navigator.pop(context);
      }
    });
    return Scaffold(
        appBar: appBar(title: "login".tr()),
        body: (ref.watch(loginProvider).isLoading)
            ? Center(
                child: progressIndicator(context),
              )
            : Center(
                child: ListView(
                shrinkWrap: true,
                children: [
                  Center(
                    child: moonCard(
                        title: "login_to_your_pica_account".tr(),
                        content: Column(
                          children: [
                            MoonTextInputGroup(
                              children: [
                                MoonFormTextInput(
                                  textInputSize: MoonTextInputSize.lg,
                                  controller: accountController,
                                  hasFloatingLabel: true,
                                  hintText: "account".tr(),
                                  onTapOutside: (PointerDownEvent _) =>
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus(),
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
                                  hintText: "password".tr(),
                                  onTapOutside: (PointerDownEvent _) =>
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus(),
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
                                            _hidePassword
                                                ? "show".tr()
                                                : "hide".tr(),
                                            style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
                                              color: Colors.grey,
                                            ),
                                          ).underlineSmall(),
                                        ),
                                      ),
                                      onTap: () => setState(
                                          () => _hidePassword = !_hidePassword),
                                    ),
                                  ),
                                ),
                              ],
                            ).paddingTop(16),
                            SizedBox(height: 16),
                          ],
                        ),
                        actions: [
                          filledButton(
                            onPressed: () async {
                              if (accountController.text.isEmpty ||
                                  passwordController.text.isEmpty) {
                                showToast(
                                    "please_enter_account_and_password".tr());
                                return;
                              }
                              ref.read(loginProvider.notifier).picalogin(
                                  accountController.text,
                                  passwordController.text,
                                  start: widget.start);
                            },
                            label: "login".tr(),
                          )
                        ]),
                  ),
                ],
              )));
  }
}
