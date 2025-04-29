import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moon_design/moon_design.dart';
import 'package:skana_pica/controller/favourite.dart';
import 'package:skana_pica/widgets/icons.dart';

double iconSize = 30;

class PicaFavorButton extends StatefulWidget {
  final String id;
  final bool filled;

  const PicaFavorButton(this.id, {super.key, this.filled = true});

  @override
  State<PicaFavorButton> createState() => _PicaFavorButtonState();
}

class _PicaFavorButtonState extends State<PicaFavorButton> {
  bool liked = false;

  @override
  Widget build(BuildContext context) {
    return Obx(() => MoonButton.icon(
          icon: favorController.isLoading.value &&
                  favorController.lastId.value == widget.id
              ? SizedBox(
                  width: iconSize,
                  height: iconSize,
                  child: progressIndicator(context))
              : favorController.favorComics.contains(widget.id)
                  ? Icon(
                      BootstrapIcons.bookmark_fill,
                      color: context.moonTheme?.tokens.colors.chichi,
                      size: iconSize,
                    )
                  : Icon(
                      widget.filled ? BootstrapIcons.bookmark_fill : BootstrapIcons.bookmark,
                      size: iconSize,
                      color: widget.filled? Colors.grey : null
                    ),
          onTap: () {
            favorController.favorCall(widget.id);
          },
        ));
  }
}

class PicaLikeButton extends StatefulWidget {
  final String id;
  final bool isLike;
  final double? size;
  final bool isComment;
  final String? commentComicId;
  final bool isReply;

  const PicaLikeButton(this.id,
      {super.key,
      required this.isLike,
      this.size,
      this.isComment = false,
      this.commentComicId,
      this.isReply = false});

  @override
  State<PicaLikeButton> createState() => _PicaLikeButtonState();
}

class _PicaLikeButtonState extends State<PicaLikeButton> {
  @override
  Widget build(BuildContext context) {
    LikeController likeController = Get.put(LikeController(),
        tag: widget.isComment ? "c${widget.id}" : widget.id);
    likeController.isLike.value = widget.isLike;
    double size = widget.size ?? iconSize;
    return Obx(() => MoonButton.icon(
          icon: likeController.isLoading.value
              ? SizedBox(
                  width: size, height: size, child: progressIndicator(context))
              : likeController.isLike.value
                  ? Icon(
                      BootstrapIcons.heart_fill,
                      color: context.moonTheme?.tokens.colors.chichi,
                      size: size,
                    )
                    : Icon(
                      BootstrapIcons.heart,
                      size: size,
                    ),
          onTap: () {
            if (widget.isComment) {
              likeController.commentLikeCall(widget.id,
                  commentComicId: widget.isReply ? null : widget.commentComicId,
                  commentId: widget.isReply ? widget.commentComicId : null);
            } else {
              likeController.likeCall(widget.id);
            }
          },
        ));
  }
}