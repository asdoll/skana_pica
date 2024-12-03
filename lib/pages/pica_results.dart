import 'package:flutter/material.dart';
import 'package:skana_pica/widgets/pica_comic_list.dart';

class PicaResultsPage extends StatefulWidget {
  static const route = "/pica_results";
  final String keyword;
  final String? sort;
  final bool? addToHistory;

  const PicaResultsPage(
      {super.key, required this.keyword, this.sort, this.addToHistory});

  @override
  State<PicaResultsPage> createState() => _PicaResultsPageState();
}

class _PicaResultsPageState extends State<PicaResultsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.keyword),
      ),
      body: PicaComicsPage(
        keyword: widget.keyword,
        type: "search",
        sort: widget.sort,
        addToHistory: widget.addToHistory ?? true,
      ),
    );
  }
}
