import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:skana_pica/config/setting.dart';

part 'searchhistory.g.dart';

@Riverpod(keepAlive: true)
class SearchHistory extends _$SearchHistory {
  @override
  List<String> build() {
    return List<String>.from(settings.searchHistory);
  }

  Future<void> removeHistory(String keyword) async {
    final newList = List<String>.from(state)..remove(keyword);
    state = newList;

    settings.searchHistory.remove(keyword);
    settings.writeHistory();
  }

  void clearHistory() {
    state = [];
    settings.searchHistory.clear();
    settings.writeHistory();
  }

  void addHistory(String keyword) {
    final newList = List<String>.from(state)
      ..remove(keyword)
      ..add(keyword);

    state = newList;

    settings.searchHistory
      ..remove(keyword)
      ..add(keyword);

    settings.writeHistory();
  }

  void init() {
    state = List<String>.from(settings.searchHistory);
  }
}