import 'dart:ui';

import 'package:path_provider/path_provider.dart';
import 'package:skana_pica/config/setting.dart';

class Base {
  /// Path to store app cache.
  ///
  /// **Warning: The end of String is not '/'**
  static late final String cachePath;

  /// Path to store app data.
  ///
  /// **Warning: The end of String is not '/'**
  static late final String dataPath;

  static const String version = "1.0.5";

  static Future<void> init() async {
    cachePath = (await getApplicationCacheDirectory()).path;
    dataPath = (await getApplicationSupportDirectory()).path;
  }

  static Locale get locale {
    Locale deviceLocale = PlatformDispatcher.instance.locale;
    if (deviceLocale.languageCode == "zh" &&
        deviceLocale.scriptCode == "Hant") {
      deviceLocale = const Locale("zh", "TW");
    }
    return switch (settings.general[2]) {
      "cn" => const Locale("zh", "CN"),
      "tw" => const Locale("zh", "TW"),
      "en" => const Locale("en", "US"),
      _ => deviceLocale,
    };
  }
}

const String webUA =
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36";

typedef ActionFunc = void Function();

enum ComicType {
  picacg,
  ehentai,
  jm,
  hitomi,
  htManga,
  htFavorite,
  nhentai,
  other;

  @override
  toString() => name;
}

enum TranslationType {
  female,
  male,
  mixed,
  language,
  other,
  group,
  artist,
  cosplayer,
  parody,
  character,
  reclass
}
