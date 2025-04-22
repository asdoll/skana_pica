import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:moon_design/moon_design.dart';
import 'package:skana_pica/api/comic_sources/picacg/pica_models.dart';
import 'package:skana_pica/api/managers/image_cache_manager.dart';
import 'package:skana_pica/pages/pica_replies.dart';
import 'package:skana_pica/util/leaders.dart';
import 'package:skana_pica/util/widgetplugin.dart';
import 'package:skana_pica/widgets/pica_like.dart';

class PicaCommentTile extends StatelessWidget {
  final PicaComment comment;
  final String? comicId;
  final bool isReply;
  final String? parentComment;

  const PicaCommentTile(
      {super.key,
      required this.comment,
      this.comicId,
      this.isReply = false,
      this.parentComment});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
        child: moonCard(
          backgroundColor: context.moonTheme?.tokens.colors.frieza10,
          padding: EdgeInsets.all(0),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 8,
                  ),
                  CircleAvatar(
                    backgroundImage:
                        AssetImage("assets/images/avatar/default.png"),
                    foregroundImage: imageProvider(comment.avatarUrl),
                    radius: 20,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(comment.name).appHeader(),
                      Text(DateFormat.yMMMd(Get.locale.toString())
                              .format(DateTime.parse(comment.time)))
                          .small(),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Text(comment.text).subHeader().paddingHorizontal(20),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  PicaLikeButton(
                    comment.id,
                    isLike: comment.isLiked,
                    size: 16,
                    isComment: true,
                    isReply: isReply,
                    commentComicId: isReply ? parentComment : comicId,
                  ),
                  Text(comment.likes.toString()).subHeader(),
                  if (!isReply)
                    SizedBox(
                      width: 8,
                    ),
                  if (!isReply)
                    MoonButton.icon(
                      onTap: () {
                        Go.to(
                            PicaRepliesPage(
                              comment: comment,
                              comicId: comicId,
                            ),
                            preventDuplicates: false);
                      },
                      icon: Icon(
                        BootstrapIcons.chat_square_text,
                        size: 16,
                      ),
                    ),
                  if (!isReply) Text(comment.reply.toString()).subHeader(),
                  SizedBox(
                    width: 16,
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
