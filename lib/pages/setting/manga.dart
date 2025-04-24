import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moon_design/moon_design.dart';
import 'package:skana_pica/controller/blocker.dart';
import 'package:skana_pica/controller/categories.dart';
import 'package:skana_pica/controller/setting_controller.dart';
import 'package:skana_pica/pages/setting/setting_page.dart';
import 'package:skana_pica/util/widgetplugin.dart';
import 'package:skana_pica/widgets/pica_tagchip.dart';

class MangaSettingPage extends StatefulWidget {
  static const route = "${SettingPage.route}/manga";
  final bool fromMain;
  const MangaSettingPage({super.key, this.fromMain = false});

  @override
  State<MangaSettingPage> createState() => _MangaSettingPageState();
}

class _MangaSettingPageState extends State<MangaSettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: "Manga Settings".tr),
      body: Obx(
        () => ListView(
          children: [
            moonListTile(
              leading: Icon(BootstrapIcons.arrow_left_right),
              title: "Set stream".tr,
              trailing: MoonDropdown(
                offset: Offset(-10, 0),
                minWidth: 100,
                maxWidth: 100,
                show: mangaSettingsController.streamMenu.value,
                onTapOutside: () =>
                    mangaSettingsController.streamMenu.value = false,
                content: Column(
                  children: [
                    MoonMenuItem(
                        onTap: () {
                          mangaSettingsController.streamMenu.value = false;
                          mangaSettingsController.setPicaStream(0);
                        },
                        label: Text('Stream 1'.tr)),
                    MoonMenuItem(
                        onTap: () {
                          mangaSettingsController.streamMenu.value = false;
                          mangaSettingsController.setPicaStream(1);
                        },
                        label: Text('Stream 2'.tr)),
                    MoonMenuItem(
                        onTap: () {
                          mangaSettingsController.streamMenu.value = false;
                          mangaSettingsController.setPicaStream(2);
                        },
                        label: Text('Stream 3'.tr)),
                  ],
                ),
                child: filledButton(
                  label: mangaSettingsController.picaStream.value == 0
                      ? 'Stream 1'.tr
                      : mangaSettingsController.picaStream.value == 1
                          ? 'Stream 2'.tr
                          : 'Stream 3'.tr,
                  onPressed: () => mangaSettingsController.streamMenu.value =
                      !mangaSettingsController.streamMenu.value,
                ),
              ),
            ),
            moonListTile(
              leading: Icon(BootstrapIcons.image),
              title: "Set image quality".tr,
              trailing: MoonDropdown(
                offset: Offset(-10, 0),
                minWidth: 100,
                maxWidth: 100,
                show: mangaSettingsController.imageQualityMenu.value,
                onTapOutside: () =>
                    mangaSettingsController.imageQualityMenu.value = false,
                content: Column(
                  children: [
                    MoonMenuItem(
                        onTap: () {
                          mangaSettingsController.imageQualityMenu.value =
                              false;
                          mangaSettingsController.setPicaImageQuality('low');
                        },
                        label: Text('Low'.tr)),
                    MoonMenuItem(
                        onTap: () {
                          mangaSettingsController.imageQualityMenu.value =
                              false;
                          mangaSettingsController.setPicaImageQuality('medium');
                        },
                        label: Text('Medium'.tr)),
                    MoonMenuItem(
                        onTap: () {
                          mangaSettingsController.imageQualityMenu.value =
                              false;
                          mangaSettingsController.setPicaImageQuality('high');
                        },
                        label: Text('High'.tr)),
                    MoonMenuItem(
                        onTap: () {
                          mangaSettingsController.imageQualityMenu.value =
                              false;
                          mangaSettingsController
                              .setPicaImageQuality('original');
                        },
                        label: Text('Original image'.tr)),
                  ],
                ),
                child: filledButton(
                  label: mangaSettingsController.picaImageQuality.value == 'low'
                      ? 'Low'.tr
                      : mangaSettingsController.picaImageQuality.value ==
                              'medium'
                          ? 'Medium'.tr
                          : mangaSettingsController.picaImageQuality.value ==
                                  'high'
                              ? 'High'.tr
                              : 'Original image'.tr,
                  onPressed: () => mangaSettingsController.imageQualityMenu
                      .value = !mangaSettingsController.imageQualityMenu.value,
                ),
              ),
            ),
            moonListTile(
              leading: Icon(BootstrapIcons.search),
              title: "Set search and category sorting mode".tr,
              trailing: MoonDropdown(
                offset: Offset(-10, 0),
                minWidth: 100,
                maxWidth: 100,
                show: mangaSettingsController.searchModeMenu.value,
                onTapOutside: () =>
                    mangaSettingsController.searchModeMenu.value = false,
                content: Column(
                  children: [
                    MoonMenuItem(
                        onTap: () {
                          mangaSettingsController.searchModeMenu.value = false;
                          mangaSettingsController.setPicaSearchMode(0);
                        },
                        label: Text('New to Old'.tr)),
                    MoonMenuItem(
                        onTap: () {
                          mangaSettingsController.searchModeMenu.value = false;
                          mangaSettingsController.setPicaSearchMode(1);
                        },
                        label: Text('Old to New'.tr)),
                    MoonMenuItem(
                        onTap: () {
                          mangaSettingsController.searchModeMenu.value = false;
                          mangaSettingsController.setPicaSearchMode(2);
                        },
                        label: Text('Most Likes'.tr)),
                    MoonMenuItem(
                        onTap: () {
                          mangaSettingsController.searchModeMenu.value = false;
                          mangaSettingsController.setPicaSearchMode(3);
                        },
                        label: Text('Most Viewed'.tr)),
                  ],
                ),
                child: filledButton(
                  label: mangaSettingsController.picaSearchMode.value == 0
                      ? 'New to Old'.tr
                      : mangaSettingsController.picaSearchMode.value == 1
                          ? 'Old to New'.tr
                          : mangaSettingsController.picaSearchMode.value == 2
                              ? 'Most Likes'.tr
                              : 'Most Viewed'.tr,
                  onPressed: () => mangaSettingsController.searchModeMenu
                      .value = !mangaSettingsController.searchModeMenu.value,
                ),
              ),
            ),
            moonListTile(
              leading: Icon(BootstrapIcons.arrow_clockwise),
              title: "Preload number of pages".tr,
              trailing: MoonDropdown(
                offset: Offset(-10, 0),
                show: mangaSettingsController.preloadMenu.value,
                onTapOutside: () =>
                    mangaSettingsController.preloadMenu.value = false,
                content: Column(
                  children: [
                    MoonMenuItem(
                        onTap: () {
                          mangaSettingsController.preloadMenu.value = false;
                          mangaSettingsController.setPreloadNumPages("0");
                        },
                        label: Text('  0  ')),
                    MoonMenuItem(
                        onTap: () {
                          mangaSettingsController.preloadMenu.value = false;
                          mangaSettingsController.setPreloadNumPages("1");
                        },
                        label: Text('  1  ')),
                    MoonMenuItem(
                        onTap: () {
                          mangaSettingsController.preloadMenu.value = false;
                          mangaSettingsController.setPreloadNumPages("2");
                        },
                        label: Text('  2  ')),
                    MoonMenuItem(
                        onTap: () {
                          mangaSettingsController.preloadMenu.value = false;
                          mangaSettingsController.setPreloadNumPages("3");
                        },
                        label: Text('  3  ')),
                    MoonMenuItem(
                        onTap: () {
                          mangaSettingsController.preloadMenu.value = false;
                          mangaSettingsController.setPreloadNumPages("4");
                        },
                        label: Text('  4  ')),
                    MoonMenuItem(
                        onTap: () {
                          mangaSettingsController.preloadMenu.value = false;
                          mangaSettingsController.setPreloadNumPages("5");
                        },
                        label: Text('  5  ')),
                  ],
                ),
                child: filledButton(
                  label: mangaSettingsController.preloadNumPages.value,
                  onPressed: () => mangaSettingsController.preloadMenu.value =
                      !mangaSettingsController.preloadMenu.value,
                ),
              ),
            ),
            moonListTile(
              leading: Icon(BootstrapIcons.calendar3),
              title: "Auto check-in".tr,
              trailing: MoonSwitch(
                value: mangaSettingsController.autoCheckIn.value,
                onChanged: (value) {
                  mangaSettingsController.toggleAutoCheckIn();
                },
              ),
            ),
            moonListTile(
              leading: Icon(BootstrapIcons.arrow_clockwise),
              title: "Preload when enter details page".tr,
              trailing: MoonSwitch(
                value: mangaSettingsController.preloadDetailsPage.value,
                onChanged: (value) {
                  mangaSettingsController.setPreloadDetailsPage(value);
                },
              ),
            ),
            moonListTile(
              leading: Icon(Icons.block),
              title: "Blocked Categories".tr,
              subtitle: "Also applies to all filters".tr,
              onTap: () {
                showMoonModal(
                  context: context,
                  builder: (context) {
                    return Obx(
                      () => Dialog(
                        insetPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                          MoonAlert(
                            label: Text("Blocked Categories".tr).header(),
                            verticalGap: 16,
                            content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    height: context.height - 200,
                                    child: Scrollbar(
                                      thumbVisibility: true,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: Wrap(
                                          spacing: 4,
                                          children: mangaSettingsController
                                              .categories
                                              .map<Widget>(
                                                  (e) => picaChoiceChip(
                                                        text: e,
                                                        selected: blocker
                                                            .blockedCategories
                                                            .contains(e),
                                                        onSelected: (value) {
                                                          blocker
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
                                    label: "Done".tr,
                                    onPressed: () => Get.back(),
                                  ),
                                ]),
                          ),
                        ]),
                      ),
                    );
                  },
                );
              },
            ),
            moonListTile(
              leading: Icon(Icons.block),
              title: "Blocked Keywords".tr,
              subtitle: "Also applies to all filters".tr,
              onTap: () {
                TextEditingController textEditingController =
                    TextEditingController();
                showMoonModal(
                  context: context,
                  builder: (context) {
                    return Dialog(
                        insetPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            MoonAlert(
                                label: Text("Blocked Keywords".tr).header(),
                                content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Scrollbar(
                                        thumbVisibility: true,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: Obx(
                                            () => Wrap(
                                              children: blocker.blockedKeywords
                                                  .map<Widget>(
                                                    (e) => picaDeleteChip(
                                                      text: e,
                                                      onDeleted: () {
                                                        blocker
                                                            .removeKeyword(e);
                                                      },
                                                    ),
                                                  )
                                                  .toList(),
                                            ),
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
                                                blocker.addKeyword(value);
                                                textEditingController.clear();
                                                Get.back();
                                              },
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          MoonButton.icon(
                                            icon: Icon(
                                                BootstrapIcons.plus_circle),
                                            onTap: () {
                                              blocker.addKeyword(
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
                                                Get.back();
                                              },
                                              label: "Close".tr,
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
              title: "Main Page Categories/Tags".tr,
              subtitle: "Set what to show on main page".tr,
              onTap: () {
                TextEditingController textEditingController =
                    TextEditingController();
                showMoonModal(
                  context: context,
                  builder: (context) {
                    return Dialog(
                        insetPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MoonAlert(
                                label: Text("Display on Main Page".tr).header(),
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
                                              child: Obx(() => Wrap(
                                                    spacing: 2,
                                                    children:
                                                        categoriesController
                                                            .mainPageTags
                                                            .map<Widget>(
                                                              (e) =>
                                                                  picaDeleteChip(
                                                                text: fixedCategories
                                                                        .contains(
                                                                            e)
                                                                    ? e
                                                                        .toString()
                                                                        .tr
                                                                    : e,
                                                                onDeleted: () {
                                                                  categoriesController
                                                                      .mainPageTags
                                                                      .remove(
                                                                          e);
                                                                },
                                                              ),
                                                            )
                                                            .toList(),
                                                  )),
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
                                                                    label: Text("Add Category"
                                                                            .tr)
                                                                        .header(),
                                                                    content: Column(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        children: [
                                                                          SizedBox(
                                                                            height:
                                                                                context.height - 200,
                                                                            child:
                                                                                Scrollbar(
                                                                              thumbVisibility: true,
                                                                              child: SingleChildScrollView(
                                                                                  scrollDirection: Axis.vertical,
                                                                                  child: Obx(
                                                                                    () => Wrap(
                                                                                      spacing: 2,
                                                                                      children: [
                                                                                        ...fixedCategories.map<Widget>((e) => picaChoiceChip(
                                                                                              text: e.toString().tr,
                                                                                              selected: categoriesController.mainPageTags.contains(e),
                                                                                              onSelected: (value) {
                                                                                                categoriesController.toggleMainPageTag(e);
                                                                                              },
                                                                                            )),
                                                                                        ...mangaSettingsController.categories.map<Widget>((e) => picaChoiceChip(
                                                                                              text: e,
                                                                                              selected: categoriesController.mainPageTags.contains(e),
                                                                                              onSelected: (value) {
                                                                                                categoriesController.toggleMainPageTag(e);
                                                                                              },
                                                                                            )),
                                                                                      ],
                                                                                    ),
                                                                                  )),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                              height: 16),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.end,
                                                                            children: [
                                                                              filledButton(
                                                                                  onPressed: () {
                                                                                    Get.back();
                                                                                  },
                                                                                  label: "Ok".tr)
                                                                            ],
                                                                          ).paddingRight(
                                                                              8),
                                                                        ]))
                                                              ],
                                                            ));
                                                      });
                                                },
                                                label:
                                                    "Click to add category".tr),
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
                                                                      label: Text("Long Press and Drag to re-order"
                                                                              .tr)
                                                                          .header(),
                                                                      content:
                                                                          Column(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        children: [
                                                                          SizedBox(
                                                                              height: 8),
                                                                          Obx(
                                                                            () =>
                                                                                SizedBox(
                                                                              height: Get.height * 0.4,
                                                                              width: Get.width * 0.8,
                                                                              child: Scrollbar(
                                                                                  thumbVisibility: true,
                                                                                  child: ReorderableListView(
                                                                                      shrinkWrap: true,
                                                                                      children: <Widget>[
                                                                                        for (int index = 0; index < categoriesController.mainPageTags.length; index += 1)
                                                                                          Padding(
                                                                                            key: Key('$index'),
                                                                                            padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                                                                            child: MoonMenuItem(
                                                                                              backgroundColor: context.moonTheme?.tokens.colors.gohan,
                                                                                              label: Text("${index + 1}. ${fixedCategories.contains(categoriesController.mainPageTags[index]) ? categoriesController.mainPageTags[index].toString().tr : categoriesController.mainPageTags[index]}").header(),
                                                                                            ),
                                                                                          ),
                                                                                      ],
                                                                                      onReorder: (int oldIndex, int newIndex) {
                                                                                        if (oldIndex < newIndex) {
                                                                                          newIndex -= 1;
                                                                                        }
                                                                                        List tmp = categoriesController.mainPageTags.toList();
                                                                                        final String item = tmp.removeAt(oldIndex);
                                                                                        tmp.insert(newIndex, item);
                                                                                        for (int i = 0; i < tmp.length; i++) {
                                                                                          categoriesController.mainPageTags[i] = tmp[i];
                                                                                        }
                                                                                        categoriesController.saveMainPageTags();
                                                                                      })),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                              height: 8),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.end,
                                                                            children: [
                                                                              filledButton(
                                                                                  onPressed: () {
                                                                                    Get.back();
                                                                                  },
                                                                                  label: "Ok".tr)
                                                                            ],
                                                                          ).paddingRight(
                                                                              8),
                                                                        ],
                                                                      )),
                                                                ]));
                                                      });
                                                },
                                                label:
                                                    "Click to reorder tags".tr),
                                            SizedBox(height: 16),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: MoonTextInput(
                                                    hintText: "Add Tag".tr,
                                                    hasFloatingLabel: true,
                                                    onTapOutside:
                                                        (PointerDownEvent _) =>
                                                            FocusManager
                                                                .instance
                                                                .primaryFocus
                                                                ?.unfocus(),
                                                    controller:
                                                        textEditingController,
                                                    onSubmitted: (value) {
                                                      if (value
                                                          .trim()
                                                          .isEmpty) {
                                                        return;
                                                      }
                                                      categoriesController
                                                          .addMainPageTag(
                                                              value);
                                                      textEditingController
                                                          .clear();
                                                    },
                                                  ),
                                                ),
                                                SizedBox(width: 8),
                                                MoonButton.icon(
                                                  icon: Icon(BootstrapIcons
                                                      .plus_circle),
                                                  onTap: () {
                                                    categoriesController
                                                        .addMainPageTag(
                                                            textEditingController
                                                                .text);
                                                    textEditingController
                                                        .clear();
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
                                            Get.back();
                                          },
                                          label: "Ok".tr,
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
      ),
    );
  }
}
