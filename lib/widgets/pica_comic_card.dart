import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skana_pica/api/comic_sources/picacg/pica_models.dart';
import 'package:skana_pica/controller/favourite.dart';
import 'package:skana_pica/pages/pica_comic.dart';
import 'package:skana_pica/util/leaders.dart';
import 'package:skana_pica/util/widget_utils.dart';
import 'package:skana_pica/widgets/pica_image.dart';
import 'package:skana_pica/widgets/pica_tagchip.dart';
import 'package:skana_pica/widgets/tag_finished.dart';

class PicaComicCard extends StatefulWidget {
  final PicaComicItemBrief comic;
  final bool isBookmarkPage;
  const PicaComicCard(this.comic, {super.key, this.isBookmarkPage = false});

  @override
  State<PicaComicCard> createState() => _PicaComicCardState();
}

class _PicaComicCardState extends State<PicaComicCard> {
  PicaComicItemBrief get comic => widget.comic;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: InkWell(
          onTap: () {
            Go.to(PicacgComicPage(comic));
          },
          child: Stack(
            children: [
              Card(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: PicaImage(
                        comic.cover,
                        width: Get.width / 4,
                        height: Get.width / 4 * 1.5,
                        fit: BoxFit.cover,
                      ).rounded(8.0),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            comic.title,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyLarge,
                            maxLines: 3,
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            comic.author,
                            maxLines: 1,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    overflow: TextOverflow.ellipsis),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Container(
                            alignment: Alignment.bottomLeft,
                            child: Row(
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
                                  comic.likes.toString(),
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
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
                                  '${comic.epsCount ?? 1}E/${comic.pages ?? 1}P',
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                if (comic.finished == true)
                                  TagFinished()
                                else
                                  Container(),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 2, // gap between adjacent chips
                            runSpacing: 0,
                            children: [
                              if (comic.tags.isEmpty) Container(),
                              for (var f in comic.tags)
                                PicaTag(
                                  text: f,
                                  type: 'tag',
                                ),
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
              ),
              Obx(() {
                if (!widget.isBookmarkPage &&
                    favorController.favorComics.contains(widget.comic.id)) {
                  return Positioned(
                      bottom: 8,
                      right: 8,
                      child: Icon(
                        Icons.bookmark_added_rounded,
                        color: Get.theme.primaryColor.withOpacity(0.3),
                        size: Get.width / 8,
                      ));
                }
                return Container();
              })
            ],
          )),
    );
  }
}
