import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skana_pica/widgets/pica_comic_list.dart';

class PicaHistoryPage extends StatefulWidget {
  @override
  State<PicaHistoryPage> createState() => _PicaHistoryPageState();
}

class _PicaHistoryPageState extends State<PicaHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("History".tr),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: PicaComicsPage(keyword: "history", type: "me"),
    );
  }
}
