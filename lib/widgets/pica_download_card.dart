import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:moon_design/moon_design.dart';
import 'package:skana_pica/api/models/objectbox_models.dart';
import 'package:skana_pica/controller/downloadstore.dart';
import 'package:skana_pica/pages/local_comic.dart';
import 'package:skana_pica/util/leaders.dart';
import 'package:skana_pica/util/widgetplugin.dart';
import 'package:skana_pica/widgets/pica_image.dart';
import 'package:skana_pica/widgets/pica_tagchip.dart';

class DownloadComicCard extends StatefulWidget {
  final DownloadTask task;
  const DownloadComicCard(this.task, {super.key});

  @override
  State<DownloadComicCard> createState() => _DownloadComicCardState();
}

class _DownloadComicCardState extends State<DownloadComicCard> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Stack(children: [
          moonListTileWidgets(
            menuItemPadding: EdgeInsets.all(6),
            onTap: () {
              Go.to(LocalComicPage(widget.task), preventDuplicates: false);
            },
            menuItemCrossAxisAlignment: CrossAxisAlignment.start,
            leading: PicaImage(
              widget.task.comic.target!.thumbUrl,
              width: 80,
              height: 120,
              fit: BoxFit.cover,
            ).rounded(8.0),
            trailing: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (downloadStore.progress[widget.task.id] !=
                      downloadStore.total[widget.task.id])
                    MoonButton.icon(
                      showBorder: true,
                      borderColor: Get
                          .context?.moonTheme?.buttonTheme.colors.borderColor
                          .withValues(alpha: 0.5),
                      backgroundColor:
                          Get.context?.moonTheme?.tokens.colors.zeno,
                      icon: downloadStore.working[widget.task.id] != true
                          ? Icon(BootstrapIcons.play, color: Colors.white)
                          : SpinKitRing(
                              lineWidth: 1,
                              size: 16,
                              color: context
                                  .moonTheme!.buttonTheme.colors.textColor),
                      onTap: () {
                        if (downloadStore.working[widget.task.id] != true) {
                          downloadStore.continueTask(widget.task.id);
                        }
                      },
                    ),
                  SizedBox(height: 12),
                  MoonButton.icon(
                    showBorder: true,
                    borderColor: Get
                        .context?.moonTheme?.buttonTheme.colors.borderColor
                        .withValues(alpha: 0.5),
                    backgroundColor: Get.context?.moonTheme?.tokens.colors.zeno,
                    icon: Icon(BootstrapIcons.trash3, color: Colors.white),
                    onTap: () {
                      alertDialog(
                        context,"${'delete'.trParams({"name": widget.task.comic.target!.title})} ?",
                        "",
                        [
                          outlinedButton(
                            label: 'Cancel'.tr,
                            onPressed: Get.back,
                          ),
                          filledButton(
                            label: 'Ok'.tr,
                            onPressed: () {
                              downloadStore.stopTask(widget.task.id);
                              Get.back();
                            },
                          ),
                        ],
                      );
                    },
                  )
                ]),
            label: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(0),
                  child: Text(
                    widget.task.comic.target!.title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ).header(),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    widget.task.comic.target!.author,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: context.moonTheme?.tokens.colors.trunks
                          .applyDarkMode(),
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
                    widget.task.comic.target!.likes.toString(),
                    strutStyle:
                        const StrutStyle(forceStrutHeight: true, leading: 0),
                  ).small(),
                  const SizedBox(
                    width: 6,
                  ),
                  Icon(
                    BootstrapIcons.journal_text,
                    size: 11,
                    color: context.moonTheme?.tokens.colors.piccolo,
                  ).paddingTop(2),
                  const SizedBox(
                    width: 2,
                  ),
                  Text(
                    '${widget.task.comic.target!.epsCount}E/${widget.task.comic.target!.pagesCount}P',
                    strutStyle:
                        const StrutStyle(forceStrutHeight: true, leading: 0),
                  ).small(),
                  const SizedBox(
                    width: 8,
                  ),
                  if (widget.task.comic.target!.finished == true)
                    TagFinished()
                  else
                    Container(),
                  const SizedBox(
                    width: 2,
                  ),
                ]).paddingBottom(4),
                const SizedBox(
                  height: 4,
                ),
                Row(
                  children: [
                    PicaTag(
                      text:
                          "${"Downloaded".tr}: ${downloadStore.progress[widget.task.id]}/${downloadStore.total[widget.task.id]}",
                      type: "placed",
                    ),
                  ],
                ),
                const SizedBox(
                  height: 4,
                ),
              ],
            ).paddingLeft(4),
          ),
        ])));
  }
}
