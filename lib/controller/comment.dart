import 'package:easy_localization/easy_localization.dart' show StringTranslateExtension;
import 'package:skana_pica/api/comic_sources/picacg/pica_api.dart';
import 'package:skana_pica/api/comic_sources/picacg/pica_models.dart';
import 'package:skana_pica/controller/comicstore.dart';
import 'package:skana_pica/util/leaders.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'comment.freezed.dart';
part 'comment.g.dart';

@freezed
abstract class CommentState with _$CommentState {
  const factory CommentState({
    required PicaComment comment,
    @Default(false) bool isLoading,
    required PicaReply replies,
  }) = _CommentState;
}

@riverpod
class Comment extends _$Comment {
  @override
  CommentState build(String id) {
    return CommentState(comment: PicaComment.error(),replies: PicaReply("", 0, 0, []));
  }

  void init(PicaComment comment) {
    state = state.copyWith(
      comment: comment,
    );
    fetch();
  }

  Future<void> fetch() async {
    if (state.isLoading) {
      return;
    }
    final comment = state.comment;
    if (comment.isError()) {
      return;
    }
    state = state.copyWith(isLoading: true);
    picaClient.getReply(id).then((value) => state = state.copyWith(
          replies: value,
          isLoading: false,
        ));
  }

  Future<bool> loadMore() async {
    if (state.isLoading) {
      return true;
    }
    state = state.copyWith(isLoading: true);

    final replies = state.replies;
    if (replies.total > replies.loaded) {
      replies.loaded++;
    }

    picaClient.getMoreReply(replies).then((value) => state = state.copyWith(
          replies: replies,
          isLoading: false,
        ));

    return true;
  }
}

@riverpod
class ReplyController extends _$ReplyController {
  @override
  bool build(String id, bool isComic) {
    return false;
  }

  Future<void> reply(String content, {String? masterId}) async {
    if (state) {
      return;
    }

    state = true;

    final value = await picaClient.comment(id, content, !isComic);

    state = false;

    if (!value) {
      showToast("failed_to_reply".tr());
      return;
    }
    if (isComic) {
      ref
          .read(comicStoreProvider(id).notifier)
          .fetchComments();
    } else {
      if (masterId != null) {
        ref
            .read(
                comicStoreProvider(masterId).notifier)
            .fetchComments();
      }
      ref.read(commentProvider(id).notifier).fetch();
    }
  }
}
