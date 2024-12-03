import 'package:flutter/material.dart';
import 'package:skana_pica/pages/pica_comic.dart';

class PicaReadPage extends StatefulWidget {
  static const route = "${PicacgComicPage.route}pica_read";
  final String id;
  final String title;

  const PicaReadPage({super.key, required this.id, required this.title});

  @override
  State<PicaReadPage> createState() => _PicaReadPageState();
}

class _PicaReadPageState extends State<PicaReadPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Text("Read Page"),
      ),
    );
  }
}