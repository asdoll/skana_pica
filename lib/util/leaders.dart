import 'package:flutter/material.dart';
import 'package:skana_pica/main.dart';

class Leader {
  static Future<void> pushUntilHome(BuildContext context) async {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => MyApp(),
      ),
      (route) => false,
    );
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
          return Container();//IllustPageLite(id.toString());
        }));
      } catch (e) {}
      return true;
    }
    return false;
  }

  static Future<dynamic> pushWithScaffold(context, Widget widget,
      {Widget? icon, Widget? title, bool root =false}) {
    if(root) {
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
    if(root) {
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
