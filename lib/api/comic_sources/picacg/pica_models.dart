import 'package:json_annotation/json_annotation.dart';
import 'package:skana_pica/api/comic_sources/picacg/pica_api.dart';
import 'package:skana_pica/api/comic_sources/picacg/pica_source.dart';
import 'package:skana_pica/api/models/base_comic.dart';
import 'package:skana_pica/api/models/history_type.dart';

part 'pica_models.g.dart';

@JsonSerializable()
class PicaProfile {
  String id;
  String title;
  String email;
  String name;
  int level;
  int exp;
  String avatarUrl;
  String? frameUrl;
  bool? isPunched;
  String? slogan;

  PicaProfile(this.id, this.avatarUrl, this.email, this.exp, this.level,
      this.name, this.title, this.isPunched, this.slogan, this.frameUrl);

  Map<String, dynamic> toJson() => _$PicaProfileToJson(this);

  factory PicaProfile.fromJson(Map<String, dynamic> json) =>
      _$PicaProfileFromJson(json);

  PicaProfile.error()
      : id = "",
        avatarUrl = "",
        email = "",
        exp = 0,
        level = 0,
        name = "",
        title = "",
        isPunched = null,
        slogan = null,
        frameUrl = null;

  factory PicaProfile.fromClient() {
    if (picacg.data['user'] != null) {
      return PicaProfile.fromJson(picacg.data['user']);
    }
    picaClient.getProfile().then((res) {
      if (!res.error) {
        picacg.data['user'] = res.data;
        return res.data;
      }
    });
    return PicaProfile.error();
  }
}

class PicaCategoryItem {
  String title;
  String path;
  PicaCategoryItem(this.title, this.path);
}

class PicaEpsImages {
  String eps;
  List<String> imageUrl;
  int? loaded;
  PicaEpsImages(this.eps, this.imageUrl);
}

@JsonSerializable()
class PicaComicItemBrief extends BaseComic {
  @override
  String title;
  String author;
  int likes;
  String path;
  @override
  String id;
  @override
  List<String> tags;
  int? pages;
  int? epsCount;
  bool? finished;
  @override
  String description = "";
  @override
  String subTitle = "";

  PicaComicItemBrief(
      this.title, this.author, this.likes, this.path, this.id, this.tags,
      {this.pages, this.epsCount, this.finished});

  Map<String, dynamic> toJson() => _$PicaComicItemBriefToJson(this);

  factory PicaComicItemBrief.fromJson(Map<String, dynamic> json) =>
      _$PicaComicItemBriefFromJson(json);

  PicaComicItemBrief.error()
      : title = "",
        author = "",
        likes = 0,
        path = errorLoadingUrl,
        id = errorId,
        tags = [];

  @override
  String get cover => path;
}

const errorId = "ERROR";

@JsonSerializable()
class PicaComicItem with HistoryMixin {
  String id;
  PicaProfile creator;
  @override
  String title;
  String description;
  String thumbUrl;
  String author;
  String chineseTeam;
  List<String> categories;
  List<String> tags;
  int likes;
  int totalViews;
  int comments;
  bool isLiked;
  bool isFavourite;
  int epsCount;
  int pagesCount;
  String time;
  List<String> eps;
  List<PicaComicItemBrief> recommendation;
  bool finished;
  PicaComicItem(
      this.creator,
      this.title,
      this.description,
      this.thumbUrl,
      this.author,
      this.chineseTeam,
      this.categories,
      this.tags,
      this.likes,
      this.totalViews,
      this.comments,
      this.isFavourite,
      this.isLiked,
      this.epsCount,
      this.id,
      this.pagesCount,
      this.time,
      this.eps,
      this.recommendation,
      this.finished);
  PicaComicItemBrief toBrief() {
    return PicaComicItemBrief(title, author, likes, thumbUrl, id, categories,
        pages: pagesCount, epsCount: epsCount, finished: finished);
  }

  Map<String, dynamic> toJson() => _$PicaComicItemToJson(this);

  factory PicaComicItem.fromJson(Map<String, dynamic> json) =>
      _$PicaComicItemFromJson(json);

  PicaComicItem.error(String id)
      : this(
            PicaProfile("", "", "", 0, 0, "", "", null, null, null),
            "error",
            "",
            "",
            "",
            "",
            [],
            [],
            0,
            0,
            0,
            false,
            false,
            0,
            id,
            0,
            "",
            [],
            [],
            false);

  @override
  String get cover => thumbUrl;
  @override
  HistoryType get historyType => HistoryType.picacg;
  @override
  String get subTitle => author;
  @override
  String get target => id;
}

class PicaComment {
  String name;
  String avatarUrl;
  String userId;
  int level;
  String text;
  int reply;
  String id;
  bool isLiked;
  int likes;
  String? frame;
  String? slogan;
  String time;

  @override
  String toString() => "$id:$name:$text";

  PicaComment(
      this.name,
      this.avatarUrl,
      this.userId,
      this.level,
      this.text,
      this.reply,
      this.id,
      this.isLiked,
      this.likes,
      this.frame,
      this.slogan,
      this.time);
  PicaComment.error()
      : this("", "", "", 0, "", 0, "", false, 0, null, null, "");
}

class PicaComments {
  List<PicaComment> comments;
  String id;
  int pages;
  int loaded;
  int total;

  PicaComments(this.comments, this.id, this.pages, this.loaded, this.total);
}

class PicaFavorites {
  List<PicaComicItemBrief> comics;
  int pages;
  int loaded;

  PicaFavorites(this.comics, this.pages, this.loaded);
}

class PicaSearchResult {
  String keyWord;
  String sort;
  int pages;
  int loaded;
  List<PicaComicItemBrief> comics;
  PicaSearchResult(
      this.keyWord, this.sort, this.comics, this.pages, this.loaded);
}

class PicaReply {
  String id;
  int loaded;
  int total;
  List<PicaComment> comments;
  PicaReply(this.id, this.loaded, this.total, this.comments);
}

class PicaGameItemBrief {
  String id;
  String iconUrl;
  String name;
  String publisher;
  bool adult;
  PicaGameItemBrief(
      this.id, this.name, this.adult, this.iconUrl, this.publisher);
}

class PicaGames {
  List<PicaGameItemBrief> games;
  int total;
  int loaded;
  PicaGames(this.games, this.loaded, this.total);
}

class PicaGameInfo {
  String id;
  String name;
  String description;
  String icon;
  String publisher;
  List<String> screenshots;
  String link;
  bool isLiked;
  int likes;
  int comments;
  PicaGameInfo(this.id, this.name, this.description, this.icon, this.publisher,
      this.screenshots, this.link, this.isLiked, this.likes, this.comments);
}