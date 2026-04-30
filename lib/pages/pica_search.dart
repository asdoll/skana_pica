import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:easy_localization/easy_localization.dart' show StringTranslateExtension;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:moon_design/moon_design.dart';
import 'package:skana_pica/controller/main_controller.dart';
import 'package:skana_pica/controller/searchhistory.dart';
import 'package:skana_pica/pages/mainscreen.dart';
import 'package:skana_pica/pages/pica_results.dart';
import 'package:skana_pica/util/leaders.dart';
import 'package:skana_pica/util/widgetplugin.dart';
import 'package:skana_pica/widgets/pica_tagchip.dart';

class PicaSearchPage extends StatefulHookConsumerWidget {
  static const route = "${Mains.route}search";

  const PicaSearchPage({super.key});

  @override
  ConsumerState<PicaSearchPage> createState() => _PicaSearchPageState();
}

class _PicaSearchPageState extends ConsumerState<PicaSearchPage> {
  bool showDelete = false;

  @override
  Widget build(BuildContext context) {
    SearchController controller = SearchController();
    return Scaffold(
        body: CustomScrollView(
        controller: globalScrollController,
        slivers: [
          SliverPadding(padding: const EdgeInsets.only(top: 8.0)),
          SliverToBoxAdapter(
            child: MoonTextInput(
              textInputSize: MoonTextInputSize.xl,
              onTapOutside: (event) => FocusScope.of(context).unfocus(),
              hintText: "search".tr(),
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
            child: (ref.watch(searchHistoryProvider).isNotEmpty)
                ? Text("search_history".tr()).appHeader().paddingAll(12.0)
                : Container(),
          ),
          if ((ref.watch(searchHistoryProvider).isNotEmpty))
            SliverList(
              delegate: SliverChildListDelegate([
                Wrap(
                  runSpacing: 0.0,
                  spacing: 5.0,
                  children: ref.watch(searchHistoryProvider)
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
                              ref.read(searchHistoryProvider.notifier).removeHistory(e);
                            },
                          ),
                        ),
                      )
                      .toList(),
                ).paddingSymmetric(horizontal: 8.0).paddingBottom(12.0),
              ]),
            ),
          if (ref.watch(searchHistoryProvider).isNotEmpty)
            SliverToBoxAdapter(
                child: InkWell(
              onTap: () {
                alertDialog(context, "${"clear_search_history".tr()}?", "", [
                  outlinedButton(
                      label: "cancel".tr(),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                  filledButton(
                      label: "ok".tr(),
                      onPressed: () {
                        ref.read(searchHistoryProvider.notifier).clearHistory();
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
                      Text("clear_search_history".tr()).subHeader()
                    ],
                  ),
                ),
              ),
            )),
        ],
      ),
    );
  }

  void onSubmitted(String value) {
    ref.read(searchHistoryProvider.notifier).addHistory(value);
    Go.to(PicaResultsPage(keyword: value));
  }
}
