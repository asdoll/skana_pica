import 'package:easy_localization/easy_localization.dart' show StringTranslateExtension, BuildContextEasyLocalizationExtension;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:intl/intl.dart';
import 'package:moon_design/moon_design.dart';
import 'package:skana_pica/api/comic_sources/picacg/pica_models.dart';
import 'package:skana_pica/api/managers/image_cache_manager.dart';
import 'package:skana_pica/controller/comment.dart';
import 'package:skana_pica/pages/pica_comments.dart';
import 'package:skana_pica/util/widgetplugin.dart';
import 'package:skana_pica/widgets/pica_comment_bar.dart';
import 'package:skana_pica/widgets/pica_comment_tile.dart';

class PicaRepliesPage extends StatefulHookConsumerWidget {
  static const route = "${PicaCommentsPage.route}pica_replies";
  final PicaComment comment;
  final String? comicId;

  const PicaRepliesPage(
      {super.key, required this.comment, required this.comicId});

  @override
  ConsumerState<PicaRepliesPage> createState() => _PicaRepliesPageState();
}

class _PicaRepliesPageState extends ConsumerState<PicaRepliesPage> {
  PicaComment get comment => widget.comment;
  @override
  Widget build(BuildContext context) {
    var cProvider = commentProvider(comment.id);
    ref.read(cProvider.notifier).init(comment);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: appBar(title: "replies".tr()),
      backgroundColor: context.moonTheme?.tokens.colors.gohan,
      body: Column(
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
                backgroundImage: AssetImage("assets/images/avatar/default.png"),
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
                  Text(DateFormat.yMMMd(context.locale.toString())
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
            height: 16,
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
                itemCount: ref.watch(cProvider).replies.comments.length,
                itemBuilder: (context, index) {
                  if (index ==
                            ref.read(cProvider).replies.comments.length -
                                1 &&
                        ref.read(cProvider).replies.loaded <
                            ref.read(cProvider).replies.total) {
                      ref.read(cProvider.notifier).loadMore();
                    }
                    return PicaCommentTile(
                      comment: ref.watch(cProvider).replies.comments[index],
                      comicId: widget.comicId,
                      isReply: true,
                      parentComment: comment.id,
                    );
                  },
                ),
              ),
          PicaCommentBar(
            widget.comment.id,
            isComic: false,
            masterId: widget.comicId,
          ).paddingOnly(bottom: 25),
        ],
      ),
    );
  }
}
