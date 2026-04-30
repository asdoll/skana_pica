import 'package:easy_localization/easy_localization.dart'
    show StringTranslateExtension;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:moon_design/moon_design.dart';
import 'package:skana_pica/controller/comicstore.dart';
import 'package:skana_pica/util/widgetplugin.dart';
import 'package:skana_pica/widgets/custom_indicator.dart';
import 'package:skana_pica/widgets/icons.dart';
import 'package:skana_pica/widgets/pica_comment_bar.dart';
import 'package:skana_pica/widgets/pica_comment_tile.dart';

class PicaCommentsPage extends StatefulHookConsumerWidget {
  static const route = "/pica_comments";
  final String id;
  const PicaCommentsPage(this.id, {super.key});

  @override
  ConsumerState<PicaCommentsPage> createState() => _PicaCommentsPageState();
}

class _PicaCommentsPageState extends ConsumerState<PicaCommentsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var comicStore = comicStoreProvider(widget.id, ComicStoreSource.online);
    return Scaffold(
        appBar: appBar(title: "comments".tr()),
        backgroundColor: context.moonTheme?.tokens.colors.gohan,
        body: Column(children: [
          Expanded(
            child: BezierIndicator(
                onRefresh: () =>
                    ref.read(comicStore.notifier).initComments(dragging: true),
                child: Stack(children: [
                  ListView.builder(
                    itemCount: ref.watch(comicStore).comments.comments.length + 1,
                    itemBuilder: (context, index) {
                      if (index == ref.watch(comicStore).comments.comments.length) {
                        if (ref.watch(comicStore).comments.comments.isEmpty) {
                          return !ref.watch(comicStore).isLoading
                              ? SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.8,
                                  child: Center(
                                    child: Text("[ ]").h1(),
                                  ))
                              : Container();
                        }
                        if (ref.watch(comicStore).comments.pages >
                            ref.watch(comicStore).comments.loaded) {
                          if (!ref.watch(comicStore).isLoading) {
                            Future.delayed(const Duration(microseconds: 100),
                                () {
                              ref.read(comicStore.notifier).loadMoreComments();
                            });
                          }
                          return progressIndicator(context).paddingVertical(10);
                        } else {
                          return Container();
                        }
                      }
                      return PicaCommentTile(
                          comment: ref.watch(comicStore).comments.comments[index]);
                    },
                    physics: BouncingScrollPhysics(),
                  ),
                  if (!ref.watch(comicStore).isDrag && ref.watch(comicStore).isLoading)
                    Center(
                      child: progressIndicator(context),
                    )
                ])),
          ),
          PicaCommentBar(
            widget.id,
            isComic: true,
          ).paddingOnly(bottom: 25)
        ]));
  }
}
