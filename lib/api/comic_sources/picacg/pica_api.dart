import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:get/get.dart' as g;
import 'package:skana_pica/api/api_dio.dart';
import 'package:skana_pica/api/comic_sources/picacg/pica_models.dart';
import 'package:skana_pica/api/comic_sources/picacg/pica_source.dart';
import 'package:skana_pica/api/models/res.dart';
import 'package:skana_pica/config/setting.dart';
import 'package:skana_pica/util/leaders.dart';
import 'package:skana_pica/util/log.dart';
import 'package:uuid/uuid.dart';
import 'package:crypto/crypto.dart';

var apiKey = "C69BAF41DA5ABD1FFEDC6D2FEA56B";

const defaultAvatarUrl = "DEFAULT AVATAR URL";
const errorLoadingUrl = "ERROR LOADING URL";

String _createNonce() {
  var uuid = const Uuid();
  String nonce = uuid.v1();
  return nonce.replaceAll("-", "");
}

String _createSignature(String path, String nonce, String time, String method) {
  String key = path + time + nonce + method + apiKey;
  String data =
      '~d}\$Q7\$eIni=V)9\\RK/P.RM4;9[7|@/CA}b~OW!3?EV`:<>M7pddUBL5n|0/*Cn';
  var s = utf8.encode(key.toLowerCase());
  var f = utf8.encode(data);
  var hmacSha256 = Hmac(sha256, f);
  var digest = hmacSha256.convert(s);
  return digest.toString();
}

Options _getHeaders(String method, String token, String url) {
  var nonce = _createNonce();
  var time = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
  var signature = _createSignature(url, nonce, time, method.toUpperCase());
  var headers = {
    "api-key": "C69BAF41DA5ABD1FFEDC6D2FEA56B",
    "accept": "application/vnd.picacomic.com.v1+json",
    "app-channel": picacg.data['appChannel'] ?? '3',
    "authorization": token,
    "time": time,
    "nonce": nonce,
    "app-version": "2.2.1.3.3.4",
    "app-uuid": "defaultUuid",
    "image-quality": picacg.data['imageQuality'] ?? "original",
    "app-platform": "android",
    "app-build-version": "45",
    "Content-Type": "application/json; charset=UTF-8",
    "user-agent": "okhttp/3.8.1",
    "version": "v1.4.1",
    "Host": "picaapi.picacomic.com",
    "signature": signature,
  };
  return Options(
    receiveDataWhenStatusError: true,
    responseType: ResponseType.plain,
    headers: headers,
  );
}

PicaClient picaClient = PicaClient();

class PicaClient {
  late Dio dio;

  PicaClient() {
    dio = ThisDio();
  }

  final String apiUrl = "https://picaapi.picacomic.com";

  String get token => picacg.data['token'] ?? '';

  PicaProfile? user;

  Future<Res<Map<String, dynamic>>> get(String url) async {
    if (token == "") {
      await Future.delayed(const Duration(milliseconds: 500));
      return Res.error("未登录");
    }
    await setNetworkProxy();
    var options = _getHeaders("get", token, url.replaceAll("$apiUrl/", ""));
    options.validateStatus = (i) => i == 200 || i == 400 || i == 401;

    try {
      var res = await dio.get(url, options: options);
      if (res.statusCode == 200) {
        var jsonResponse = jsonDecode(res.data) as Map<String, dynamic>;
        return Res(jsonResponse);
      } else if (res.statusCode == 400) {
        var jsonResponse = jsonDecode(res.data) as Map<String, dynamic>;
        return Res.error(jsonResponse["message"]);
      } else if (res.statusCode == 401) {
        var reLogin = await loginFromAppdata();
        if (reLogin.error) {
          return Res.error("登录失效且重新登录失败");
        } else {
          return get(url);
        }
      } else {
        return Res.error("Invalid Status Code ${res.statusCode}");
      }
    } on DioException catch (e) {
      String message;
      if (e.type == DioExceptionType.connectionTimeout) {
        message = "连接超时";
      } else if (e.type != DioExceptionType.unknown) {
        message = e.message!;
      } else {
        message = e.toString().split("\n")[1];
      }
      return Res.error(message);
    } catch (e) {
      return Res.error(e.toString());
    }
  }

  Future<Response<ResponseBody>> getStream(String url) async {
    if (token == "") {
      throw Exception("未登录");
    }
    await setNetworkProxy();
    var res = await dio.get<ResponseBody>(url,
        options: Options(responseType: ResponseType.stream));
    if (res.statusCode == 200) {
      return res;
    } else {
      throw Exception("Invalid Status Code ${res.statusCode}");
    }
  }

  Future<Res<Map<String, dynamic>>> post(
      String url, Map<String, String>? data) async {
    var api = "https://picaapi.picacomic.com";
    if (token == "" &&
        url != '$api/auth/sign-in' &&
        url != "https://picaapi.picacomic.com/auth/register") {
      await Future.delayed(const Duration(milliseconds: 500));
      return const Res(null, errorMessage: "未登录");
    }
    var options = _getHeaders("post", token, url.replaceAll("$apiUrl/", ""));
    try {
      await setNetworkProxy();
      var res = await dio.post<String>(url, data: data, options: options);

      if (res.data == null) {
        throw Exception("Empty data");
      }

      if (res.statusCode == 200) {
        var jsonResponse = jsonDecode(res.data!) as Map<String, dynamic>;
        return Res(jsonResponse);
      } else if (res.statusCode == 400) {
        var jsonResponse = jsonDecode(res.data!) as Map<String, dynamic>;
        return Res.error(jsonResponse["message"] ?? "Unknown Error");
      } else if (res.statusCode == 401) {
        var reLogin = await loginFromAppdata();
        if (reLogin.error) {
          return Res.error('Login expired and re-login failed');
        } else {
          return post(url, data);
        }
      } else {
        return Res.error("Invalid Status Code ${res.statusCode}");
      }
    } on DioException catch (e) {
      String message;
      if (e.type == DioExceptionType.connectionTimeout) {
        message = "Connection Timeout";
      } else if (e.type != DioExceptionType.unknown) {
        message = e.message!;
      } else {
        message = e.toString().split("\n")[1];
      }
      return Res.error(message);
    } catch (e) {
      return Res.error(e.toString());
    }
  }

  ///登录, 返回token
  Future<Res<String>> login(String email, String password) async {
    var api = "https://picaapi.picacomic.com";
    var response = await post('$api/auth/sign-in', {
      "email": email,
      "password": password,
    });
    if (response.error) {
      return Res.error(response.errorMessage ?? "Failed to login");
    }
    var res = response.data;
    if (res["message"] == "success") {
      try {
        return Res(res["data"]["token"]);
      } catch (e) {
        return Res.error("Failed to get token");
      }
    } else {
      return Res.error(res["message"] ?? "Failed to login");
    }
  }

  Future<Res<bool>> loginFromAppdata() async {
    var res = await reLogin();
    if (res) {
      return const Res(true);
    } else {
      return Res.error("Failed to re-login");
    }
  }

  Future<bool> reLogin() async {
    if (picacg.data["account"] == null || picacg.data["password"] == null) {
      return false;
    }
    final String account = picacg.data["account"];
    final String pwd = picacg.data["password"];
    var res = await login(account, pwd);
    if (res.error) {
      log.e(error: "Failed to re-login", res.errorMessage ?? "Error");
      return false;
    }
    picacg.data['token'] = res.data;
    var profile = await getProfile();
    if (profile.error) {
      picacg.data['token'] = null;
      return false;
    }
    user = profile.data;
    picacg.data['user'] = profile.data.toJson();
    return true;
  }

  ///获取用户信息
  Future<Res<PicaProfile>> getProfile([bool bLog = true]) async {
    var response = await get("$apiUrl/users/profile");
    if (response.error) {
      return Res(null, errorMessage: response.errorMessage);
    }
    var res = response.data;
    res = res["data"]["user"];
    String url = "";
    if (res["avatar"] == null) {
      url = defaultAvatarUrl;
    } else {
      url = res["avatar"]["fileServer"] + "/static/" + res["avatar"]["path"];
    }
    var p = PicaProfile(
        res["_id"],
        url,
        res["email"],
        res["exp"],
        res["level"],
        res["name"],
        res["title"],
        res["isPunched"],
        res["slogan"],
        res["character"]);
    return Res(p);
  }

  Future<Res<bool>> updateProfile() async {
    if (token == "") {
      return const Res(false);
    }
    var res = await getProfile();
    if (res.error) {
      return Res.fromErrorRes(res);
    }
    user = res.data;
    picacg.data['user'] = user!.toJson();
    appdata.saveSecures(picacg.key);
    return const Res(true);
  }

  Future<Res<List<String>>> getHotTags() async {
    var response = await get("$apiUrl/keywords");
    if (response.error) {
      return Res(null, errorMessage: response.errorMessageWithoutNull);
    }
    var res = response.data;
    var k = <String>[];
    for (int i = 0; i < (res["data"]["keywords"] ?? []).length; i++) {
      k.add(res["data"]["keywords"][i]);
    }
    return Res(k);
  }

  ///获取分类
  Future<Res<List<PicaCategoryItem>>> getCategories() async {
    var response = await get("$apiUrl/categories");
    if (response.error) {
      return Res(null, errorMessage: response.errorMessage);
    }
    var res = response.data;
    try {
      var c = <PicaCategoryItem>[];
      for (int i = 0; i < res["data"]["categories"].length; i++) {
        if (res["data"]["categories"][i]["isWeb"] == true) continue;
        String url = res["data"]["categories"][i]["thumb"]["fileServer"];
        if (url[url.length - 1] != '/') {
          url = '$url/static/';
        }
        url = url + res["data"]["categories"][i]["thumb"]["path"];
        var ca = PicaCategoryItem(res["data"]["categories"][i]["title"], url);
        c.add(ca);
      }
      return Res(c);
    } catch (e, s) {
      log.e("Network", error: "$e\n$s");
      return Res(null, errorMessage: e.toString());
    }
  }

  Future<Res<bool>> init() async {
    updateProfile().then((res) {
      if (res.data == false) {
        return Res(true); //not logged in
      }
      if (res.error) {
        return res;
      } else {
        //检查是否打卡
        DateTime? lastPunchedTime = appdata.lastPunchedTime;
        if (appdata.pica[2] == "1" &&
            (lastPunchedTime == null ||
                DateTime.now().difference(lastPunchedTime).inDays.abs() > 0)) {
          punchIn().then((b) {
            if (b) {
              appdata.lastPunchedTime = DateTime.now();
              toast("Check-in successful".tr);
              return const Res(true);
            }
            return Res(false, errorMessage: "Failed to punch in");
          });
        }
      }
    });
    return const Res(true);
  }

  ///搜索
  Future<Res<List<PicaComicItemBrief>>> search(
      String keyWord, String sort, int page,
      {bool addToHistory = false}) async {
    var response = await post('$apiUrl/comics/advanced-search?page=$page',
        {"keyword": keyWord, "sort": sort});
    if (response.error) {
      return Res(null, errorMessage: response.errorMessage);
    }
    var res = response.data;
    try {
      var pages = res["data"]["comics"]["pages"];
      var comics = <PicaComicItemBrief>[];
      for (int i = 0; i < res["data"]["comics"]["docs"].length; i++) {
        try {
          var tags = <String>[];
          tags.addAll(List<String>.from(
              res["data"]["comics"]["docs"][i]["tags"] ?? []));
          tags.addAll(List<String>.from(
              res["data"]["comics"]["docs"][i]["categories"] ?? []));
          var si = PicaComicItemBrief(
              res["data"]["comics"]["docs"][i]["title"] ?? "Unknown",
              res["data"]["comics"]["docs"][i]["author"] ?? "Unknown",
              int.parse(
                  res["data"]["comics"]["docs"][i]["likesCount"].toString()),
              res["data"]["comics"]["docs"][i]["thumb"]["fileServer"] +
                  "/static/" +
                  res["data"]["comics"]["docs"][i]["thumb"]["path"],
              res["data"]["comics"]["docs"][i]["_id"],
              tags,
              pages: res["data"]["comics"]["docs"][i]["pagesCount"],
              epsCount: res["data"]["comics"]["docs"][i]["epsCount"],
              finished: res["data"]["comics"]["docs"][i]["finished"]);
          comics.add(si);
        } catch (e) {
          continue;
        }
      }
      return Res(comics, subData: pages);
    } catch (e, s) {
      log.e("Data Analyse", error: "$s\n$s");
      return Res(null, errorMessage: e.toString());
    }
  }

Future<Res<PicaComicItemBrief>> getBriefComicInfo(String id) async {
    var response = await get("$apiUrl/comics/$id");
    if (response.error) {
      return Res(null, errorMessage: response.errorMessage);
    }
    var res = response.data;
    try {
      var tags = <String>[];
      tags.addAll(List<String>.from(res["data"]["comic"]["categories"] ?? []));
      var si = PicaComicItemBrief(
          res["data"]["comic"]["title"] ?? "Unknown",
          res["data"]["comic"]["author"] ?? "Unknown",
          res["data"]["comic"]["likesCount"] ?? 0,
          res["data"]["comic"]["thumb"]["fileServer"] +
              "/static/" +
              res["data"]["comic"]["thumb"]["path"],
          res["data"]["comic"]["_id"],
          tags,
          pages: res["data"]["comic"]["pagesCount"],
          epsCount: res["data"]["comic"]["epsCount"],
          finished: res["data"]["comic"]["finished"]);
      return Res(si);
    } catch (e, s) {
      log.e("Data Analyse", error: "$s\n$s");
      return Res(null, errorMessage: e.toString());
    }
  }

  ///获取漫画信息
  Future<Res<PicaComicItem>> getComicInfo(String id) async {
    var response = await get("$apiUrl/comics/$id");
    if (response.error) {
      return Res(null, errorMessage: response.errorMessage);
    }
    var res = response.data;
    var epsRes = await getEps(id);
    if (epsRes.error) {
      return Res(null, errorMessage: epsRes.errorMessage);
    }
    var recommendationRes = await getRecommendation(id);
    if (recommendationRes.error) {
      recommendationRes = const Res([]);
    }
    try {
      String url;
      if (res["data"]["comic"]["_creator"]["avatar"] == null) {
        url = defaultAvatarUrl;
      } else {
        url = res["data"]["comic"]["_creator"]["avatar"]["fileServer"] +
            "/static/" +
            res["data"]["comic"]["_creator"]["avatar"]["path"];
      }
      var creator = PicaProfile(
          res["data"]["comic"]["_id"],
          url,
          "",
          res["data"]["comic"]["_creator"]["exp"],
          res["data"]["comic"]["_creator"]["level"],
          res["data"]["comic"]["_creator"]["name"],
          res["data"]["comic"]["_creator"]["title"] ?? "Unknown",
          null,
          res["data"]["comic"]["_creator"]["slogan"] ?? "无",
          null);
      var categories = <String>[];
      for (int i = 0; i < res["data"]["comic"]["categories"].length; i++) {
        categories.add(res["data"]["comic"]["categories"][i]);
      }
      var tags = <String>[];
      for (int i = 0; i < res["data"]["comic"]["tags"].length; i++) {
        tags.add(res["data"]["comic"]["tags"][i]);
      }
      var ci = PicaComicItem(
          creator,
          res["data"]["comic"]["title"] ?? "Unknown",
          res["data"]["comic"]["description"] ?? "无",
          res["data"]["comic"]["thumb"]["fileServer"] +
                  "/static/" +
                  res["data"]["comic"]["thumb"]["path"] ??
              "",
          res["data"]["comic"]["author"] ?? "Unknown",
          res["data"]["comic"]["chineseTeam"] ?? "Unknown",
          categories,
          tags,
          res["data"]["comic"]["likesCount"] ?? 0,
          res["data"]["comic"]["totalViews"] ?? 0,
          res["data"]["comic"]["commentsCount"] ?? 0,
          res["data"]["comic"]["isFavourite"] ?? false,
          res["data"]["comic"]["isLiked"] ?? false,
          res["data"]["comic"]["epsCount"] ?? 0,
          id,
          res["data"]["comic"]["pagesCount"],
          res["data"]["comic"]["updated_at"],
          epsRes.data,
          recommendationRes.data,
          res["data"]["comic"]["finished"]);
      return Res(ci);
    } catch (e, s) {
      log.e("Data Analyse", error: "$s\n$s");
      return Res(null, errorMessage: e.toString());
    }
  }

  ///获取漫画的章节信息
  Future<Res<List<String>>> getEps(String id) async {
    var eps = <String>[];
    int i = 0;
    bool flag = true;
    try {
      while (flag) {
        i++;
        var res = await get("$apiUrl/comics/$id/eps?page=$i");
        if (res.error) {
          return Res(null, errorMessage: res.errorMessage);
        } else if (res.data["data"]["eps"]["pages"] == i) {
          flag = false;
        }
        for (int j = 0; j < res.data["data"]["eps"]["docs"].length; j++) {
          eps.add(res.data["data"]["eps"]["docs"][j]["title"]);
        }
      }
    } catch (e, s) {
      log.e("Data Analyse", error: "$s\n$s");
      return Res(null, errorMessage: e.toString());
    }
    return Res(eps.reversed.toList());
  }

  /// 获取漫画章节的图片链接
  Future<Res<List<String>>> getComicContent(String id, int order) async {
    var imageUrls = <String>[];
    int i = 0;
    bool flag = true;
    while (flag) {
      i++;
      var res = await get("$apiUrl/comics/$id/order/$order/pages?page=$i");
      if (res.error) {
        return Res(null, errorMessage: res.errorMessage);
      } else if (res.data["data"]["pages"]["pages"] == i) {
        flag = false;
      }
      for (int j = 0; j < res.data["data"]["pages"]["docs"].length; j++) {
        imageUrls.add(res.data["data"]["pages"]["docs"][j]["media"]
                ["fileServer"] +
            "/static/" +
            res.data["data"]["pages"]["docs"][j]["media"]["path"]);
      }
    }
    return Res(imageUrls);
  }

  Future<Res<bool>> loadMoreComments(PicaComments c,
      {String type = "comics"}) async {
    if (c.loaded != c.pages) {
      var response =
          await get("$apiUrl/$type/${c.id}/comments?page=${c.loaded + 1}");
      if (response.error) {
        return Res(null, errorMessage: response.errorMessage);
      }
      var res = response.data;
      c.pages = res["data"]["comments"]["pages"];
      c.total = res["data"]["comments"]["total"];
      for (int i = 0; i < res["data"]["comments"]["docs"].length; i++) {
        String url = "";
        try {
          url = res["data"]["comments"]["docs"][i]["_user"]["avatar"]
                  ["fileServer"] +
              "/static/" +
              res["data"]["comments"]["docs"][i]["_user"]["avatar"]["path"];
        } catch (e) {
          url = defaultAvatarUrl;
        }
        var t = PicaComment("", "", "", 1, "", 0, "", false, 0, null, null, "");
        if (res["data"]["comments"]["docs"][i]["_user"] != null) {
          t = PicaComment(
              res["data"]["comments"]["docs"][i]["_user"]["name"],
              url,
              res["data"]["comments"]["docs"][i]["_user"]["_id"],
              res["data"]["comments"]["docs"][i]["_user"]["level"],
              res["data"]["comments"]["docs"][i]["content"],
              res["data"]["comments"]["docs"][i]["commentsCount"],
              res["data"]["comments"]["docs"][i]["_id"],
              res["data"]["comments"]["docs"][i]["isLiked"],
              res["data"]["comments"]["docs"][i]["likesCount"],
              res["data"]["comments"]["docs"][i]["_user"]["character"],
              res["data"]["comments"]["docs"][i]["_user"]["slogan"],
              res["data"]["comments"]["docs"][i]["created_at"]);
        } else {
          t = PicaComment(
              "Unknown",
              url,
              "",
              1,
              res["data"]["comments"]["docs"][i]["content"],
              res["data"]["comments"]["docs"][i]["commentsCount"],
              res["data"]["comments"]["docs"][i]["_id"],
              res["data"]["comments"]["docs"][i]["isLiked"],
              res["data"]["comments"]["docs"][i]["likesCount"],
              null,
              null,
              res["data"]["comments"]["docs"][i]["created_at"]);
        }
        c.comments.add(t);
      }
      c.loaded++;
    }
    return const Res(true);
  }

  Future<PicaComments> getComments(String id, {String type = "comics"}) async {
    var t = PicaComments([], id, 1, 0, 0);
    await loadMoreComments(t, type: type);
    return t;
  }

  /// 获取收藏夹
  Future<Res<List<PicaComicItemBrief>>> getFavorites(
      int page, bool newToOld) async {
    var response = await get(
        "$apiUrl/users/favourite?s=${newToOld ? "dd" : "da"}&page=$page");
    if (response.error) {
      return Res(null, errorMessage: response.errorMessage);
    }
    var res = response.data;
    try {
      var pages = res["data"]["comics"]["pages"];
      var comics = <PicaComicItemBrief>[];
      for (int i = 0; i < res["data"]["comics"]["docs"].length; i++) {
        var tags = <String>[];
        tags.addAll(
            List<String>.from(res["data"]["comics"]["docs"][i]["tags"] ?? []));
        tags.addAll(List<String>.from(
            res["data"]["comics"]["docs"][i]["categories"] ?? []));
        var si = PicaComicItemBrief(
            res["data"]["comics"]["docs"][i]["title"] ?? "Unknown",
            res["data"]["comics"]["docs"][i]["author"] ?? "Unknown",
            int.parse(
                res["data"]["comics"]["docs"][i]["likesCount"].toString()),
            res["data"]["comics"]["docs"][i]["thumb"]["fileServer"] +
                "/static/" +
                res["data"]["comics"]["docs"][i]["thumb"]["path"],
            res["data"]["comics"]["docs"][i]["_id"],
            tags,
            epsCount: res["data"]["comics"]["docs"][i]["epsCount"],
            pages: res["data"]["comics"]["docs"][i]["pagesCount"],
            finished: res["data"]["comics"]["docs"][i]["finished"]);
        comics.add(si);
      }
      return Res(comics, subData: pages);
    } catch (e, s) {
      log.e("Data Analysis", error: "$e\n$s");
      return Res(null, errorMessage: e.toString());
    }
  }

  Future<Res<List<PicaComicItemBrief>>> getRandomComics() async {
    var comics = <PicaComicItemBrief>[];
    var response = await get("$apiUrl/comics/random");
    if (response.success) {
      var res = response.data;
      for (int i = 0; i < res["data"]["comics"].length; i++) {
        try {
          var tags = <String>[];
          tags.addAll(
              List<String>.from(res["data"]["comics"][i]["tags"] ?? []));
          tags.addAll(
              List<String>.from(res["data"]["comics"][i]["categories"] ?? []));
          var si = PicaComicItemBrief(
            res["data"]["comics"][i]["title"] ?? "Unknown",
            res["data"]["comics"][i]["author"] ?? "Unknown",
            res["data"]["comics"][i]["totalLikes"] ?? 0,
            res["data"]["comics"][i]["thumb"]["fileServer"] +
                "/static/" +
                res["data"]["comics"][i]["thumb"]["path"],
            res["data"]["comics"][i]["_id"],
            tags,
            pages: res["data"]["comics"][i]["pagesCount"],
          );
          comics.add(si);
        } finally {}
      }
    } else {
      return Res.fromErrorRes(response);
    }
    return Res(comics, subData: 1);
  }

  Future<bool> likeOrUnlikeComic(String id) async {
    var res = await post('$apiUrl/comics/$id/like', {});
    if (res.success) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> favouriteOrUnfavouriteComic(String id) async {
    var res = await post('$apiUrl/comics/$id/favourite', {});
    if (res.error) {
      return false;
    }
    return true;
  }

  /// 获取排行榜, 传入参数为时间
  /// - H24: 过去24小时
  /// - D7: 过去7天
  /// - D30: 过去30天
  Future<Res<List<PicaComicItemBrief>>> getLeaderboard(String time) async {
    var response = await get("$apiUrl/comics/leaderboard?tt=$time&ct=VC");
    if (response.error) {
      return Res(null, errorMessage: response.errorMessage);
    }
    var res = response.data;
    var comics = <PicaComicItemBrief>[];
    for (int i = 0; i < res["data"]["comics"].length; i++) {
      try {
        var tags = <String>[];
        tags.addAll(List<String>.from(res["data"]["comics"][i]["tags"] ?? []));
        tags.addAll(
            List<String>.from(res["data"]["comics"][i]["categories"] ?? []));
        var si = PicaComicItemBrief(
            res["data"]["comics"][i]["title"] ?? "Unknown",
            res["data"]["comics"][i]["author"] ?? "Unknown",
            res["data"]["comics"][i]["totalLikes"] ?? 0,
            res["data"]["comics"][i]["thumb"]["fileServer"] +
                "/static/" +
                res["data"]["comics"][i]["thumb"]["path"],
            res["data"]["comics"][i]["_id"],
            tags,
            pages: res["data"]["comics"][i]["pagesCount"]);
        comics.add(si);
      } finally {}
    }
    return Res(comics, subData: 1);
  }

  Future<Res<String>> register(
      String ans1,
      String ans2,
      String ans3,
      String birthday,
      String account,
      String gender,
      String name,
      String password,
      String que1,
      String que2,
      String que3) async {
    //gender:m,f,bot
    var res = await post("https://picaapi.picacomic.com/auth/register", {
      "answer1": ans1,
      "answer2": ans2,
      "answer3": ans3,
      "birthday": birthday,
      "email": account,
      "gender": gender,
      "name": name,
      "password": password,
      "question1": que1,
      "question2": que2,
      "question3": que3
    });
    if (res.error) {
      return Res(null, errorMessage: res.errorMessageWithoutNull);
    } else if (res.data["message"] == "failure") {
      return const Res(null, errorMessage: "注册失败, 用户名或账号可能已存在");
    } else {
      return const Res("注册成功");
    }
  }

  ///打卡
  Future<bool> punchIn() async {
    var res = await post("$apiUrl/users/punch-in", null);
    if (res.success) {
      return true;
    } else {
      return false;
    }
  }

  /// 上传头像
  Future<bool> uploadAvatar(String imageData) async {
    //数据仍然是json, 只有一条"avatar"数据, 数据内容为base64编码的图像, 例如{"avatar":"[在这里放图像数据]"}
    var url = "$apiUrl/users/avatar";
    var dio = ThisDio();
    var options = _getHeaders("put", token, url.replaceAll("$apiUrl/", ""));
    try {
      var res =
          await dio.put(url, data: {"avatar": imageData}, options: options);
      return res.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> changeSlogan(String slogan) async {
    var url = "$apiUrl/users/profile";
    var dio = ThisDio();
    var options = _getHeaders("put", token, url.replaceAll("$apiUrl/", ""));
    try {
      var res = await dio.put(url, data: {"slogan": slogan}, options: options);
      if (res.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<void> getMoreReply(PicaReply reply) async {
    if (reply.loaded == reply.total) return;
    var response = await get(
        "$apiUrl/comments/${reply.id}/childrens?page=${reply.loaded + 1}"); //哔咔的英语水平有点烂
    if (response.success) {
      var res = response.data;
      reply.total = res["data"]["comments"]["pages"];
      for (int i = 0; i < res["data"]["comments"]["docs"].length; i++) {
        String url = "";
        try {
          url = res["data"]["comments"]["docs"][i]["_user"]["avatar"]
                  ["fileServer"] +
              "/static/" +
              res["data"]["comments"]["docs"][i]["_user"]["avatar"]["path"];
        } catch (e) {
          url = defaultAvatarUrl;
        }
        var t = PicaComment("", "", "", 1, "", 0, "", false, 0, null, null, "");
        if (res["data"]["comments"]["docs"][i]["_user"] != null) {
          t = PicaComment(
              res["data"]["comments"]["docs"][i]["_user"]["name"] ?? "Unknown",
              url,
              res["data"]["comments"]["docs"][i]["_user"]["_id"] ?? "",
              res["data"]["comments"]["docs"][i]["_user"]["level"] ?? 0,
              res["data"]["comments"]["docs"][i]["content"] ?? "",
              0,
              res["data"]["comments"]["docs"][i]["_id"],
              res["data"]["comments"]["docs"][i]["isLiked"],
              res["data"]["comments"]["docs"][i]["likesCount"] ?? 0,
              res["data"]["comments"]["docs"][i]["_user"]["character"],
              res["data"]["comments"]["docs"][i]["_user"]["slogan"] ?? "",
              res["data"]["comments"]["docs"][i]["created_at"]);
        } else {
          t = PicaComment(
              "Unknown",
              url,
              "",
              1,
              res["data"]["comments"]["docs"][i]["content"],
              0,
              "",
              res["data"]["comments"]["docs"][i]["isLiked"],
              res["data"]["comments"]["docs"][i]["likesCount"],
              null,
              null,
              res["data"]["comments"]["docs"][i]["created_at"]);
        }
        reply.comments.add(t);
      }
      reply.loaded++;
    }
  }

  Future<PicaReply> getReply(String id) async {
    var reply = PicaReply(id, 0, 1, []);
    await getMoreReply(reply);
    return reply;
  }

  Future<bool> likeOrUnlikeComment(String id) async {
    var res = await post("$apiUrl/comments/$id/like", {});
    return res.success;
  }

  Future<bool> comment(String id, String text, bool isReply,
      {String type = "comics"}) async {
    Res<Map<String, dynamic>?> res;
    if (!isReply) {
      res = await post("$apiUrl/$type/$id/comments", {"content": text});
    } else {
      res = await post("$apiUrl/comments/$id", {"content": text});
    }
    return res.success;
  }

  /// 获取相关推荐
  Future<Res<List<PicaComicItemBrief>>> getRecommendation(String id) async {
    var comics = <PicaComicItemBrief>[];
    var response = await get("$apiUrl/comics/$id/recommendation");
    if (response.success) {
      var res = response.data;
      for (int i = 0; i < res["data"]["comics"].length; i++) {
        try {
          var tags = <String>[];
          tags.addAll(
              List<String>.from(res["data"]["comics"][i]["tags"] ?? []));
          tags.addAll(
              List<String>.from(res["data"]["comics"][i]["categories"] ?? []));
          var si = PicaComicItemBrief(
            res["data"]["comics"][i]["title"] ?? "Unknown",
            res["data"]["comics"][i]["author"] ?? "Unknown",
            int.parse(res["data"]["comics"][i]["likesCount"].toString()),
            res["data"]["comics"][i]["thumb"]["fileServer"] +
                "/static/" +
                res["data"]["comics"][i]["thumb"]["path"],
            res["data"]["comics"][i]["_id"],
            tags,
            pages: res["data"]["comics"][i]["pagesCount"],
          );
          comics.add(si);
        } finally {}
      }
    } else {
      return Res.fromErrorRes(response);
    }
    return Res(comics);
  }

  /// 获取本子母/本子妹推荐
  Future<Res<List<List<PicaComicItemBrief>>>> getCollection() async {
    var comics = <List<PicaComicItemBrief>>[[], []];
    var response = await get("$apiUrl/collections");
    if (response.error) {
      return Res(null, errorMessage: response.errorMessage);
    }
    var res = response.data;
    try {
      for (int i = 0; i < res["data"]["collections"][0]["comics"].length; i++) {
        try {
          var si = PicaComicItemBrief(
              res["data"]["collections"][0]["comics"][i]["title"] ?? "Unknown",
              res["data"]["collections"][0]["comics"][i]["author"] ?? "Unknown",
              res["data"]["collections"][0]["comics"][i]["totalLikes"] ?? 0,
              res["data"]["collections"][0]["comics"][i]["thumb"]
                      ["fileServer"] +
                  "/static/" +
                  res["data"]["collections"][0]["comics"][i]["thumb"]["path"],
              res["data"]["collections"][0]["comics"][i]["_id"],
              [],
              epsCount: res["data"]["collections"]["docs"][i]["epsCount"],
              pages: res["data"]["collections"][0]["comics"][i]["pagesCount"],
              finished: res["data"]["collections"]["docs"][i]["finished"]);
          comics[0].add(si);
        } catch (e) {
          //出现错误跳过
        }
      }
    } finally {}
    try {
      for (int i = 0; i < res["data"]["collections"][1]["comics"].length; i++) {
        try {
          var si = PicaComicItemBrief(
              res["data"]["collections"][1]["comics"][i]["title"] ?? "Unknown",
              res["data"]["collections"][1]["comics"][i]["author"] ?? "Unknown",
              res["data"]["collections"][1]["comics"][i]["totalLikes"] ?? 0,
              res["data"]["collections"][1]["comics"][i]["thumb"]
                      ["fileServer"] +
                  "/static/" +
                  res["data"]["collections"][1]["comics"][i]["thumb"]["path"],
              res["data"]["collections"][1]["comics"][i]["_id"],
              [],
              epsCount: res["data"]["collections"]["docs"][i]["epsCount"],
              pages: res["data"]["collections"][1]["comics"][i]["pagesCount"],
              finished: res["data"]["collections"]["docs"][i]["finished"]);
          comics[1].add(si);
        } finally {}
      }
    } finally {}
    return Res(comics);
  }

  Future<void> getMoreGames(PicaGames games) async {
    if (games.total == games.loaded) return;
    var response = await get("$apiUrl/games?page=${games.loaded + 1}");
    if (response.success) {
      var res = response.data;
      games.total = res["data"]["games"]["pages"];
      for (int i = 0; i < res["data"]["games"]["docs"].length; i++) {
        var game = PicaGameItemBrief(
            res["data"]["games"]["docs"][i]["_id"] ?? "",
            res["data"]["games"]["docs"][i]["title"] ?? "Unknown",
            res["data"]["games"]["docs"][i]["adult"],
            res["data"]["games"]["docs"][i]["icon"]["fileServer"] +
                "/static/" +
                res["data"]["games"]["docs"][i]["icon"]["path"],
            res["data"]["games"]["docs"][i]["publisher"] ?? "Unknown");
        games.games.add(game);
      }
    }
    games.loaded++;
  }

  Future<PicaGames> getGames() async {
    var games = PicaGames([], 0, 1);
    await getMoreGames(games);
    return games;
  }

  Future<Res<PicaGameInfo>> getGameInfo(String id) async {
    var response = await get("$apiUrl/games/$id");
    if (response.error) {
      return Res(null, errorMessage: response.errorMessage);
    }
    var res = response.data;
    var gameInfo = PicaGameInfo(
        id,
        res["data"]["game"]["title"] ?? "Unknown",
        res["data"]["game"]["description"],
        res["data"]["game"]["icon"]["fileServer"] +
            "/static/" +
            res["data"]["game"]["icon"]["path"],
        res["data"]["game"]["publisher"],
        [],
        res["data"]["game"]["androidLinks"][0],
        res["data"]["game"]["isLiked"],
        res["data"]["game"]["likesCount"],
        res["data"]["game"]["commentsCount"]);
    for (int i = 0; i < res["data"]["game"]["screenshots"].length; i++) {
      gameInfo.screenshots.add(res["data"]["game"]["screenshots"][i]
              ["fileServer"] +
          "/static/" +
          res["data"]["game"]["screenshots"][i]["path"]);
    }
    return Res(gameInfo);
  }

  Future<bool> likeGame(String id) async {
    var res = await post("$apiUrl/games/$id/like", {});
    return res.success;
  }

  Future<Res<bool>> changePassword(
      String oldPassword, String newPassword) async {
    var url = "$apiUrl/users/password";
    var dio = ThisDio();
    var options = _getHeaders("put", token, url.replaceAll("$apiUrl/", ""))
        .copyWith(validateStatus: (i) => i == 200 || i == 400);
    try {
      var res = await dio.put(url,
          data: {"new_password": newPassword, "old_password": oldPassword},
          options: options);
      if (res.statusCode == 200) {
        return const Res(true);
      } else {
        return const Res(false);
      }
    } on DioException catch (e) {
      return Res(null, errorMessage: e.toString());
    } catch (e, s) {
      log.e("Network", error: "$e\n$s");
      return Res(null, errorMessage: e.toString());
    }
  }

  /// 获取分类中的漫画
  Future<Res<List<PicaComicItemBrief>>> getCategoryComics(
      String keyWord, int page, String sort,
      [String type = "c"]) async {
    if (keyWord == "latest") {
      return getLatest(page);
    }

    if (keyWord == "random") {
      return getRandomComics();
    }

    if (keyWord == "leaderboard") {
      return getLeaderboard(type);
    }

    if (keyWord == "bookmarks") {
      return getFavorites(page, sort == "da");
    }

    var response = await get(
        '$apiUrl/comics?page=$page&$type=${Uri.encodeComponent(keyWord)}&s=$sort');
    if (response.error) {
      return Res(null, errorMessage: response.errorMessage);
    }
    var res = response.data;
    var pages = res["data"]["comics"]["pages"];
    var comics = <PicaComicItemBrief>[];
    for (int i = 0; i < res["data"]["comics"]["docs"].length; i++) {
      try {
        var tags = <String>[];
        tags.addAll(
            List<String>.from(res["data"]["comics"]["docs"][i]["tags"] ?? []));
        tags.addAll(List<String>.from(
            res["data"]["comics"]["docs"][i]["categories"] ?? []));
        var si = PicaComicItemBrief(
          res["data"]["comics"]["docs"][i]["title"] ?? "Unknown",
          res["data"]["comics"]["docs"][i]["author"] ?? "Unknown",
          int.parse(res["data"]["comics"]["docs"][i]["likesCount"].toString()),
          res["data"]["comics"]["docs"][i]["thumb"]["fileServer"] +
              "/static/" +
              res["data"]["comics"]["docs"][i]["thumb"]["path"],
          res["data"]["comics"]["docs"][i]["_id"],
          tags,
          epsCount: res["data"]["comics"]["docs"][i]["epsCount"],
          pages: res["data"]["comics"]["docs"][i]["pagesCount"],
          finished: res["data"]["comics"]["docs"][i]["finished"],
        );
        comics.add(si);
      } catch (e) {
        continue;
      }
    }
    return Res(comics, subData: pages);
  }

  ///获取最新漫画
  Future<Res<List<PicaComicItemBrief>>> getLatest(int page) async {
    var response = await get("$apiUrl/comics?page=$page&s=dd");
    if (response.error) {
      return Res(null, errorMessage: response.errorMessage);
    }
    var res = response.data;
    var comics = <PicaComicItemBrief>[];
    for (int i = 0; i < res["data"]["comics"]["docs"].length; i++) {
      try {
        var tags = <String>[];
        tags.addAll(
            List<String>.from(res["data"]["comics"]["docs"][i]["tags"] ?? []));
        tags.addAll(List<String>.from(
            res["data"]["comics"]["docs"][i]["categories"] ?? []));

        var si = PicaComicItemBrief(
            res["data"]["comics"]["docs"][i]["title"] ?? "Unknown",
            res["data"]["comics"]["docs"][i]["author"] ?? "Unknown",
            int.parse(
                res["data"]["comics"]["docs"][i]["likesCount"].toString()),
            res["data"]["comics"]["docs"][i]["thumb"]["fileServer"] +
                "/static/" +
                res["data"]["comics"]["docs"][i]["thumb"]["path"],
            res["data"]["comics"]["docs"][i]["_id"],
            tags,
            epsCount: res["data"]["comics"]["docs"][i]["epsCount"],
            pages: res["data"]["comics"]["docs"][i]["pagesCount"],
            finished: res["data"]["comics"]["docs"][i]["finished"]);
        comics.add(si);
      } catch (e) {
        continue;
      }
    }
    return Res(comics, subData: res["data"]["comics"]["pages"]);
  }
}
