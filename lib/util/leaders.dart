
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moon_design/moon_design.dart';
import 'package:skana_pica/controller/log.dart';

class Go {
  static Future<T?> to<T>(dynamic page,
      {dynamic arguments,
      Transition? transition,
      bool? opaque,
      bool preventDuplicates = true}) async {
    return await Get.to<T>(page,
        arguments: arguments,
        transition: transition ?? Transition.rightToLeft,
        duration: const Duration(milliseconds: 200),
        opaque: opaque,
        preventDuplicates: preventDuplicates);
  }

  static Future<dynamic> off(dynamic page,
      {dynamic arguments, Transition? transition}) async {
    Get.off(
      page,
      arguments: arguments,
      transition: transition ?? Transition.rightToLeft,
      duration: const Duration(milliseconds: 200),
    );
  }

  static Future<dynamic> offUntil(dynamic page,
      {Transition? transition}) async {
    Get.offUntil(
        GetPageRoute(
          page: page,
          transition: transition ?? Transition.rightToLeft,
          transitionDuration: const Duration(milliseconds: 200),
        ),
        (route) => false);
  }
}

void showToast(String text,[Duration? duration]) {
    try {
      MoonToast.show(
        toastAlignment: Alignment(0.0, 0.8),
        backgroundColor: MoonColors.dark.gohan,
        Get.context!,
        label: Text(text, style: TextStyle(color: MoonColors.light.goku)),
        displayDuration: duration,
      );
    } catch (e) {
      log.e(e);
    }
}


