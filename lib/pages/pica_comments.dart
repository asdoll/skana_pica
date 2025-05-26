import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moon_design/moon_design.dart';
import 'package:skana_pica/controller/comicstore.dart';
import 'package:skana_pica/util/widgetplugin.dart';
import 'package:skana_pica/widgets/custom_indicator.dart';
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
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      
    });
  }
  @override
  Widget build(BuildContext context) {
    ComicStore comicStore = Get.find<ComicStore>(tag: widget.id);
    return Scaffold(
        appBar: appBar(title: "Comments".tr),
        backgroundColor: context.moonTheme?.tokens.colors.gohan,
        floatingActionButton: GoTop(scrollController: scrollController),
        body: Column(children: [
          Expanded(
            child: BezierIndicator(
                onRefresh: () => comicStore.initComments(dragging: true),
                child: Obx(() => Stack(children: [
                      ListView.builder(
                        controller: scrollController,
                        itemCount:
                            comicStore.comments.value.comments.length + 1,
                        itemBuilder: (context, index) {
                          if (index ==
                              comicStore.comments.value.comments.length) {
                            if (comicStore.comments.value.comments.isEmpty) {
                              return !comicStore.isLoading.value
                                  ? SizedBox(
                                      height: Get.height * 0.8,
                                      child: Center(
                                        child: Text("[ ]").h1(),
                                      ))
                                  : Container();
                            }
                            if (comicStore.comments.value.pages >
                                comicStore.comments.value.loaded) {
                              if (!comicStore.isLoading.value) {
                                Future.delayed(
                                    const Duration(microseconds: 100), () {
                                  comicStore.loadMoreComments();
                                });
                              }
                              return progressIndicator(context)
                                  .paddingVertical(10);
                            } else {
                              return Container();
                            }
                          }
                          return PicaCommentTile(
                              comment:
                                  comicStore.comments.value.comments[index]);
                        },
                        physics: BouncingScrollPhysics(),
                      ),
                      if (!comicStore.isDrag.value &&
                          comicStore.isLoading.value)
                        Center(
                          child: progressIndicator(context),
                        )
                    ]))),
          ),
          PicaCommentBar(
            widget.id,
            isComic: true,
          ).paddingOnly(bottom: 25)
        ]));
  }
}
