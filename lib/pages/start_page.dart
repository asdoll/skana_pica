import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skana_pica/pages/pica_login.dart';
import 'package:skana_pica/util/leaders.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 8),
              Text(
                  "The purpose of this App is only for learning, communication, and personal interest. Any content displayed comes from the internet and is not related to the developer"
                      .tr),
              SizedBox(height: 8),
              Text(
                  "If you encounter any problems during use, please first confirm whether it is a problem with your device, and then provide feedback"
                      .tr),
              SizedBox(height: 8),
              Text(
                  "The developer is not responsible for whether the problem can be solved"
                      .tr),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Go.to(PicaLoginPage(start:true));
                },
                child: Text("Login".tr),
              ),
              SizedBox(height: 8),
            ],
          ).paddingAll(16),
        ).paddingAll(20),
      ],
    );
  }
}
