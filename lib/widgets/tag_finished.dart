import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TagFinished extends StatelessWidget {
  const TagFinished({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Get.theme.colorScheme.secondaryContainer,
      ),
      child: Text("Finished".tr,
          style: Get.theme.textTheme.bodySmall
              ?.copyWith(color: Get.theme.colorScheme.onSecondaryContainer)),
    );
  }
}
