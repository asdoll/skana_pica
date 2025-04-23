import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RxInt pageIndex = 0.obs;
  RxBool showBackArea = false.obs;
  RxBool filterMenu = false.obs;
  RxInt tagIndex = 0.obs;
  Rx<DateTime?> dateTime = Rxn<DateTime>();

  void resetTags() {
    tagIndex.value = 0;
  }
}

List<String> pages = [
  "",
  "Search",
  "Categories",
  "Leaderboard",
  "Bookmarks",
  "History",
  "Downloads",
  "Settings"
];

late HomeController homeController;

ScrollController globalScrollController = ScrollController();
