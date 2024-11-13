import 'package:hive_flutter/hive_flutter.dart';
import 'package:skana_pica/config/setting_models/proxy_setting.dart';

class Settings {
  static final dbname = 'pica_settings';
  static final _box = Hive.box(dbname);
  static ProxySetting _proxy = ProxySetting.fromJson({});
  static ProxySetting get proxy => _proxy;

  static set proxy(ProxySetting s) {
    _proxy = s;
    _box.put(dbname, s.toJson());
  }

  static Future<void> init() async {
    await Hive.initFlutter(dbname);
    await Hive.openBox(dbname);
    if (_box.isEmpty) {
      _box.putAll(ProxySetting.fromJson({}).toJson());
    }
    var t = _box.toMap().cast<String, dynamic>();
    _proxy = ProxySetting.fromJson(t);
  }
}
