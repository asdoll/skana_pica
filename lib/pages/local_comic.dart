import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:skana_pica/api/managers/image_cache_manager.dart';
import 'package:skana_pica/api/models/objectbox_models.dart';
import 'package:skana_pica/controller/comicstore.dart';
import 'package:skana_pica/controller/local_comicstore.dart';
import 'package:skana_pica/pages/local_read.dart';
import 'package:skana_pica/pages/pica_comic.dart';
import 'package:skana_pica/pages/pica_list_comics.dart';
import 'package:skana_pica/pages/pica_results.dart';
import 'package:skana_pica/util/leaders.dart';
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
    TextStyle? tagStyle = Theme.of(context).textTheme.bodyLarge;
    Color bgColor = Theme.of(context).colorScheme.primaryContainer;
    Color bgColor2 = Theme.of(context).colorScheme.primaryContainer;

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(locaComicController.comic.value.title)),
      ),
      body: Obx(() {
        return ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 8,
                    ),
                    PicaImage(
                      locaComicController.comic.value.thumbUrl,
                      width: Get.width / 3,
                      height: Get.width / 3 * 1.5,
                      fit: BoxFit.cover,
                      downloaded: true,
                    ).rounded(8.0),
                    SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            locaComicController.comic.value.title,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          InkWell(
                            onLongPress: () => blockDialog(context,
                                locaComicController.comic.value.author),
                            onTap: () {
                              Go.to(
                                  PicaCatComicsPage(
                                      id: locaComicController
                                          .comic.value.author,
                                      type: "author"),
                                  preventDuplicates: false);
                            },
                            child: Text(
                              locaComicController.comic.value.author,
                              maxLines: 1,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      overflow: TextOverflow.ellipsis),
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          InkWell(
                            onLongPress: () => blockDialog(context,
                                locaComicController.comic.value.chineseTeam),
                            onTap: () {
                              Go.to(
                                  PicaResultsPage(
                                    keyword: locaComicController
                                        .comic.value.chineseTeam,
                                    addToHistory: false,
                                  ),
                                  preventDuplicates: false);
                            },
                            child: Text(
                              locaComicController.comic.value.chineseTeam,
                              maxLines: 1,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                      overflow: TextOverflow.ellipsis),
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.favorite,
                                size: 12,
                                color: Colors.pink,
                              ),
                              const SizedBox(
                                width: 2,
                              ),
                              Text(
                                locaComicController.comic.value.likes
                                    .toString(),
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Icon(Icons.remove_red_eye_rounded,
                                  size: 12,
                                  color: Theme.of(context)
                                      .textTheme
                                      .labelLarge!
                                      .color),
                              const SizedBox(
                                width: 2,
                              ),
                              Text(
                                locaComicController.comic.value.totalViews
                                    .toString(),
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
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
                                Icons.sticky_note_2_outlined,
                                size: 12,
                                color: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .color,
                              ),
                              const SizedBox(
                                width: 2,
                              ),
                              Text(
                                '${locaComicController.comic.value.epsCount}E/${locaComicController.comic.value.pagesCount}P',
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              if (locaComicController.comic.value.finished ==
                                  true)
                                TagFinished()
                              else
                                Container(),
                            ],
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Row(
                            children: [
                              ElevatedButton(onPressed: () => Go.to(PicacgComicPage(locaComicController.comic.value.toComicItem().toBrief())), child: Text("Comic Page".tr)),
                            ],
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
                Divider(indent: 8, endIndent: 8),
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
                      style: tagStyle,
                      backgroundColor: bgColor,
                    ),
                    ...locaComicController.comic.value.categories
                        .map((e) => PicaTag(
                              text: e,
                              type: 'category',
                              style: tagStyle,
                              backgroundColor: bgColor,
                            ))
                  ],
                ).paddingHorizontal(16),
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
                      style: tagStyle,
                      backgroundColor: bgColor2,
                    ),
                    ...locaComicController.comic.value.tags.map((e) => PicaTag(
                          text: e,
                          type: 'tag',
                          style: tagStyle,
                          backgroundColor: bgColor2,
                        ))
                  ],
                ).paddingHorizontal(16),
                SizedBox(
                  height: 8,
                ),
                Card(
                  color: bgColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 32,
                      ),
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: localProvider(
                            locaComicController.comic.value.creatorAvatarUrl),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            locaComicController.comic.value.creatorName,
                            style: Get.theme.textTheme.bodyLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${DateFormat.yMd(Get.locale.toString()).add_jm().format(DateTime.parse(locaComicController.comic.value.time))} ${"Updated".tr}",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 32,
                      ),
                    ],
                  ).paddingVertical(8),
                ).paddingHorizontal(16),
                SizedBox(
                  height: 8,
                ),
                Divider(indent: 8, endIndent: 8),
                SizedBox(
                  height: 8,
                ),
                Text(
                  "Description: ".tr +
                      locaComicController.comic.value.description,
                  style: Theme.of(context).textTheme.titleMedium,
                ).paddingHorizontal(16),
                SizedBox(
                  height: 8,
                ),
                Divider(),
              ],
            ),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: [
                if (locaComicController.dldEps.value != 0 ||
                    locaComicController.currentIndex.value != 0)
                  ChoiceChip(
                    label: Text("continue_page".trParams({
                      "eps": locaComicController.comic.value
                          .eps[locaComicController.dldEps.value],
                      "page": locaComicController.currentIndex.value.toString()
                    })),
                    selected: false,
                    onSelected: (bool value) {
                      locaComicController.setPage(
                          locaComicController.dldEps.value,
                          locaComicController.currentIndex.value);
                      Go.to(
                          LocalReadPage(id: locaComicController.task.value.id));
                    },
                    backgroundColor: bgColor2,
                  ),
                for (int index = 0;
                    index < locaComicController.eps.length;
                    index++)
                  ChoiceChip(
                    label: Text(locaComicController.comic.value.eps[locaComicController.eps[index].eps]),
                    selected: false,
                    onSelected: (bool value) {
                      locaComicController.setPage(index, 0);
                      Go.to(
                          LocalReadPage(id: locaComicController.task.value.id));
                    },
                  ),
              ],
            ).paddingAll(16),
          ],
        );
      }),
    );
  }
}
