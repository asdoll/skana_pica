import 'package:skana_pica/api/models/base_comic.dart';
import 'package:skana_pica/config/setting.dart';

final picacg = PicaSource();

class PicaSource extends Source{
  @override
  final String key = "picacg";
  Map<String, dynamic> data = {};

  void init() {
    if (appdata.cookies["picacg_account"] != null) {
      data['account'] = appdata.cookies["picacg_account"];
      data['password'] = appdata.cookies["picacg_password"];
      data['token'] = appdata.cookies["picacg_token"];
    }
    if (data['appChannel'] == null) {
      data['appChannel'] = (int.parse(appdata.pica[0]) + 1).toString();
    }
    if (data['imageQuality'] == null) {
      data['imageQuality'] = appdata.picaImageQuality;
    }
  }

  final List<String> categories = [
    "大家都在看",
    "大濕推薦",
    "那年今天",
    "官方都在看",
    "嗶咔漢化",
    "全彩",
    "長篇",
    "同人",
    "短篇",
    "圓神領域",
    "碧藍幻想",
    "CG雜圖",
    "英語 ENG",
    "生肉",
    "純愛",
    "百合花園",
    "耽美花園",
    "偽娘哲學",
    "後宮閃光",
    "扶他樂園",
    "單行本",
    "姐姐系",
    "妹妹系",
    "SM",
    "性轉換",
    "足の恋",
    "人妻",
    "NTR",
    "強暴",
    "非人類",
    "艦隊收藏",
    "Love Live",
    "SAO 刀劍神域",
    "Fate",
    "東方",
    "WEBTOON",
    "禁書目錄",
    "歐美",
    "Cosplay",
    "重口地帶"
  ];
}
