import 'package:skana_pica/api/comic_sources/picacg/pica_api.dart';
import 'package:skana_pica/api/comic_sources/picacg/pica_models.dart';
import 'package:skana_pica/api/managers/history_manager.dart';
import 'package:skana_pica/api/models/objectbox_models.dart';
import 'package:skana_pica/config/setting.dart' show settings;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'history.freezed.dart';
part 'history.g.dart';

@freezed
abstract class HistoryState with _$HistoryState {

  const factory HistoryState({
    @Default([]) List<VisitHistory> history,
    @Default([]) List<PicaComicItemBrief> comics,
    @Default(0) int total,
    @Default(false) bool isLoading,
    @Default(10) int perPage,
    @Default(0) int page,
    @Default(0) int totalPage,
  }) = _HistoryState;
}

@riverpod
class History extends _$History {
  @override
  HistoryState build() {
    return const HistoryState();
  }

  Future<bool> init() async {
    if (state.isLoading) {
      return false;
    }
    state = state.copyWith(isLoading: true);
    var count = await M.o.getVisitHistoryCount();
    var val = await M.o.getVisitHistoryByOffset(0, state.perPage);
    state = state.copyWith(total: count, totalPage: (count/ state.perPage).ceil(), history: val);
    fetchComic();
    return true;
  }

  // next page if index is -1
  Future<bool> toPage({int index = -1}) async {
    //log.d("index: $index, totalPage: ${totalPage.value}");
    if (state.isLoading) {
      return false;
    }
    if (index >= state.totalPage) {
      return false;
    }
    if (index != -1) {
      state = state.copyWith(page: index);
    } else {
      if (state.page + 1 >= state.totalPage) {
        return false;
      }
      state = state.copyWith(page: state.page + 1);
    }
    state = state.copyWith(isLoading: true);
    var value =
        await M.o.getVisitHistoryByOffset(state.page * state.perPage, state.perPage);
    state = state.copyWith(history: value);
    fetchComic();
    return true;
  }

  Future<bool> fetchComic() async {
    var comics = await Future.wait(
    state.history.map((history) async {
        final comicId = history.comicid;

        final item = await M.o.getComicHistory(comicId);
        if (item != null) return item.toBrief();

        final res = await picaClient.getBriefComicInfo(comicId);
        if (!res.error) return res.data;

        return PicaComicItemBrief.error();
      }),
    );
    if (settings.isPageView) {
      state = state.copyWith(comics: comics);
    }else{
      state = state.copyWith(comics: [...state.comics,...comics]);
    }
    return true;
  }

  Future<void> removeHistory() async {
    M.o.removeAllHistory();
    M.o.removeAllHistoryItem();
    ref.read(visitHistoryControllerProvider.notifier).clear();
    state = state.copyWith(comics: const [],history: const []);
  }
}

@Riverpod(keepAlive: true)
class VisitHistoryController extends _$VisitHistoryController {
  @override
  Map<String, VisitHistory> build() {
    return const {};
  }

  void init() {
    M.o.getVisitHistory().then((value) {
      Map<String, VisitHistory> map = {};
      for (var e in value) {
        map[e.comicid] = e;
      }
      state = Map.unmodifiable(map);
    });
  }

  Future<VisitHistory?> fetchVisitHistory(String id) async {
    var item = await M.o.getVisitHistoryByComic(id);
    if (item != null) {
      state = Map.unmodifiable({
        ...state,
        id: item,
      });
      return item;
    } else {
      return null;
    }
  }

  void updateVisitHistory(String id, int eps, int index) {
    final old = state[id];
    final item = old?.copyWith(
      lastEps: eps,
      lastIndex: index,
      timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
    ) ??
        VisitHistory(
          comicid: id,
          lastEps: eps,
          lastIndex: index,
          timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
        );

    M.o.addVisitHistory(item);
    state = Map.unmodifiable({
        ...state,
        id: item,
      });
  }

  void clear() {
    state = const {};
  }
}