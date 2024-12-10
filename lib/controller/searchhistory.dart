import 'package:get/get.dart';
import 'package:skana_pica/config/setting.dart';

late SearchHistoryController searchHistoryController;

class SearchHistoryController extends GetxController {
  RxList<String> searchHistory = <String>[].obs;

  void removeHistory(String keyword) {
    searchHistory.remove(keyword);
    appdata.searchHistory.remove(keyword);
    appdata.writeHistory();
    searchHistory.refresh();
  }

  void clearHistory() {
    searchHistory.clear();
    appdata.searchHistory.clear();
    appdata.writeHistory();
    searchHistory.refresh();
  }

  void addHistory(String keyword) {
    if (searchHistory.contains(keyword)) {
      searchHistory.remove(keyword);
      appdata.searchHistory.remove(keyword);
    }
    searchHistory.add(keyword);
    appdata.searchHistory.add(keyword);
    appdata.writeHistory();
    searchHistory.refresh();
  }

  void init() {
    searchHistory.clear();
    searchHistory.addAll(appdata.searchHistory);
    searchHistory.refresh();
  }
}
