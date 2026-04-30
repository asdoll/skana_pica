import 'package:easy_localization/easy_localization.dart' show StringTranslateExtension;
import 'package:skana_pica/api/comic_sources/picacg/pica_api.dart';
import 'package:skana_pica/api/comic_sources/picacg/pica_models.dart';
import 'package:skana_pica/config/setting.dart';
import 'package:skana_pica/controller/comicstore.dart';
import 'package:skana_pica/controller/comment.dart';
import 'package:skana_pica/util/leaders.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'favourite.freezed.dart';
part 'favourite.g.dart';

@freezed
abstract class FavorState with _$FavorState {
  const factory FavorState({
    @Default([]) List<String> favorComics,
    @Default(false) bool isLoading,
    @Default("") String lastId,
    @Default("") String sort,
  }) = _FavorState;
}

@Riverpod(keepAlive: true)
class Favor extends _$Favor {
  @override
  FavorState build() {
    fetch();
    return const FavorState();
  }

  void addFavor(String id, [bool unload = false]) {
    if (state.favorComics.contains(id)) {
      return;
    }
    var comics = List<String>.from(state.favorComics);
    comics.add(id);
    if (unload) {
      state = state.copyWith(favorComics: comics, isLoading: false);
    } else {
      state = state.copyWith(favorComics: comics);
    }
  }

  void removeFavor(String id, [bool unload = false]) {
    if (!state.favorComics.contains(id)) {
      return;
    }
    var comics = List<String>.from(state.favorComics);
    comics.remove(id);
    if (unload) {
      state = state.copyWith(favorComics: comics, isLoading: false);
    } else {
      state = state.copyWith(favorComics: comics);
    }
  }

  void loading([String? id]) {
    state = state.copyWith(isLoading: true, lastId: id ?? state.lastId);
  }

  void unloading() {
    state = state.copyWith(isLoading: false);
  }

  Future<void> favorCall(String id) async {
    if (state.isLoading && state.lastId == id) {
      return;
    }
    loading(id);
    bool isFavor = state.favorComics.contains(id);
    var value = await picaClient.favouriteOrUnfavouriteComic(id);
    if (value) {
      if (isFavor) {
        removeFavor(id, true);
      } else {
        addFavor(id, true);
      }
      return;
    }
    showToast("network_error".tr());
    unloading();
  }

  Future<void> fetch({bool init = false}) async {
    if (state.isLoading) return;
    List<String> comics = [];
    int pages = 1;
    state = state.copyWith(isLoading: true);

    final first = await picaClient.getFavorites(1, settings.pica[4] != "da");

    if (first.error) {
      showToast(first.errorMessageWithoutNull);
      return;
    }
    pages = first.subData ?? 1;

    final results = await Future.wait(
      [
        for (int i = 2; i <= pages; i++)
          picaClient.getFavorites(i, settings.pica[4] != "da")
      ],
    );

    comics = <String>[
      for (final e in first.data) e.id,
    ];

    for (final value in results) {
      if (value.error) {
        showToast(value.errorMessageWithoutNull);
        continue;
      }
      for (final e in value.data) {
        comics.add(e.id);
      }
    }
    state = state.copyWith(favorComics: comics, isLoading: false);
  }

  void addList(List<PicaComicItemBrief> list) {
    state = state.copyWith(favorComics: list.map((l) => l.id).toList());
  }

  void clear() {
    state = state.copyWith(
        favorComics: [],
        isLoading: false,
        lastId: "",
        sort: settings.pica[4] == "da" ? "da" : "dd");
  }
}

@freezed
abstract class LikeState with _$LikeState {
  const factory LikeState(
      {@Default(false) bool isLike,
      @Default(false) bool isLoading,
      required String id,
      @Default(false) bool isComment}) = _LikeState;
}

@riverpod
class Like extends _$Like {
  @override
  LikeState build(bool isLike, bool isComment, String id) {
    return LikeState(isLike: isLike, isComment: isComment, id: id);
  }

  bool likeCall(String id) {
    if (state.isLoading) {
      return false;
    }
    state = state.copyWith(isLoading: true);
    picaClient.likeOrUnlikeComic(id).then((value) {
      if (!value) {
        showToast("network_error".tr());
        state = state.copyWith(isLoading: false);
        return false;
      }
      state = state.copyWith(isLike: !state.isLike, isLoading: false);
    });
    return true;
  }

  bool commentLikeCall(String id, {String? commentComicId, String? commentId}) {
    if (state.isLoading) {
      return false;
    }
    state = state.copyWith(isLoading: true);
    picaClient.likeOrUnlikeComment(id).then((value) {
      if (!value) {
        showToast("network_error".tr());
        state = state.copyWith(isLoading: false);
        return;
      }
      state = state.copyWith(isLike: !state.isLike);
      if (commentComicId != null) {
        if (ref.exists(comicStoreProvider(commentComicId))) {
          ref.read(comicStoreProvider(commentComicId).notifier).fetchComments();
        }
      }
      if (commentId != null) {
        if (ref.exists(commentProvider(commentId))) {
          ref.read(commentProvider(commentId).notifier).fetch();
        }
      }
      state = state.copyWith(isLoading: false);
    });

    return true;
  }
}
