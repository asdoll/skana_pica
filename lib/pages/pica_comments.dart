import 'dart:math';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skana_pica/controller/comicstore.dart';
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
      appBar: AppBar(
        title: Text("Comments".tr),
      ),
      body: EasyRefresh(
        controller: controller,
        onLoad: () {
          bool res = comicStore.loadMoreComments();
          controller
              .finishLoad(res ? IndicatorResult.success : IndicatorResult.fail);
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
      bottomNavigationBar:  PicaCommentBar(widget.id,isComic: true,).paddingOnly(bottom: 25),
    );
  }
}
