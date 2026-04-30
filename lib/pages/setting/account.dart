import 'package:bootstrap_icons/bootstrap_icons.dart' show BootstrapIcons;
import 'package:easy_localization/easy_localization.dart'
    show StringTranslateExtension;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:moon_design/moon_design.dart';
import 'package:skana_pica/controller/login.dart';
import 'package:skana_pica/controller/profile.dart';
import 'package:skana_pica/pages/pica_login.dart';
import 'package:skana_pica/util/leaders.dart';
import 'package:skana_pica/util/widgetplugin.dart';

class AccountPage extends StatefulHookConsumerWidget {
  const AccountPage({super.key});

  @override
  ConsumerState<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends ConsumerState<AccountPage> {
  @override
  Widget build(BuildContext context) {
    ref.read(loginProvider.notifier).init();
    if (ref.read(loginProvider).isLogin &&
        ref.read(profileProvider).profile.name.isEmpty) {
      ref.read(profileProvider.notifier).fetch();
    }
    return Scaffold(
        appBar: appBar(
          title: "account".tr(),
        ),
        body: (ref.watch(profileProvider).isLoading)
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                children: [
                  SizedBox(height: 16),
                  if (!ref.watch(loginProvider).isLogin)
                    moonListTile(
                      title: "login".tr(),
                      trailing: Icon(BootstrapIcons.box_arrow_in_left),
                      onTap: () {
                        Go.to(PicaLoginPage());
                      },
                    ),
                  if (ref.watch(loginProvider).isLogin)
                    moonListTile(
                      title: "username".tr(),
                      subtitle: ref.watch(profileProvider).profile.name,
                    ),
                  // TODO: Avatar change
                  // if(ref.watch(loginProvider).isLogin)
                  //   ListTile(
                  //     title: Text("Avatar".tr()),
                  //     subtitle: Text("Click to change avatar".tr()),
                  //     trailing: CircleAvatar(
                  //       backgroundImage: NetworkImage(ref.watch(profileProvider).profile.avatarUrl),
                  //       radius: 20,
                  //     ),
                  //     onTap: (){

                  //     }
                  //   ),
                  if (ref.watch(loginProvider).isLogin)
                    moonListTile(
                      title: "email".tr(),
                      subtitle: ref.watch(profileProvider).profile.email,
                    ),
                  if (ref.watch(loginProvider).isLogin)
                    moonListTile(
                      title: "level".tr(),
                      subtitle:
                          "(Lv. ${ref.watch(profileProvider).profile.level}) (${ref.watch(profileProvider).profile.title})",
                    ),
                  if (ref.watch(loginProvider).isLogin)
                    moonListTile(
                      title: "${"slogan".tr()}(${"tap_to_change".tr()})",
                      subtitle: ref.watch(profileProvider).profile.slogan ?? "",
                      onTap: () {
                        showMoonModal(
                            context: context,
                            builder: (context) {
                              TextEditingController controller =
                                  TextEditingController();
                              return Dialog(
                                  child: ListView(
                                shrinkWrap: true,
                                children: [
                                  MoonAlert(
                                      borderColor: context.moonTheme
                                          ?.buttonTheme.colors.borderColor
                                          .withValues(alpha: 0.5),
                                      showBorder: true,
                                      label: Text("slogan".tr()).header(),
                                      verticalGap: 16,
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          MoonTextInput(
                                            controller: controller,
                                            hintText: "slogan".tr(),
                                          ).paddingBottom(16),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              outlinedButton(
                                                      label: "cancel".tr(),
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context))
                                                  .paddingRight(8),
                                              filledButton(
                                                  label: "save".tr(),
                                                  onPressed: () {
                                                    FocusManager
                                                        .instance.primaryFocus
                                                        ?.unfocus();
                                                    if (controller.text
                                                        .trim()
                                                        .isEmpty) {
                                                      showToast(
                                                          "slogan_cant_be_empty"
                                                              .tr());
                                                      return;
                                                    }
                                                    ref.read(profileProvider.notifier)
                                                        .updateSlogan(
                                                            controller.text);
                                                    Navigator.of(context).pop();
                                                  }).paddingRight(8)
                                            ],
                                          ),
                                        ],
                                      )),
                                ],
                              ));
                            });
                      },
                    ),
                  if (ref.watch(loginProvider).isLogin)
                    moonListTile(
                        title: "change_password".tr(),
                        onTap: () {
                          showMoonModal(
                              context: context,
                              builder: (context) {
                                TextEditingController oldPasswordController =
                                    TextEditingController();
                                TextEditingController newPasswordController =
                                    TextEditingController();
                                TextEditingController
                                    confirmPasswordController =
                                    TextEditingController();
                                return Dialog(
                                        child: ListView(
                                            shrinkWrap: true,
                                            children: [
                                          MoonAlert(
                                            label: Text("change_password".tr())
                                                .header(),
                                            verticalGap: 16,
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                MoonTextInput(
                                                  controller:
                                                      oldPasswordController,
                                                  hintText: "old_password".tr(),
                                                  keyboardType: TextInputType
                                                      .visiblePassword,
                                                  obscureText: ref.watch(loginProvider)
                                                      .hideOldPassword,
                                                  hasFloatingLabel: true,
                                                  onTapOutside:
                                                      (PointerDownEvent _) =>
                                                          FocusManager.instance
                                                              .primaryFocus
                                                              ?.unfocus(),
                                                  leading: const Icon(
                                                    MoonIcons
                                                        .security_password_24_light,
                                                    size: 24,
                                                  ),
                                                  trailing: MouseRegion(
                                                    cursor: SystemMouseCursors
                                                        .click,
                                                    child: GestureDetector(
                                                      child: IntrinsicWidth(
                                                        child: Align(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child: Text(
                                                            ref.watch(loginProvider)
                                                                    .hideOldPassword
                                                                    
                                                                ? "show".tr()
                                                                : "hide".tr(),
                                                            style: TextStyle(
                                                              decoration:
                                                                  TextDecoration
                                                                      .underline,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ).underlineSmall(),
                                                        ),
                                                      ),
                                                      onTap: () => setState(
                                                          () => ref.read(loginProvider.notifier).setHideOP(),)
                                                    ),
                                                  ),
                                                ).paddingBottom(8),
                                                MoonTextInput(
                                                  controller:
                                                      newPasswordController,
                                                  hintText: "new_password".tr(),
                                                  obscureText: ref.watch(loginProvider)
                                                      .hideNewPassword,
                                                  leading: const Icon(
                                                    MoonIcons
                                                        .security_password_24_light,
                                                    size: 24,
                                                  ),
                                                  trailing: MouseRegion(
                                                    cursor: SystemMouseCursors
                                                        .click,
                                                    child: GestureDetector(
                                                      child: IntrinsicWidth(
                                                        child: Align(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child: Text(
                                                            ref.watch(loginProvider)
                                                                    .hideNewPassword
                                                                ? "show".tr()
                                                                : "hide".tr(),
                                                            style: TextStyle(
                                                              decoration:
                                                                  TextDecoration
                                                                      .underline,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ).underlineSmall(),
                                                        ),
                                                      ),
                                                      onTap: () => setState(
                                                          () => ref.read(loginProvider.notifier).setHideNP()),
                                                    ),
                                                  ),
                                                ).paddingBottom(8),
                                                MoonTextInput(
                                                  controller:
                                                      confirmPasswordController,
                                                  hintText:
                                                      "confirm_password".tr(),
                                                  obscureText: ref.watch(loginProvider)
                                                      .hideConfirmPassword,
                                                  leading: const Icon(
                                                    MoonIcons
                                                        .security_password_24_light,
                                                    size: 24,
                                                  ),
                                                  trailing: MouseRegion(
                                                    cursor: SystemMouseCursors
                                                        .click,
                                                    child: GestureDetector(
                                                      child: IntrinsicWidth(
                                                        child: Align(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child: Text(
                                                            ref.watch(loginProvider)
                                                                    .hideConfirmPassword
                                                                ? "show".tr()
                                                                : "hide".tr(),
                                                            style: TextStyle(
                                                              decoration:
                                                                  TextDecoration
                                                                      .underline,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ).underlineSmall(),
                                                        ),
                                                      ),
                                                      onTap: () => setState(
                                                          () => ref.read(loginProvider.notifier).setHideCP()),
                                                    ),
                                                  ),
                                                ).paddingBottom(16),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    outlinedButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      label: "cancel".tr(),
                                                    ).paddingRight(8),
                                                    filledButton(
                                                      onPressed: () {
                                                        if (oldPasswordController.text.isEmpty ||
                                                            newPasswordController
                                                                .text.isEmpty ||
                                                            confirmPasswordController
                                                                .text.isEmpty) {
                                                          showToast(
                                                              "password_cant_be_empty"
                                                                  .tr());
                                                          return;
                                                        }
                                                        if (newPasswordController
                                                                .text !=
                                                            confirmPasswordController
                                                                .text) {
                                                          showToast(
                                                              "password_not_match"
                                                                  .tr());
                                                          return;
                                                        }
                                                        Navigator.pop(context);
                                                        ref.read(profileProvider.notifier)
                                                            .updatePassword(
                                                                oldPasswordController
                                                                    .text,
                                                                newPasswordController
                                                                    .text);
                                                      },
                                                      label: "change".tr(),
                                                    ).paddingRight(8),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )
                                        ]));
                              });
                        }),
                  if (ref.watch(loginProvider).isLogin)
                    moonListTile(
                      title: "logout".tr(),
                      trailing: Icon(BootstrapIcons.box_arrow_in_right),
                      onTap: () {
                        alertDialog(context, "logout".tr(),
                            "are_you_sure_to_logout".tr(), [
                          outlinedButton(
                            label: "cancel".tr(),
                            onPressed: () => Navigator.pop(context),
                          ),
                          filledButton(
                            label: "logout".tr(),
                            onPressed: () => ref.read(loginProvider.notifier).logout(),
                          ),
                        ]);
                      },
                    ),
                ],
              ));
  }
}
