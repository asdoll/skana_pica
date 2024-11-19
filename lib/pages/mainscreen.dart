import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:skana_pica/pages/home_page.dart';
import 'package:skana_pica/pages/me_page.dart';
import 'package:skana_pica/pages/testpage.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class Mains extends StatefulWidget {
  static const route = "/";
  final int index;

  const Mains({super.key, this.index = 0});

  @override
  State<Mains> createState() => _MainsState();
}

class _MainsState extends State<Mains> {
  late MainScreenIndex mainScreenIndex;

  @override
  void initState() {
    super.initState();
    mainScreenIndex = Get.put(MainScreenIndex());
    mainScreenIndex.changeIndex(widget.index);
  }

  @override
  void dispose() {
    mainScreenIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final contents = [
      HomePage(),
      Testpage(),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text("Search".tr)],
      ),
      MePage(),
    ];
    return Scaffold(
      appBar: TDNavBar(
        height: 48,
        titleFontWeight: FontWeight.w600,
        title: "test",
        screenAdaptation: true,
        useDefaultBack: false,
    ),
    );
    return Obx(() => FScaffold(
      content: contents[mainScreenIndex.index.value],
      footer: FBottomNavigationBar(
        index: mainScreenIndex.index.value,
        onChange: (i) => mainScreenIndex.changeIndex(i),
        children: [
          FBottomNavigationBarItem(
            icon: FIcon(FAssets.icons.house),
            label: Text("Home".tr),
          ),
          FBottomNavigationBarItem(
            icon: FIcon(FAssets.icons.layoutGrid),
            label: Text("Categories".tr),
          ),
          FBottomNavigationBarItem(
            icon: FIcon(FAssets.icons.search),
            label: Text("Search".tr),
          ),
          FBottomNavigationBarItem(
            icon: FIcon(FAssets.icons.ghost),
            label: Text("Me".tr),
          ),
        ],
      ),
    ),);
  }
}

class MainScreenIndex extends GetxController {
  var index = 0.obs;
  void changeIndex(int i) {
    index.value = i;
  }
}