import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:skana_pica/pages/mainscreen.dart';

class Testpage extends StatefulWidget {
  const Testpage({Key? key}) : super(key: key);

  @override
  _TestpageState createState() => _TestpageState();
}

class _TestpageState extends State<Testpage> {
  MainScreenIndex mainScreenIndex = Get.find();

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader(
        title: Container(),
      ),
      content: FTabs(
        tabs: [
          FTabEntry(
            label: const Text('Account'),
            content: FCard(
              title: const Text('Account'),
              subtitle: const Text(
                  'Make changes to your account here. Click save when you are done.'),
              child: Column(
                children: [
                  const FTextField(
                    label: Text('Name'),
                    hint: 'John Renalo',
                  ),
                ],
              ),
            ),
          ),
          FTabEntry(
            label: const Text('Password'),
            content: FCard(
              title: const Text('Password'),
              subtitle: const Text(
                  'Change your password here. After saving, you will be logged out.'),
              child: Column(
                children: [
                  const FTextField(label: Text('Current password')),
                ],
              ),
            ),
          ),
          FTabEntry(
            label: const Text('Account'),
            content: FCard(
              title: const Text('Account'),
              subtitle: const Text(
                  'Make changes to your account here. Click save when you are done.'),
              child: Column(
                children: [
                  const FTextField(
                    label: Text('Name'),
                    hint: 'John Renalo',
                  ),
                ],
              ),
            ),
          ),
          FTabEntry(
            label: const Text('Password'),
            content: FCard(
              title: const Text('Password'),
              subtitle: const Text(
                  'Change your password here. After saving, you will be logged out.'),
              child: Column(
                children: [
                  const FTextField(label: Text('Current password')),
                ],
              ),
            ),
          ),
          FTabEntry(
            label: const Text('Account'),
            content: FCard(
              title: const Text('Account'),
              subtitle: const Text(
                  'Make changes to your account here. Click save when you are done.'),
              child: Column(
                children: [
                  const FTextField(
                    label: Text('Name'),
                    hint: 'John Renalo',
                  ),
                ],
              ),
            ),
          ),
          FTabEntry(
            label: const Text('Password'),
            content: FCard(
              title: const Text('Password'),
              subtitle: const Text(
                  'Change your password here. After saving, you will be logged out.'),
              child: Column(
                children: [
                  const FTextField(label: Text('Current password')),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
