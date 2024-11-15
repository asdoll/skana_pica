import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    return FScaffold(content: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Start Page'),
        FButton(
          label: Text('Go to Home Page'),
          onPress: () {
            Navigator.pushNamed(context, '/home');
          },
        ),
      ],
    ));
  }
}