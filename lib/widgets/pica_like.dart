import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skana_pica/controller/favourite.dart';

double iconSize = 30;

class PicaFavorButton extends StatefulWidget {
  final String id;

  const PicaFavorButton(this.id, {super.key});

  @override
  State<PicaFavorButton> createState() => _PicaFavorButtonState();
}

class _PicaFavorButtonState extends State<PicaFavorButton> {
  bool liked = false;

  @override
  Widget build(BuildContext context) {
    return Obx(() => IconButton(
          icon: favorController.isLoading.value &&
                  favorController.lastId.value == widget.id
              ? SizedBox(
                  width: iconSize,
                  height: iconSize,
                  child: CircularProgressIndicator())
              : favorController.favorComics.contains(widget.id)
                  ? Icon(
                      Icons.bookmark,
                      color: Colors.red,
                      size: iconSize,
                    )
                  : Icon(
                      Icons.bookmark_border,
                      size: iconSize,
                    ),
          onPressed: () {
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
    return Obx(() => IconButton(
          icon: likeController.isLoading.value
              ? SizedBox(
                  width: size, height: size, child: CircularProgressIndicator())
              : likeController.isLike.value
                  ? Icon(
                      Icons.favorite_rounded,
                      color: Colors.red,
                      size: size,
                    )
                  : Icon(
                      Icons.favorite_border_rounded,
                      size: size,
                    ),
          onPressed: () {
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