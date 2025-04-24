import 'package:flutter/material.dart';

extension ContextExt on BuildContext {
  EdgeInsets get padding => MediaQuery.of(this).padding;

  double get width => MediaQuery.of(this).size.width;

  double get height => MediaQuery.of(this).size.height;

  EdgeInsets get viewInsets => MediaQuery.of(this).viewInsets;

  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  Brightness get brightness => Theme.of(this).brightness;
}

double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;

Widget sized(double? width, double? height) {
  return SizedBox(width: width, height: height);
}

UiModes uiMode(BuildContext context) {
  if (MediaQuery.of(context).size.shortestSide < 600) {
    return UiModes.m1;
  } else if (!(MediaQuery.of(context).size.shortestSide < 600) &&
      !(MediaQuery.of(context).size.width > 1400)) {
    return UiModes.m2;
  } else {
    return UiModes.m3;
  }
}

enum UiModes {
  /// The screen have a short width. Usually the device is phone.
  m1,

  /// The screen's width is medium size. Usually the device is tablet.
  m2,

  /// The screen's width is long. Usually the device is PC.
  m3
}

Size screenSize(BuildContext context) => MediaQuery.of(context).size;

ColorScheme colors(BuildContext context) => Theme.of(context).colorScheme;
