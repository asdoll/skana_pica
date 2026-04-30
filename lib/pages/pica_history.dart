import 'package:bootstrap_icons/bootstrap_icons.dart' show BootstrapIcons;
import 'package:easy_localization/easy_localization.dart'
    show StringTranslateExtension;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:moon_design/moon_design.dart';
import 'package:skana_pica/controller/history.dart';
import 'package:skana_pica/controller/main_controller.dart';
import 'package:skana_pica/controller/profile.dart';
import 'package:skana_pica/controller/setting_controller.dart';
import 'package:skana_pica/util/leaders.dart';
import 'package:skana_pica/util/widgetplugin.dart';
import 'package:skana_pica/widgets/custom_indicator.dart';
import 'package:skana_pica/widgets/pica_comic_card.dart';

class PicaHistoryPage extends StatefulHookConsumerWidget {
  const PicaHistoryPage({super.key});

  @override
  ConsumerState<PicaHistoryPage> createState() => _PicaHistoryPageState();
}

class _PicaHistoryPageState extends ConsumerState<PicaHistoryPage> {
  @override
  Widget build(BuildContext context) {
    TextEditingController pageJumpController = TextEditingController();
    ScrollController scrollController = globalScrollController;
    ref.read(historyProvider.notifier).init();

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: MoonButton.icon(
        buttonSize: MoonButtonSize.lg,
        showBorder: true,
        borderColor: context.moonTheme?.buttonTheme.colors.borderColor
            .withValues(alpha: 0.5),
        backgroundColor: context.moonTheme?.tokens.colors.zeno,
        onTap: () {
          alertDialog(context, 'clear_history'.tr(), 'clear_all_history'.tr(), [
            outlinedButton(
                label: 'cancel'.tr(), onPressed: () => Navigator.pop(context)),
            filledButton(
                label: 'clear'.tr(),
                onPressed: () {
                  ref.read(historyProvider.notifier).removeHistory();
                  Navigator.pop(context);
                })
          ]);
        },
        icon: Icon(
          BootstrapIcons.trash3,
          color: Colors.white,
        ),
      ),
      body: Column(
        children: [
          if (ref.watch(mangaSettingProvider).picaPageViewMode)
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: ref.watch(historyProvider).totalPage <= 1
                        ? null
                        : () {
                            showMoonModal(
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                      child: ListView(
                                    shrinkWrap: true,
                                    children: [
                                      MoonAlert(
                                          borderColor: context.moonTheme
                                              ?.buttonTheme.colors.borderColor
                                              .withValues(alpha: 0.5),
                                          showBorder: true,
                                          label: Text('jump_to_page'.tr())
                                              .header(),
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
                                                      int.tryParse(value)! <
                                                          1 ||
                                                      int.tryParse(value)! >
                                                          ref
                                                              .read(
                                                                  historyProvider)
                                                              .total) {
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
                                                          ref
                                                              .read(
                                                                  historyProvider)
                                                              .totalPage) {
                                                    scrollController.animateTo(
                                                        0,
                                                        duration:
                                                            const Duration(
                                                                microseconds:
                                                                    200),
                                                        curve: Curves.ease);
                                                    ref.read(historyProvider.notifier).toPage(
                                                        index: pageNumber);
                                                    Navigator.pop(context);
                                                  } else {
                                                    showToast(
                                                        'invalid_page_number'
                                                            .tr());
                                                  }
                                                },
                                              ).paddingBottom(16),
                                              Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    filledButton(
                                                      label: "cancel".tr(),
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                    ).paddingRight(8),
                                                    filledButton(
                                                      label: "ok".tr(),
                                                      onPressed: () {
                                                        FocusManager.instance
                                                            .primaryFocus
                                                            ?.unfocus();
                                                        int? pageNumber =
                                                            int.tryParse(
                                                                pageJumpController
                                                                    .value
                                                                    .text);
                                                        if (pageNumber !=
                                                                null &&
                                                            pageNumber >= 0 &&
                                                            pageNumber <
                                                                ref.read(historyProvider)
                                                                    .totalPage) {
                                                          scrollController.animateTo(
                                                              0,
                                                              duration:
                                                                  const Duration(
                                                                      microseconds:
                                                                          200),
                                                              curve:
                                                                  Curves.ease);
                                                          ref.read(historyProvider.notifier).toPage(
                                                              index:
                                                                  pageNumber);
                                                          Navigator.pop(
                                                              context);
                                                        } else {
                                                          showToast(
                                                              'invalid_page_number'
                                                                  .tr());
                                                        }
                                                      },
                                                    ).paddingRight(8),
                                                  ]),
                                            ],
                                          )),
                                    ],
                                  ));
                                });
                          },
                    child: Text('at_page'.tr(args: [
                      (ref.watch(historyProvider).page + 1).toString(),
                      ref.watch(historyProvider).totalPage == 0
                          ? "1"
                          : ref.watch(historyProvider).totalPage.toString()
                    ])).subHeader()),
                Expanded(child: SizedBox()),
                filledButton(
                  color: context.moonTheme?.tokens.colors.cell60,
                  label: "prev_page".tr(),
                  applyDarkMode: true,
                  onPressed: (ref.watch(historyProvider).page == 0)
                      ? null
                      : () {
                          scrollController.animateTo(0,
                              duration: const Duration(microseconds: 200),
                              curve: Curves.ease);
                          ref.read(historyProvider.notifier).toPage(index: ref.watch(historyProvider).page - 1);
                        },
                ),
                SizedBox(width: 4),
                filledButton(
                  color: context.moonTheme?.tokens.colors.cell60,
                  label: "next_page".tr(),
                  applyDarkMode: true,
                  onPressed: (ref.watch(historyProvider).page + 1 >=
                          ref.watch(historyProvider).totalPage)
                      ? null
                      : () {
                          scrollController.animateTo(0,
                              duration: const Duration(microseconds: 200),
                              curve: Curves.ease);
                          ref.read(historyProvider.notifier).toPage(index: ref.watch(historyProvider).page + 1);
                        },
                ),
                SizedBox(width: 16),
              ],
            ),
          SizedBox(
            height: 4,
          ),
          Expanded(
            child: BezierIndicator(
              onRefresh: () async {
                if (ref.read(historyProvider).history.isEmpty) {
                  ref.read(historyProvider.notifier).init();
                } else {
                  ref.read(historyProvider.notifier).toPage(index: ref.read(historyProvider).page);
                }
              },
              child: ListView.builder(
                controller: scrollController,
                itemCount: ref.watch(historyProvider).comics.length + 1,
                itemBuilder: (context, index) {
                  if (index == ref.watch(historyProvider).comics.length) {
                    if (!ref.watch(mangaSettingProvider).picaPageViewMode) {
                      ref.read(historyProvider.notifier).toPage();
                    }
                    if ((ref.watch(historyProvider).page + 1 <
                            ref.watch(historyProvider).totalPage) &&
                        !ref.watch(historyProvider).isLoading) {
                      return Center(
                        child: IconButton(
                            onPressed: () {
                              scrollController.animateTo(0,
                                  duration: const Duration(microseconds: 200),
                                  curve: Curves.ease);
                              ref.read(historyProvider.notifier).toPage(
                                  index: ref.read(historyProvider).page + 1);
                            },
                            icon: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 40,
                            )),
                      );
                    } else {
                      return Container();
                    }
                  }
                  if (ref.watch(historyProvider).comics.isEmpty) {
                    return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: Center(
                          child: Text(
                            "[ ]",
                            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary
                                    .withValues(alpha: 0.7)),
                          ),
                        ));
                  }
                  if (!ref.watch(profileProvider).isLogin) {
                    return InkWell(
                      onTap: () => showToast("not_logged_in".tr()),
                      child: IgnorePointer(
                        child: PicaComicCard(
                          ref.watch(historyProvider).comics[index],
                          type: "history",
                        ),
                      ),
                    );
                  }
                  return PicaComicCard(ref.watch(historyProvider).comics[index],
                      type: "history");
                },
                physics: BouncingScrollPhysics(),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
