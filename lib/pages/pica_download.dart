import 'dart:math';

import 'package:easy_localization/easy_localization.dart'
    show StringTranslateExtension;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:moon_design/moon_design.dart';
import 'package:skana_pica/controller/downloadstore.dart';
import 'package:skana_pica/controller/main_controller.dart';
import 'package:skana_pica/controller/setting_controller.dart';
import 'package:skana_pica/util/leaders.dart';
import 'package:skana_pica/util/widgetplugin.dart';
import 'package:skana_pica/widgets/pica_download_card.dart';

class PicaDownloadPage extends StatefulHookConsumerWidget {
  static const route = "/pica_download";
  const PicaDownloadPage({super.key});

  @override
  ConsumerState<PicaDownloadPage> createState() => _PicaDownloadPageState();
}

class _PicaDownloadPageState extends ConsumerState<PicaDownloadPage> {
  @override
  Widget build(BuildContext context) {
    TextEditingController pageJumpController = TextEditingController();
    ScrollController scrollController = globalScrollController;

    return Column(
      children: [
        if (ref.watch(mangaSettingProvider).picaPageViewMode)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: ref.watch(downloadProvider).tasks.length <=
                          DownloadPage.perPage
                      ? null
                      : () {
                          showMoonModal(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                    child:
                                        ListView(shrinkWrap: true, children: [
                                  MoonAlert(
                                      borderColor: context.moonTheme
                                          ?.buttonTheme.colors.borderColor
                                          .withValues(alpha: 0.5),
                                      showBorder: true,
                                      label: Text('jump_to_page'.tr()).header(),
                                      verticalGap: 16,
                                      content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            MoonFormTextInput(
                                              controller: pageJumpController,
                                              keyboardType:
                                                  TextInputType.number,
                                              hintText: "page_number".tr(),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty ||
                                                    int.tryParse(value) ==
                                                        null ||
                                                    int.tryParse(value)! < 1 ||
                                                    int.tryParse(value)! >
                                                        (ref
                                                                    .read(
                                                                        downloadProvider)
                                                                    .tasks
                                                                    .length /
                                                                DownloadPage
                                                                    .perPage)
                                                            .ceil()) {
                                                  return 'invalid_page_number'
                                                      .tr();
                                                }
                                                return null;
                                              },
                                              onSubmitted: (value) {
                                                int? pageNumber =
                                                    int.tryParse(value);
                                                if (pageNumber != null &&
                                                    pageNumber >= 0 &&
                                                    pageNumber <
                                                        (ref
                                                                    .read(
                                                                        downloadProvider)
                                                                    .tasks
                                                                    .length /
                                                                DownloadPage
                                                                    .perPage)
                                                            .ceil()) {
                                                  scrollController.animateTo(0,
                                                      duration: const Duration(
                                                          microseconds: 200),
                                                      curve: Curves.ease);
                                                  ref
                                                      .read(downloadPageProvider
                                                          .notifier)
                                                      .setPage(pageNumber);
                                                  Navigator.pop(context);
                                                } else {
                                                  showToast(
                                                      "invalid_page_number"
                                                          .tr());
                                                }
                                              },
                                            ),
                                            SizedBox(height: 16),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                outlinedButton(
                                                  label: 'cancel'.tr(),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                SizedBox(width: 8),
                                                filledButton(
                                                    label: 'ok'.tr(),
                                                    onPressed: () {
                                                      int? pageNumber =
                                                          int.tryParse(
                                                              pageJumpController
                                                                  .value.text);
                                                      if (pageNumber != null &&
                                                          pageNumber >= 0 &&
                                                          pageNumber <
                                                              (ref
                                                                          .read(
                                                                              downloadProvider)
                                                                          .tasks
                                                                          .length /
                                                                      DownloadPage
                                                                          .perPage)
                                                                  .ceil()) {
                                                        scrollController.animateTo(
                                                            0,
                                                            duration:
                                                                const Duration(
                                                                    microseconds:
                                                                        200),
                                                            curve: Curves.ease);
                                                        ref
                                                            .read(
                                                                downloadPageProvider
                                                                    .notifier)
                                                            .setPage(
                                                                pageNumber);
                                                        Navigator.pop(context);
                                                      } else {
                                                        showToast(
                                                            'invalid_page_number'
                                                                .tr());
                                                      }
                                                    }),
                                              ],
                                            )
                                          ]))
                                ]));
                              });
                        },
                  child: Text('at_page'.tr(args: [
                    (ref.watch(downloadPageProvider) + 1).toString(),
                    (ref.watch(downloadProvider).tasks.length /
                                    DownloadPage.perPage)
                                .ceil() ==
                            0
                        ? "1"
                        : (ref.watch(downloadProvider).tasks.length /
                                DownloadPage.perPage)
                            .ceil()
                            .toString()
                  ])).subHeader()),
              Expanded(child: SizedBox()),
              filledButton(
                color: context.moonTheme?.tokens.colors.cell60,
                label: "prev_page".tr(),
                applyDarkMode: true,
                onPressed: (ref.read(downloadPageProvider) == 0)
                    ? null
                    : () {
                        scrollController.animateTo(0,
                            duration: const Duration(microseconds: 200),
                            curve: Curves.ease);
                        ref.read(downloadPageProvider.notifier).prevPage();
                      },
              ),
              SizedBox(width: 4),
              filledButton(
                color: context.moonTheme?.tokens.colors.cell60,
                label: "next_page".tr(),
                applyDarkMode: true,
                onPressed: (ref.read(downloadPageProvider) ==
                        (ref.read(downloadProvider).tasks.length ~/
                            DownloadPage.perPage))
                    ? null
                    : () {
                        scrollController.animateTo(0,
                            duration: const Duration(microseconds: 200),
                            curve: Curves.ease);
                        ref.read(downloadPageProvider.notifier).nextPage();
                      },
              ),
              SizedBox(width: 16),
            ],
          ),
        SizedBox(height: 8),
        if (ref.watch(mangaSettingProvider).picaPageViewMode)
          Expanded(
            child: ListView.builder(
                itemBuilder: (context, index) {
                  return DownloadComicCard(ref.watch(downloadProvider).tasks[
                      index +
                          ref.watch(downloadPageProvider) *
                              DownloadPage.perPage]);
                },
                itemCount: min(
                    DownloadPage.perPage,
                    ref.watch(downloadProvider).tasks.length -
                        ref.watch(downloadPageProvider) * DownloadPage.perPage),
                controller: scrollController),
          ),
        if (!ref.watch(mangaSettingProvider).picaPageViewMode)
          Expanded(
            child: ListView.builder(
                itemBuilder: (context, index) {
                  return DownloadComicCard(
                      ref.watch(downloadProvider).tasks[index]);
                },
                itemCount: ref.watch(downloadProvider).tasks.length,
                controller: scrollController),
          ),
      ],
    );
  }
}
