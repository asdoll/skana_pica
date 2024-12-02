import 'package:flutter/material.dart';

class PicaCommentsPage extends StatefulWidget {
  static const route = "/pica_comments";
  final String id;
  const PicaCommentsPage(this.id,{super.key});

  @override
  State<PicaCommentsPage> createState() => _PicaCommentsPageState();
}

class _PicaCommentsPageState extends State<PicaCommentsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comments"),
      ),
      body: Center(
        child: Text("Comments"),
      ),
    );
  }
}