// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pica_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Profile _$ProfileFromJson(Map<String, dynamic> json) => Profile(
      json['id'] as String,
      json['avatarUrl'] as String,
      json['email'] as String,
      (json['exp'] as num).toInt(),
      (json['level'] as num).toInt(),
      json['name'] as String,
      json['title'] as String,
      json['isPunched'] as bool?,
      json['slogan'] as String?,
      json['frameUrl'] as String?,
    );

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'email': instance.email,
      'name': instance.name,
      'level': instance.level,
      'exp': instance.exp,
      'avatarUrl': instance.avatarUrl,
      'frameUrl': instance.frameUrl,
      'isPunched': instance.isPunched,
      'slogan': instance.slogan,
    };

ComicItemBrief _$ComicItemBriefFromJson(Map<String, dynamic> json) =>
    ComicItemBrief(
      json['title'] as String,
      json['author'] as String,
      (json['likes'] as num).toInt(),
      json['path'] as String,
      json['id'] as String,
      (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      pages: (json['pages'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ComicItemBriefToJson(ComicItemBrief instance) =>
    <String, dynamic>{
      'title': instance.title,
      'author': instance.author,
      'likes': instance.likes,
      'path': instance.path,
      'id': instance.id,
      'tags': instance.tags,
      'pages': instance.pages,
    };

ComicItem _$ComicItemFromJson(Map<String, dynamic> json) => ComicItem(
      Profile.fromJson(json['creator'] as Map<String, dynamic>),
      json['title'] as String,
      json['description'] as String,
      json['thumbUrl'] as String,
      json['author'] as String,
      json['chineseTeam'] as String,
      (json['categories'] as List<dynamic>).map((e) => e as String).toList(),
      (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      (json['likes'] as num).toInt(),
      (json['comments'] as num).toInt(),
      json['isFavourite'] as bool,
      json['isLiked'] as bool,
      (json['epsCount'] as num).toInt(),
      json['id'] as String,
      (json['pagesCount'] as num).toInt(),
      json['time'] as String,
      (json['eps'] as List<dynamic>).map((e) => e as String).toList(),
      (json['recommendation'] as List<dynamic>)
          .map((e) => ComicItemBrief.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ComicItemToJson(ComicItem instance) => <String, dynamic>{
      'id': instance.id,
      'creator': instance.creator,
      'title': instance.title,
      'description': instance.description,
      'thumbUrl': instance.thumbUrl,
      'author': instance.author,
      'chineseTeam': instance.chineseTeam,
      'categories': instance.categories,
      'tags': instance.tags,
      'likes': instance.likes,
      'comments': instance.comments,
      'isLiked': instance.isLiked,
      'isFavourite': instance.isFavourite,
      'epsCount': instance.epsCount,
      'pagesCount': instance.pagesCount,
      'time': instance.time,
      'eps': instance.eps,
      'recommendation': instance.recommendation,
    };
