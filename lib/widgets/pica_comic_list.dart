import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:easy_localization/easy_localization.dart'
    show StringTranslateExtension;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moon_design/moon_design.dart';
import 'package:skana_pica/controller/comiclist.dart';
import 'package:skana_pica/controller/main_controller.dart';
import 'package:skana_pica/controller/profile.dart';
import 'package:skana_pica/controller/setting_controller.dart';
import 'package:skana_pica/util/leaders.dart';
import 'package:skana_pica/util/widgetplugin.dart';
import 'package:skana_pica/widgets/custom_indicator.dart';
import 'package:skana_pica/widgets/icons.dart';
import 'package:skana_pica/widgets/pica_comic_card.dart';

class PicaComicsPage extends StatefulHookConsumerWidget {
  final String keyword;
  final String type;
  final bool? addToHistory;
  final String? sort;
  final bool fromDrawer;
  final ScrollController? scrollController;

  const PicaComicsPage(
      {super.key,
      required this.keyword,
      required this.type,
      this.addToHistory,
      this.sort,
      this.scrollController,
      this.fromDrawer = false});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PicaComicsPageState();
}

class _PicaComicsPageState extends ConsumerState<PicaComicsPage> {
  @override
  Widget build(BuildContext context) {
    final provider = comicListProvider(
        keyword: widget.keyword,
        type: widget.type,
        isAuthor: widget.type == "author",
        isSearch: widget.type == "search",
        sortByDefault: widget.sort ?? "",
        addToHistory: widget.addToHistory ?? false);
    TextEditingController pageJumpController = TextEditingController();
    ref.read(provider.notifier).reset();
    GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
        GlobalKey<RefreshIndicatorState>();
    ScrollController scrollController =
        widget.scrollController ?? globalScrollController;
    return !ref.watch(profileProvider).isLogin
        ? ErrorLoading(text: "not_logged_in".tr())
        : Column(
            children: [
              if (widget.keyword == "leaderboard")
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: Leaderboard.items.map((String value) {
                    return filledButton(
                      label: value.tr(),
                      textColor: context.moonTheme?.tokens.colors.bulma,
                      color: ref.watch(leaderboardProvider) == value
                          ? context.moonTheme?.tokens.colors.frieza60
                          : context.moonTheme?.tokens.colors.goku,
                      onPressed: () {
                        ref.read(leaderboardProvider.notifier).setType(value);
                        ref.read(provider.notifier).reset();
                      },
                    );
                  }).toList(),
                ).paddingVertical(8),
              if (widget.keyword != "leaderboard" &&
                  widget.keyword != "latest" &&
                  widget.keyword != "random" &&
                  !ref.watch(mangaSettingProvider).picaPageViewMode)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    filledButton(
                      label: "new_to_old".tr(),
                      textColor: context.moonTheme?.tokens.colors.bulma,
                      color: ref.watch(provider).sort == 0
                          ? context.moonTheme?.tokens.colors.frieza60
                          : context.moonTheme?.tokens.colors.goku,
                      onPressed: () {
                        ref.read(provider.notifier).resetWithSort(0);
                      },
                    ),
                    filledButton(
                      label: "old_to_new".tr(),
                      textColor: context.moonTheme?.tokens.colors.bulma,
                      color: ref.watch(provider).sort == 1
                          ? context.moonTheme?.tokens.colors.frieza60
                          : context.moonTheme?.tokens.colors.goku,
                      onPressed: () {
                        ref.read(provider.notifier).resetWithSort(1);
                      },
                    ),
                    if (widget.keyword != "bookmarks")
                      filledButton(
                        label: 'most_likes'.tr(),
                        textColor: context.moonTheme?.tokens.colors.bulma,
                        color: ref.watch(provider).sort == 2
                            ? context.moonTheme?.tokens.colors.frieza60
                            : context.moonTheme?.tokens.colors.goku,
                        onPressed: () {
                          ref.read(provider.notifier).resetWithSort(2);
                        },
                      ),
                    if (widget.keyword != "bookmarks")
                      filledButton(
                        label: 'most_viewed'.tr(),
                        textColor: context.moonTheme?.tokens.colors.bulma,
                        color: ref.watch(provider).sort == 3
                            ? context.moonTheme?.tokens.colors.frieza60
                            : context.moonTheme?.tokens.colors.goku,
                        onPressed: () {
                          ref.read(provider.notifier).resetWithSort(3);
                        },
                      ),
                  ],
                ).paddingVertical(8),
              if (ref.watch(mangaSettingProvider).picaPageViewMode &&
                  ref.watch(provider).total > 1)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 12,
                    ),
                    if (widget.keyword != "leaderboard" &&
                        widget.keyword != "latest" &&
                        widget.keyword != "random")
                      MoonDropdown(
                          show: ref.watch(provider).filterMenu,
                          onTapOutside: () =>
                              ref.read(provider.notifier).closeMenu(),
                          offset: Offset(5, 0),
                          minWidth: 80,
                          maxWidth: 80,
                          content: Column(
                            children: [
                              MoonMenuItem(
                                label: Text('new_to_old'.tr()).small(),
                                onTap: () {
                                  ref.read(provider.notifier).closeMenu();
                                  ref.read(provider.notifier).resetWithSort(0);
                                },
                              ),
                              MoonMenuItem(
                                label: Text('old_to_new'.tr()).small(),
                                onTap: () {
                                  ref.read(provider.notifier).closeMenu();
                                  ref.read(provider.notifier).resetWithSort(1);
                                },
                              ),
                              if (widget.keyword != "bookmarks")
                                MoonMenuItem(
                                  label: Text('most_likes'.tr()).small(),
                                  onTap: () {
                                    ref.read(provider.notifier).closeMenu();
                                    ref.read(provider.notifier).resetWithSort(2);
                                  },
                                ),
                              if (widget.keyword != "bookmarks")
                                MoonMenuItem(
                                  label: Text('most_viewed'.tr()).small(),
                                  onTap: () {
                                    ref.read(provider.notifier).closeMenu();
                                    ref.read(provider.notifier).resetWithSort(3);
                                  },
                                ),
                            ],
                          ),
                          child: filledButton(
                              label: ref.watch(provider).sort == 0
                                  ? "new_to_old".tr()
                                  : ref.watch(provider).sort == 1
                                      ? "old_to_new".tr()
                                      : ref.watch(provider).sort == 2
                                          ? "most_likes".tr()
                                          : "most_viewed".tr(),
                              onPressed: () => ref.read(provider.notifier).toggleMenu())),
                    TextButton(
                        onPressed: () {
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
                                        label:
                                            Text('jump_to_page'.tr()).header(),
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
                                                        ref.watch(provider).total) {
                                                  return 'invalid_page_number'
                                                      .tr();
                                                }
                                                return null;
                                              },
                                              onSubmitted: (value) {
                                                int pageNumber =
                                                    int.parse(value);
                                                ref.read(provider.notifier)
                                                    .pageFetch(pageNumber);
                                              },
                                            ).paddingBottom(16),
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  filledButton(
                                                    label: "cancel".tr(),
                                                    onPressed: () => () =>
                                                        Navigator.pop(
                                                            context),
                                                  ).paddingRight(8),
                                                  filledButton(
                                                    label: "ok".tr(),
                                                    onPressed: () {
                                                      FocusManager
                                                          .instance.primaryFocus
                                                          ?.unfocus();
                                                      if (int.tryParse(
                                                              pageJumpController
                                                                  .text) ==
                                                          null) {
                                                        showToast(
                                                            "invalid_page_number"
                                                                .tr());
                                                        return;
                                                      }
                                                      int pageNumber =
                                                          int.tryParse(
                                                              pageJumpController
                                                                  .text)!;
                                                      if (pageNumber < 1 ||
                                                          pageNumber >
                                                              ref.watch(provider).total) {
                                                        showToast(
                                                            "invalid_page_number"
                                                                .tr());
                                                        return;
                                                      }
                                                      ref.read(provider.notifier).pageFetch(
                                                          pageNumber);
                                                      Navigator.pop(context);
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
                          ref.watch(provider).page.toString(),
                          ref.watch(provider).total.toString()
                        ])).subHeader()),
                    Expanded(child: SizedBox()),
                    filledButton(
                      color: context.moonTheme?.tokens.colors.cell60,
                      label: "prev_page".tr(),
                      applyDarkMode: true,
                      onPressed: (ref.watch(provider).page == 1)
                          ? null
                          : () {
                              ref.read(provider.notifier).pageFetch(ref.read(provider).page - 1);
                              scrollController.animateTo(-100,
                                  duration: const Duration(microseconds: 200),
                                  curve: Curves.ease);
                              refreshIndicatorKey.currentState?.show();
                            },
                    ),
                    SizedBox(width: 4),
                    filledButton(
                      color: context.moonTheme?.tokens.colors.cell60,
                      label: "next_page".tr(),
                      applyDarkMode: true,
                      onPressed: (ref.watch(provider).page ==
                              ref.watch(provider).total)
                          ? null
                          : () {
                              ref.read(provider.notifier).pageFetch(ref.read(provider).page + 1);
                              scrollController.animateTo(-100,
                                  duration: const Duration(microseconds: 200),
                                  curve: Curves.ease);
                              refreshIndicatorKey.currentState?.show();
                            },
                    ),
                    SizedBox(width: 16),
                  ],
                ),
              Expanded(
                  child: BezierIndicator(
                      onRefresh: () => ref.read(provider.notifier).reset(drag: true),
                      child: Stack(children: [
                            ListView.builder(
                              controller: scrollController,
                              itemCount: ref.watch(provider).comics.length + 1,
                              itemBuilder: (context, index) {
                                if (index == ref.watch(provider).comics.length) {
                                  if (ref.watch(provider).comics.isEmpty) {
                                    return !ref.watch(provider).isLoading
                                        ? SizedBox(
                                            height: MediaQuery.of(context).size.height * 0.8,
                                            child: Center(
                                              child: Text("[ ]").h1(),
                                            ))
                                        : Container();
                                  }
                                  if (ref.watch(provider).page <
                                      ref.watch(provider).total) {
                                    if (ref.watch(mangaSettingProvider)
                                        .picaPageViewMode) {
                                      return !ref.watch(provider).isLoading
                                          ? Center(
                                              child: MoonButton.icon(
                                                  onTap: () {
                                                    scrollController.animateTo(
                                                        0,
                                                        duration:
                                                            const Duration(
                                                                microseconds:
                                                                    200),
                                                        curve: Curves.ease);
                                                    ref.read(provider.notifier).pageFetch(
                                                        ref.read(provider).page +
                                                            1);
                                                  },
                                                  icon: Icon(
                                                    BootstrapIcons
                                                        .chevron_compact_down,
                                                    size: 40,
                                                  )),
                                            )
                                          : Container();
                                    } else {
                                      if (!ref.watch(provider).isLoading) {
                                        Future.delayed(
                                            const Duration(microseconds: 100),
                                            () {
                                          ref.read(provider.notifier).onLoad();
                                        });
                                      }
                                      return progressIndicator(context)
                                          .paddingVertical(10);
                                    }
                                  } else {
                                    return Container();
                                  }
                                }
                                return PicaComicCard(
                                  ref.watch(provider).comics[index],
                                  type: widget.keyword == "bookmarks"
                                      ? "bookmarks"
                                      : "comic",
                                );
                              },
                              physics: BouncingScrollPhysics(),
                            ),
                            if (!ref.watch(provider).isDrag &&
                                ref.watch(provider).isLoading)
                              Center(
                                child: progressIndicator(context),
                              )
                          ]))),
              SizedBox(
                height: 10,
              ),
            ],
          );
  }
}
