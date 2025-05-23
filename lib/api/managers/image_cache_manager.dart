import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:skana_pica/api/comic_sources/picacg/pica_api.dart';
// ignore: implementation_imports
import 'package:flutter_cache_manager/src/web/mime_converter.dart';
import 'package:skana_pica/config/setting.dart';

class DioFileService extends FileService {
  @override
  Future<FileServiceResponse> get(String url,
      {Map<String, String>? headers}) async {
    final res = await picaClient.getStream(url);
    return DioResponse(res);
  }
}

class DioResponse implements FileServiceResponse {
  final Response<ResponseBody> _response;
  DioResponse(this._response);

  @override
  Stream<List<int>> get content => _response.data!.stream;

  @override
  int? get contentLength {
    final contentLengthHeader = _response.headers.value("content-length");
    return contentLengthHeader != null ? int.parse(contentLengthHeader) : null;
  }

  @override
  String? get eTag => _response.headers.value("etag");

  @override
  int get statusCode => _response.statusCode ?? 404; //wont happen

  @override
  DateTime get validTill => DateTime.now().add(const Duration(days: 1));

  @override
  String get fileExtension {
    final contentType = _response.headers.value("content-type");
    if (contentType == null) {
      return ".jpeg";
    }
    return ContentType.parse(contentType).fileExtension;
  }
}

class ImagesCacheManager extends CacheManager with ImageCacheManager {
  static const key = 'PicaCachedImage';
  ImagesCacheManager()
      : super(Config(
          key,
          stalePeriod: Duration(days: settings.cachePeriod),
          repo: JsonCacheInfoRepository(databaseName: key),
          fileSystem: IOFileSystem(key),
          fileService: DioFileService(),
        ));
}

class DownloadCacheManage extends CacheManager with ImageCacheManager {
  static const key = 'PicaDownloadImage';
  DownloadCacheManage()
      : super(Config(
          key,
          stalePeriod: const Duration(days: 365*10),
          repo: JsonCacheInfoRepository(databaseName: key),
          fileSystem: IOFileSystem(key),
          fileService: DioFileService(),
        ));
}

DownloadCacheManage downloadCacheManager = DownloadCacheManage();

ImagesCacheManager imagesCacheManager = ImagesCacheManager();

ImageProvider imageProvider(String url) {
  if(url==defaultAvatarUrl) {
    return AssetImage("assets/images/avatar/default.png");
  }
  if(url==errorLoadingUrl) {
    return AssetImage("assets/images/error.png");
  }
  if(url.isEmpty) {
    return AssetImage("assets/images/0.png");
  }
  return CachedNetworkImageProvider(url, cacheManager: imagesCacheManager);
}

ImageProvider localProvider(String url) {
    if(url==defaultAvatarUrl) {
    return AssetImage("assets/images/avatar/default.png");
  }
  if(url==errorLoadingUrl) {
    return AssetImage("assets/images/error.png");
  }
  if(url.isEmpty) {
    return AssetImage("assets/images/0.png");
  }
  return CachedNetworkImageProvider(url, cacheManager: downloadCacheManager);
}
