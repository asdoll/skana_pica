import 'package:bootstrap_icons/bootstrap_icons.dart';
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
            width: 100,
            height: 150,
            fit: BoxFit.cover,
          ).rounded(8.0),
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
                child:
                    Text(
                      comic.author,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        color: context.moonTheme?.tokens.colors.trunks.applyDarkMode(),
                      ),
                    ).small(),
              ),
              Row(children: [
                    Icon(
                      BootstrapIcons.heart,
                      size: 11,
                      color: context.moonTheme?.tokens.colors.piccolo,
                    ).paddingTop(2),
                    const SizedBox(
                      width: 2,
                    ),
                    Text(
                      comic.likes.toString(),
                      strutStyle: const StrutStyle(forceStrutHeight: true, leading: 0),
                    ).small(),
                    const SizedBox(
                      width: 6,
                    ),
                    if (comic.epsCount != null || comic.pages != null)
                      Icon(
                        BootstrapIcons.journal_text,
                        size: 11,
                        color: context.moonTheme?.tokens.colors.piccolo,
                      ).paddingTop(2),
                    if (comic.epsCount != null || comic.pages != null)
                      const SizedBox(
                        width: 2,
                      ),
                    if (comic.epsCount != null || comic.pages != null)
                      Text(
                        '${comic.epsCount != null ? "${comic.epsCount}E/" : ""}${comic.pages != null ? "${comic.pages}P" : ""}',
                        strutStyle: const StrutStyle(forceStrutHeight: true, leading: 0),
                      ).small(),
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
