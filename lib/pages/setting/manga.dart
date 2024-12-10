import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skana_pica/api/comic_sources/picacg/pica_source.dart';
import 'package:skana_pica/config/setting.dart';
import 'package:skana_pica/controller/blocker.dart';
import 'package:skana_pica/controller/categories.dart';
import 'package:skana_pica/pages/mainscreen.dart';
import 'package:skana_pica/pages/setting/setting_page.dart';
import 'package:skana_pica/util/widget_utils.dart';
import 'package:smooth_highlight/smooth_highlight.dart';

class MangaSettingPage extends StatefulWidget {
  static const route = "${SettingPage.route}/manga";
  final bool fromMain;
  const MangaSettingPage({super.key, this.fromMain = false});

  @override
  State<MangaSettingPage> createState() => _MangaSettingPageState();
}

class _MangaSettingPageState extends State<MangaSettingPage> {
  late MangaSettingsController mangaSettingsController;

  @override
  void initState() {
    super.initState();
    mangaSettingsController = Get.put(MangaSettingsController());
  }

  @override
  void dispose() {
    super.dispose();
    Get.delete<MangaSettingsController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manga Settings".tr),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            if (widget.fromMain) {
              mainScreenIndex.index.value = 0;
            }
            Get.back();
          },
        ),
      ),
      body: Column(
        children: [
          _buildPica(context).padding(EdgeInsets.only(top: 20)),
        ],
      ),
    );
  }

  Widget _buildPica(BuildContext context) {
    if(widget.fromMain) {
      mangaSettingsController.setMainTrigger();
    }
    return Obx(
      () => ListTileTheme(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Icon(Icons.compare_arrows),
              title: Text("Set stream".tr),
              trailing: DropdownButton<int>(
                value: mangaSettingsController.picaStream.value,
                items: [
                  DropdownMenuItem(value: 0, child: Text('Stream 1'.tr)),
                  DropdownMenuItem(value: 1, child: Text('Stream 2'.tr)),
                  DropdownMenuItem(value: 2, child: Text('Stream 3'.tr)),
                ],
                onChanged: (value) {
                  if (value != null) {
                    mangaSettingsController.setPicaStream(value);
                  }
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.image),
              title: Text("Set image quality".tr),
              trailing: DropdownButton<String>(
                value: mangaSettingsController.picaImageQuality.value,
                items: [
                  DropdownMenuItem(value: 'low', child: Text('Low'.tr)),
                  DropdownMenuItem(value: 'medium', child: Text('Medium'.tr)),
                  DropdownMenuItem(value: 'high', child: Text('High'.tr)),
                  DropdownMenuItem(
                      value: 'original', child: Text('Original image'.tr)),
                ],
                onChanged: (value) {
                  if (value != null) {
                    mangaSettingsController.setPicaImageQuality(value);
                  }
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.search),
              title: Text("Set search and category sorting mode".tr),
              trailing: DropdownButton<int>(
                value: mangaSettingsController.picaSearchMode.value,
                items: [
                  DropdownMenuItem(value: 0, child: Text('New to Old'.tr)),
                  DropdownMenuItem(value: 1, child: Text('Old to New'.tr)),
                  DropdownMenuItem(value: 2, child: Text('Most Likes'.tr)),
                  DropdownMenuItem(value: 3, child: Text('Most Viewed'.tr)),
                ],
                onChanged: (value) {
                  if (value != null) {
                    mangaSettingsController.setPicaSearchMode(value);
                  }
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.view_agenda_outlined),
              title: Text("Set page view mode".tr),
              trailing: DropdownButton<String>(
                value: mangaSettingsController.picaPageViewMode.value,
                items: [
                  DropdownMenuItem(
                      value: "0", child: Text('Infinite Scroll'.tr)),
                  DropdownMenuItem(value: "1", child: Text('Page View'.tr)),
                ],
                onChanged: (value) {
                  if (value != null) {
                    mangaSettingsController.setPicaPageViewMode(value);
                  }
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text("Auto check-in".tr),
              trailing: Switch(
                value: mangaSettingsController.autoCheckIn.value,
                onChanged: (value) {
                  mangaSettingsController.toggleAutoCheckIn();
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.refresh_rounded),
              title: Text("Preload number of pages".tr),
              trailing: DropdownButton<String>(
                value: mangaSettingsController.preloadNumPages.value,
                items: [
                  DropdownMenuItem(value: "0", child: Text('0')),
                  DropdownMenuItem(value: "1", child: Text('1')),
                  DropdownMenuItem(value: "2", child: Text('2')),
                  DropdownMenuItem(value: "3", child: Text('3')),
                  DropdownMenuItem(value: "4", child: Text('4')),
                  DropdownMenuItem(value: "5", child: Text('5')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    mangaSettingsController.setPreloadNumPages(value);
                  }
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.spoke_outlined),
              title: Text("Preload when enter details page".tr),
              trailing: Switch(
                value: mangaSettingsController.preloadDetailsPage.value,
                onChanged: (value) {
                  mangaSettingsController.setPreloadDetailsPage(value);
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.block),
              title: Text("Blocked Categories".tr),
              subtitle: Text("Also applies to all filters".tr),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Obx(() => AlertDialog(
                          title: Text("Blocked Categories".tr),
                          content: Scrollbar(
                            thumbVisibility: true,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Wrap(
                                children: picacg.categories
                                    .map<Widget>((e) => FilterChip(
                                          label: Text(
                                            e,
                                          ),
                                          selected: blocker.blockedCategories
                                              .contains(e),
                                          onSelected: (value) {
                                            blocker.toggleBlockedCategory(e);
                                          },
                                        ))
                                    .toList(),
                              ),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: Text("Ok".tr),
                            ),
                          ],
                        ));
                  },
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.block),
              title: Text("Blocked Keywords".tr),
              subtitle: Text("Also applies to all filters".tr),
              onTap: () {
                TextEditingController textEditingController =
                    TextEditingController();
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Blocked Keywords".tr),
                      content: Scrollbar(
                        thumbVisibility: true,
                        child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              children: [
                                Obx(
                                  () => Wrap(
                                    children: blocker.blockedKeywords
                                        .map<Widget>(
                                          (e) => Chip(
                                            label: Text(e),
                                            deleteIcon: const Icon(Icons.clear),
                                            onDeleted: () {
                                              blocker.removeKeyword(e);
                                            },
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: textEditingController,
                                        onSubmitted: (value) {
                                          blocker.addKeyword(value);
                                          Get.back();
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    IconButton(
                                      icon: Icon(
                                          Icons.add_circle_outline_outlined),
                                      onPressed: () {
                                        blocker.addKeyword(
                                            textEditingController.text);
                                        textEditingController.clear();
                                      },
                                    )
                                  ],
                                )
                              ],
                            )),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: Text("Close".tr),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            ValueChangeHighlight(
              value: mangaSettingsController.mainTrigger.value,
              duration: const Duration(seconds: 1),
              color: Get.theme.colorScheme.secondary,
              child: ListTile(
                leading: Icon(Icons.switch_access_shortcut_rounded),
                title: Text("Main Page Categories/Tags".tr),
                subtitle: Text("Set what to show on main page".tr),
                onTap: () {
                  TextEditingController textEditingController =
                      TextEditingController();
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Display on Main Page".tr),
                        content: Scrollbar(
                          thumbVisibility: true,
                          child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 8),
                                  Obx(
                                    () => Wrap(
                                      children: categoriesController
                                          .mainPageTags
                                          .map<Widget>(
                                            (e) => Chip(
                                              label: fixedCategories.contains(e)
                                                  ? Text(e.toString().tr)
                                                  : Text(e),
                                              deleteIcon:
                                                  const Icon(Icons.clear),
                                              onDeleted: () {
                                                categoriesController
                                                    .removeMainPageTag(e);
                                              },
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text("Add Category".tr),
                                                content: Scrollbar(
                                                  thumbVisibility: true,
                                                  child: SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      child: Obx(
                                                        () => Wrap(
                                                          children: [
                                                            ...fixedCategories
                                                                .map<Widget>(
                                                                    (e) =>
                                                                        FilterChip(
                                                                          label: Text(e
                                                                              .toString()
                                                                              .tr),
                                                                          selected: categoriesController
                                                                              .mainPageTags
                                                                              .contains(e),
                                                                          onSelected:
                                                                              (value) {
                                                                            categoriesController.toggleMainPageTag(e);
                                                                          },
                                                                        )),
                                                            ...picacg.categories
                                                                .map<Widget>(
                                                                    (e) =>
                                                                        FilterChip(
                                                                          label:
                                                                              Text(e),
                                                                          selected: categoriesController
                                                                              .mainPageTags
                                                                              .contains(e),
                                                                          onSelected:
                                                                              (value) {
                                                                            categoriesController.toggleMainPageTag(e);
                                                                          },
                                                                        )),
                                                          ],
                                                        ),
                                                      )),
                                                ),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Get.back();
                                                      },
                                                      child: Text("Ok".tr))
                                                ],
                                              );
                                            });
                                      },
                                      child: Text("Click to add category".tr)),
                                  SizedBox(height: 8),
                                  TextButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text(
                                                    "Long Press and Drag to re-order"
                                                        .tr),
                                                content: Obx(
                                                  () => SizedBox(
                                                    width: Get.width * 0.8,
                                                    child: ReorderableListView(
                                                        children: <Widget>[
                                                          for (int index = 0;
                                                              index <
                                                                  categoriesController
                                                                      .mainPageTags
                                                                      .length;
                                                              index += 1)
                                                            ListTile(
                                                              key:
                                                                  Key('$index'),
                                                              title: fixedCategories.contains(
                                                                      categoriesController
                                                                              .mainPageTags[
                                                                          index])
                                                                  ? Text(categoriesController
                                                                      .mainPageTags[
                                                                          index]
                                                                      .toString()
                                                                      .tr)
                                                                  : Text(categoriesController
                                                                          .mainPageTags[
                                                                      index]),
                                                            ),
                                                        ],
                                                        onReorder:
                                                            (int oldIndex,
                                                                int newIndex) {
                                                          if (oldIndex <
                                                              newIndex) {
                                                            newIndex -= 1;
                                                          }
                                                          List tmp =
                                                              categoriesController
                                                                  .mainPageTags
                                                                  .toList();
                                                          final String item =
                                                              tmp.removeAt(
                                                                  oldIndex);
                                                          tmp.insert(
                                                              newIndex, item);
                                                          for (int i = 0;
                                                              i < tmp.length;
                                                              i++) {
                                                            categoriesController
                                                                    .mainPageTags[
                                                                i] = tmp[i];
                                                          }
                                                          categoriesController
                                                              .saveMainPageTags();
                                                        }),
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Get.back();
                                                      },
                                                      child: Text("Ok".tr))
                                                ],
                                              );
                                            });
                                      },
                                      child: Text("Click to reorder tags".tr)),
                                  SizedBox(height: 8),
                                  Text("Add Tag".tr),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: textEditingController,
                                          onSubmitted: (value) {
                                            categoriesController
                                                .addMainPageTag(value);
                                          },
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      IconButton(
                                        icon: Icon(
                                            Icons.add_circle_outline_outlined),
                                        onPressed: () {
                                          categoriesController.addMainPageTag(
                                              textEditingController.text);
                                          textEditingController.clear();
                                        },
                                      )
                                    ],
                                  )
                                ],
                              )),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              if (textEditingController.text.isNotEmpty) {
                                categoriesController
                                    .addMainPageTag(textEditingController.text);
                              }
                              Get.back();
                            },
                            child: Text("Ok".tr),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MangaSettingsController extends GetxController {
  final picaStream = int.parse(appdata.pica[0]).obs;
  final picaImageQuality = appdata.picaImageQuality.obs;
  final picaSearchMode = appdata.picaSearchMode.obs;
  final picaPageViewMode = appdata.pica[6].obs;
  final autoCheckIn = (appdata.pica[2] == "1").obs;
  final preloadNumPages =
      (int.parse(appdata.pica[7]) > 6 ? '5' : appdata.pica[7]).obs;
  final preloadDetailsPage = (appdata.pica[8] == "1").obs;
  final mainTrigger = false.obs;

  void setPicaStream(int value) {
    picaStream.value = value;
    appdata.pica[0] = value.toString();
    appdata.updateSettings("pica");
    picacg.data['appChannel'] = (value + 1).toString();
  }

  void setPicaImageQuality(String value) {
    picaImageQuality.value = value;
    appdata.picaImageQuality = value;
    picacg.data['imageQuality'] = value;
  }

  void setPicaSearchMode(int value) {
    picaSearchMode.value = value;
    appdata.picaSearchMode = value;
  }

  void setPicaPageViewMode(String value) {
    picaPageViewMode.value = value;
    appdata.pica[6] = value;
    appdata.updateSettings("pica");
  }

  void toggleAutoCheckIn() {
    autoCheckIn.value = !autoCheckIn.value;
    appdata.pica[2] = autoCheckIn.value ? "1" : "0";
    appdata.updateSettings("pica");
  }

  void setPreloadNumPages(String value) {
    preloadNumPages.value = value;
    appdata.pica[7] = value;
    appdata.updateSettings("pica");
  }

  void setPreloadDetailsPage(bool value) {
    preloadDetailsPage.value = value;
    appdata.pica[8] = value ? "1" : "0";
    appdata.updateSettings("pica");
  }

  void setMainTrigger() {
    Future.delayed(const Duration(milliseconds: 500), () {
      mainTrigger.value = true;
    });
  }
}
