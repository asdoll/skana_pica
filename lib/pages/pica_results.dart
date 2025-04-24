import 'package:flutter/material.dart';
import 'package:skana_pica/util/widgetplugin.dart';
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
        title: widget.keyword,
      ),
      body: PicaComicsPage(
        keyword: widget.keyword,
        type: "search",
        sort: widget.sort,
        addToHistory: widget.addToHistory ?? true,
        scrollController: scrollController,
      ),
    );
  }
}
