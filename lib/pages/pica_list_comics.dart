import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skana_pica/pages/mainscreen.dart';
import 'package:skana_pica/util/widgetplugin.dart' show appBar;
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
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        title: widget.id == "random"
            ? "Random".tr
            : widget.id == "latest"
                ? "Latest".tr
                : widget.id == "bookmarks"
                    ? "Bookmarks".tr: 
                    widget.id == "leaderboard"
                    ? "Leaderboard".tr
                    : widget.id),
      body: PicaComicsPage(
          keyword: widget.id, type: widget.id == "leaderboard" ? "H24" : widget.type, scrollController: scrollController),
    );
  }
}
