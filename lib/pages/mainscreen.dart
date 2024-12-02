import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skana_pica/config/setting.dart';
import 'package:skana_pica/pages/home_page.dart';
import 'package:skana_pica/pages/me_page.dart';
import 'package:skana_pica/pages/pica_search.dart';

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
    MainScreenIndex mainScreenIndex = Get.put(MainScreenIndex());
    return Scaffold(
        body: Obx(() {
          switch (mainScreenIndex.index.value) {
            case 0:
              return HomePage();
            case 1:
              return PicaSearchPage();
            case 2:
              return MePage();
            default:
              return HomePage();
          }
        }),
        bottomNavigationBar: Obx(
          () => GestureDetector(
              child: BottomNavigationBar(
            currentIndex: mainScreenIndex.index.value,
            onTap: (index) => mainScreenIndex.changeIndex(index),
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Get.theme.primaryColor,
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.motion_photos_on_outlined,
                  size: 30,
                ),
                activeIcon: Icon(Icons.motion_photos_on, size: 35),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.auto_awesome_outlined, size: 30),
                activeIcon: Icon(Icons.auto_awesome, size: 35),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.pest_control_rodent_outlined, size: 30),
                activeIcon: Icon(Icons.pest_control_rodent, size: 35),
                label: "",
              ),
            ],
          )),
        ));
  }
}

class MainScreenIndex extends GetxController {
  RxInt index = (int.tryParse(appdata.general[5]) ?? 0).obs;
  void changeIndex(int i) {
    if (index.value == i && i == 0) goToTop();
    index.value = i;
  }

  void goToTop() {
    globalScrollController.animateTo(0,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }
}
