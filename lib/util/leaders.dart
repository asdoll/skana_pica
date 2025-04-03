import 'package:bot_toast/bot_toast.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skana_pica/main.dart';

class Go {
  /// Similar to **Navigation.push()**
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

  /// Similar to **Navigation.pushReplacement**
  static Future<dynamic> off(dynamic page,
      {dynamic arguments, Transition? transition}) async {
    Get.off(
      page,
      arguments: arguments,
      transition: transition ?? Transition.rightToLeft,
      duration: const Duration(milliseconds: 200),
    );
  }

  /// Similar to **Navigation.pushAndRemoveUntil()**
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

void toast(String message) {
  BotToast.showCustomText(
      onlyOne: true,
      duration: const Duration(seconds: 2),
      toastBuilder: (cancel) {
        return Card(
          color: Get.theme.colorScheme.tertiary,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              message,
              style: TextStyle(color: Get.theme.colorScheme.onTertiary),
            ),
          ),
        );
      });
}

class Leader {
  static Future<void> pushUntilHome(BuildContext context) async {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => MyApp(),
      ),
      (route) => false,
    );
  }

  static final rootNavigatorKey = GlobalKey<NavigatorState>();

  static final mainScreenEasyRefreshController = EasyRefreshController(
      controlFinishLoad: true, controlFinishRefresh: true);

  static pop(BuildContext context) {
    Navigator.of(context).pop();
  }

  static popUtilHome(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  static Future<bool> pushWithUri(BuildContext context, Uri link) async {
    // https://www.pixiv.net/novel/series/$id
    if (link.scheme == "pixiv") {
      if (link.host.contains("illusts") ||
          link.host.contains("user") ||
          link.host.contains("novel")) {
        return _parseUriContent(context, link);
      }
    } else if (link.scheme.contains("http")) {
      return _parseUriContent(context, link);
    } else if (link.scheme == "pixez") {
      return _parseUriContent(context, link);
    }
    return false;
  }

  static bool _parseUriContent(BuildContext context, Uri link) {
    if (link.host.contains('illusts')) {
      //var idSource = link.pathSegments.last;
      try {
        //int id = int.parse(idSource);
        Navigator.of(context, rootNavigator: true)
            .push(MaterialPageRoute(builder: (context) {
          return Container(); //IllustPageLite(id.toString());
        }));
      // ignore: empty_catches
      } catch (e) {}
      return true;
    }
    return false;
  }

  static Future<dynamic> pushWithScaffold(context, Widget widget,
      {Widget? icon, Widget? title, bool root = false}) {
    if (root) {
      return Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
        builder: (context) => Scaffold(
          body: widget,
        ),
      ));
    }
    return Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Scaffold(
              body: widget,
            )));
  }

  static Future<dynamic> push(
    context,
    Widget widget, {
    Widget? icon,
    Widget? title,
    bool forceSkipWrap = false,
    bool root = false,
  }) {
    if (root) {
      return Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
        builder: (context) => Scaffold(
          body: widget,
        ),
      ));
    }
    return Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Scaffold(
              body: widget,
            )));
  }
}
