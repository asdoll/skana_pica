// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'proxy_setting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProxySetting _$ProxySettingFromJson(Map<String, dynamic> json) => ProxySetting(
      IsHttpProxy: (json['IsHttpProxy'] as num?)?.toInt() ?? 0,
      HttpProxy: json['HttpProxy'] as String? ?? '',
      Sock5Proxy: json['Sock5Proxy'] as String? ?? '',
      ChatProxy: json['ChatProxy'] as bool? ?? false,
      IsUseHttps: json['IsUseHttps'] as bool? ?? true,
      PreIpv6: json['PreIpv6'] as bool? ?? false,
      ProxySelectIndex: (json['ProxySelectIndex'] as num?)?.toInt() ?? 1,
      ProxyImgSelectIndex: (json['ProxyImgSelectIndex'] as num?)?.toInt() ?? 1,
      PreferCDNIPImg: json['PreferCDNIPImg'] as String? ?? '104.18.227.172',
      PreferCDNIP: json['PreferCDNIP'] as String? ?? '104.18.227.172',
      ApiTimeOut: (json['ApiTimeOut'] as num?)?.toInt() ?? 5,
      ImgTimeOut: (json['ImgTimeOut'] as num?)?.toInt() ?? 5,
      LastProxyResult: (json['LastProxyResult'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          {},
      SaveNameType: (json['SaveNameType'] as num?)?.toInt() ?? 0,
      SavePath: json['SavePath'] as String? ?? '',
    );

Map<String, dynamic> _$ProxySettingToJson(ProxySetting instance) =>
    <String, dynamic>{
      'IsHttpProxy': instance.IsHttpProxy,
      'HttpProxy': instance.HttpProxy,
      'Sock5Proxy': instance.Sock5Proxy,
      'ChatProxy': instance.ChatProxy,
      'PreferCDNIP': instance.PreferCDNIP,
      'IsUseHttps': instance.IsUseHttps,
      'PreIpv6': instance.PreIpv6,
      'LastProxyResult': instance.LastProxyResult,
      'ProxySelectIndex': instance.ProxySelectIndex,
      'ProxyImgSelectIndex': instance.ProxyImgSelectIndex,
      'PreferCDNIPImg': instance.PreferCDNIPImg,
      'ApiTimeOut': instance.ApiTimeOut,
      'ImgTimeOut': instance.ImgTimeOut,
      'SavePath': instance.SavePath,
      'SaveNameType': instance.SaveNameType,
    };
