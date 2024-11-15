import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:skana_pica/pages/first_page.dart';
import 'package:skana_pica/util/translate.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = 0;
  }

  @override
  Widget build(BuildContext context) {
    final headers = [
      FHeader(title: Text(S.of(context).home)),
      FHeader(title: Text(S.of(context).categories)),
      FHeader(title: Text(S.of(context).search)),
      FHeader(
        title: Text(S.of(context).settings),
        actions: [
          FHeaderAction(
            icon: FIcon(FAssets.icons.ellipsis),
            onPress: () {
              BotToast.showText(text: 'Settings');
            },
          ),
        ],
      ),
    ];

    final contents = [
      FirstPage(),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text(S.of(context).categories)],
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text(S.of(context).search)],
      ),
      Column(
        children: [
          const SizedBox(height: 5),
          
        ],
      ),
    ];
    return FScaffold(
      header: headers[_index],
      content: contents[_index],
      footer: FBottomNavigationBar(
        index: _index,
        onChange: (i) => setState(() => _index = i),
        children: [
          FBottomNavigationBarItem(
            icon: FIcon(FAssets.icons.house),
            label: Text(S.of(context).home),
          ),
          FBottomNavigationBarItem(
            icon: FIcon(FAssets.icons.layoutGrid),
            label: Text(S.of(context).categories),
          ),
          FBottomNavigationBarItem(
            icon: FIcon(FAssets.icons.search),
            label: Text(S.of(context).search),
          ),
          FBottomNavigationBarItem(
            icon: FIcon(FAssets.icons.settings),
            label: Text(S.of(context).settings),
          ),
        ],
      ),
    );
  }
}
