import 'package:skana_pica/api/models/base_comic.dart';
import 'package:skana_pica/config/setting.dart';

final picacg = PicaSource();

class PicaSource extends Source {
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

  final cateMap = {
    "大家都在看": "0.jpg",
    "大濕推薦": "1.jpg",
    "那年今天": "2.jpg",
    "官方都在看": "3.jpg",
    "嗶咔漢化": "4.jpg",
    "全彩": "5.jpg",
    "長篇": "6.jpg",
    "同人": "7.jpg",
    "短篇": "8.jpg",
    "圓神領域": "9.jpg",
    "碧藍幻想": "10.jpg",
    "CG雜圖": "11.jpg",
    "英語 ENG": "12.jpg",
    "生肉": "13.jpg",
    "純愛": "14.jpg",
    "百合花園": "15.jpg",
    "耽美花園": "16.jpg",
    "偽娘哲學": "17.jpg",
    "後宮閃光": "18.jpg",
    "扶他樂園": "19.jpg",
    "單行本": "20.jpg",
    "姐姐系": "21.jpg",
    "妹妹系": "22.jpg",
    "SM": "23.jpg",
    "性轉換": "24.jpg",
    "足の恋": "25.jpg",
    "人妻": "26.jpg",
    "NTR": "27.jpg",
    "強暴": "28.jpg",
    "非人類": "29.jpg",
    "艦隊收藏": "30.jpg",
    "Love Live": "31.jpg",
    "SAO 刀劍神域": "32.jpg",
    "Fate": "33.jpg",
    "東方": "34.jpg",
    "WEBTOON": "35.jpg",
    "禁書目錄": "36.jpg",
    "歐美": "37.jpg",
    "Cosplay": "38.jpg",
    "重口地帶": "39.jpg"
  };
}
