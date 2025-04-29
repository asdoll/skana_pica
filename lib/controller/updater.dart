import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:moon_design/moon_design.dart';
import 'package:skana_pica/config/base.dart';
import 'package:skana_pica/config/setting.dart';
import 'package:skana_pica/util/leaders.dart';
import 'package:skana_pica/controller/log.dart';
import 'package:skana_pica/util/widgetplugin.dart';
import 'package:url_launcher/url_launcher_string.dart';

enum Result { yes, no, timeout }

late Updater updater;

class Updater extends GetxController {
  Rx<Result> result = Result.timeout.obs;
  RxString updateUrl =
      "https://github.com/asdoll/skana_pica/releases/latest".obs;
  RxString updateDescription = "".obs;
  RxString updateVersion = "".obs;
  RxString updateDate = "".obs;
  RxBool autoCheck = settings.autoCheckUpdate.obs;

  void init() {
    if (autoCheck.value) {
      check().then((value) {
        if (value == Result.yes) {
          alertDialog(
              Get.context!,
              "New version available".tr,
              "${"Description: ".tr} ${updateDescription.value}\n${"Version: ".tr} ${updateVersion.value}\n${"Date: ".tr} ${updateDate.value}",
              [
                outlinedButton(onPressed: () => Get.back(), label: "Cancel".tr),
                filledButton(
                    onPressed: () {
                      launchUrlString(updateUrl.value);
                      Get.back();
                    },
                    label: "Update".tr)
              ]);
        }
      });
    }
  }

  Future<Result> check({bool showResult = false}) async {
    //if (Constants.isGooglePlay) return Result.no;
    final result = await checkUpdate("");
    this.result.value = result;
    if (showResult) {
      if (result == Result.yes) {
        showToast('Update available'.tr);
      } else if (result == Result.no) {
        showToast('No update available'.tr);
      } else {
        showToast('Update check failed'.tr);
      }
    }
    return result;
  }

  Future<Result> checkUpdate(String arg) async {
    log.i("check for update ============");
    try {
      Response response =
          await Dio(BaseOptions(baseUrl: 'https://api.github.com'))
              .get('/repos/asdoll/skana_pica/releases/latest');
      if (response.statusCode != 200) return Result.no;
      String tagName = response.data['tag_name'];
      updateVersion.value = tagName;
      log.i("tagName:$tagName ");
      if (tagName != Base.version) {
        List<String> remoteList = tagName.split(".");
        List<String> localList = Base.version.split(".");
        log.i("r:$remoteList l$localList");
        if (remoteList.length != localList.length) return Result.yes;
        for (var i = 0; i < remoteList.length; i++) {
          int r = int.tryParse(remoteList[i]) ?? 0;
          int l = int.tryParse(localList[i]) ?? 0;
          log.i("r:$r l$l");
          if (r > l) {
            updateDate.value = response.data['published_at'];
            updateDescription.value = response.data['body'];
            return Result.yes;
          }
        }
      }
    } catch (e) {
      log.w(e);
      showToast("Update check failed".tr);
      return Result.timeout;
    }
    return Result.no;
  }

  String getCurrentVersion() {
    return Base.version;
  }

  void setAutoCheck(bool value) {
    autoCheck.value = value;
    settings.autoCheckUpdate = value;
  }
}

class BoardInfo {
  BoardInfo({
    required this.title,
    required this.content,
    required this.startDate,
    required this.endDate,
    required this.debug,
  });

  String title;
  String content;
  String startDate;
  String? endDate;
  bool? debug;

  factory BoardInfo.fromJson(Map<String, dynamic> json) => BoardInfo(
        title: json['title'] as String,
        content: json['content'] as String,
        startDate: json['startDate'] as String,
        endDate: json['endDate'] as String?,
        debug: json['debug'] as bool?,
      );
  Map<String, dynamic> toJson() => <String, dynamic>{
        'title': title,
        'content': content,
        'startDate': startDate,
        'endDate': endDate,
        'debug': debug,
      };
}

late BoardController boardController;

class BoardController extends GetxController {
  RxList<BoardInfo> boardList = <BoardInfo>[].obs;

  void init() {
    getBoardList();

    Duration(seconds: 5).delay(() {
      BoardInfo? info;
      info = boardController.boardList.firstWhere(
          (element) => element.debug == true,
          orElse: () => BoardInfo(
              title: "PLACEHOLDER",
              content: "",
              startDate: "",
              endDate: "",
              debug: true));
      if (info.debug ?? true) {
        info = null;
      }
      boardController.boardList.clear();
      if (info != null) {
        MoonToast.show(
            toastAlignment: Alignment.center,
            backgroundColor: MoonColors.dark.gohan,
            displayDuration: const Duration(seconds: 10),
            Get.context!,
            label: Text(info.title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(info.content).paddingBottom(16),
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  filledButton(
                    onPressed: () {
                      MoonToast.clearToastQueue();
                    },
                    label: "Ok".tr,
                  ),
                ]),
              ],
            ));
      }
    });
  }

  Future<void> getBoardList() async {
    try {
      Response response = await Dio().get(
          'https://raw.githubusercontent.com/asdoll/skana_pica/refs/heads/main/board.json');
      final list = (jsonDecode(response.data) as List)
          .map((e) => BoardInfo.fromJson(e))
          .toList();
      boardList.value = list;
    } catch (e) {
      log.w(e);
    }
  }
}
