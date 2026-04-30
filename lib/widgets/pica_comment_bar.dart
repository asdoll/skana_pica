import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:easy_localization/easy_localization.dart' show StringTranslateExtension;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moon_design/moon_design.dart';
import 'package:skana_pica/controller/comment.dart';
import 'package:skana_pica/util/widgetplugin.dart';

class PicaCommentBar extends HookConsumerWidget {
  final bool isComic;
  final String id;
  final String? masterId;

  const PicaCommentBar(this.id, {super.key, this.isComic = false, this.masterId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var replyProvider = replyControllerProvider(id,isComic);
    TextEditingController reply = TextEditingController();

    return MoonFormTextInput(
      controller: reply,
      hintText: "reply".tr(),
      onTapOutside: (PointerDownEvent _) => FocusManager.instance.primaryFocus?.unfocus(),
      padding: EdgeInsets.symmetric(horizontal: 8),
      trailing: MoonButton.icon(
          icon: Icon(BootstrapIcons.send),
          onTap: () {
            reply.text = reply.text.trim();
            if (reply.text.isEmpty) {
              return;
            }
            ref.read(replyProvider.notifier).reply(id, masterId: masterId);
          },
        )
    ).paddingHorizontal(8);
  }
}
