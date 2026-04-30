
import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';
import 'package:skana_pica/controller/log.dart';

class Go {
  static Future<T?> to<T>(dynamic page) async {
      return Navigator.push(context!, page);
  }
  static Future<T?> toNamed<T>(String page,
      {dynamic arguments}) async {
      return Navigator.pushNamed(context!, page, arguments: arguments);
  }
  static BuildContext? context;
}

String? _lastToastText;
DateTime? _lastToastTime;

void showToast(String text,[Duration? duration]) {
    final now = DateTime.now();

    if (_lastToastText == text &&
        _lastToastTime != null &&
        now.difference(_lastToastTime!) < const Duration(seconds: 2)) {
      return;
    }
    _lastToastText = text;
    _lastToastTime = now;
    
    try {
      MoonToast.show(
        toastAlignment: Alignment(0.0, 0.8),
        backgroundColor: MoonColors.dark.gohan,
        Go.context!,
        label: Text(text, style: TextStyle(color: MoonColors.light.goku)),
        displayDuration: duration,
      );
    } catch (e) {
      log.e(e);
    }
}


