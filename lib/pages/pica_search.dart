import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moon_design/moon_design.dart';
import 'package:skana_pica/controller/main_controller.dart';
import 'package:skana_pica/controller/searchhistory.dart';
import 'package:skana_pica/pages/mainscreen.dart';
import 'package:skana_pica/pages/pica_results.dart';
import 'package:skana_pica/util/leaders.dart';
import 'package:skana_pica/util/widgetplugin.dart';
import 'package:skana_pica/widgets/pica_tagchip.dart';

class PicaSearchPage extends StatefulWidget {
  static const route = "${Mains.route}search";

  const PicaSearchPage({super.key});

  @override
  State<PicaSearchPage> createState() => _PicaSearchPageState();
}

class _PicaSearchPageState extends State<PicaSearchPage> {
  late SearchController controller;
  bool showDelete = false;

  @override
  void initState() {
    super.initState();
    controller = SearchController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Obx(
      () => CustomScrollView(
        controller: globalScrollController,
        slivers: [
          SliverPadding(padding: const EdgeInsets.only(top: 8.0)),
          SliverToBoxAdapter(
            child: MoonTextInput(
              textInputSize: MoonTextInputSize.xl,
              onTapOutside: (event) => FocusScope.of(context).unfocus(),
              hintText: "Search".tr,
              onSubmitted: onSubmitted,
              onChanged: (value) => setState(() {
                showDelete = value.isNotEmpty;
              }),
              controller: controller,
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              trailing: showDelete
                  ? MoonButton.icon(
                      icon: const Icon(Icons.clear),
                      onTap: () {
                        controller.clear();
                      },
                    )
                  : MoonButton.icon(
                      icon: const Icon(Icons.search),
                      onTap: () {
                        onSubmitted(controller.text);
                      },
                    ),
            ).paddingAll(8.0),
          ),
          SliverPadding(padding: const EdgeInsets.only(top: 8.0)),
          SliverToBoxAdapter(
            child: (searchHistoryController.searchHistory.isNotEmpty)
                ? Text("Search History".tr).appHeader().paddingAll(12.0)
                : Container(),
          ),
          if ((searchHistoryController.searchHistory.isNotEmpty))
            SliverList(
              delegate: SliverChildListDelegate([
                Wrap(
                  runSpacing: 0.0,
                  spacing: 5.0,
                  children: searchHistoryController.searchHistory
                      .map(
                        (e) => InkWell(
                          onTap: () {
                            onSubmitted(e);
                          },
                          child: picaDeleteChip(
                            backgroundColor:
                                context.moonTheme?.tokens.colors.frieza60,
                            text: e,
                            onDeleted: () {
                              searchHistoryController.removeHistory(e);
                            },
                          ),
                        ),
                      )
                      .toList(),
                ).paddingSymmetric(horizontal: 8.0).paddingBottom(12.0),
              ]),
            ),
          if (searchHistoryController.searchHistory.isNotEmpty)
            SliverToBoxAdapter(
                child: InkWell(
              onTap: () {
                alertDialog(context, "${"Clear search history".tr}?", "", [
                  outlinedButton(
                      label: "Cancel".tr,
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                  filledButton(
                      label: "Ok".tr,
                      onPressed: () {
                        searchHistoryController.clearHistory();
                        Navigator.of(context).pop();
                      })
                ]);
              },
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        BootstrapIcons.trash3,
                        size: 18.0,
                        color: context.moonTheme?.tokens.colors.bulma,
                      ),
                      SizedBox(width: 8.0),
                      Text("Clear search history".tr).subHeader()
                    ],
                  ),
                ),
              ),
            )),
        ],
      ),
    ));
  }

  void onSubmitted(String value) {
    searchHistoryController.addHistory(value);
    Go.to(PicaResultsPage(keyword: value), preventDuplicates: false);
  }
}
