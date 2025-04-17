import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moon_design/moon_design.dart';
import 'package:skana_pica/pages/mainscreen.dart';

class CommonBackArea extends StatefulWidget {
  const CommonBackArea({super.key});

  @override
  State<CommonBackArea> createState() => _CommonBackAreaState();
}

class _CommonBackAreaState extends State<CommonBackArea> {
  bool _isLongPress = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: IconButton(
        icon: Icon(
          _isLongPress ? Icons.home : Icons.arrow_back,
          color: Colors.white,
          size: 20,
        ),
        onPressed: () {
          Get.back();
        },
      ),
      onLongPress: () {
        setState(() {
          _isLongPress = true;
        });
        Get.offAll(() => const Mains());
      },
    );
  }
}

class NormalBackButton extends StatelessWidget {
  const NormalBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Get.back();
      },
      icon: Icon(
        Icons.arrow_back,
        color: context.moonTheme?.tokens.colors.bulma,
      ),
    );
  }
}
