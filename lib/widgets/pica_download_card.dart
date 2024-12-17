import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skana_pica/api/models/objectbox_models.dart';
import 'package:skana_pica/controller/downloadstore.dart';
import 'package:skana_pica/pages/local_comic.dart';
import 'package:skana_pica/util/leaders.dart';
import 'package:skana_pica/util/widget_utils.dart';
import 'package:skana_pica/widgets/pica_image.dart';
import 'package:skana_pica/widgets/pica_tagchip.dart';
import 'package:skana_pica/widgets/tag_finished.dart';

class DownloadComicCard extends StatefulWidget {
  final DownloadTask task;
  const DownloadComicCard(this.task, {super.key});

  @override
  State<DownloadComicCard> createState() => _DownloadComicCardState();
}

class _DownloadComicCardState extends State<DownloadComicCard> {

  @override
  void initState() {
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: InkWell(
          onTap: () {
            Go.to(LocalComicPage(widget.task));
          },
          child: Obx(() => Stack(
                children: [
                  Card(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: PicaImage(
                            widget.task.comic.target!.thumbUrl,
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
                                widget.task.comic.target!.title,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodyLarge,
                                maxLines:3,
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                widget.task.comic.target!.author,
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
                                      widget.task.comic.target!.likes.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge,
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
                                        '${widget.task.comic.target!.epsCount}E/ ${widget.task.comic.target!.pagesCount}P',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge,
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                    if (widget.task.comic.target!.finished == true)
                                      TagFinished()
                                    else
                                      Container(),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Row(
                                  children: [
                                    PicaTag(
                                      text:
                                          "${"Downloaded".tr}: ${downloadStore.progress[widget.task.id]}/${downloadStore.total[widget.task.id]}",
                                      type: "placed",
                                      style: Get.textTheme.bodySmall?.copyWith(
                                          color: Get
                                              .theme.colorScheme.onSecondary),
                                      backgroundColor:
                                          Get.theme.colorScheme.secondary,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 4,
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
                ],
              ))),
    );
  }
}
