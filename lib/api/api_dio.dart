import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/services.dart';
import 'package:skana_pica/config/setting.dart';
import 'package:skana_pica/util/log.dart';
import 'package:dio_http2_adapter/dio_http2_adapter.dart';
import 'package:skana_pica/util/tool.dart';

import '../config/base.dart';

class MyLogInterceptor implements Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log.e("Network:"
        "${err.requestOptions.method} ${err.requestOptions.path}\n$err\n${err.response?.data.toString()}");
    switch (err.type) {
      case DioExceptionType.badResponse:
        var statusCode = err.response?.statusCode;
        if (statusCode != null) {
          err = err.copyWith(
              message: "Invalid Status Code: $statusCode. "
                  "${_getStatusCodeInfo(statusCode)}");
        }
      case DioExceptionType.connectionTimeout:
        err = err.copyWith(message: "Connection Timeout");
      case DioExceptionType.receiveTimeout:
        err = err.copyWith(
            message: "Receive Timeout: "
                "This indicates that the server is too busy to respond");
      case DioExceptionType.unknown:
        if (err.toString().contains("Connection terminated during handshake")) {
          err = err.copyWith(
              message: "Connection terminated during handshake: "
                  "This may be caused by the firewall blocking the connection "
                  "or your requests are too frequent.");
        } else if (err.toString().contains("Connection reset by peer")) {
          err = err.copyWith(
              message: "Connection reset by peer: "
                  "The error is unrelated to app, please check your network.");
        }
      default:
        {}
    }
    handler.next(err);
  }

  static const errorMessages = <int, String>{
    400: "The Request is invalid.",
    401: "The Request is unauthorized.",
    403: "No permission to access the resource. Check your account or network.",
    404: "Not found.",
    429: "Too many requests. Please try again later.",
  };

  String _getStatusCodeInfo(int? statusCode) {
    if (statusCode != null && statusCode >= 500) {
      return "This is server-side error, please try again later. "
          "Do not report this issue.";
    } else {
      return errorMessages[statusCode] ?? "";
    }
  }

  @override
  void onResponse(
      Response<dynamic> response, ResponseInterceptorHandler handler) {
    var headers = response.headers.map.map((key, value) => MapEntry(
        key.toLowerCase(), value.length == 1 ? value.first : value.toString()));
    headers.remove("cookie");
    String content;
    if (response.data is List<int>) {
      try {
        content = utf8.decode(response.data, allowMalformed: false);
      } catch (e) {
        content = "<Bytes>\nlength:${response.data.length}";
      }
    } else {
      content = response.data.toString();
    }
    String logs = "Network:"
        "Response ${response.realUri.toString()} ${response.statusCode}\n"
        "headers:\n$headers\n$content";
    if (response.statusCode != null && response.statusCode! < 400) {
      log.t(logs);
    } else {
      log.e(logs);
    }
    handler.next(response);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.connectTimeout = const Duration(seconds: 15);
    options.receiveTimeout = const Duration(seconds: 15);
    options.sendTimeout = const Duration(seconds: 15);
    handler.next(options);
  }
}

class AppHttpAdapter implements HttpClientAdapter {
  HttpClientAdapter? adapter;

  final bool http2;

  AppHttpAdapter(this.http2);

  static Future<HttpClientAdapter> createAdapter(bool http2) async {
    return http2
        ? Http2Adapter(
            ConnectionManager(
              idleTimeout: const Duration(seconds: 15),
              onClientCreate: (_, config) {
                if (proxyHttpOverrides?.proxyStr != null &&
                    appdata.settings[58] != "1") {
                  config.proxy =
                      Uri.parse('http://${proxyHttpOverrides?.proxyStr}');
                }
              },
            ),
          )
        : IOHttpClientAdapter();
  }

  @override
  void close({bool force = false}) {
    adapter?.close(force: force);
  }

  /// 直接使用ip访问绕过sni
  bool changeHost(RequestOptions options) {
    var config = const JsonDecoder()
        .convert(File("${Base.dataPath}/rule.json").readAsStringSync());
    if ((config["sni"] ?? []).contains(options.uri.host) &&
        (config["rule"] ?? {})[options.uri.host] != null) {
      options.path = options.path
          .replaceFirst(options.uri.host, config["rule"][options.uri.host]!);
      return true;
    }
    return false;
  }

  @override
  Future<ResponseBody> fetch(RequestOptions o, Stream<Uint8List>? requestStream,
      Future<void>? cancelFuture) async {
    adapter ??= await createAdapter(http2);
    int retry = 0;
    while (true) {
      try {
        var res = await fetchOnce(o, requestStream, cancelFuture);
        return res;
      } catch (e) {
        if (e is DioException) {
          if (e.response?.statusCode != null) {
            var code = e.response!.statusCode!;
            if (code >= 400 && code < 500) {
              rethrow;
            }
          }
        }
        log.e("Network:"
            "${o.method} ${o.path}\n$e\nRetrying...");
        retry++;
        if (retry == 2) {
          rethrow;
        }
        await Future.delayed(const Duration(seconds: 1));
      }
    }
  }

  Future<ResponseBody> fetchOnce(RequestOptions o,
      Stream<Uint8List>? requestStream, Future<void>? cancelFuture) async {
    var options = o.copyWith();
    log.t("Network:"
        "${options.method} ${options.path}\nheaders:\n${options.headers.toString()}\ndata:${options.data}");
    if (appdata.settings[58] == "0") {
      return checkCookie(
          await adapter!.fetch(options, requestStream, cancelFuture));
    }
    if (!changeHost(options)) {
      return checkCookie(
          await adapter!.fetch(options, requestStream, cancelFuture));
    }
    if (options.headers["host"] == null && options.headers["Host"] == null) {
      options.headers["host"] = options.uri.host;
    }
    options.followRedirects = false;
    var res = await adapter!.fetch(options, requestStream, cancelFuture);
    while (res.statusCode < 400 && res.statusCode > 300) {
      var location = res.headers["location"]!.first;
      if (location.contains("http") && Uri.tryParse(location) != null) {
        if (Uri.parse(location).host != o.uri.host) {
          options.path = location;
          changeHost(options);
          res = await adapter!.fetch(options, requestStream, cancelFuture);
        } else {
          location = Uri.parse(location).path;
          options.path = options.path.contains("https://")
              ? "https://${options.uri.host}$location"
              : "http://${options.uri.host}$location";
          res = await adapter!.fetch(options, requestStream, cancelFuture);
        }
      } else {
        options.path = options.path.contains("https://")
            ? "https://${options.uri.host}$location"
            : "http://${options.uri.host}$location";
        res = await adapter!.fetch(options, requestStream, cancelFuture);
      }
    }
    return checkCookie(res);
  }

  /// 检查cookie是否合法, 去除无效cookie
  ResponseBody checkCookie(ResponseBody res) {
    if (res.headers["set-cookie"] == null) {
      return res;
    }

    var cookies = <String>[];

    var invalid = <String>[];

    for (var cookie in res.headers["set-cookie"]!) {
      try {
        Cookie.fromSetCookieValue(cookie);
        cookies.add(cookie);
      } catch (e) {
        invalid.add(cookie);
      }
    }

    if (cookies.isNotEmpty) {
      res.headers["set-cookie"] = cookies;
    } else {
      res.headers.remove("set-cookie");
    }

    if (invalid.isNotEmpty) {
      res.headers["invalid-cookie"] = invalid;
    }

    return res;
  }
}

Dio ThisDio([BaseOptions? options, bool http2 = false]) {
  var dio = Dio(options)..interceptors.add(MyLogInterceptor());
  dio.httpClientAdapter = AppHttpAdapter(http2);
  return dio;
}

///获取系统设置中的代理, 仅windows,安卓有效
Future<String?> getProxy() async {
  if (appdata.settings[58] == "1") {
    final file = File("${Base.dataPath}/rule.json");
    var json = const JsonDecoder().convert(file.readAsStringSync());
    return "${InternetAddress.loopbackIPv4.address}:${json["port"]}";
  }

  //手动设置的代理
  if (appdata.settings[8].removeAllBlank == "") return null;
  if (appdata.settings[8] != "0") return appdata.settings[8];
  //对于安卓, 将获取WIFI设置中的代理

  String res;
  if (!Platform.isLinux) {
    const channel = MethodChannel("kokoiro.xyz.pica_comic/proxy");
    try {
      res = await channel.invokeMethod("getProxy");
    } catch (e) {
      return null;
    }
  } else {
    res = "No Proxy";
  }
  if (res == "No Proxy") return null;
  //windows上部分代理工具会将代理设置为http=127.0.0.1:8888;https=127.0.0.1:8888;ftp=127.0.0.1:7890的形式
  //下面的代码从中提取正确的代理地址
  if (res.contains("https")) {
    var proxies = res.split(";");
    for (String proxy in proxies) {
      proxy = proxy.removeAllBlank;
      if (proxy.startsWith('https=')) {
        return proxy.substring(6);
      }
    }
  }
  // 执行最终检查
  final RegExp regex = RegExp(
    r'^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}:\d+$',
    caseSensitive: false,
    multiLine: false,
  );
  if (!regex.hasMatch(res)) {
    return null;
  }

  return res;
}

ProxyHttpOverrides? proxyHttpOverrides;

///获取代理设置并应用
Future<void> setNetworkProxy() async {
  //Image加载使用的是Image.network()和CachedNetworkImage(), 均使用flutter内置http进行网络请求
  var proxy = await getProxy();

  if (proxy != null) {
    proxy = "PROXY $proxy;";
  }

  if (proxyHttpOverrides == null) {
    proxyHttpOverrides = ProxyHttpOverrides(proxy);
    HttpOverrides.global = proxyHttpOverrides;
    log.t("Network:" "Set Proxy $proxy");
  } else if (proxyHttpOverrides!.proxy != proxy) {
    proxyHttpOverrides!.proxy = proxy;
    log.t("Network:" "Set Proxy $proxy");
  }
}

void setProxy(String? proxy) {
  if (proxy != null) {
    proxy = "PROXY $proxy;";
  }
  var proxyHttpOverrides = ProxyHttpOverrides(proxy);
  HttpOverrides.global = proxyHttpOverrides;
}

class ProxyHttpOverrides extends HttpOverrides {
  String? proxy;
  ProxyHttpOverrides(this.proxy);

  String? get proxyStr =>
      proxy?.replaceAll("PROXY", "").replaceAll(" ", "").replaceAll(";", "");

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = super.createHttpClient(context);
    client.connectionTimeout = const Duration(seconds: 5);
    client.findProxy = (uri) => proxy ?? "DIRECT";
    client.idleTimeout = const Duration(seconds: 100);
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) {
      if (host.contains("cdn")) return true;
      final ipv4RegExp = RegExp(
          r'^((25[0-5]|2[0-4]\d|[0-1]?\d?\d)(\.(25[0-5]|2[0-4]\d|[0-1]?\d?\d)){3})$');
      if (ipv4RegExp.hasMatch(host)) {
        // 允许ip访问
        return true;
      }
      return false;
    };
    return client;
  }
}
