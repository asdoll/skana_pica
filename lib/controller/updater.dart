import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart'
    show StringTranslateExtension;
import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';
import 'package:skana_pica/config/base.dart';
import 'package:skana_pica/config/setting.dart';
import 'package:skana_pica/util/leaders.dart';
import 'package:skana_pica/controller/log.dart';
import 'package:skana_pica/util/widgetplugin.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'updater.freezed.dart';
part 'updater.g.dart';

enum Result { yes, no, timeout }

@freezed
abstract class UpdaterState with _$UpdaterState {
  factory UpdaterState(
      {@Default(Result.timeout) Result result,
      @Default("") String updateDescription,
      @Default("") String updateVersion,
      @Default("") String updateDate,
      @Default(true) bool autoCheck}) = _UpdaterState;
}

String get updateUrl => "https://github.com/asdoll/skana_pica/releases/latest";

@Riverpod(keepAlive: true)
class Updater extends _$Updater {
  @override
  UpdaterState build() {
    return UpdaterState(autoCheck: settings.autoCheckUpdate);
  }

  void init() {
    if (state.autoCheck) {
      check().then((value) {
        if (value == Result.yes) {
          alertDialog(
              Go.context!,
              "new_version_available".tr(),
              "${"description".tr()}: ${state.updateDescription}\n${"latest_version".tr()}: ${state.updateVersion}\n${"release_date".tr()}: ${state.updateDate}",
              [
                outlinedButton(
                    onPressed: () => Navigator.pop(Go.context!),
                    label: "cancel".tr()),
                filledButton(
                    onPressed: () {
                      launchUrlString(updateUrl);
                      Navigator.pop(Go.context!);
                    },
                    label: "update".tr())
              ]);
        }
      });
    }
  }

  Future<Result> check({bool showResult = false}) async {
    //if (Constants.isGooglePlay) return Result.no;
    final result = await checkUpdate("");
    state = state.copyWith(result: result);
    if (showResult) {
      if (result == Result.yes) {
        showToast("new_version_available".tr());
      } else if (result == Result.no) {
        showToast('no_update_available'.tr());
      } else {
        showToast('update_check_failed'.tr());
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
      state = state.copyWith(
          updateVersion: tagName,
          updateDate: response.data['published_at'] ?? "",
          updateDescription: response.data['body'] ?? "");
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
            return Result.yes;
          }
        }
      }
    } catch (e) {
      log.w(e);
      showToast("update_check_failed".tr());
      return Result.timeout;
    }
    return Result.no;
  }

  String getCurrentVersion() {
    return Base.version;
  }

  void setAutoCheck(bool value) {
    state = state.copyWith(autoCheck: value);
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

@Riverpod(keepAlive: true)
class Board extends _$Board {
  @override
  List<BoardInfo> build() {
    return List<BoardInfo>.unmodifiable([]);
  }

  void init() {
    getBoardList();

    Future.delayed(const Duration(seconds: 5), () {
      BoardInfo? info;
      info = state.firstWhere((element) => element.debug == true,
          orElse: () => BoardInfo(
              title: "PLACEHOLDER",
              content: "",
              startDate: "",
              endDate: "",
              debug: true));
      if (info.debug ?? true) {
        info = null;
      }
      state = List<BoardInfo>.unmodifiable([]);
      if (info != null) {
        MoonToast.show(
            toastAlignment: Alignment.center,
            backgroundColor: MoonColors.dark.gohan,
            displayDuration: const Duration(seconds: 10),
            Go.context!,
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
                    label: "ok".tr(),
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
      state = List<BoardInfo>.from(list);
    } catch (e) {
      log.w(e);
    }
  }
}
