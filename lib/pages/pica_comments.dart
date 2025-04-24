import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moon_design/moon_design.dart';
import 'package:skana_pica/controller/comicstore.dart';
import 'package:skana_pica/util/widgetplugin.dart';
import 'package:skana_pica/widgets/icons.dart';
import 'package:skana_pica/widgets/pica_comment_bar.dart';
import 'package:skana_pica/widgets/pica_comment_tile.dart';

class PicaCommentsPage extends StatefulWidget {
  static const route = "/pica_comments";
  final String id;
  const PicaCommentsPage(this.id, {super.key});

  @override
  State<PicaCommentsPage> createState() => _PicaCommentsPageState();
}

class _PicaCommentsPageState extends State<PicaCommentsPage> {
  @override
  Widget build(BuildContext context) {
    ComicStore comicStore = Get.find<ComicStore>(tag: widget.id);
    ScrollController scrollController = ScrollController();
    EasyRefreshController controller = EasyRefreshController(
        controlFinishLoad: true, controlFinishRefresh: true);
    return Scaffold(
        appBar: appBar(title: "Comments".tr),
        backgroundColor: context.moonTheme?.tokens.colors.gohan,
        body: Column(children: [
          Expanded(
            child: EasyRefresh(
              controller: controller,
              footer: DefaultHeaderFooter.footer(context),
              header: DefaultHeaderFooter.header(context),
              refreshOnStartHeader: DefaultHeaderFooter.refreshHeader(context),
              onLoad: () {
                bool res = comicStore.loadMoreComments();
                controller.finishLoad(
                    res ? IndicatorResult.success : IndicatorResult.fail);
                if (comicStore.comments.value.comments.length >=
                    comicStore.comments.value.total) {
                  controller.finishLoad(IndicatorResult.noMore);
                }
              },
              onRefresh: () {
                comicStore.initComments();
                controller.finishRefresh();
              },
              child: Obx(() => ListView.builder(
                    controller: scrollController,
                    itemCount: comicStore.comments.value.comments.length,
                    itemBuilder: (context, index) {
                      return PicaCommentTile(
                          comment: comicStore.comments.value.comments[index]);
                    },
                  )),
            ),
          ),
          PicaCommentBar(
            widget.id,
            isComic: true,
          ).paddingOnly(bottom: 25)
        ]));
  }
}
