import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:skana_pica/pages/pica_login.dart';
import 'package:skana_pica/util/leaders.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return FScaffold(content: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('First Page'),
        FButton(
          label: Text('Go to Second Page'),
          onPress: () {
            Go.to(PicaLoginPage());
          },
        ),
      ],
    ));
  }
}