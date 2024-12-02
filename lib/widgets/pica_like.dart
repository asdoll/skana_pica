import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skana_pica/controller/favourite.dart';

double _iconSize = 30;

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
                  width: _iconSize,
                  height: _iconSize,
                  child: CircularProgressIndicator())
              : favorController.favorComics.contains(widget.id)
                  ? Icon(
                      Icons.bookmark,
                      color: Colors.red,
                      size: _iconSize,
                    )
                  : Icon(
                      Icons.bookmark_border,
                      size: _iconSize,
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

  const PicaLikeButton(this.id, {super.key, required this.isLike});

  @override
  State<PicaLikeButton> createState() => _PicaLikeButtonState();
}

class _PicaLikeButtonState extends State<PicaLikeButton> {
  @override
  Widget build(BuildContext context) {
    LikeController likeController = Get.put(LikeController(), tag: widget.id);
    likeController.isLike.value = widget.isLike;
    return Obx(() => IconButton(
          icon: likeController.isLoading.value
              ? SizedBox(
                  width: _iconSize,
                  height: _iconSize,
                  child: CircularProgressIndicator())
              : likeController.isLike.value
                  ? Icon(
                      Icons.favorite_rounded,
                      color: Colors.red,
                      size: _iconSize,
                    )
                  : Icon(
                      Icons.favorite_border_rounded,
                      size: _iconSize,
                    ),
          onPressed: () {
            likeController.likeCall(widget.id);
          },
        ));
  }
}

class PicaDownloadButton extends StatefulWidget {
  final String id;

  const PicaDownloadButton(this.id, {super.key});

  @override
  State<PicaDownloadButton> createState() => _PicaDownloadButtonState();
}

class _PicaDownloadButtonState extends State<PicaDownloadButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.download_rounded, size: _iconSize), onPressed: () {});
  }
}
