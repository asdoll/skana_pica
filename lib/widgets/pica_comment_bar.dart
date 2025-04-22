import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moon_design/moon_design.dart';
import 'package:skana_pica/controller/comment.dart';

class PicaCommentBar extends StatelessWidget {
  final bool isComic;
  final String id;
  final String? masterId;

  const PicaCommentBar(this.id, {super.key, this.isComic = false, this.masterId});

  @override
  Widget build(BuildContext context) {
    ReplyController replyController =
        Get.put(ReplyController(), tag: id + isComic.toString());
    TextEditingController reply = TextEditingController();

    return MoonFormTextInput(
      controller: reply,
      hintText: "Reply:".tr,
      trailing: MoonButton.icon(
          icon: Icon(BootstrapIcons.send),
          onTap: () {
            replyController.reply(id, reply.text, isComic, masterId: masterId);
          },
        )
    );
  }
}
