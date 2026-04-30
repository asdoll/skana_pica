import 'package:flutter/widgets.dart' show ScrollController;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'main_controller.freezed.dart';
part 'main_controller.g.dart';

@freezed
abstract class HomeState with _$HomeState {

  factory HomeState({
    @Default(0) int pageIndex,
    @Default(false) bool showBackArea,
    @Default(false) bool filterMenu,
    @Default(0) int tagIndex
  }) = _HomeState;
}

@Riverpod(keepAlive: true)
class Home extends _$Home {
  @override
  HomeState build() {
    return HomeState();
  }

  void setShowBack(bool f){
    state = state.copyWith(showBackArea: f);
  }

  void resetTags() {
    state = state.copyWith(tagIndex:0);
  }

  void setTag(int index){
    state = state.copyWith(tagIndex:index);
  }
  void setPage(int index){
    state = state.copyWith(pageIndex:index);
  }
}

List<String> pages = [
  "",
  "search",
  "categories",
  "leaderboard",
  "bookmarks",
  "history",
  "downloads",
  "settings"
];

ScrollController globalScrollController = ScrollController();
