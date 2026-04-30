import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:easy_localization/easy_localization.dart'
    show StringTranslateExtension;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:moon_design/moon_design.dart';
import 'package:skana_pica/controller/blocker.dart';
import 'package:skana_pica/controller/categories.dart';
import 'package:skana_pica/controller/setting_controller.dart';
import 'package:skana_pica/pages/setting/setting_page.dart';
import 'package:skana_pica/util/widgetplugin.dart';
import 'package:skana_pica/widgets/pica_tagchip.dart';

class MangaSettingPage extends StatefulHookConsumerWidget {
  static const route = "${SettingPage.route}/manga";
  final bool fromMain;
  const MangaSettingPage({super.key, this.fromMain = false});

  @override
  ConsumerState<MangaSettingPage> createState() => _MangaSettingPageState();
}

class _MangaSettingPageState extends ConsumerState<MangaSettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: "manga_settings".tr()),
      body: ListView(
        children: [
          SizedBox(height: 16),
          moonListTile(
            leading: Icon(BootstrapIcons.arrow_left_right),
            title: "set_stream".tr(),
            trailing: MoonDropdown(
              offset: Offset(-10, 0),
              minWidth: 100,
              maxWidth: 100,
              show: ref.watch(mangaSettingProvider).streamMenu,
              onTapOutside: () =>
                  ref.read(mangaSettingProvider.notifier).setStreamMenu(),
              content: Column(
                children: [
                  MoonMenuItem(
                      onTap: () {
                        ref.read(mangaSettingProvider.notifier).setStreamMenu();
                        ref.read(mangaSettingProvider.notifier).setPicaStream(0);
                      },
                      label: Text('stream_1'.tr())),
                  MoonMenuItem(
                      onTap: () {
                        ref.read(mangaSettingProvider.notifier).setStreamMenu();
                        ref.read(mangaSettingProvider.notifier).setPicaStream(1);
                      },
                      label: Text('stream_2'.tr())),
                  MoonMenuItem(
                      onTap: () {
                        ref.read(mangaSettingProvider.notifier).setStreamMenu();
                        ref.read(mangaSettingProvider.notifier).setPicaStream(2);
                      },
                      label: Text('stream_3'.tr())),
                ],
              ),
              child: filledButton(
                label: ref.watch(mangaSettingProvider).picaStream == 0
                    ? 'stream_1'.tr()
                    : ref.watch(mangaSettingProvider).picaStream == 1
                        ? 'stream_2'.tr()
                        : 'stream_3'.tr(),
                onPressed: () => ref.read(mangaSettingProvider.notifier).setStreamMenu(!ref.read(mangaSettingProvider).streamMenu),
              ),
            ),
          ),
          moonListTile(
            leading: Icon(BootstrapIcons.image),
            title: "set_image_quality".tr(),
            trailing: MoonDropdown(
              offset: Offset(-10, 0),
              minWidth: 100,
              maxWidth: 100,
              show: ref.watch(mangaSettingProvider).imageQualityMenu,
              onTapOutside: () =>
                  ref.read(mangaSettingProvider.notifier).setIQMenu(),
              content: Column(
                children: [
                  MoonMenuItem(
                      onTap: () {
                        ref.read(mangaSettingProvider.notifier).setIQMenu();
                        ref.read(mangaSettingProvider.notifier).setPicaImageQuality('low');
                      },
                      label: Text('low'.tr())),
                  MoonMenuItem(
                      onTap: () {
                        ref.read(mangaSettingProvider.notifier).setIQMenu();
                        ref.read(mangaSettingProvider.notifier).setPicaImageQuality('medium');
                      },
                      label: Text('medium'.tr())),
                  MoonMenuItem(
                      onTap: () {
                        ref.read(mangaSettingProvider.notifier).setIQMenu();
                        ref.read(mangaSettingProvider.notifier).setPicaImageQuality('high');
                      },
                      label: Text('high'.tr())),
                  MoonMenuItem(
                      onTap: () {
                        ref.read(mangaSettingProvider.notifier).setIQMenu();
                        ref.read(mangaSettingProvider.notifier).setPicaImageQuality('original');
                      },
                      label: Text('original_image'.tr())),
                ],
              ),
              child: filledButton(
                label: ref.watch(mangaSettingProvider).picaImageQuality == 'low'
                    ? 'low'.tr()
                    : ref.watch(mangaSettingProvider).picaImageQuality == 'medium'
                        ? 'medium'.tr()
                        : ref.watch(mangaSettingProvider).picaImageQuality ==
                                'high'
                            ? 'high'.tr()
                            : 'original_image'.tr(),
                onPressed: () => ref.read(mangaSettingProvider.notifier).setIQMenu(!ref.read(mangaSettingProvider).imageQualityMenu),
              ),
            ),
          ),
          moonListTile(
            leading: Icon(BootstrapIcons.search),
            title: "set_search_and_category_sorting_mode".tr(),
            trailing: MoonDropdown(
              offset: Offset(-10, 0),
              minWidth: 100,
              maxWidth: 100,
              show: ref.watch(mangaSettingProvider).searchModeMenu,
              onTapOutside: () =>
                  ref.read(mangaSettingProvider.notifier).setSMMenu(),
              content: Column(
                children: [
                  MoonMenuItem(
                      onTap: () {
                        ref.read(mangaSettingProvider.notifier).setSMMenu();
                        ref.read(mangaSettingProvider.notifier).setPicaSearchMode(0);
                      },
                      label: Text('new_to_old'.tr())),
                  MoonMenuItem(
                      onTap: () {
                        ref.read(mangaSettingProvider.notifier).setSMMenu();
                        ref.read(mangaSettingProvider.notifier).setPicaSearchMode(1);
                      },
                      label: Text('old_to_new'.tr())),
                  MoonMenuItem(
                      onTap: () {
                        ref.read(mangaSettingProvider.notifier).setSMMenu();
                        ref.read(mangaSettingProvider.notifier).setPicaSearchMode(2);
                      },
                      label: Text('most_likes'.tr())),
                  MoonMenuItem(
                      onTap: () {
                        ref.read(mangaSettingProvider.notifier).setSMMenu();
                        ref.read(mangaSettingProvider.notifier).setPicaSearchMode(3);
                      },
                      label: Text('most_viewed'.tr())),
                ],
              ),
              child: filledButton(
                label: ref.watch(mangaSettingProvider).picaSearchMode == 0
                    ? 'new_to_old'.tr()
                    : ref.watch(mangaSettingProvider).picaSearchMode == 1
                        ? 'old_to_new'.tr()
                        : ref.watch(mangaSettingProvider).picaSearchMode == 2
                            ? 'most_likes'.tr()
                            : 'most_viewed'.tr(),
                onPressed: () => ref.read(mangaSettingProvider.notifier).setSMMenu(ref.read(mangaSettingProvider).searchModeMenu),
              ),
            ),
          ),
          moonListTile(
            leading: Icon(BootstrapIcons.arrow_clockwise),
            title: "preload_number_of_pages".tr(),
            trailing: MoonDropdown(
              offset: Offset(-10, 0),
              show: ref.watch(mangaSettingProvider).preloadMenu,
              onTapOutside: () =>
                  ref.read(mangaSettingProvider.notifier).setPLMenu(),
              content: Column(
                children: [
                  MoonMenuItem(
                      onTap: () {
                        ref.read(mangaSettingProvider.notifier).setPLMenu();
                        ref.read(mangaSettingProvider.notifier).setPreloadNumPages("0");
                      },
                      label: Text('  0  ')),
                  MoonMenuItem(
                      onTap: () {
                        ref.read(mangaSettingProvider.notifier).setPLMenu();
                        ref.read(mangaSettingProvider.notifier).setPreloadNumPages("1");
                      },
                      label: Text('  1  ')),
                  MoonMenuItem(
                      onTap: () {
                        ref.read(mangaSettingProvider.notifier).setPLMenu();
                        ref.read(mangaSettingProvider.notifier).setPreloadNumPages("2");
                      },
                      label: Text('  2  ')),
                  MoonMenuItem(
                      onTap: () {
                        ref.read(mangaSettingProvider.notifier).setPLMenu();
                        ref.read(mangaSettingProvider.notifier).setPreloadNumPages("3");
                      },
                      label: Text('  3  ')),
                  MoonMenuItem(
                      onTap: () {
                        ref.read(mangaSettingProvider.notifier).setPLMenu();
                        ref.read(mangaSettingProvider.notifier).setPreloadNumPages("4");
                      },
                      label: Text('  4  ')),
                  MoonMenuItem(
                      onTap: () {
                        ref.read(mangaSettingProvider.notifier).setPLMenu();
                        ref.read(mangaSettingProvider.notifier).setPreloadNumPages("5");
                      },
                      label: Text('  5  ')),
                ],
              ),
              child: filledButton(
                label: ref.watch(mangaSettingProvider).preloadNumPages,
                onPressed: () => ref.read(mangaSettingProvider.notifier).setPLMenu(ref.read(mangaSettingProvider).preloadMenu),
              ),
            ),
          ),
          moonListTile(
            leading: Icon(BootstrapIcons.calendar3),
            title: "view_comic_card_list_in_pages".tr(),
            trailing: MoonSwitch(
              value: ref.watch(mangaSettingProvider).picaPageViewMode,
              onChanged: (value) {
                ref.read(mangaSettingProvider.notifier).setPicaPageViewMode(value);
              },
            ),
          ),
          moonListTile(
            leading: Icon(BootstrapIcons.calendar3),
            title: "auto_check_in".tr(),
            trailing: MoonSwitch(
              value: ref.watch(mangaSettingProvider).autoCheckIn,
              onChanged: (value) {
                ref.read(mangaSettingProvider.notifier).toggleAutoCheckIn();
              },
            ),
          ),
          moonListTile(
            leading: Icon(BootstrapIcons.arrow_clockwise),
            title: "preload_when_enter_details_page".tr(),
            trailing: MoonSwitch(
              value: ref.watch(mangaSettingProvider).preloadDetailsPage,
              onChanged: (value) {
                ref.read(mangaSettingProvider.notifier).setPreloadDetailsPage(value);
              },
            ),
          ),
          moonListTile(
            leading: Icon(Icons.block),
            title: "blocked_categories".tr(),
            subtitle: "also_applies_to_all_filters".tr(),
            onTap: () {
              showMoonModal(
                context: context,
                builder: (context) {
                  return Dialog(
                      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        MoonAlert(
                          label: Text("blocked_categories".tr()).header(),
                          verticalGap: 16,
                          content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height - 200,
                                  child: Scrollbar(
                                    thumbVisibility: true,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Wrap(
                                        spacing: 4,
                                        children: categories
                                            .map<Widget>((e) => picaChoiceChip(
                                                  text: e,
                                                  selected: ref.watch(blockerProvider)
                                                      .categories
                                                      .contains(e),
                                                  onSelected: (value) {
                                                    ref.read(blockerProvider.notifier)
                                                        .toggleBlockedCategory(
                                                            e);
                                                  },
                                                ))
                                            .toList(),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                filledButton(
                                  label: "done".tr(),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ]),
                        ),
                      ]),
                  );
                },
              );
            },
          ),
          moonListTile(
            leading: Icon(Icons.block),
            title: "blocked_keywords".tr(),
            subtitle: "also_applies_to_all_filters".tr(),
            onTap: () {
              TextEditingController textEditingController =
                  TextEditingController();
              showMoonModal(
                context: context,
                builder: (context) {
                  return Dialog(
                      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          MoonAlert(
                              label: Text("blocked_keywords".tr()).header(),
                              content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Scrollbar(
                                      thumbVisibility: true,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: Wrap(
                                            children: ref.watch(blockerProvider).keywords
                                                .map<Widget>(
                                                  (e) => picaDeleteChip(
                                                    text: e,
                                                    onDeleted: () {
                                                      ref.read(blockerProvider.notifier).removeKeyword(e);
                                                    },
                                                  ),
                                                )
                                                .toList(),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: MoonTextInput(
                                            controller: textEditingController,
                                            onTapOutside:
                                                (PointerDownEvent _) =>
                                                    FocusManager
                                                        .instance.primaryFocus
                                                        ?.unfocus(),
                                            onSubmitted: (value) {
                                              ref.read(blockerProvider.notifier).addKeyword(value);
                                              textEditingController.clear();
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        MoonButton.icon(
                                          icon:
                                              Icon(BootstrapIcons.plus_circle),
                                          onTap: () {
                                            ref.read(blockerProvider.notifier).addKeyword(
                                                textEditingController.text);
                                            textEditingController.clear();
                                          },
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 16),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          filledButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            label: "close".tr(),
                                          ),
                                        ])
                                  ]))
                        ],
                      ));
                },
              );
            },
          ),
          moonListTile(
            leading: Icon(Icons.switch_access_shortcut_rounded),
            title: "main_page_categories_tags".tr(),
            subtitle: "set_what_to_show_on_main_page".tr(),
            onTap: () {
              TextEditingController textEditingController =
                  TextEditingController();
              showMoonModal(
                context: context,
                builder: (context) {
                  return Dialog(
                      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MoonAlert(
                              label: Text("display_on_main_page".tr()).header(),
                              content: Column(children: [
                                Scrollbar(
                                  thumbVisibility: true,
                                  child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 8),
                                          SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
                                            child: Wrap(
                                                  spacing: 2,
                                                  children: ref
                                                      .watch(categoryProvider)
                                                      .mainPageTags
                                                      .map<Widget>(
                                                        (e) => picaDeleteChip(
                                                          text: fixedCategories
                                                                  .contains(e)
                                                              ? e
                                                                  .toString()
                                                                  .tr()
                                                              : e,
                                                          onDeleted: () {
                                                            ref
                                                                .watch(
                                                                    categoryProvider)
                                                                .mainPageTags
                                                                .remove(e);
                                                          },
                                                        ),
                                                      )
                                                      .toList(),
                                                ),
                                          ),
                                          SizedBox(height: 8),
                                          outlinedButton(
                                              onPressed: () {
                                                showMoonModal(
                                                    context: context,
                                                    builder: (context) {
                                                      return Dialog(
                                                          insetPadding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      16),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              MoonAlert(
                                                                  label: Text("click_to_add_category"
                                                                          .tr())
                                                                      .header(),
                                                                  content: Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: [
                                                                        SizedBox(
                                                                          height:
                                                                              MediaQuery.of(context).size.height - 200,
                                                                          child:
                                                                              Scrollbar(
                                                                            thumbVisibility:
                                                                                true,
                                                                            child: SingleChildScrollView(
                                                                                scrollDirection: Axis.vertical,
                                                                                child: Wrap(
                                                                                    spacing: 2,
                                                                                    children: [
                                                                                      ...fixedCategories.map<Widget>((e) => picaChoiceChip(
                                                                                            text: e.toString().tr(),
                                                                                            selected: ref.watch(categoryProvider).mainPageTags.contains(e),
                                                                                            onSelected: (value) {
                                                                                              ref.read(categoryProvider.notifier).toggleMainPageTag(e);
                                                                                            },
                                                                                          )),
                                                                                      ...categories.map<Widget>((e) => picaChoiceChip(
                                                                                            text: e,
                                                                                            selected: ref.watch(categoryProvider).mainPageTags.contains(e),
                                                                                            onSelected: (value) {
                                                                                              ref.read(categoryProvider.notifier).toggleMainPageTag(e);
                                                                                            },
                                                                                          )),
                                                                                    ],
                                                                                )),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                            height:
                                                                                16),
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.end,
                                                                          children: [
                                                                            filledButton(
                                                                                onPressed: () {
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                label: "ok".tr())
                                                                          ],
                                                                        ).paddingRight(
                                                                            8),
                                                                      ]))
                                                            ],
                                                          ));
                                                    });
                                              },
                                              label:
                                                  "click_to_add_category".tr()),
                                          SizedBox(height: 8),
                                          outlinedButton(
                                              onPressed: () {
                                                showMoonModal(
                                                    context: context,
                                                    builder: (context) {
                                                      return Dialog(
                                                          insetPadding:
                                                              EdgeInsets.all(
                                                                  16),
                                                          child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                MoonAlert(
                                                                    label: Text("long_press_and_drag_to_re_order"
                                                                            .tr())
                                                                        .header(),
                                                                    content:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: [
                                                                        SizedBox(
                                                                            height:
                                                                                8),
                                                                              SizedBox(
                                                                            height:
                                                                                MediaQuery.of(context).size.height * 0.4,
                                                                            width:
                                                                                MediaQuery.of(context).size.width * 0.8,
                                                                            child: Scrollbar(
                                                                                thumbVisibility: true,
                                                                                child: ReorderableListView(
                                                                                    shrinkWrap: true,
                                                                                    children: <Widget>[
                                                                                      for (int index = 0; index < ref.watch(categoryProvider).mainPageTags.length; index += 1)
                                                                                        Padding(
                                                                                          key: Key('$index'),
                                                                                          padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                                                                          child: MoonMenuItem(
                                                                                            backgroundColor: context.moonTheme?.tokens.colors.gohan,
                                                                                            label: Text("${index + 1}. ${fixedCategories.contains(ref.watch(categoryProvider).mainPageTags[index]) ? ref.watch(categoryProvider).mainPageTags[index].toString().tr() : ref.watch(categoryProvider).mainPageTags[index]}").header(),
                                                                                          ),
                                                                                        ),
                                                                                    ],
                                                                                    onReorder: (int oldIndex, int newIndex) {
                                                                                      if (oldIndex < newIndex) {
                                                                                        newIndex -= 1;
                                                                                      }
                                                                                      List<String> tmp = ref.read(categoryProvider).mainPageTags.toList();
                                                                                      final String item = tmp.removeAt(oldIndex);
                                                                                      tmp.insert(newIndex, item);
                                                                                      ref.read(categoryProvider.notifier).setMainPageTag(tmp);
                                                                                      ref.read(categoryProvider.notifier).saveMainPageTags();
                                                                                    })),
                                                                          ),
                                                                        SizedBox(
                                                                            height:
                                                                                8),
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.end,
                                                                          children: [
                                                                            filledButton(
                                                                                onPressed: () {
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                label: "ok".tr())
                                                                          ],
                                                                        ).paddingRight(
                                                                            8),
                                                                      ],
                                                                    )),
                                                              ]));
                                                    });
                                              },
                                              label:
                                                  "click_to_reorder_tags".tr()),
                                          SizedBox(height: 16),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: MoonTextInput(
                                                  hintText: "add_tag".tr(),
                                                  hasFloatingLabel: true,
                                                  onTapOutside:
                                                      (PointerDownEvent _) =>
                                                          FocusManager.instance
                                                              .primaryFocus
                                                              ?.unfocus(),
                                                  controller:
                                                      textEditingController,
                                                  onSubmitted: (value) {
                                                    if (value.trim().isEmpty) {
                                                      return;
                                                    }
                                                    ref
                                                        .read(categoryProvider.notifier)
                                                        .addMainPageTag(value);
                                                    textEditingController
                                                        .clear();
                                                  },
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              MoonButton.icon(
                                                icon: Icon(
                                                    BootstrapIcons.plus_circle),
                                                onTap: () {
                                                  ref
                                                      .read(categoryProvider.notifier)
                                                      .addMainPageTag(
                                                          textEditingController
                                                              .text);
                                                  textEditingController.clear();
                                                },
                                              )
                                            ],
                                          )
                                        ],
                                      )),
                                ),
                                SizedBox(height: 16),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      filledButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        label: "ok".tr(),
                                      ),
                                    ]),
                              ]),
                            )
                          ]));
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
