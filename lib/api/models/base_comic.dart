import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:skana_pica/api/comic_sources/picacg/pica_api.dart';
import 'package:skana_pica/api/comic_sources/picacg/pica_source.dart';
import 'package:skana_pica/api/models/account_config.dart';
import 'package:skana_pica/api/models/res.dart';
import 'package:skana_pica/config/setting.dart';
import 'package:skana_pica/util/log.dart';
import 'package:skana_pica/util/tool.dart';
import 'dart:math' as math;

import 'package:skana_pica/widgets/comic_tile.dart';

part 'base_comic.g.dart';

typedef TapFunc = void Function(BuildContext context);

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

@JsonSerializable()
class CustomComic extends BaseComic {
  @override
  final String title;

  @override
  @JsonKey(defaultValue: "")
  final String subTitle;

  @override
  final String cover;

  @override
  final String id;

  @override
  @JsonKey(defaultValue: [])
  final List<String> tags;

  @override
  @JsonKey(defaultValue: "")
  final String description;

  final String sourceKey;

  const CustomComic(
    this.title,
    this.subTitle,
    this.cover,
    this.id,
    this.tags,
    this.description,
    this.sourceKey,
  );

  factory CustomComic.fromJson(Map<String, dynamic> json) =>
      _$CustomComicFromJson(json);

  Map<String, dynamic> toJson() => _$CustomComicToJson(this);
}

abstract mixin class HistoryMixin {
  String get title;

  String? get subTitle;

  String get cover;

  String get target;

  Object? get maxPage => null;

  HistoryType get historyType;
}

final class HistoryType {
  static HistoryType get picacg => const HistoryType(0);

  static HistoryType get ehentai => const HistoryType(1);

  static HistoryType get jmComic => const HistoryType(2);

  static HistoryType get hitomi => const HistoryType(3);

  static HistoryType get htmanga => const HistoryType(4);

  static HistoryType get nhentai => const HistoryType(5);

  final int value;

  String get name {
    if (value >= 0 && value <= 5) {
      return ["picacg", "ehentai", "jm", "hitomi", "htmanga", "nhentai"][value];
    } else {
      return ComicSource.fromIntKey(value)?.name ?? "Unknown";
    }
  }

  const HistoryType(this.value);

  @override
  bool operator ==(Object other) =>
      other is HistoryType && other.value == value;

  @override
  int get hashCode => value.hashCode;

  ComicSource? get comicSource {
    if (value >= 0 && value <= 5) {
      return ComicSource.find(name);
    } else {
      return ComicSource.fromIntKey(value);
    }
  }
}

typedef AddOrDelFavFunc = Future<Res<bool>> Function(
    String comicId, String folderId, bool isAdding);

class FavoriteData {
  final String key;

  final String title;

  final bool multiFolder;

  final Future<Res<List<BaseComic>>> Function(int page, [String? folder])
      loadComic;

  /// key-id, value-name
  ///
  /// if comicId is not null, Res.subData is the folders that the comic is in
  final Future<Res<Map<String, String>>> Function([String? comicId])?
      loadFolders;

  /// A value of null disables this feature
  final Future<Res<bool>> Function(String key)? deleteFolder;

  /// A value of null disables this feature
  final Future<Res<bool>> Function(String name)? addFolder;

  /// A value of null disables this feature
  final String? allFavoritesId;

  final AddOrDelFavFunc? addOrDelFavorite;

  const FavoriteData(
      {required this.key,
      required this.title,
      required this.multiFolder,
      required this.loadComic,
      this.loadFolders,
      this.deleteFolder,
      this.addFolder,
      this.allFavoritesId,
      this.addOrDelFavorite});
}

class CategoryData {
  /// The title is displayed in the tab bar.
  final String title;

  /// 当使用中文语言时, 英文的分类标签将在构建页面时被翻译为中文
  final List<BaseCategoryPart> categories;

  final bool enableRankingPage;

  final String key;

  final List<CategoryButtonData> buttons;

  /// Data class for building category page.
  const CategoryData({
    required this.title,
    required this.categories,
    required this.enableRankingPage,
    required this.key,
    this.buttons = const [],
  });
}

class CategoryButtonData {
  final String label;

  final TapFunc onTap;

  const CategoryButtonData({
    required this.label,
    required this.onTap,
  });
}

abstract class BaseCategoryPart {
  String get title;

  List<String> get categories;

  List<String>? get categoryParams => null;

  bool get enableRandom;

  String get categoryType;

  /// Data class for building a part of category page.
  const BaseCategoryPart();
}

class FixedCategoryPart extends BaseCategoryPart {
  @override
  final List<String> categories;

  @override
  bool get enableRandom => false;

  @override
  final String title;

  @override
  final String categoryType;

  @override
  final List<String>? categoryParams;

  /// A [BaseCategoryPart] that show fixed tags on category page.
  const FixedCategoryPart(this.title, this.categories, this.categoryType,
      [this.categoryParams]);
}

class RandomCategoryPart extends BaseCategoryPart {
  final List<String> tags;

  final int randomNumber;

  @override
  final String title;

  @override
  bool get enableRandom => true;

  @override
  final String categoryType;

  List<String> _categories() {
    if (randomNumber >= tags.length) {
      return tags;
    }
    return tags.sublist(math.Random().nextInt(tags.length - randomNumber));
  }

  @override
  List<String> get categories => _categories();

  /// A [BaseCategoryPart] that show random tags on category page.
  const RandomCategoryPart(
      this.title, this.tags, this.randomNumber, this.categoryType);
}

class RandomCategoryPartWithRuntimeData extends BaseCategoryPart {
  final Iterable<String> Function() loadTags;

  final int randomNumber;

  @override
  final String title;

  @override
  bool get enableRandom => true;

  @override
  final String categoryType;

  static final random = math.Random();

  List<String> _categories() {
    var tags = loadTags();
    if (randomNumber >= tags.length) {
      return tags.toList();
    }
    final start = random.nextInt(tags.length - randomNumber);
    var res = List.filled(randomNumber, '');
    int index = -1;
    for (var s in tags) {
      index++;
      if (start > index) {
        continue;
      } else if (index == start + randomNumber) {
        break;
      }
      res[index - start] = s;
    }
    return res;
  }

  @override
  List<String> get categories => _categories();

  /// A [BaseCategoryPart] that show random tags on category page.
  RandomCategoryPartWithRuntimeData(
      this.title, this.loadTags, this.randomNumber, this.categoryType);
}

CategoryData getCategoryDataWithKey(String key) {
  for (var source in ComicSource.sources) {
    if (source.categoryData?.key == key) {
      return source.categoryData!;
    }
  }
  throw "Unknown category key $key";
}

/// build comic list, [Res.subData] should be maxPage or null if there is no limit.
typedef ComicListBuilder = Future<Res<List<BaseComic>>> Function(int page);

typedef LoadComicFunc = Future<Res<ComicInfoData>> Function(String id);

typedef LoadComicPagesFunc = Future<Res<List<String>>> Function(
    String id, String? ep);

typedef CommentsLoader = Future<Res<List<Comment>>> Function(
    String id, String? subId, int page, String? replyTo);

typedef SendCommentFunc = Future<Res<bool>> Function(
    String id, String? subId, String content, String? replyTo);

typedef GetImageLoadingConfigFunc = Map<String, dynamic> Function(
    String imageKey, String comicId, String epId)?;
typedef GetThumbnailLoadingConfigFunc = Map<String, dynamic> Function(
    String imageKey)?;

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

  static List<ComicSource> sources = [];

  static ComicSource? find(String key) =>
      sources.firstWhereOrNull((element) => element.key == key);

  static ComicSource? fromIntKey(int key) =>
      sources.firstWhereOrNull((element) => element.key.hashCode == key);

  static Future<void> init() async {
    sources.clear();
    for (var source in builtInSources) {
      if (appdata.appSettings.isComicSourceEnabled(source)) {
        var s = builtIn.firstWhere((e) => e.key == source);
        sources.add(s);
        //await s.loadData();
        s.initData?.call(s);
      }
      if(source == "picacg"){
        await picaClient.init();
      }
    }
  }

  static Future reload() => init();

  /// Name of this source.
  final String name;

  /// Identifier of this source.
  final String key;

  int get intKey => key.hashCode;

  /// Account config.
  final AccountConfig? account;

  /// Category data used to build a static category tags page.
  final CategoryData? categoryData;

  /// Category comics data used to build a comics page with a category tag.
  final CategoryComicsData? categoryComicsData;

  /// Favorite data used to build favorite page.
  final FavoriteData? favoriteData;

  /// Explore pages.
  final List<ExplorePageData> explorePages;

  /// Search page.
  final SearchPageData? searchPageData;

  /// Settings.
  final List<SettingItem> settings;

  /// Load comic info.
  final LoadComicFunc? loadComicInfo;

  /// Load comic pages.
  final LoadComicPagesFunc? loadComicPages;

  final Map<String, dynamic> Function(
      String imageKey, String comicId, String epId)? getImageLoadingConfig;

  final Map<String, dynamic> Function(String imageKey)?
      getThumbnailLoadingConfig;

  final String? matchBriefIdReg;

  var data = <String, dynamic>{};

  bool get isLogin => data["account"] != null;

  final String filePath;

  final String url;

  final String version;

  final CommentsLoader? commentsLoader;

  final SendCommentFunc? sendCommentFunc;

  final RegExp? idMatcher;

  final Widget Function(BuildContext context, String id, String? cover)?
      comicPageBuilder;

  // Future<void> loadData() async {
  //   return;
  // }

  bool _isSaving = false;
  bool _haveWaitingTask = false;

  Future<void> saveData() async {
    if (_haveWaitingTask) return;
    while (_isSaving) {
      _haveWaitingTask = true;
      await Future.delayed(const Duration(milliseconds: 20));
      _haveWaitingTask = false;
    }
    _isSaving = true;
    for (var e in data.entries){
      appdata.secureStorage.write(key: "${key}_${e.key}", value: e.value.toString());
    }
    _isSaving = false;
  }

  Future<bool> reLogin() async {
    if (data["account"] == null || data["password"] == null) {
      return false;
    }
    final String user = data["account"];
    final String pwd = data["password"];
    var res = await account!.login!(user, pwd);
    if (res.error) {
      log.e(error:"Failed to re-login", res.errorMessage ?? "Error");
    }
    return !res.error;
  }

  // only for built-in comic sources
  final FutureOr<void> Function(ComicSource source)? initData;

  bool get isBuiltIn => filePath == 'built-in';

  final Widget Function(BuildContext, BaseComic, List<ComicTileMenuOption>?)?
      comicTileBuilderOverride;

  ComicSource(
      this.name,
      this.key,
      this.account,
      this.categoryData,
      this.categoryComicsData,
      this.favoriteData,
      this.explorePages,
      this.searchPageData,
      this.settings,
      this.loadComicInfo,
      this.loadComicPages,
      this.getImageLoadingConfig,
      this.getThumbnailLoadingConfig,
      this.matchBriefIdReg,
      this.filePath,
      this.url,
      this.version,
      this.commentsLoader,
      this.sendCommentFunc)
      : initData = null,
        comicTileBuilderOverride = null,
        idMatcher = null,
        comicPageBuilder = null;

  ComicSource.named({
    required this.name,
    required this.key,
    this.account,
    this.categoryData,
    this.categoryComicsData,
    this.favoriteData,
    this.explorePages = const [],
    this.searchPageData,
    this.settings = const [],
    this.loadComicInfo,
    this.loadComicPages,
    this.getImageLoadingConfig,
    this.getThumbnailLoadingConfig,
    this.matchBriefIdReg,
    required this.filePath,
    this.url = '',
    this.version = '',
    this.commentsLoader,
    this.sendCommentFunc,
    this.initData,
    this.comicTileBuilderOverride,
    this.idMatcher,
    this.comicPageBuilder,
  });

  ComicSource.unknown(this.key)
      : name = "Unknown",
        account = null,
        categoryData = null,
        categoryComicsData = null,
        favoriteData = null,
        explorePages = [],
        searchPageData = null,
        settings = [],
        loadComicInfo = null,
        loadComicPages = null,
        getImageLoadingConfig = null,
        getThumbnailLoadingConfig = null,
        matchBriefIdReg = null,
        filePath = "",
        url = "",
        version = "",
        commentsLoader = null,
        sendCommentFunc = null,
        initData = null,
        comicTileBuilderOverride = null,
        idMatcher = null,
        comicPageBuilder = null;
}

class LoadImageRequest {
  String url;

  Map<String, String> headers;

  LoadImageRequest(this.url, this.headers);
}

class ExplorePageData {
  final String title;

  final ExplorePageType type;

  final ComicListBuilder? loadPage;

  final Future<Res<List<ExplorePagePart>>> Function()? loadMultiPart;

  /// return a `List` contains `List<BaseComic>` or `ExplorePagePart`
  final Future<Res<List<Object>>> Function(int index)? loadMixed;

  final WidgetBuilder? overridePageBuilder;

  ExplorePageData(this.title, this.type, this.loadPage, this.loadMultiPart)
      : loadMixed = null,
        overridePageBuilder = null;

  ExplorePageData.named({
    required this.title,
    required this.type,
    this.loadPage,
    this.loadMultiPart,
    this.loadMixed,
    this.overridePageBuilder,
  });
}

class ExplorePagePart {
  final String title;

  final List<BaseComic> comics;

  /// If this is not null, the [ExplorePagePart] will show a button to jump to new page.
  ///
  /// Value of this field should match the following format:
  ///   - search:keyword
  ///   - category:categoryName
  ///
  /// End with `@`+`param` if the category has a parameter.
  final String? viewMore;

  const ExplorePagePart(this.title, this.comics, this.viewMore);
}

enum ExplorePageType {
  multiPageComicList,
  singlePageWithMultiPart,
  mixed,
  override,
}

typedef SearchFunction = Future<Res<List<BaseComic>>> Function(
    String keyword, int page, List<String> searchOption);

class SearchPageData {
  /// If this is not null, the default value of search options will be first element.
  final List<SearchOptions>? searchOptions;

  final Widget Function(BuildContext, List<String> initialValues,
      void Function(List<String>))? customOptionsBuilder;

  final Widget Function(String keyword, List<String> options)?
      overrideSearchResultBuilder;

  final SearchFunction? loadPage;

  final bool enableLanguageFilter;

  final bool enableTagsSuggestions;

  const SearchPageData(this.searchOptions, this.loadPage)
      : enableLanguageFilter = false,
        customOptionsBuilder = null,
        overrideSearchResultBuilder = null,
        enableTagsSuggestions = false;

  const SearchPageData.named({
    this.searchOptions,
    this.loadPage,
    this.enableLanguageFilter = false,
    this.customOptionsBuilder,
    this.overrideSearchResultBuilder,
    this.enableTagsSuggestions = false,
  });
}

class SearchOptions {
  final LinkedHashMap<String, String> options;

  final String label;

  const SearchOptions(this.options, this.label);

  String get defaultValue => options.keys.first;

  const SearchOptions.named({required this.options, required this.label});
}

class SettingItem {
  final String name;
  final String iconName;
  final SettingType type;
  final List<String>? options;

  const SettingItem(this.name, this.iconName, this.type, this.options);
}

enum SettingType {
  switcher,
  selector,
  input,
}

@JsonSerializable()
class ComicInfoData with HistoryMixin {
  @override
  final String title;

  @override
  final String? subTitle;

  @override
  final String cover;

  final String? description;

  final Map<String, List<String>> tags;

  /// id-name
  final Map<String, String>? chapters;

  final List<String>? thumbnails;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final Future<Res<List<String>>> Function(String id, int page)?
      thumbnailLoader;

  final int thumbnailMaxPage;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final List<BaseComic>? suggestions;

  final String sourceKey;

  final String comicId;

  final bool? isFavorite;

  final String? subId;

  const ComicInfoData(
      this.title,
      this.subTitle,
      this.cover,
      this.description,
      this.tags,
      this.chapters,
      this.thumbnails,
      this.thumbnailMaxPage,
      this.sourceKey,
      this.comicId,
      {this.suggestions,
      this.thumbnailLoader,
      this.isFavorite,
      this.subId});

  Map<String, dynamic> toJson() => _$ComicInfoDataToJson(this);

  static Map<String, List<String>> _generateMap(Map<String, dynamic> map) {
    var res = <String, List<String>>{};
    map.forEach((key, value) {
      res[key] = List<String>.from(value);
    });
    return res;
  }

  factory ComicInfoData.fromJson(Map<String, dynamic> json) =>
      _$ComicInfoDataFromJson(json);

  @override
  HistoryType get historyType => HistoryType(sourceKey.hashCode);

  @override
  String get target => comicId;
}

typedef CategoryComicsLoader = Future<Res<List<BaseComic>>> Function(
    String category, String? param, List<String> options, int page);

class CategoryComicsData {
  /// options
  final List<CategoryComicsOptions> options;

  /// [category] is the one clicked by the user on the category page.

  /// if [BaseCategoryPart.categoryParams] is not null, [param] will be not null.
  ///
  /// [Res.subData] should be maxPage or null if there is no limit.
  final CategoryComicsLoader load;

  final RankingData? rankingData;

  const CategoryComicsData(this.options, this.load, {this.rankingData});

  const CategoryComicsData.named({
    this.options = const [],
    required this.load,
    this.rankingData,
  });
}

class RankingData {
  final Map<String, String> options;

  final Future<Res<List<BaseComic>>> Function(String option, int page) load;

  const RankingData(this.options, this.load);

  const RankingData.named({
    required this.options,
    required this.load,
  });
}

class CategoryComicsOptions {
  /// Use a [LinkedHashMap] to describe an option list.
  /// key is for loading comics, value is the name displayed on screen.
  /// Default value will be the first of the Map.
  final LinkedHashMap<String, String> options;

  /// If [notShowWhen] contains category's name, the option will not be shown.
  final List<String> notShowWhen;

  final List<String>? showWhen;

  const CategoryComicsOptions(this.options, this.notShowWhen, this.showWhen);

  const CategoryComicsOptions.named({
    required this.options,
    this.notShowWhen = const [],
    this.showWhen,
  });
}

class Comment {
  final String userName;
  final String? avatar;
  final String content;
  final String? time;
  final int? replyCount;
  final String? id;

  const Comment(this.userName, this.avatar, this.content, this.time,
      this.replyCount, this.id);
}
