import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:skana_pica/api/comic_sources/picacg/pica_source.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skana_pica/api/managers/history_manager.dart';
import 'package:skana_pica/config/base.dart';
import 'package:skana_pica/controller/blocker.dart';
import 'package:skana_pica/controller/categories.dart';
import 'package:skana_pica/controller/favourite.dart';
import 'package:skana_pica/controller/profile.dart';
import 'package:skana_pica/controller/searchhistory.dart';
import 'package:skana_pica/controller/log.dart';

class Appdata {
  ///搜索历史
  List<String> searchHistory = [];

  ///屏蔽的关键词
  List<String> blockingKeyword = [];

  late SharedPreferences s;

  late FlutterSecureStorage secureStorage;

  Map<String, String> cookies = {};

  Future<void> init() async {
    s = await SharedPreferences.getInstance();
    secureStorage = FlutterSecureStorage(
        iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
        aOptions: AndroidOptions(encryptedSharedPreferences: true));
    cookies = await secureStorage.readAll();
    await readData();
  }

  bool _isSaving = false;
  bool _haveWaitingTask = false;

  Future<void> saveSecures(String key) async {
    Map<String, dynamic> data = {};
    switch (key) {
      case "picacg":
        data = picacg.data;
        break;
    }
    if (_haveWaitingTask) return;
    while (_isSaving) {
      _haveWaitingTask = true;
      await Future.delayed(const Duration(milliseconds: 20));
      _haveWaitingTask = false;
    }
    _isSaving = true;
    for (var e in data.entries) {
      settings.secureStorage
          .write(key: "${key}_${e.key}", value: e.value.toString());
    }
    _isSaving = false;
  }

  List<String> general = [
    "0", //0 dark mode 0/1/2 (system/disabled/enable)
    "8", //1 theme color
    "", //2 language empty=system
    "0", //3 hosts
    "0", //4 代理设置, 0代表使用系统代理
    "0", //5 mainscreen default tab
    "0", //6 default orientation, 0-auto, 1-portrait, 2-landscape
    "30", //7 cache period
    "1", //8 auto check update
  ];

  List<String> pica = [
    "0", //0 Api请求地址, 为0时表示使用哔咔官方Api, 为1表示使用转发服务器
    "original", //1 pica图片质量
    "1", //2 启动时签到
    "", //3 last punched time
    "dd", //4 搜索模式
    "", //5 blocked category
    "0", //6 page view(1) or unlimited scroll(0)
    "3", //7 preload pages
    "1", //8 preload when enter details page
    "Leaderboard;Latest;Random;Bookmarks;", //9 main screen display cates
  ];

  List<String> read = [
    "0", //0 限制图片宽度
    "0", //1 阅读器图片布局方式, 0-contain, 1-cover
    "2", //2 翻页方式: 1从左向右,2从右向左,3从上至下,4从上至下(连续),5 duo,6 duo reversed
    "1", //3 阅读器背景色 1-dark, 0-light
    "25", //4 tap to next page threshold
    "0", //5 orientation, 0-auto, 1-portrait, 2-landscape
    "5", //6 autoPageTurningInterval
    "200", //7 animation duration
  ];

  bool isFirstLaunch() {
    return s.getBool("_is_first_launch") ?? true;
  }

  Future<bool> firstLaunch() async {
    bool f = s.getBool("_is_first_launch") ?? true;
    if (f) {
      await s.setBool("_is_first_launch", false);
      secureStorage.deleteAll();
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    cookies.clear();
    await secureStorage.deleteAll();
  }

  Future<void> readSettings() async {
    List<String> g = s.getStringList("general") ?? [];
    log.t("read settings: $g");
    if (g.isNotEmpty) {
      for (int i = 0; i < g.length && i < general.length; i++) {
        general[i] = g[i];
      }
    }
    List<String> p = s.getStringList("pica") ?? [];
    log.t("read pica settings: $p");
    if (p.isNotEmpty) {
      for (int i = 0; i < p.length && i < pica.length; i++) {
        pica[i] = p[i];
      }
    }
    List<String> r = s.getStringList("read") ?? [];
    log.t("read read settings: $r");
    if (r.isNotEmpty) {
      for (int i = 0; i < r.length && i < read.length; i++) {
        read[i] = r[i];
      }
    }
  }

  Future<void> updateSettings(String? type) async {
    switch (type) {
      case "general":
        await s.setStringList("general", general);
        break;
      case "pica":
        await s.setStringList("pica", pica);
        break;
      case "read":
        await s.setStringList("read", read);
        break;
      default:
        await s.setStringList("general", general);
        await s.setStringList("pica", pica);
        await s.setStringList("read", read);
    }
  }

  void writeHistory() async {
    await s.setStringList("search", searchHistory);
  }

  Future<void> writeData() async {
    await updateSettings("");
    writeHistory();
    await setBlockingKeyword();
  }

  Future<void> setBlockingKeyword() async {
    await s.setStringList("blockingKeyword", blockingKeyword);
  }

  Future<bool> readData() async {
    try {
      await readSettings();
      searchHistory = s.getStringList("search") ?? [];
      blockingKeyword = s.getStringList("blockingKeyword") ?? [];
      return true;
    } catch (e) {
      return false;
    }
  }

  bool readDataFromJson(Map<String, dynamic> json) {
    try {
      var newGeneral = List<String>.from(json["general"]);
      for (var i = 0; i < general.length && i < newGeneral.length; i++) {
        general[i] = newGeneral[i];
      }
      var newPica = List<String>.from(json["pica"]);
      for (var i = 0; i < pica.length && i < newPica.length; i++) {
        pica[i] = newPica[i];
      }
      var newRead = List<String>.from(json["read"]);
      for (var i = 0; i < read.length && i < newRead.length; i++) {
        read[i] = newRead[i];
      }
      blockingKeyword = Set<String>.from(
              ((json["blockingKeywords"] ?? []) + blockingKeyword) as List)
          .toList();
      writeData();
      return true;
    } catch (e, s) {
      log.e("Appdata.readDataFromJson", error: "error reading appdata$e\n$s");
      readData();
      return false;
    }
  }

  void restore(String type) {
    switch (type) {
      case "general":
        general = [
          "0", //0 dark mode 0/1/2 (system/disabled/enable)
          "8", //1 theme color
          "", //2 language empty=system
          "0", //3 hosts
          "0", //4 代理设置, 0代表使用系统代理
          "0", //5 mainscreen default tab
          "1", //6 default orientation, 0-auto, 1-portrait, 2-landscape
          "30", //7 cache period
          "1", //8 high refresh rate
        ];
        break;
      case "pica":
        pica = [
          "0", //0 Api请求地址, 为0时表示使用哔咔官方Api, 为1表示使用转发服务器
          "original", //1 pica图片质量
          "1", //2 启动时签到
          "", //3 last punched time
          "dd", //4 搜索模式
          "", //5 blocked category
          "0", //6 page view(1) or unlimited scroll(0)
          "3", //7 preload pages
          "1", //8 preload when enter details page
          "Leaderboard;Latest;Random;Bookmarks;", //9 main screen display cates
        ];
        categoriesController.init();
        break;
      case "read":
        read = [
          "0", //0 限制图片宽度
          "0", //1 阅读器图片布局方式, 0-contain, 1-cover
          "2", //2 翻页方式: 1从左向右,2从右向左,3从上至下,4从上至下(连续),5 duo,6 duo reversed
          "1", //3 阅读器背景色 1-dark, 0-light
          "25", //4 tap to next page threshold
          "0", //5 orientation, 0-auto, 1-portrait, 2-landscape
          "5", //6 autoPageTurningInterval
          "200", //7 animation duration
        ];
        break;
    }
    updateSettings(type);
  }

  /***
   * following are get set funtions
   * 
   */

  /// Theme color, index of [colors] (lib/foundation/def.dart)
  int get theme => int.parse(general[1]);

  set theme(int value) {
    settings.general[1] = value.toString();
    settings.updateSettings("general");
  }

  /// Dark Mode, 0/1/2 (system/disabled/enable)
  String get darkMode => settings.general[0];

  bool get isDarkMode =>
      settings.general[0] == '2' ||
      settings.general[0] == '0' &&
          WidgetsBinding.instance.platformDispatcher.platformBrightness ==
              Brightness.dark;

  set darkMode(String value) {
    settings.general[0] = value;
    settings.updateSettings("general");
  }

  /// image quality, original/low/middle/high
  String get picaImageQuality => settings.pica[1];

  set picaImageQuality(String value) {
    settings.pica[1] = value;
    settings.updateSettings("pica");
  }

  DateTime? get lastPunchedTime => DateTime.tryParse(settings.pica[3]);

  set lastPunchedTime(DateTime? value) {
    settings.pica[3] = value?.toIso8601String() ?? "";
    settings.updateSettings("pica");
  }

  int get picaSearchMode {
    var modes = ["dd", "da", "ld", "vd"];
    return modes.indexOf(settings.pica[4]);
  }

  set picaSearchMode(int mode) {
    var modes = ["dd", "da", "ld", "vd"];
    settings.pica[4] = modes[mode];
    settings.updateSettings("pica");
  }

  List<String> get blockedCategory => settings.pica[5].split(";");
  set blockedCategory(List<String> value) {
    settings.pica[5] = value.join(";");
    settings.updateSettings("pica");
  }

  bool get useDarkBackground => settings.read[3] == "1";

  set useDarkBackground(bool value) {
    settings.read[3] = value ? "1" : "0";
    settings.updateSettings("read");
  }

  int get cachePeriod => int.tryParse(settings.general[7])??30;

  String getVersion() {return Base.version;}

  bool get autoCheckUpdate => settings.general[8] == "1";

  set autoCheckUpdate(bool value) {
    settings.general[8] = value ? "1" : "0";
    settings.updateSettings("general");
  }

  bool get highRefreshRate => settings.general[8] == "1";

  set highRefreshRate(bool value) {
    settings.general[8] = value ? "1" : "0";
    settings.updateSettings("general");
  }
}

var settings = Appdata();

/// clear all data
Future<void> clearAppdata() async {
  var s = await SharedPreferences.getInstance();
  await s.clear();
  //appdata.history.clearHistory();
  settings = Appdata();
  await settings.init();
  await settings.readData();
  clearGlobalControllers();
  M.o.clearDB();
}

void clearGlobalControllers() {
  profileController.logout();
  favorController.clear();
  searchHistoryController.init();
  blocker.init();
  categoriesController.init();
}
