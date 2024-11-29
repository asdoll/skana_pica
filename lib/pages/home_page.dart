import 'package:flutter/material.dart';
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
    return Scaffold(body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('First Page'),
        ElevatedButton(
          child: Text('Go to Second Page'),
          onPressed: () {
            Go.to(PicaLoginPage());
          },
        ),
      ],
    ));
  }
}