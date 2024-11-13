// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_comic.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomComic _$CustomComicFromJson(Map<String, dynamic> json) => CustomComic(
      json['title'] as String,
      json['subTitle'] as String? ?? '',
      json['cover'] as String,
      json['id'] as String,
      (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      json['description'] as String? ?? '',
      json['sourceKey'] as String,
    );

Map<String, dynamic> _$CustomComicToJson(CustomComic instance) =>
    <String, dynamic>{
      'title': instance.title,
      'subTitle': instance.subTitle,
      'cover': instance.cover,
      'id': instance.id,
      'tags': instance.tags,
      'description': instance.description,
      'sourceKey': instance.sourceKey,
    };
