import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skana_pica/pages/mainscreen.dart';
import 'package:skana_pica/widgets/pica_comic_list.dart';

class PicaCatComicsPage extends StatefulWidget {
  static const route = "${Mains.route}catcomics";

  final String id;
  final String type;

  const PicaCatComicsPage(
      {super.key, required this.id, required this.type});

  @override
  State<PicaCatComicsPage> createState() => _PicaCatComicsPageState();
}

class _PicaCatComicsPageState extends State<PicaCatComicsPage> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // scrollController.addListener(() {
    //   if (scrollController.offset < context.height) {
    //     homeController.showBackArea.value = false;
    //   } else {
    //     homeController.showBackArea.value = true;
    //   }
    // });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.id == "random"
            ? "Random".tr
            : widget.id == "latest"
                ? "Latest".tr
                : widget.id == "bookmarks"
                    ? "Bookmarks".tr
                    : widget.id),
      ),
      //floatingActionButton: GoTop(scrollController: scrollController),
      body: PicaComicsPage(
          keyword: widget.id, type: widget.type, scrollController: scrollController),
    );
  }
}
