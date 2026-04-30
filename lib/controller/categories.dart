import 'package:skana_pica/api/comic_sources/picacg/pica_source.dart';
import 'package:skana_pica/config/setting.dart';
import 'package:skana_pica/controller/blocker.dart';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'categories.freezed.dart';
part 'categories.g.dart';

@freezed
abstract class CategoryState with _$CategoryState {

  factory CategoryState({
    required List<String> categories,
    required List<String> mainPageTags
  }) = _CategoryState;
}

@Riverpod(keepAlive: true)
class Category extends _$Category {
  @override
  CategoryState build() {
    return _createState();
  }

  CategoryState _createState() {
    return CategoryState(
      categories: List.unmodifiable(fetchCategories()),
      mainPageTags: List.unmodifiable(fetchMainPageTags()),
    );
  }

  void init() {
    state = _createState();
  }

  List<String> fetchCategories() {
    List<String> categories = [];
    categories.clear();
    for (int i = 0; i < picacg.categories.length; i++) {
      if (!settings.blockedCategory.contains(picacg.categories[i])) {
        categories.add(picacg.categories[i]);
      }
    }
    return categories;
  }

  void blockCategory(String cat) async {
    if (!ref.read(blockerProvider.notifier).containsCat(cat)) {
      ref.read(blockerProvider.notifier).addBlockedCategory(cat);
    }
    state = state.copyWith(categories: fetchCategories());
  }

  String getCoverImg(String category) {
    if (category == "leaderboard") {
      return "assets/images/categories/leaderboard.png";
    }
    if (category == "random") {
      return "assets/images/categories/random.png";
    }
    if (category == "latest") {
      return "assets/images/categories/latest.png";
    }

    String path = picacg.cateMap[category] ?? "";
    return "assets/images/categories/$path";
  }

  List<String> fetchMainPageTags() {
    List<String> tags = settings.pica[9].split(";");
    tags.removeWhere((element) => element.trim().isEmpty);
    return tags;
  }

  void toggleMainPageTag(String tag) {
    if (state.mainPageTags.contains(tag)) {
      removeMainPageTag(tag);
    } else {
      addMainPageTag(tag);
    }
  }

  void setMainPageTag(List<String> tag){
    state = state.copyWith(mainPageTags: tag);
  }

  void addMainPageTag(String tag) {
    if (state.mainPageTags.contains(tag)) return;

    state = state.copyWith(
      mainPageTags: List.unmodifiable([...state.mainPageTags, tag]),
    );
    saveMainPageTags();
  }

  void removeMainPageTag(String tag) {
    if (!state.mainPageTags.contains(tag)) return;

    state = state.copyWith(
      mainPageTags: List.unmodifiable(
        state.mainPageTags.where((e) => e != tag).toList(),
      ),
    );
    saveMainPageTags();
  }

  void saveMainPageTags() {
    settings.pica[9] = state.mainPageTags.join(";");
    settings.updateSettings("pica");
  }

}

final fixedCategories = ["random", "latest", "leaderboard", "bookmarks"];
