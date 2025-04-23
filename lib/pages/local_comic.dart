import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:moon_design/moon_design.dart';
import 'package:skana_pica/api/managers/image_cache_manager.dart';
import 'package:skana_pica/api/models/objectbox_models.dart';
import 'package:skana_pica/controller/comicstore.dart';
import 'package:skana_pica/controller/local_comicstore.dart';
import 'package:skana_pica/pages/local_read.dart';
import 'package:skana_pica/pages/pica_comic.dart';
import 'package:skana_pica/pages/pica_list_comics.dart';
import 'package:skana_pica/util/leaders.dart';
import 'package:skana_pica/util/tool.dart';
import 'package:skana_pica/util/widgetplugin.dart';
import 'package:skana_pica/widgets/pica_image.dart';
import 'package:skana_pica/widgets/pica_tagchip.dart';

class LocalComicPage extends StatefulWidget {
  static const route = "/pica_comic";
  final DownloadTask task;
  const LocalComicPage(this.task, {super.key});

  @override
  State<StatefulWidget> createState() => _LocalComicPageState();
}

class _LocalComicPageState extends State<LocalComicPage>
    with TickerProviderStateMixin {
  late LocalComicStore locaComicController;

  @override
  void initState() {
    super.initState();
    locaComicController =
        Get.put(LocalComicStore(), tag: widget.task.id.toString());
    locaComicController.fetch(widget.task);
  }

  @override
  void dispose() {
    Get.delete<ComicStore>(tag: widget.task.id.toString());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color bgColor =
        context.moonTheme?.tokens.colors.frieza60 ?? Colors.deepPurpleAccent;
    Color bgColor2 =
        context.moonTheme?.tokens.colors.chichi60 ?? Colors.deepPurpleAccent;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: appBar(title: locaComicController.comic.value.title),
      backgroundColor: context.moonTheme?.tokens.colors.gohan,
      body: Obx(() {
        return ListView(children: [
          SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 8,
              ),
              PicaImage(
                locaComicController.comic.value.thumbUrl,
                width: context.width / 3,
                height: context.width / 3 * 1.5,
                fit: BoxFit.cover,
              ).rounded(8.0),
              SizedBox(
                width: 8,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(locaComicController.comic.value.title).appHeader(),
                    SizedBox(
                      height: 4,
                    ),
                    InkWell(
                      onLongPress: () => blockDialog(
                          context, locaComicController.comic.value.author),
                      onTap: () {
                        Go.to(
                            PicaCatComicsPage(
                                id: locaComicController.comic.value.author,
                                type: "author"),
                            preventDuplicates: false);
                      },
                      child: Text(locaComicController.comic.value.author,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: context.moonTheme?.tokens.colors.trunks
                                .applyDarkMode(),
                          )).small(),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Row(
                      children: [
                        Icon(
                          BootstrapIcons.heart,
                          size: 11,
                          color: context.moonTheme?.tokens.colors.piccolo,
                        ).paddingTop(2),
                        const SizedBox(
                          width: 2,
                        ),
                        Text(
                          locaComicController.comic.value.likes.toString(),
                          strutStyle: const StrutStyle(
                              forceStrutHeight: true, leading: 0),
                        ).small(),
                        const SizedBox(
                          width: 8,
                        ),
                        Icon(
                          BootstrapIcons.eye,
                          size: 11,
                          color: context.moonTheme?.tokens.colors.piccolo,
                        ).paddingTop(2),
                        const SizedBox(
                          width: 2,
                        ),
                        Text(
                          locaComicController.comic.value.totalViews.toString(),
                          strutStyle: const StrutStyle(
                              forceStrutHeight: true, leading: 0),
                        ).small(),
                        const SizedBox(
                          width: 8,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Row(
                      children: [
                        Icon(
                          BootstrapIcons.journal_text,
                          size: 11,
                          color: context.moonTheme?.tokens.colors.piccolo,
                        ).paddingTop(2),
                        const SizedBox(
                          width: 2,
                        ),
                        Text(
                          '${locaComicController.comic.value.epsCount}E/${locaComicController.comic.value.pagesCount}P',
                          strutStyle: const StrutStyle(
                              forceStrutHeight: true, leading: 0),
                        ).small(),
                        const SizedBox(
                          width: 8,
                        ),
                        if (locaComicController.comic.value.finished == true)
                          TagFinished()
                        else
                          Container(),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        filledButton(
                            onPressed: () => Go.to(PicacgComicPage(
                                locaComicController.comic.value
                                    .toComicItem()
                                    .toBrief())),
                            label: "Comic Page".tr),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 8,
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Divider(
              indent: 8,
              endIndent: 8,
              color: context.moonTheme?.tokens.colors.bulma
                  .withValues(alpha: 0.2)),
          SizedBox(
            height: 8,
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              PicaTag(
                text: "Category".tr,
                type: '',
                backgroundColor: bgColor,
              ),
              ...locaComicController.comic.value.categories
                  .map((e) => PicaTag(
                        text: e,
                        type: 'category',
                        backgroundColor: bgColor,
                      ))
            ],
          ).paddingHorizontal(16),
          SizedBox(
            height: 8,
          ),
          if (locaComicController
              .comic.value.chineseTeam.removeAllBlank.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                PicaTag(
                  text: "Chinese".tr,
                  type: '',
                  backgroundColor: context.moonTheme?.tokens.colors.cell60 ??
                      Colors.deepPurpleAccent,
                ),
                PicaTag(
                  text: locaComicController.comic.value.chineseTeam,
                  type: 'tag',
                  backgroundColor: context.moonTheme?.tokens.colors.cell60 ??
                      Colors.deepPurpleAccent,
                )
              ],
            ).paddingHorizontal(16),
          if (locaComicController
              .comic.value.chineseTeam.removeAllBlank.isNotEmpty)
            SizedBox(
              height: 8,
            ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              PicaTag(
                text: "Tags".tr,
                type: '',
                backgroundColor: bgColor2,
              ),
              ...locaComicController.comic.value.tags.map((e) => PicaTag(
                    text: e,
                    type: 'tag',
                    backgroundColor: bgColor2,
                  ))
            ],
          ).paddingHorizontal(16),
          SizedBox(
            height: 8,
          ),
          moonCard(
            backgroundColor: bgColor,
            padding: EdgeInsets.only(top: 6, bottom: 12),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 16,
                ),
                CircleAvatar(
                  radius: 30,
                  backgroundImage: imageProvider(
                      locaComicController.comic.value.creatorAvatarUrl),
                ),
                SizedBox(
                  width: 8,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(locaComicController.comic.value.creatorName)
                        .header(),
                    Text(
                      "${DateFormat.yMd(Get.locale.toString()).add_jm().format(DateTime.parse(locaComicController.comic.value.time))} ${"Updated".tr}",
                    ).subHeader(),
                  ],
                ),
                SizedBox(
                  width: 32,
                ),
              ],
            ),
          ).paddingHorizontal(16),
          SizedBox(
            height: 8,
          ),
          if (locaComicController
              .comic.value.description.removeAllBlank.isNotEmpty)
            Divider(
                indent: 8,
                endIndent: 8,
                color: context.moonTheme?.tokens.colors.bulma
                    .withValues(alpha: 0.2)),
          if (locaComicController
              .comic.value.description.removeAllBlank.isNotEmpty)
            SizedBox(
              height: 8,
            ),
          if (locaComicController
              .comic.value.description.removeAllBlank.isNotEmpty)
            Text("${"Description: ".tr}\n      ${locaComicController.comic.value.description}")
                .subHeader()
                .paddingHorizontal(16),
          if (locaComicController
              .comic.value.description.removeAllBlank.isNotEmpty)
            SizedBox(
              height: 8,
            ),
          Divider(
              color: context.moonTheme?.tokens.colors.bulma
                  .withValues(alpha: 0.2)),
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 2,
            children: [
              if (locaComicController.dldEps.value != 0 ||
                    locaComicController.currentIndex.value != 0)
                picaChoiceChip(
                  backgroundColor:
                      Get.context!.moonTheme?.tokens.colors.chichi60,
                  selectedColor: Get.context!.moonTheme?.tokens.colors.chichi,
                  disabledColor: Get.context!.moonTheme?.tokens.colors.chichi60,
                  text: "continue_page".trParams({
                      "eps": locaComicController
                          .comic.value.eps[locaComicController.dldEps.value],
                      "page": locaComicController.currentIndex.value.toString()
                    }),
                  selected: false,
                  onSelected: (bool value) {
                      locaComicController.setPage(
                          locaComicController.dldEps.value,
                          locaComicController.currentIndex.value);
                      Go.to(
                          LocalReadPage(id: locaComicController.task.value.id));
                    },
                ),
              for (int index = 0;
                  index < locaComicController.comic.value.eps.length;
                  index++)
                picaChoiceChip(
                  text: locaComicController.comic.value.eps[index],
                  selected: false,
                  onSelected: (bool value) {
                    locaComicController.setPage(index, 0);
                    Go.to(
                        LocalReadPage(id: locaComicController.task.value.id));
                  },
                ),
            ],
          )
        ]);
      }),
    );
  }
}
