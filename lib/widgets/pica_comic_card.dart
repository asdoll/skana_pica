import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moon_design/moon_design.dart';
import 'package:skana_pica/api/comic_sources/picacg/pica_models.dart';
import 'package:skana_pica/controller/favourite.dart';
import 'package:skana_pica/controller/history.dart';
import 'package:skana_pica/pages/pica_comic.dart';
import 'package:skana_pica/util/leaders.dart';
import 'package:skana_pica/util/tool.dart';
import 'package:skana_pica/util/widgetplugin.dart';
import 'package:skana_pica/widgets/pica_image.dart';
import 'package:skana_pica/widgets/pica_tagchip.dart';

class PicaComicCard extends StatefulWidget {
  final PicaComicItemBrief comic;
  final String type;
  const PicaComicCard(this.comic, {super.key, this.type = "comic"});

  @override
  State<PicaComicCard> createState() => _PicaComicCardState();
}

class _PicaComicCardState extends State<PicaComicCard> {
  PicaComicItemBrief get comic => widget.comic;
  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Stack(
          children: [
            moonListTileWidgets(
              menuItemPadding: EdgeInsets.all(6),
              onTap: () {
                Go.to(PicacgComicPage(comic), preventDuplicates: false);
              },
              menuItemCrossAxisAlignment: CrossAxisAlignment.start,
          leading: PicaImage(
            comic.cover,
            width: 80,
            height: 120,
            fit: BoxFit.cover,
          ).rounded(8.0).paddingTop(6),
          label: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(0),
                child: Text(
                  comic.title,
                  overflow: TextOverflow.ellipsis,
                  maxLines:
                      visitHistoryController.history[comic.id] != null ? 2 : 3,
                ).header(),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      comic.author.atMost(),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ).small(),
                  ],
                ),
              ),
              Row(children: [
                    Icon(
                      Icons.favorite_outline,
                      size: 12,
                      color: context.moonTheme?.tokens.colors.piccolo,
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    Text(
                      comic.likes.toString(),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    if (comic.epsCount != null || comic.pages != null)
                      Icon(
                        Icons.sticky_note_2_outlined,
                        size: 12,
                        color: context.moonTheme?.tokens.colors.piccolo,
                      ),
                    if (comic.epsCount != null || comic.pages != null)
                      const SizedBox(
                        width: 2,
                      ),
                    if (comic.epsCount != null || comic.pages != null)
                      Text(
                        '${comic.epsCount != null ? "${comic.epsCount}E/" : ""}${comic.pages != null ? "${comic.pages}P" : ""}',
                      ),
                    if (comic.epsCount != null || comic.pages != null)
                      const SizedBox(
                        width: 8,
                      ),
                    if (comic.finished == true) TagFinished() else Container(),
                    const SizedBox(
                      width: 2,
                    ),
                  ]).paddingBottom(4),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 2, // gap between adjacent chips
                runSpacing: 2,
                children: [
                  if (comic.tags.isEmpty) Container(),
                  for (var f in comic.tags)
                    PicaTag(
                      text: f,
                      type: 'tag',
                    ),
                ],
              ),
              if (visitHistoryController.history[comic.id] != null)
                const SizedBox(
                  height: 4,
                ),
              if (visitHistoryController.history[comic.id] != null)
                Row(
                  children: [
                    PicaTag(
                      text:
                          "${"Last Read:".tr} ${getLastRead(visitHistoryController.history[comic.id])}${widget.type == "history" ? "  ${getLastTime(visitHistoryController.history[comic.id])}" : ""}",
                      type: "placed",
                      backgroundColor: Get.context!.moonTheme?.tokens.colors.nappa60,
                    ),
                  ],
                ),
              const SizedBox(
                height: 4,
              ),
            ],
          ).paddingLeft(4),),
          if (widget.type == "comic" &&
                      favorController.favorComics.contains(widget.comic.id))
                    Positioned(
                        bottom: 8,
                        right: 8,
                        child: Icon(
                          Icons.bookmark_added_rounded,
                          color: context.moonTheme?.tokens.colors.chichi60,
                          size: Get.width / 8,
                        ))
          ]
        )));
  }
}
