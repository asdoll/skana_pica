
import 'package:json_annotation/json_annotation.dart';
import 'package:skana_pica/api/models/base_comic.dart';

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

  PicaProfile(this.id, this.avatarUrl, this.email, this.exp, this.level, this.name, this.title, this.isPunched, this.slogan, this.frameUrl);

  Map<String,dynamic> toJson()=> _$PicaProfileToJson(this);

  factory PicaProfile.fromJson(Map<String,dynamic> json) => _$PicaProfileFromJson(json);
  
}

class PicaCategoryItem {
  String title;
  String path;
  PicaCategoryItem(this.title, this.path);
}

class InitData {
  String imageServer;
  String fileServer;
  var categories = <PicaCategoryItem>[];
  InitData(this.imageServer, this.fileServer);
}

@JsonSerializable()
class PicaComicItemBrief extends BaseComic{
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

  PicaComicItemBrief(this.title, this.author, this.likes, this.path, this.id, this.tags, {this.pages});

  Map<String,dynamic> toJson()=> _$PicaComicItemBriefToJson(this);

  factory PicaComicItemBrief.fromJson(Map<String,dynamic> json) => _$PicaComicItemBriefFromJson(json);

  @override
  String get cover => path;

  @override
  String get description => "$likes pages";

  @override
  String get subTitle => author;
}

@JsonSerializable()
class PicaComicItem with HistoryMixin{
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
  int comments;
  bool isLiked;
  bool isFavourite;
  int epsCount;
  int pagesCount;
  String time;
  List<String> eps;
  List<PicaComicItemBrief> recommendation;
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
      this.comments,
      this.isFavourite,
      this.isLiked,
      this.epsCount,
      this.id,
      this.pagesCount,
      this.time,
      this.eps,
      this.recommendation
      );
  PicaComicItemBrief toBrief(){
    return PicaComicItemBrief(title, author, likes, thumbUrl, id, []);
  }

  Map<String,dynamic> toJson()=> _$PicaComicItemToJson(this);

  factory PicaComicItem.fromJson(Map<String,dynamic> json) => _$PicaComicItemFromJson(json);
  
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
  String toString()=>"$name:$text";

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
      this.time
      );
}

class PicaComments {
  List<PicaComment> comments;
  String id;
  int pages;
  int loaded;

  PicaComments(this.comments, this.id, this.pages, this.loaded);
}

class PicaFavorites {
  List<PicaComicItemBrief> comics;
  int pages;
  int loaded;

  PicaFavorites(this.comics, this.pages, this.loaded);
}

class PicaSearchResult{
  String keyWord;
  String sort;
  int pages;
  int loaded;
  List<PicaComicItemBrief> comics;
  PicaSearchResult(this.keyWord,this.sort,this.comics,this.pages,this.loaded);
}

class PicaReply{
  String id;
  int loaded;
  int total;
  List<PicaComment> comments;
  PicaReply(this.id,this.loaded,this.total,this.comments);
}

class PicaGameItemBrief{
  String id;
  String iconUrl;
  String name;
  String publisher;
  bool adult;
  PicaGameItemBrief(this.id,this.name,this.adult,this.iconUrl,this.publisher);
}

class PicaGames{
  List<PicaGameItemBrief> games;
  int total;
  int loaded;
  PicaGames(this.games,this.loaded,this.total);
}

class PicaGameInfo{
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
  PicaGameInfo(this.id,this.name,this.description,this.icon,this.publisher,this.screenshots,this.link,this.isLiked,this.likes,this.comments);
}