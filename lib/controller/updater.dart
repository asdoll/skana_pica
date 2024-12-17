import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:skana_pica/config/base.dart';
import 'package:skana_pica/config/setting.dart';
import 'package:skana_pica/util/leaders.dart';
import 'package:skana_pica/util/log.dart';

enum Result { yes, no, timeout }

late Updater updater;

class Updater extends GetxController {
  Rx<Result> result = Result.timeout.obs;
  RxString updateUrl = "https://github.com/asdoll/skana_pix/releases".obs;
  RxString updateDescription = "".obs;
  RxString updateVersion = "".obs;
  RxString updateDate = "".obs;

  void init() {
    if (appdata.autoCheckUpdate) {
      check();
    }
  }

  Future<Result> check() async {
    //if (Constants.isGooglePlay) return Result.no;
    final result = await checkUpdate("");
    this.result.value = result;
    return result;
  }

  Future<Result> checkUpdate(String arg) async {
    log.i("check for update ============");
    try {
      Response response =
          await Dio(BaseOptions(baseUrl: 'https://api.github.com'))
              .get('/repos/asdoll/skana_pix/releases/latest');
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
            updateUrl.value =
                response.data['assets'][0]['browser_download_url'];
            updateDescription.value = response.data['body'];
            return Result.yes;
          }
        }
      }
    } catch (e) {
      log.w(e);
      toast("Update check failed".tr);
      return Result.timeout;
    }
    return Result.no;
  }

  String getCurrentVersion() {
    return Base.version;
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
  }

  Future<void> getBoardList() async {
    try {
      Response response = await Dio().get(
          'https://raw.githubusercontent.com/asdoll/skana_pica/main/board.json');
      List<dynamic> list = response.data;
      boardList.value = list.map((e) => BoardInfo.fromJson(e)).toList();
    } catch (e) {
      log.w(e);
    }
  }
}