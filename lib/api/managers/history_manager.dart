
import 'package:skana_pica/api/managers/objectbox.dart';
import 'package:skana_pica/api/models/objectbox_models.dart';

class M{
  static late ObjectBox o;
  static Future<void> init() async {
    o = await ObjectBox.create();
  }
  static Future<List<VisitHistory>> getHistory() async {
    return o.getVisitHistory();
  }
}