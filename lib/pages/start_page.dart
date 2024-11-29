import 'package:flutter/material.dart';
import 'package:skana_pica/pages/home_page.dart';
import 'package:skana_pica/util/leaders.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Start Page'),
        ElevatedButton(
          child: Text('Go to Home Page'),
          onPressed: () {
            Go.to(HomePage());
          },
        ),
      ],
    ));
  }
}