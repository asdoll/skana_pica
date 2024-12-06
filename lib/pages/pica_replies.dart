import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:skana_pica/api/comic_sources/picacg/pica_models.dart';
import 'package:skana_pica/api/managers/image_cache_manager.dart';
import 'package:skana_pica/controller/comment.dart';
import 'package:skana_pica/pages/pica_comments.dart';
import 'package:skana_pica/widgets/pica_comment_bar.dart';
import 'package:skana_pica/widgets/pica_comment_tile.dart';

class PicaRepliesPage extends StatefulWidget {
  static const route = "${PicaCommentsPage.route}pica_replies";
  final PicaComment comment;
  final String? comicId;

  const PicaRepliesPage(
      {super.key, required this.comment, required this.comicId});

  @override
  State<PicaRepliesPage> createState() => _PicaRepliesPageState();
}

class _PicaRepliesPageState extends State<PicaRepliesPage> {
  PicaComment get comment => widget.comment;
  @override
  Widget build(BuildContext context) {
    CommentController commentController =
        Get.put(CommentController(), tag: widget.comment.id);
    commentController.init(comment, widget.comicId ?? "");

    return Scaffold(
      appBar: AppBar(
        title: Text("Replies".tr),
      ),
      body: Obx(() => CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
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
                      width: 16,
                    ),
                  ],
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index ==
                            commentController.replies.value.comments.length -
                                1 &&
                        commentController.replies.value.loaded <
                            commentController.replies.value.total) {
                      commentController.loadMore();
                    }
                    return PicaCommentTile(
                      comment: commentController.replies.value.comments[index],
                      comicId: widget.comicId,
                      isReply: true,
                      parentComment: comment.id,
                    );
                  },
                  childCount: commentController.replies.value.comments.length,
                ),
              ),
            ],
          )),
      bottomNavigationBar:  PicaCommentBar(widget.comment.id,isComic: false,masterId: widget.comicId,).paddingOnly(bottom: 25),
    );
  }
}
