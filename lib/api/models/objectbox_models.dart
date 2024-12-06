import 'package:objectbox/objectbox.dart';
import 'package:skana_pica/api/comic_sources/picacg/pica_models.dart';

@Entity()
class PicaHistoryItem {
  @Id()
  int id = 0;
  @Index()
  String comicid;
  String creatorName;
  String creatorAvatarUrl;
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
  bool finished;

  PicaHistoryItem(
      {required this.comicid,
      required this.creatorName,
      required this.creatorAvatarUrl,
      required this.title,
      required this.description,
      required this.thumbUrl,
      required this.author,
      required this.chineseTeam,
      required this.categories,
      required this.tags,
      required this.likes,
      required this.totalViews,
      required this.comments,
      required this.isLiked,
      required this.isFavourite,
      required this.epsCount,
      required this.pagesCount,
      required this.time,
      required this.eps,
      required this.finished});

  PicaHistoryItem.withItem(PicaComicItem item,{this.id = 0})
      : comicid = item.id,
        creatorName = item.creator.name,
        creatorAvatarUrl = item.creator.avatarUrl,
        title = item.title,
        description = item.description,
        thumbUrl = item.thumbUrl,
        author = item.author,
        chineseTeam = item.chineseTeam,
        categories = item.categories,
        tags = item.tags,
        likes = item.likes,
        totalViews = item.totalViews,
        comments = item.comments,
        isLiked = item.isLiked,
        isFavourite = item.isFavourite,
        epsCount = item.epsCount,
        pagesCount = item.pagesCount,
        time = item.time,
        eps = item.eps,
        finished = item.finished;

  PicaComicItem toComicItem() {
    return PicaComicItem(
        PicaProfile(
            creatorName, creatorAvatarUrl, '', 0, 0, '', '', false, '', ''),
        title,
        description,
        thumbUrl,
        author,
        chineseTeam,
        categories,
        tags,
        likes,
        totalViews,
        comments,
        isLiked,
        isFavourite,
        epsCount,
        comicid,
        pagesCount,
        time,
        eps,
        [],
        finished);
  }
}

@Entity()
class VisitHistory {
  @Id()
  int id = 0;
  @Index()
  String comicid;
  int lastEps;
  int lastIndex;
  String timestamp;

  VisitHistory(
      {required this.comicid,
      required this.lastEps,
      required this.lastIndex,
      required this.timestamp});
}

@Entity()
class DownloadItem {
  @Id()
  int id = 0;
  @Index()
  String comicId;
  String epsId;
  String thumbUrl;
  String path;
  int totalPage;
  int downloadedPage;
  int status;
  String timestamp;

  DownloadItem(
      {required this.comicId,
      required this.epsId,
      required this.thumbUrl,
      required this.path,
      required this.totalPage,
      required this.downloadedPage,
      required this.status,
      required this.timestamp});
}