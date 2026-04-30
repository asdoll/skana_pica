import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:skana_pica/config/setting.dart';

part 'blocker.freezed.dart';
part 'blocker.g.dart';

@freezed
abstract class BlockerState with _$BlockerState {
  factory BlockerState(
    {required List<String> keywords,
    required List<String> categories
    }) = _BlockerState;
}


@Riverpod(keepAlive: true)
class Blocker extends _$Blocker {
  @override
  BlockerState build() {
  return _createState();
  }

  BlockerState _createState() {
    return BlockerState(
      keywords: List.unmodifiable(settings.blockingKeyword),
      categories: List.unmodifiable(fetchCategories()),
    );
  }

  void init() {
    state = _createState();
  }

  void removeKeyword(String keyword) {
    if (!state.keywords.contains(keyword)) {
      return;
    }
    state = state.copyWith(
      keywords: state.keywords.where((e) => e != keyword).toList(),
    );
    settings.blockingKeyword.remove(keyword);
    settings.setBlockingKeyword();
  }

  void addKeyword(String keyword) {
    if (state.keywords.contains(keyword)) {
      return;
    }
    state = state.copyWith(
      keywords: [...state.keywords, keyword],
    );
    settings.blockingKeyword.add(keyword);
    settings.setBlockingKeyword();
  }

  void addBlockedCategory(String category) {
    if (state.categories.contains(category)) {
      return;
    }
    state = state.copyWith(
      keywords: [...state.categories, category],
    );
    settings.pica[5] = state.categories.join(";");
    settings.updateSettings("picacg");
  }

  void removeBlockedCategory(String category) {
    if (!state.categories.contains(category)) {
      return;
    }
    state = state.copyWith(
      keywords: state.categories.where((e) => e != category).toList(),
    );
    settings.pica[5] = state.categories.join(";");
    settings.updateSettings("picacg");
  }

  void toggleBlockedCategory(String category) {
    if (state.categories.contains(category)) {
      removeBlockedCategory(category);
    } else {
      addBlockedCategory(category);
    }
  }

  List<String> fetchCategories() {
      return settings.pica[5].split(";").toList();
  }

  bool containsCat(String cat) => state.categories.contains(cat);
}