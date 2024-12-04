
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:skana_pica/api/comic_sources/picacg/pica_source.dart';
import 'package:skana_pica/config/base.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skana_pica/util/log.dart';

class Appdata {
  ///搜索历史
  List<String> searchHistory = [];
  Set<String> favoriteTags = {};

  ///屏蔽的关键词
  List<String> blockingKeyword = [];

  ///历史记录管理器, 可以通过factory构造函数访问, 也可以通过这里访问
  //var history = HistoryManager();

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
      appdata.secureStorage
          .write(key: "${key}_${e.key}", value: e.value.toString());
    }
    _isSaving = false;
  }

  List<String> general = [
    "0", //0 dark mode 0/1/2 (system/disabled/enable)
    "0", //1 theme color
    "", //2 language empty=system
    "0", //3 hosts
    "0", //4 代理设置, 0代表使用系统代理
    "0", //5 mainscreen default tab
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
  ];

  List<String> read = [
    "0", //0 限制图片宽度
    "0", //1 阅读器图片布局方式, 0-contain, 1-cover
    "5", //2 翻页方式: 1从左向右,2从右向左,3从上至下,4从上至下(连续),5 duo,6 duo reversed
    "1", //3 阅读器背景色 1-dark, 0-light
  ];

  Future<bool> firstLaunch() async {
    bool f = s.getBool("_is_first_launch") ?? true;
    if (f) {
      await s.setBool("_is_first_launch", false);
      secureStorage.deleteAll();
      return true;
    }
    return false;
  }

  Future<void> readSettings() async {
    List<String> g = s.getStringList("general") ?? [];
    log.d("read settings: $g");
    if (g.isNotEmpty) {
      for (int i = 0; i < g.length && i < general.length; i++) {
        general[i] = g[i];
      }
    }
    List<String> p = s.getStringList("pica") ?? [];
    log.d("read pica settings: $p");
    if (p.isNotEmpty) {
      for (int i = 0; i < p.length && i < pica.length; i++) {
        pica[i] = p[i];
      }
    }
    List<String> r = s.getStringList("read") ?? [];
    log.d("read read settings: $r");
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
    await s.setStringList("favoriteTags", favoriteTags.toList());
  }

  Future<void> writeData() async {
    await updateSettings("");
    writeHistory();
    await s.setStringList("blockingKeyword", blockingKeyword);
  }

  Future<bool> readData() async {
    try {
      await readSettings();
      searchHistory = s.getStringList("search") ?? [];
      favoriteTags = (s.getStringList("favoriteTags") ?? []).toSet();
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
      favoriteTags =
          Set.from((json["favoriteTags"] ?? []) + List.from(favoriteTags));
      writeData();
      return true;
    } catch (e, s) {
      log.e("Appdata.readDataFromJson", error: "error reading appdata$e\n$s");
      readData();
      return false;
    }
  }

  /***
   * following are get set funtions
   * 
   */

  /// Theme color, index of [colors] (lib/foundation/def.dart)
  int get theme => int.parse(general[1]);

  set theme(int value) {
    appdata.general[1] = value.toString();
    appdata.updateSettings("general");
  }

  /// Dark Mode, 0/1/2 (system/disabled/enable)
  int get darkMode => int.parse(appdata.general[0]);

  set darkMode(int value) {
    appdata.general[0] = value.toString();
    appdata.updateSettings("general");
  }

  /// image quality, original/low/middle/high
  String get picaImageQuality => appdata.pica[1];

  set picaImageQuality(String value) {
    appdata.pica[1] = value;
    appdata.updateSettings("pica");
  }

  DateTime? get lastPunchedTime => DateTime.tryParse(appdata.pica[3]);

  set lastPunchedTime(DateTime? value) {
    appdata.pica[3] = value?.toIso8601String() ?? "";
    appdata.updateSettings("pica");
  }

  int get picaSearchMode {
    var modes = ["dd", "da", "ld", "vd"];
    return modes.indexOf(appdata.pica[4]);
  }

  set picaSearchMode(int mode) {
    var modes = ["dd", "da", "ld", "vd"];
    appdata.pica[4] = modes[mode];
    appdata.updateSettings("pica");
  }

  List<String> get blockedCategory => appdata.pica[5].split(";");
  set blockedCategory(List<String> value) {
    appdata.pica[5] = value.join(";");
    appdata.updateSettings("pica");
  }

  bool get useDarkBackground => appdata.read[3] == "1";

  set useDarkBackground(bool value) {
    appdata.read[3] = value ? "1" : "0";
    appdata.updateSettings("read");
  }
}

var appdata = Appdata();

/// clear all data
Future<void> clearAppdata() async {
  var s = await SharedPreferences.getInstance();
  await s.clear();
  var settingsFile = File("${Base.dataPath}/settings");
  if (await settingsFile.exists()) {
    await settingsFile.delete();
  }
  //appdata.history.clearHistory();
  appdata = Appdata();
  await appdata.init();
  await appdata.readData();
}
