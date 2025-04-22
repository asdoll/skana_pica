import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moon_design/moon_design.dart';
import 'package:skana_pica/config/setting.dart';
import 'package:skana_pica/widgets/icons.dart';

extension WidgetExtension on Widget {
  Widget padding(EdgeInsetsGeometry padding) {
    return Padding(padding: padding, child: this);
  }

  Widget paddingLeft(double padding) {
    return Padding(padding: EdgeInsets.only(left: padding), child: this);
  }

  Widget paddingRight(double padding) {
    return Padding(padding: EdgeInsets.only(right: padding), child: this);
  }

  Widget paddingTop(double padding) {
    return Padding(padding: EdgeInsets.only(top: padding), child: this);
  }

  Widget paddingBottom(double padding) {
    return Padding(padding: EdgeInsets.only(bottom: padding), child: this);
  }

  Widget paddingVertical(double padding) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: padding), child: this);
  }

  Widget paddingHorizontal(double padding) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: padding), child: this);
  }

  Widget rounded(double radius) {
    return ClipRRect(borderRadius: BorderRadius.circular(radius), child: this);
  }

  Widget toCenter() {
    return Center(child: this);
  }

  Widget toAlign(AlignmentGeometry alignment) {
    return Align(alignment: alignment, child: this);
  }

  Widget sliverPadding(EdgeInsetsGeometry padding) {
    return SliverPadding(padding: padding, sliver: this);
  }

  Widget sliverPaddingAll(double padding) {
    return SliverPadding(padding: EdgeInsets.all(padding), sliver: this);
  }

  Widget sliverPaddingVertical(double padding) {
    return SliverPadding(
        padding: EdgeInsets.symmetric(vertical: padding), sliver: this);
  }

  Widget sliverPaddingHorizontal(double padding) {
    return SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: padding), sliver: this);
  }

  Widget fixWidth(double width) {
    return SizedBox(width: width, child: this);
  }

  Widget fixHeight(double height) {
    return SizedBox(height: height, child: this);
  }

  Widget bgColor(Color color) {
    return Container(color: color, child: this);
  }

  PreferredSizeWidget preferredSize(double height) {
    return PreferredSize(preferredSize: Size.fromHeight(height), child: this);
  }
}

extension ColorExtension on Color {
  Color darken([int percent = 10]) {
    return Color.lerp(this, Colors.black, percent / 100) ?? this;
  }

  Color lighten([int percent = 10]) {
    return Color.lerp(this, Colors.white, percent / 100) ?? this;
  }

  // lighten if dark by default
  Color applyDarkMode({bool reverse = false, int percent = 20}) {
    if (reverse) {
      return settings.isDarkMode ? darken(percent) : lighten(percent);
    }
    return settings.isDarkMode ? lighten(percent) : darken(percent);
  }
}

final homeKey = GlobalKey<ScaffoldState>();

void openDrawer() {
  homeKey.currentState!.openDrawer();
}

void closeDrawer() {
  homeKey.currentState!.closeDrawer();
}

Future<T?> alertDialog<T>(BuildContext context, String title, String content,
    [List<Widget>? actions]) {
  return showMoonModal<T>(
      context: context,
      builder: (context) {
        return Dialog(
            child: ListView(
          shrinkWrap: true,
          children: [
            MoonAlert(
                borderColor: Get
                    .context?.moonTheme?.buttonTheme.colors.borderColor
                    .withValues(alpha: 0.5),
                showBorder: true,
                label: Text(title).header(),
                verticalGap: 16,
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(content).paddingBottom(16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: actions
                              ?.map((action) => action.paddingRight(8))
                              .toList() ??
                          [],
                    ),
                  ],
                )),
          ],
        ));
      });
}

Widget moonCard(
    {String? title,
    required Widget content,
    List<Widget>? actions,
    EdgeInsetsGeometry? padding,
    Color? backgroundColor}) {
  return MoonAlert(
      backgroundColor: backgroundColor ??
          (Get.context?.moonTheme?.tokens.colors.gohan ?? Colors.white),
      padding: padding,
      showBorder: false,
      label: title == null ? Container() : Text(title).header(),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          content,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children:
                actions?.map((action) => action.paddingRight(8)).toList() ?? [],
          ),
        ],
      ));
}

Widget outlinedButton(
    {String? label, VoidCallback? onPressed, MoonButtonSize? buttonSize}) {
  return MoonOutlinedButton(
      buttonSize: buttonSize ?? MoonButtonSize.sm,
      onTap: onPressed,
      label: label == null ? null : Text(label),
      borderColor: Get.context?.moonTheme?.buttonTheme.colors.borderColor
          .withValues(alpha: 0.5));
}

Widget textButton(
    {String? label, VoidCallback? onPressed, MoonButtonSize? buttonSize}) {
  return MoonTextButton(
    buttonSize: buttonSize ?? MoonButtonSize.sm,
    onTap: onPressed,
    label: label == null ? null : Text(label).small(),
  );
}

Widget filledButton(
    {String? label,
    VoidCallback? onPressed,
    MoonButtonSize? buttonSize,
    Widget? leading,
    Color? textColor,
    Color? color,
    bool applyDarkMode = false}) {
  return MoonFilledButton(
    buttonSize: buttonSize ?? MoonButtonSize.sm,
    onTap: onPressed,
    label: label == null
        ? null
        : Text(label,
            style: TextStyle(
                color: textColor ??
                    (applyDarkMode
                        ? (settings.isDarkMode ? Colors.white : Colors.black)
                        : null))),
    backgroundColor: color,
  );
}

Widget moonListTile(
    {required String title,
    String? subtitle,
    VoidCallback? onTap,
    Widget? leading,
    Widget? trailing}) {
  return InkWell(
      onTap: onTap ?? () {},
      child: MoonMenuItem(
        backgroundColor: settings.isDarkMode
            ? MoonColors.dark.gohan
            : MoonColors.light.gohan,
        onTap: onTap ?? () {},
        label: Text(title).header(),
        content: subtitle == null ? null : Text(subtitle).subHeader(),
        leading: leading,
        trailing: trailing,
      ).paddingSymmetric(vertical: 2, horizontal: 8));
}

Widget moonListTileWidgets(
    {required Widget label,
    Widget? content,
    Widget? leading,
    Widget? trailing,
    VoidCallback? onTap,
    EdgeInsetsGeometry? menuItemPadding,
    CrossAxisAlignment? menuItemCrossAxisAlignment,
    bool noPadding = false}) {
  return InkWell(
      onTap: onTap ?? () {},
      child: MoonMenuItem(
        backgroundColor: settings.isDarkMode
            ? MoonColors.dark.gohan
            : MoonColors.light.gohan,
        menuItemPadding: menuItemPadding,
        menuItemCrossAxisAlignment: menuItemCrossAxisAlignment,
        onTap: onTap ?? () {},
        label: label,
        content: content,
        leading: leading,
        trailing: trailing,
      ).paddingSymmetric(
          vertical: noPadding ? 0 : 2, horizontal: noPadding ? 0 : 8));
}

Widget emptyPlaceholder(BuildContext context) {
  return Container(
    padding: const EdgeInsets.only(bottom: 100),
    width: double.infinity,
    height: context.height / 1.5,
    alignment: Alignment.center,
    child: Center(
      child: Text('[ ]').h1(),
    ),
  );
}

AppBar appBar(
        {required String title,
        String? subtitle,
        Widget? leading = const NormalBackButton(),
        List<Widget>? actions}) =>
    AppBar(
      leadingWidth: 40,
      title: MoonMenuItem(
          onTap: () {},
          label: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis)
              .appHeader()
              .paddingRight(8),
          verticalGap: 0,
          content: subtitle == null
              ? null
              : Text(subtitle,
                      style: TextStyle(
                          color: Get.context?.moonTheme?.textAreaTheme.colors
                              .helperTextColor))
                  .subHeader()),
      leading: Transform.translate(offset: Offset(0, 2), child: leading),
      actions: actions,
      shape: Border(
          bottom: BorderSide(
        color: settings.isDarkMode
            ? Colors.white.withValues(alpha: 0.5)
            : Colors.black.withValues(alpha: 0.5),
        width: 0.2,
      )),
    );

extension TextExtension on Text {
  Color get _textColor =>
      style?.color ?? (settings.isDarkMode ? Colors.white : Colors.black);

  Text appHeader() => Text(
        data ?? '',
        maxLines: maxLines,
        overflow: overflow,
        strutStyle: strutStyle,
        style: Get.context?.moonTheme?.tokens.typography.heading.text18
            .copyWith(color: _textColor),
      );

  Text appSubHeader() => Text(
        data ?? '',
        maxLines: maxLines,
        overflow: overflow,
        strutStyle: strutStyle,
        style: Get.context?.moonTheme?.tokens.typography.heading.text16
            .copyWith(color: _textColor),
      );

  Text header() => Text(
        data ?? '',
        maxLines: maxLines,
        overflow: overflow,
        strutStyle: strutStyle,
        style: Get.context?.moonTheme?.tokens.typography.heading.text16
            .copyWith(color: _textColor),
      );

  Text subHeader() => Text(
        data ?? '',
        maxLines: maxLines,
        overflow: overflow,
        strutStyle: strutStyle,
        style: Get.context?.moonTheme?.tokens.typography.heading.text14
            .copyWith(color: _textColor),
      );

  Text small() {
    return Text(
      data ?? '',
      maxLines: maxLines,
      overflow: overflow,
      strutStyle: strutStyle,
      style: Get.context?.moonTheme?.tokens.typography.heading.text12
          .copyWith(color: _textColor),
    );
  }

  Text underlineSmall() => Text(
        data ?? '',
        maxLines: maxLines,
        overflow: overflow,
        strutStyle: strutStyle,
        style: Get.context?.moonTheme?.tokens.typography.heading.text12
            .copyWith(color: _textColor, decoration: TextDecoration.underline),
      );

  Text subHeaderForgound() => Text(
        data ?? '',
        maxLines: maxLines,
        overflow: overflow,
        strutStyle: strutStyle,
        style:
            Get.context?.moonTheme?.tokens.typography.heading.text14.copyWith(
          foreground: style?.foreground ??
              Get.context?.moonTheme?.tokens.typography.heading.text14
                  .foreground,
        ),
      );

  Text xSmall() => Text(
        data ?? '',
        maxLines: maxLines,
        overflow: overflow,
        strutStyle: strutStyle,
        style: Get.context?.moonTheme?.tokens.typography.heading.text10
            .copyWith(color: _textColor),
      );

  Text h1() => Text(
        data ?? '',
        maxLines: maxLines,
        overflow: overflow,
        strutStyle: strutStyle,
        style: Get.context?.moonTheme?.tokens.typography.heading.text40
            .copyWith(color: _textColor),
      );

  Text h2() => Text(
        data ?? '',
        maxLines: maxLines,
        overflow: overflow,
        strutStyle: strutStyle,
        style: Get.context?.moonTheme?.tokens.typography.heading.text32
            .copyWith(color: _textColor),
      );
}

extension TextSpanExtension on TextSpan {
  TextSpan small() => TextSpan(
        style: Get.context?.moonTheme?.tokens.typography.heading.text12
            .copyWith(
                color: style?.color ??
                    (settings.isDarkMode ? Colors.white : Colors.black),
                fontStyle: style?.fontStyle),
        text: text,
        children: children,
        recognizer: recognizer,
        mouseCursor: mouseCursor,
        locale: locale,
        spellOut: spellOut,
        onEnter: onEnter,
        onExit: onExit,
      );
}
