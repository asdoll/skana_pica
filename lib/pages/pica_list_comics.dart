import 'package:flutter/material.dart';
import 'package:skana_pica/pages/mainscreen.dart';
import 'package:skana_pica/widgets/pica_comic_list.dart';

class PicaCatComicsPage extends StatefulWidget {
  static const route = "${Mains.route}catcomics";

  final String id;
  final String type;
  final bool isMain;

  const PicaCatComicsPage(
      {super.key, required this.id, required this.type, this.isMain = false});

  @override
  State<PicaCatComicsPage> createState() => _PicaCatComicsPageState();
}

class _PicaCatComicsPageState extends State<PicaCatComicsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.id),
      ),
      body: PicaComicsPage(
          keyword: widget.id, type: widget.type, isMain: widget.isMain),
    );
  }
}
