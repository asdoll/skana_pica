import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:skana_pica/controller/main_controller.dart';
import 'package:skana_pica/controller/setting_controller.dart';
import 'package:skana_pica/util/widgetplugin.dart';
import 'package:skana_pica/widgets/icons.dart';
import 'package:skana_pica/widgets/pica_comic_list.dart';

class PicaResultsPage extends StatefulHookConsumerWidget {
  static const route = "/pica_results";
  final String keyword;
  final String? sort;
  final bool? addToHistory;

  const PicaResultsPage(
      {super.key, required this.keyword, this.sort, this.addToHistory});

  @override
  ConsumerState<PicaResultsPage> createState() => _PicaResultsPageState();
}

class _PicaResultsPageState extends ConsumerState<PicaResultsPage> {

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.offset < MediaQuery.of(context).size.height) {
        ref.read(homeProvider.notifier).setShowBack(false);
      } else {
        ref.read(homeProvider.notifier).setShowBack(true);
      }
    });
    return Scaffold(
      appBar: appBar(
        title: widget.keyword,
      ),
      floatingActionButton: !ref.watch(mangaSettingProvider).picaPageViewMode ? GoTop(scrollController: scrollController) : null,
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
