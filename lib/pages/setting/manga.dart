import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skana_pica/api/comic_sources/picacg/pica_source.dart';
import 'package:skana_pica/config/setting.dart';
import 'package:skana_pica/pages/setting/setting_page.dart';
import 'package:skana_pica/util/widget_utils.dart';

class MangaSettingPage extends StatefulWidget {
  static const route = "${SettingPage.route}/manga";
  const MangaSettingPage({super.key});

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
          onPressed: () => Get.back(),
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
              title: Text("Displayed Categories".tr),
              subtitle: Text("Also applies to all filters".tr),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Obx(() => AlertDialog(
                          title: Text("Displayed Categories".tr),
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
                                          selected: mangaSettingsController
                                              .blockedCategories
                                              .contains(e),
                                          onSelected: (value) {
                                            mangaSettingsController
                                                .toggleBlockedCategory(e);
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
  final preloadNumPages = appdata.pica[7].obs;
  final preloadDetailsPage = (appdata.pica[8] == "1").obs;
  final blockedCategories = appdata.blockedCategory.obs;

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

  void toggleBlockedCategory(String category) {
    if (blockedCategories.contains(category)) {
      blockedCategories.remove(category);
    } else {
      blockedCategories.add(category);
    }
    blockedCategories.refresh();
    appdata.blockedCategory = blockedCategories.toList();
  }
}
