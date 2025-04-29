import 'package:flutter/material.dart';
import 'package:skana_pica/widgets/custom_indicator.dart';

class TestPage extends StatefulWidget{

  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SafeArea(child: BezierIndicator(
      onRefresh: () async {await Future.delayed(const Duration(seconds: 2));},
      child: ListView(
        children: [
          for (int i = 0; i < 10; i++)
            ListTile(
              title: Text('Item $i'),
            ),
        ],
      ),
    ))
    );
  }
}