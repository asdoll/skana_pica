import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:skana_pica/api/api_dio.dart';
import 'package:skana_pica/api/res.dart';
import 'package:skana_pica/config/setting.dart';
import 'package:uuid/uuid.dart';
import 'package:crypto/crypto.dart';

var apiKey = "C69BAF41DA5ABD1FFEDC6D2FEA56B";

String createNonce() {
  var uuid = const Uuid();
  String nonce = uuid.v1();
  return nonce.replaceAll("-", "");
}

String createSignature(String path, String nonce, String time, String method) {
  String key = path + time + nonce + method + apiKey;
  String data =
      '~d}\$Q7\$eIni=V)9\\RK/P.RM4;9[7|@/CA}b~OW!3?EV`:<>M7pddUBL5n|0/*Cn';
  var s = utf8.encode(key.toLowerCase());
  var f = utf8.encode(data);
  var hmacSha256 = Hmac(sha256, f);
  var digest = hmacSha256.convert(s);
  return digest.toString();
}

Options getHeaders(String method, String token, String url) {
  var nonce = createNonce();
  var time = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
  var signature = createSignature(url, nonce, time, method.toUpperCase());
  var headers = {
    "api-key": "C69BAF41DA5ABD1FFEDC6D2FEA56B",
    "accept": "application/vnd.picacomic.com.v1+json",
    "app-channel": '3',
    "authorization": token,
    "time": time,
    "nonce": nonce,
    "app-version": "2.2.1.3.3.4",
    "app-uuid": "defaultUuid",
    "image-quality": "original",
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

class PicaClient {
  late Dio dio;

  PicaClient() {
    dio = ThisDio();
  }

  final String apiUrl = "https://picaapi.picacomic.com";

  String get token => ''; //picacg.data['token'] ?? '';

  //Profile? user;

  Future<Res<Map<String, dynamic>>> get(String url) async {
    if (token == "") {
      await Future.delayed(const Duration(milliseconds: 500));
      return Res.error("未登录");
    }
    await setNetworkProxy();
    var options = getHeaders("get", token, url.replaceAll("$apiUrl/", ""));
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

  Future<Res<Map<String, dynamic>>> post(
      String url, Map<String, String>? data) async {
    var api = "https://picaapi.picacomic.com";
    if (token == "" &&
        url != '$api/auth/sign-in' &&
        url != "https://picaapi.picacomic.com/auth/register") {
      await Future.delayed(const Duration(milliseconds: 500));
      return const Res(null, errorMessage: "未登录");
    }
    var options = getHeaders("post", token, url.replaceAll("$apiUrl/", ""));
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
        return Res.error(jsonResponse["message"]);
      } else if (res.statusCode == 401) {
        var reLogin = await loginFromAppdata();
        if (reLogin.error) {
          return Res.error("登录失效且重新登录失败");
        } else {
          return post(url, data);
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

    ///登录, 返回token
  Future<Res<String>> login(String email, String password) async {
    var api = "https://picaapi.picacomic.com";
    var response = await post('$api/auth/sign-in', {
      "email": email,
      "password": password,
    });
    if (response.error) {
      return Res.error(response.errorMessage??"Failed to login");
    }
    var res = response.data;
    if (res["message"] == "success") {
      try {
        return Res(res["data"]["token"]);
      } catch (e) {
        return Res.error("Failed to get token");
      }
    } else {
      return Res.error(res["message"]);
    }
  }

  Future<Res<bool>> loginFromAppdata() async {
    var res = await login(Settings.user, Settings.passwd);
    if (res.error) {
      return const Res(true);
    } else {
      return Res.error("Failed to re-login");
    }
  }


}
