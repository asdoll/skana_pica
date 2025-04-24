import 'package:get/get.dart';
import 'package:skana_pica/config/setting.dart';

late SearchHistoryController searchHistoryController;

class SearchHistoryController extends GetxController {
  RxList<String> searchHistory = <String>[].obs;

  void removeHistory(String keyword) {
    searchHistory.remove(keyword);
    settings.searchHistory.remove(keyword);
    settings.writeHistory();
    searchHistory.refresh();
  }

  void clearHistory() {
    searchHistory.clear();
    settings.searchHistory.clear();
    settings.writeHistory();
    searchHistory.refresh();
  }

  void addHistory(String keyword) {
    if (searchHistory.contains(keyword)) {
      searchHistory.remove(keyword);
      settings.searchHistory.remove(keyword);
    }
    searchHistory.add(keyword);
    settings.searchHistory.add(keyword);
    settings.writeHistory();
    searchHistory.refresh();
  }

  void init() {
    searchHistory.clear();
    searchHistory.addAll(settings.searchHistory);
    searchHistory.refresh();
  }
}
