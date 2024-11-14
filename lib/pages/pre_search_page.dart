import 'package:skana_pica/api/models/base_comic.dart';
import 'package:skana_pica/config/base.dart';
import 'package:skana_pica/config/setting.dart';
import 'package:skana_pica/models/pair.dart';
import 'package:skana_pica/models/state_controller.dart';

class PreSearchController extends StateController {
  String target = '';

  SearchPageData get searchPageData =>
      ComicSource.find(target)!.searchPageData!;

  var options = <String>[];

  var suggestions = <Pair<String, TranslationType>>[];

  String? language;

  bool limitHistory = true;

  void updateOptions() {
    for (var source in ComicSource.sources) {
      if (source.key == target &&
          source.searchPageData?.searchOptions != null) {
        options = List.generate(
          source.searchPageData!.searchOptions!.length,
          (index) => source.searchPageData!.searchOptions![index].defaultValue,
        );
      }
    }
  }

  void updateTarget(String i) {
    target = i;
    updateOptions();
    update();
  }

  PreSearchController() {
    var searchSource = <String>[];
    for (var source in ComicSource.sources) {
      searchSource.add(source.key);
    }
    if (!searchSource.contains(appdata.appSettings.initialSearchTarget)) {
      appdata.appSettings.initialSearchTarget = searchSource.first;
      appdata.updateSettings();
    }
    target = appdata.appSettings.initialSearchTarget;
    updateOptions();
  }
}