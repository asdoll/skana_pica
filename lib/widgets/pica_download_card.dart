import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:easy_localization/easy_localization.dart'
    show StringTranslateExtension;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moon_design/moon_design.dart';
import 'package:skana_pica/api/models/objectbox_models.dart';
import 'package:skana_pica/controller/downloadstore.dart';
import 'package:skana_pica/pages/pica_comic.dart' show PicacgComicPage;
import 'package:skana_pica/util/leaders.dart';
import 'package:skana_pica/util/widgetplugin.dart';
import 'package:skana_pica/widgets/pica_image.dart';
import 'package:skana_pica/widgets/pica_tagchip.dart';

class DownloadComicCard extends HookConsumerWidget {
  final DownloadTask task;
  const DownloadComicCard(this.task, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Stack(children: [
          moonListTileWidgets(
            menuItemPadding: EdgeInsets.all(6),
            onTap: () {
              Go.to(PicacgComicPage(null,task));
            },
            menuItemCrossAxisAlignment: CrossAxisAlignment.start,
            leading: PicaImage(
              task.comic.target!.thumbUrl,
              width: 80,
              height: 120,
              fit: BoxFit.cover,
              downloaded: true,
            ).rounded(8.0),
            trailing: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (ref.watch(downloadProvider).progress[task.id] !=
                      ref.watch(downloadProvider).total[task.id])
                    MoonButton.icon(
                      showBorder: true,
                      borderColor: context.moonTheme?.buttonTheme.colors.borderColor
                          .withValues(alpha: 0.5),
                      backgroundColor:
                          context.moonTheme?.tokens.colors.zeno,
                      icon: ref.watch(downloadProvider).working[task.id] != true
                          ? Icon(BootstrapIcons.play, color: Colors.white)
                          : SpinKitRing(
                              lineWidth: 1,
                              size: 16,
                              color: context
                                  .moonTheme!.buttonTheme.colors.textColor),
                      onTap: () {
                        if (ref.read(downloadProvider).working[task.id] != true) {
                          ref.read(downloadProvider.notifier).continueTask(task.id);
                        }
                      },
                    ),
                  SizedBox(height: 12),
                  MoonButton.icon(
                    showBorder: true,
                    borderColor: context.moonTheme?.buttonTheme.colors.borderColor
                        .withValues(alpha: 0.5),
                    backgroundColor: context.moonTheme?.tokens.colors.zeno,
                    icon: Icon(BootstrapIcons.trash3, color: Colors.white),
                    onTap: () {
                      alertDialog(
                        context,
                        "${'delete'.tr(args: [
                              task.comic.target!.title
                            ])} ?",
                        "",
                        [
                          outlinedButton(
                            label: 'cancel'.tr(),
                            onPressed: () => Navigator.pop(context),
                          ),
                          filledButton(
                            label: 'ok'.tr(),
                            onPressed: () {
                              ref.read(downloadProvider.notifier).stopTask(task.id);
                              Navigator.pop(context);
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
                    task.comic.target!.title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ).header(),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    task.comic.target!.author,
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
                    task.comic.target!.likes.toString(),
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
                    '${task.comic.target!.epsCount}E/${task.comic.target!.pagesCount}P',
                    strutStyle:
                        const StrutStyle(forceStrutHeight: true, leading: 0),
                  ).small(),
                  const SizedBox(
                    width: 8,
                  ),
                  if (task.comic.target!.finished == true)
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
                          "${"downloaded".tr()}: ${ref.watch(downloadProvider).progress[task.id]}/${ref.watch(downloadProvider).total[task.id]}",
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
        ]));
  }
}
