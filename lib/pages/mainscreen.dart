import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skana_pica/config/setting.dart';
import 'package:skana_pica/controller/history.dart';
import 'package:skana_pica/controller/profile.dart';
import 'package:skana_pica/models/bottom_bar_matu.dart';
import 'package:skana_pica/pages/home_page.dart';
import 'package:skana_pica/pages/me_page.dart';
import 'package:skana_pica/pages/pica_search.dart';
import 'package:skana_pica/pages/start_page.dart';
import 'package:skana_pica/util/leaders.dart';
import 'package:skana_pica/util/tool.dart';

final ScrollController globalScrollController = ScrollController();

class Mains extends StatefulWidget {
  static const route = "/";

  const Mains({super.key});

  @override
  State<Mains> createState() => _MainsState();
}

class _MainsState extends State<Mains> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    resetOrientation();
    return Obx(() => profileController.isFirstLaunch.value
        ? Scaffold(body: StartPage())
        : buildNormal(context));
  }

  Widget buildNormal(BuildContext context) {

    return Scaffold(
        body: Obx(() => PageTransitionSwitcher(
              transitionBuilder: (
                Widget child,
                Animation<double> primaryAnimation,
                Animation<double> secondaryAnimation,
              ) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: Offset.zero,
                    end: const Offset(1.5, 0.0),
                  ).animate(secondaryAnimation),
                  child: child,
                );
              },
              duration: Duration(milliseconds: 100),
              child: mainScreenIndex.index.value == 0
                  ? HomePage()
                  : mainScreenIndex.index.value == 1
                      ? PicaSearchPage()
                      : MePage(),
            )),
        bottomNavigationBar: Obx(() => BottomBarDoubleBullet(
              selectedIndex: mainScreenIndex.index.value,
              onSelect: (index) {
                mainScreenIndex.changeIndex(index, goTop: true);
              },
              color: mainScreenIndex.color.value,
              backgroundColor: mainScreenIndex.backgroundColor.value,
              height: 65,
              items: [
                BottomBarItem(
                  iconBuilder: (color) => mainScreenIndex.index.value != 0
                      ? Icon(
                          Icons.motion_photos_on_outlined,
                          size: 30,
                        )
                      : GestureDetector(
                          onDoubleTap: () {
                            Leader.mainScreenEasyRefreshController
                                .callRefresh();
                          },
                          child: Icon(
                            Icons.motion_photos_on,
                            color: color,
                            size: 30,
                          )),
                ),
                BottomBarItem(
                  iconBuilder: (color) => mainScreenIndex.index.value != 1
                      ? Icon(Icons.auto_awesome_outlined, size: 30)
                      : Icon(Icons.auto_awesome, color: color, size: 30),
                ),
                BottomBarItem(
                  iconBuilder: (color) => mainScreenIndex.index.value != 2
                      ? Icon(Icons.pest_control_rodent_outlined, size: 30)
                      : Icon(Icons.pest_control_rodent, color: color, size: 30),
                ),
              ],
            )));
  }
}

class MainScreenIndex extends GetxController {
  RxInt index = (int.tryParse(appdata.general[5]) ?? 0).obs;
  Rx<Color> color = Get.theme.primaryColor.obs;
  Rx<Color> backgroundColor = Get.theme.scaffoldBackgroundColor.obs;

  bool notified = false;

  void changeIndex(int i, {bool goTop = false}) {
    if (index.value == i && goTop) {
      goToTop();
      return;
    }
    if (index.value != i) {
      visitHistoryController.clear();
    }
    index.value = i;
  }

  void changeColor(ThemeData t) {
    color.value = t.primaryColor;
    backgroundColor.value = t.scaffoldBackgroundColor;
    color.refresh();
    backgroundColor.refresh();
  }

  void goToTop() {
    if (globalScrollController.hasClients) {
      globalScrollController.animateTo(0,
          duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
    }
  }
}

MainScreenIndex mainScreenIndex = Get.put(MainScreenIndex());
