import 'package:easy_localization/easy_localization.dart' show StringTranslateExtension;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:skana_pica/controller/main_controller.dart';
import 'package:skana_pica/controller/setting_controller.dart' show mangaSettingProvider;
import 'package:skana_pica/pages/mainscreen.dart';
import 'package:skana_pica/util/widgetplugin.dart' show appBar;
import 'package:skana_pica/widgets/icons.dart';
import 'package:skana_pica/widgets/pica_comic_list.dart';

class PicaCatComicsPage extends StatefulHookConsumerWidget {
  static const route = "${Mains.route}catcomics";

  final String id;
  final String type;

  const PicaCatComicsPage(
      {super.key, required this.id, required this.type});

  @override
  ConsumerState<PicaCatComicsPage> createState() => _PicaCatComicsPageState();
}

class _PicaCatComicsPageState extends ConsumerState<PicaCatComicsPage> {

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
        title: widget.id == "random"
            ? "random".tr()
            : widget.id == "latest"
                ? "latest".tr()
                : widget.id == "bookmarks"
                    ? "bookmarks".tr(): 
                    widget.id == "leaderboard"
                    ? "leaderboard".tr()
                    : widget.id),
      floatingActionButton:!ref.watch(mangaSettingProvider).picaPageViewMode ? GoTop(scrollController: scrollController) : null,
      body: PicaComicsPage(
          keyword: widget.id, type: widget.id == "leaderboard" ? "H24" : widget.type, scrollController: scrollController),
    );
  }
}
