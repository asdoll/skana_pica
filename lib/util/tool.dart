import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:skana_pica/config/host.dart';
import 'package:uuid/uuid.dart';

class ToolUtil {
  static String GetUrlHost(String url) {
    var host = url.replaceAll("https://", "");
    host = host.replaceAll("http://", "");
    host = host.split("/")[0];
    return host;
  }

  static Map<String, String> GetHeader(String url, String method) {
    var now = ((DateTime.now().millisecondsSinceEpoch~/1000)).toString();
    var uuid = Uuid();
    var nonce = uuid.v4().replaceAll("-", "");
    //var nonce = 'c74f6b365c8411eb97cf3c7c3f156854';
    List<String> data = [
      Config.Url,
      url.replaceAll(Config.Url, ""),
      now,
      nonce,
      method,
      Config.ApiKey,
      Config.Version,
      Config.BuildVersion
    ];
    var src = ToolUtil.ConFromNative(data);
    var key = ToolUtil.SigFromNative();
    var signature = ToolUtil.hashKey(src, key);

    Map<String, String> headers = {
            "api-key": Config.ApiKey,
            "accept": Config.Accept,
            "app-channel": Config.AppChannel,
            "time": now,
            "app-uuid": Config.Uuid,
            "nonce": nonce,
            "signature": signature,
            "app-version": Config.Version,
            "image-quality": Config.ImageQuality,
            "app-platform": Config.Platform,
            "app-build-version": Config.BuildVersion,
            "user-agent": Config.Agent,
            "version": Config.UpdateVersion,
        };
    
    if(method.toLowerCase() == "post" || method.toLowerCase() == "put") {
      headers["content-type"] = "application/json; charset=UTF-8";
    }

    return headers;
  }

  static String ConFromNative(List<String> datas) {
    //# 以下是IDA PRO反编译的混淆代码
    String key = "";

    //# v6 = datas[0]
    String v37 = datas[1];
    String v7 = datas[2];
    String v35 = datas[3];
    String v36 = datas[4];
    String v8 = datas[5];
    //# v9 = datas[6]
    //# v10 = datas[7]
    //# v33 = v9
    //# v34 = v6

    key += v37;
    key += v7;
    key += v35;
    key += v36;
    key += v8;
    return key.toLowerCase();
  }

  static String SigFromNative() =>
      r"~d}$Q7$eIni=V)9\\RK/P.RM4;9[7|@/CA}b~OW!3?EV`:<>M7pddUBL5n|0/*Cn";

  static String hashKey(String src, String key) {
    var appsecret = utf8.encode(key); // 秘钥
    var data = utf8.encode(src.toLowerCase()); // 数据
    var hmacSha256 = Hmac(sha256, appsecret);
    var digest = hmacSha256.convert(data);
    return digest.toString();
  }
}

extension ListExtension<T> on List<T>{
  /// Remove all blank value and return the list.
  List<T> getNoBlankList(){
    List<T> newList = [];
    for(var value in this){
      if(value.toString() != ""){
        newList.add(value);
      }
    }
    return newList;
  }

  T? firstWhereOrNull(bool Function(T element) test){
    for(var element in this){
      if(test(element)){
        return element;
      }
    }
    return null;
  }

  void addIfNotNull(T? value){
    if(value != null){
      add(value);
    }
  }
}

extension StringExtension on String{
  ///Remove all value that would display blank on the screen.
  String get removeAllBlank => replaceAll("\n", "").replaceAll(" ", "").replaceAll("\t", "");

  /// convert this to a one-element list.
  List<String> toList() => [this];

  String _nums(){
    String res = "";
    for(int i=0; i<length; i++){
      res += this[i].isNum?this[i]:"";
    }
    return res;
  }

  String get nums => _nums();

  String setValueAt(String value, int index){
    return replaceRange(index, index+1, value);
  }

  String? subStringOrNull(int start, [int? end]){
    if(start < 0 || (end != null && end > length)){
      return null;
    }
    return substring(start, end);
  }

  String replaceLast(String from, String to) {
    if (isEmpty || from.isEmpty) {
      return this;
    }

    final lastIndex = lastIndexOf(from);
    if (lastIndex == -1) {
      return this;
    }

    final before = substring(0, lastIndex);
    final after = substring(lastIndex + from.length);
    return '$before$to$after';
  }

  static bool hasMatch(String? value, String pattern) {
    return (value == null) ? false : RegExp(pattern).hasMatch(value);
  }

  bool _isURL(){
    final regex = RegExp(
        r'^((http|https|ftp)://)?[\w-]+(\.[\w-]+)+([\w.,@?^=%&:/~+#-|]*[\w@?^=%&/~+#-])?$',
        caseSensitive: false);
    return regex.hasMatch(this);
  }

  bool get isURL => _isURL();

  bool get isNum => double.tryParse(this) != null;
}

extension MapExtension<S, T> on Map<S, List<T>>{
  int _getTotalLength(){
    int res = 0;
    for(var l in values.toList()){
      res += l.length;
    }
    return res;
  }

  int get totalLength => _getTotalLength();
}

class ListOrNull{
  static List<T>? from<T>(Iterable<dynamic>? i){
    return i == null ? null : List.from(i);
  }
}
