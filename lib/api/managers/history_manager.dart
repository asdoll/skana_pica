import 'dart:io';

import 'package:skana_pica/api/managers/objectbox.dart';
import 'package:skana_pica/api/managers/sqlite_store.dart';
import 'package:skana_pica/api/managers/store.dart';

class M {
  static late AppStore o;

  static Future<void> init() async {
    // objectbox has no native library for HarmonyOS, so OHOS is served by the
    // sqlite3 backend. Every other platform keeps objectbox, so anything the
    // app already stored there stays readable.
    o = Platform.isOhos ? await SqliteStore.create() : await ObjectBox.create();
  }
}
