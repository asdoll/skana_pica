import 'dart:async';

import 'package:skana_pica/api/comic_sources/picacg/pica_api.dart';
import 'package:skana_pica/api/comic_sources/picacg/pica_source.dart';


class ComicSource {
  static final builtIn = [picacg]; //, ehentai, jm, hitomi, htManga, nhentai];
  static const builtInSources = [
    "picacg",
    // "ehentai",
    // "jm",
    // "hitomi",
    // "htmanga",
    // "nhentai"
  ];

  static List<Source> sources = [];

  static Future<void> init() async {
      picacg.init();
      await picaClient.init();
  }
}

abstract class BaseComic {
  String get title;

  String get subTitle;

  String get cover;

  String get id;

  List<String> get tags;

  String get description;

  bool get enableTagsTranslation => false;

  const BaseComic();
}

abstract class Source {
  final String key = "unknown";
}

class LoadImageRequest {
  String url;

  Map<String, String> headers;

  LoadImageRequest(this.url, this.headers);
}