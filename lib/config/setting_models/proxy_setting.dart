import 'package:json_annotation/json_annotation.dart';

part 'proxy_setting.g.dart';

@JsonSerializable()
class ProxySetting {
  @JsonKey(defaultValue: 0)
  int IsHttpProxy;
  @JsonKey(defaultValue: "")
  String HttpProxy;
  @JsonKey(defaultValue: "")
  String Sock5Proxy;
  @JsonKey(defaultValue: false)
  bool ChatProxy;
  @JsonKey(defaultValue: "104.18.227.172")
  String PreferCDNIP;
  @JsonKey(defaultValue: true)
  bool IsUseHttps;
  @JsonKey(defaultValue: false)
  bool PreIpv6;
  @JsonKey(defaultValue: {})
  Map<String, String> LastProxyResult;
  @JsonKey(defaultValue: 1)
  int ProxySelectIndex;
  @JsonKey(defaultValue: 1)
  int ProxyImgSelectIndex;
  @JsonKey(defaultValue: "104.18.227.172")
  String PreferCDNIPImg;
  @JsonKey(defaultValue: 5)
  int ApiTimeOut;
  @JsonKey(defaultValue: 5)
  int ImgTimeOut;
  @JsonKey(defaultValue: "")
  String SavePath;
  @JsonKey(defaultValue: 0)
  int SaveNameType;

  String get isHttpProxy => ["", "Http", "Sock5", "system"][IsHttpProxy];
  int get apiTimeOut => [2, 5, 7, 10][ApiTimeOut];
  int get imgTimeOut => [2, 5, 7, 10, 15][ImgTimeOut];

  ProxySetting(
      {required this.IsHttpProxy,
      required this.HttpProxy,
      required this.Sock5Proxy,
      required this.ChatProxy,
      required this.IsUseHttps,
      required this.PreIpv6,
      required this.ProxySelectIndex,
      required this.ProxyImgSelectIndex,
      required this.PreferCDNIPImg,
      required this.PreferCDNIP,
      required this.ApiTimeOut,
      required this.ImgTimeOut,
      required this.LastProxyResult,
      required this.SaveNameType,
      required this.SavePath});

  factory ProxySetting.fromJson(Map<String, dynamic> json) =>
      _$ProxySettingFromJson(json);

  Map<String, dynamic> toJson() => _$ProxySettingToJson(this);
}