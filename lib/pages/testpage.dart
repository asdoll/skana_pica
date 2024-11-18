import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:skana_pica/pages/mainscreen.dart';

class Testpage extends StatefulWidget {
  const Testpage({Key? key}) : super(key: key);

  @override
  _TestpageState createState() => _TestpageState();
}

class _TestpageState extends State<Testpage> {
  MainScreenIndex mainScreenIndex = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Page'),
      ),
      body:  Center(
        child: FButton(
          label: Text('Go to Home Page'),
          onPress: () {
            mainScreenIndex.changeIndex(2);
          },
        ),
      ),
    );
  }
}