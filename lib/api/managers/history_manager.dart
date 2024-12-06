
import 'package:skana_pica/api/managers/objectbox.dart';

class M{
  static late ObjectBox o;
  static Future<void> init() async {
    o = await ObjectBox.create();
  }
}