import 'dart:convert';

import 'package:skana_pica/api/comic_sources/picacg/pica_models.dart';
import 'package:skana_pica/api/models/base_comic.dart';
import 'package:skana_pica/config/base.dart';
import 'package:skana_pica/util/tool.dart';

String getCurTime() {
  return DateTime.now()
      .toIso8601String()
      .replaceFirst("T", " ")
      .substring(0, 19);
}

final class FavoriteType {
  final int key;

  const FavoriteType(this.key);

  static FavoriteType get picacg => const FavoriteType(0);

  static FavoriteType get ehentai => const FavoriteType(1);

  static FavoriteType get jm => const FavoriteType(2);

  static FavoriteType get hitomi => const FavoriteType(3);

  static FavoriteType get htManga => const FavoriteType(4);

  static FavoriteType get nhentai => const FavoriteType(6);

  ComicType get comicType {
    if (key >= 0 && key <= 6) {
      return ComicType.values[key];
    }
    return ComicType.other;
  }

  String get name {
    if (comicType != ComicType.other) {
      return comicType.name;
    } else {
        return "**Unknown**";
    }
  }

  @override
  bool operator ==(Object other) {
    return other is FavoriteType && other.key == key;
  }

  @override
  int get hashCode => key.hashCode;
}

class FavoriteItem {
  String name;
  String author;
  FavoriteType type;
  List<String> tags;
  String target;
  String coverPath;
  String time = getCurTime();

  bool get available {
    if (type.key <= 6 && type.key >= 0) {
      return true;
    }
    return ComicSource.sources
            .firstWhereOrNull((element) => element.key.hashCode == type.key) !=
        null;
  }

  String toDownloadId() {
    try {
      return switch (type.comicType) {
        ComicType.picacg => target,
        _ => target,
        //TODO: implement other comic source
        // ComicType.ehentai => getGalleryId(target),
        // ComicType.jm => "jm$target",
        // ComicType.hitomi => RegExp(r"\d+(?=\.html)").hasMatch(target)
        //     ? "hitomi${RegExp(r"\d+(?=\.html)").firstMatch(target)?[0]}"
        //     : target,
        // ComicType.htManga => "ht$target",
        // ComicType.nhentai => "nhentai$target",
        // _ => DownloadManager().generateId(type.comicSource.key, target)
      };
    } catch (e) {
      return "**Invalid ID**";
    }
  }

  FavoriteItem({
    required this.target,
    required this.name,
    required this.coverPath,
    required this.author,
    required this.type,
    required this.tags,
  });

  FavoriteItem.fromPicacg(PicaComicItemBrief comic)
      : name = comic.title,
        author = comic.author,
        type = FavoriteType.picacg,
        tags = comic.tags,
        target = comic.id,
        coverPath = comic.path;
  //TODO: implement other comic source
  // FavoriteItem.fromEhentai(EhGalleryBrief comic)
  //     : name = comic.title,
  //       author = comic.uploader,
  //       type = FavoriteType.ehentai,
  //       tags = comic.tags,
  //       target = comic.link,
  //       coverPath = comic.coverPath;

  // FavoriteItem.fromJmComic(JmComicBrief comic)
  //     : name = comic.name,
  //       author = comic.author,
  //       type = FavoriteType.jm,
  //       tags = [],
  //       target = comic.id,
  //       coverPath = getJmCoverUrl(comic.id);

  // FavoriteItem.fromHitomi(HitomiComicBrief comic)
  //     : name = comic.name,
  //       author = comic.artist,
  //       type = FavoriteType.hitomi,
  //       tags = List.generate(
  //           comic.tagList.length, (index) => comic.tagList[index].name),
  //       target = comic.link,
  //       coverPath = comic.cover;

  // FavoriteItem.fromHtcomic(HtComicBrief comic)
  //     : name = comic.name,
  //       author = "${comic.pages}Pages",
  //       type = FavoriteType.htManga,
  //       tags = [],
  //       target = comic.id,
  //       coverPath = comic.image;

  // FavoriteItem.fromNhentai(NhentaiComicBrief comic)
  //     : name = comic.title,
  //       author = "",
  //       type = FavoriteType.nhentai,
  //       tags = comic.tags,
  //       target = comic.id,
  //       coverPath = comic.cover;

  Map<String, dynamic> toJson() => {
        "name": name,
        "author": author,
        "type": type.key,
        "tags": tags,
        "target": target,
        "coverPath": coverPath,
        "time": time
      };

  FavoriteItem.fromJson(Map<String, dynamic> json)
      : name = json["name"],
        author = json["author"],
        type = FavoriteType(json["type"]),
        tags = List<String>.from(json["tags"]),
        target = json["target"],
        coverPath = json["coverPath"],
        time = json["time"];
  //TODO: implement import from row
  // FavoriteItem.fromRow(Row row)
  //     : name = row["name"],
  //       author = row["author"],
  //       type = FavoriteType(row["type"]),
  //       tags = (row["tags"] as String).split(","),
  //       target = row["target"],
  //       coverPath = row["cover_path"],
  //       time = row["time"] {
  //   tags.remove("");
  // }

  factory FavoriteItem.fromBaseComic(BaseComic comic) {
    if (comic is PicaComicItemBrief) {
      return FavoriteItem.fromPicacg(comic);
    //TODO: implement other comic source
    // } else if (comic is EhGalleryBrief) {
    //   return FavoriteItem.fromEhentai(comic);
    // } else if (comic is JmComicBrief) {
    //   return FavoriteItem.fromJmComic(comic);
    // } else if (comic is HtComicBrief) {
    //   return FavoriteItem.fromHtcomic(comic);
    // } else if (comic is NhentaiComicBrief) {
    //   return FavoriteItem.fromNhentai(comic);
    } 
    throw UnimplementedError();
  }

  @override
  bool operator ==(Object other) {
    return other is FavoriteItem && other.target == target && other.type == type;
  }

  @override
  int get hashCode => target.hashCode ^ type.hashCode;

  @override
  String toString() {
    var s = "FavoriteItem: $name $author $coverPath $hashCode $tags";
    if(s.length > 100) {
      return s.substring(0, 100);
    }
    return s;
  }
}

class FavoriteItemWithFolderInfo {
  FavoriteItem comic;
  String folder;

  FavoriteItemWithFolderInfo(this.comic, this.folder);

  @override
  bool operator ==(Object other) {
    return other is FavoriteItemWithFolderInfo &&
        other.comic == comic &&
        other.folder == folder;
  }

  @override
  int get hashCode => comic.hashCode ^ folder.hashCode;
}

class FolderSync {
  String folderName;
  String time = getCurTime();
  String key;
  String syncData; // 内容是 json, 存一下选中的文件夹 folderId
  FolderSync(this.folderName, this.key, this.syncData);

  Map<String, dynamic> get syncDataObj => jsonDecode(syncData);
}

extension SQL on String {
  String get toParam => replaceAll('\'', "''").replaceAll('"', "\"\"");
}
