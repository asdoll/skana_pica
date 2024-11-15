import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:skana_pica/pages/pica_login.dart';
import 'package:skana_pica/util/leaders.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {

  @override
  Widget build(BuildContext context) {
    return FScaffold(content: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('First Page'),
        FButton(
          label: Text('Go to Second Page'),
          onPress: () {
            Leader.push(context, PicaLoginPage());
          },
        ),
      ],
    ));
  }
}