import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:skana_pica/api/comic_sources/picacg/pica_models.dart';
import 'package:skana_pica/api/managers/image_cache_manager.dart';
import 'package:skana_pica/pages/pica_replies.dart';
import 'package:skana_pica/util/leaders.dart';
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
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 16,
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
                      Text(
                        comment.name,
                        style: Get.theme.textTheme.bodyMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(DateFormat.yMMMd()
                          .format(DateTime.parse(comment.time))),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Text(
                      comment.text,
                      style: Get.theme.textTheme.bodyMedium,
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                ],
              ),
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
                  Text(comment.likes.toString()),
                  if (!isReply)
                    SizedBox(
                      width: 8,
                    ),
                  if (!isReply)
                    IconButton(
                      onPressed: () {
                        Go.to(
                            PicaRepliesPage(
                              comment: comment,
                              comicId: comicId,
                            ),
                            preventDuplicates: false);
                      },
                      icon: Icon(
                        Icons.mode_comment_rounded,
                        size: 16,
                      ),
                    ),
                  if (!isReply) Text(comment.reply.toString()),
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
