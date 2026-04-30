import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moon_design/moon_design.dart';
import 'package:skana_pica/controller/favourite.dart';
import 'package:skana_pica/widgets/icons.dart';

double iconSize = 30;

class PicaFavorButton extends ConsumerWidget {
  final String id;
  final bool filled;

  const PicaFavorButton(this.id, {super.key, this.filled = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MoonButton.icon(
          icon: ref.watch(favorProvider).isLoading &&
                  ref.watch(favorProvider).lastId == id
              ? SizedBox(
                  width: iconSize,
                  height: iconSize,
                  child: progressIndicator(context))
              : ref.watch(favorProvider).favorComics.contains(id)
                  ? Icon(
                      BootstrapIcons.bookmark_fill,
                      color: context.moonTheme?.tokens.colors.chichi,
                      size: iconSize,
                    )
                  : Icon(
                      filled ? BootstrapIcons.bookmark_fill : BootstrapIcons.bookmark,
                      size: iconSize,
                      color: filled? Colors.grey : null
                    ),
          onTap: () {
            ref.read(favorProvider.notifier).favorCall(id);
          },
        );
  }
}

class PicaLikeButton extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = likeProvider(isLike, isComment, id);
    return  MoonButton.icon(
          icon: ref.watch(provider).isLoading
              ? SizedBox(
                  width: size ?? iconSize, height: size ?? iconSize, child: progressIndicator(context))
              : ref.watch(provider).isLike
                  ? Icon(
                      BootstrapIcons.heart_fill,
                      color: context.moonTheme?.tokens.colors.chichi,
                      size: size ?? iconSize,
                    )
                    : Icon(
                      BootstrapIcons.heart,
                      size: size ?? iconSize,
                    ),
          onTap: () {
            if (isComment) {
              ref.read(provider.notifier).commentLikeCall(id,
                  commentComicId: isReply ? null : commentComicId,
                  commentId: isReply ? commentComicId : null);
            } else {
              ref.read(provider.notifier).likeCall(id);
            }
          },
        );
  }
}