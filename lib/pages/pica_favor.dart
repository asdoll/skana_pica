import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skana_pica/widgets/pica_comic_list.dart';

class PicaFavorPage extends StatefulWidget {
  const PicaFavorPage({super.key});

  @override
  State<PicaFavorPage> createState() => _PicaFavorPageState();
}

class _PicaFavorPageState extends State<PicaFavorPage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Bookmarks".tr),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: PicaComicsPage(keyword: "bookmarks", type: "me"),
    );
  }
}
