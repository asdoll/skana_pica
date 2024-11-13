import 'package:json_annotation/json_annotation.dart';

part 'base_comic.g.dart';

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

  factory CustomComic.fromJson(Map<String, dynamic> json) => _$CustomComicFromJson(json);

  Map<String, dynamic> toJson() => _$CustomComicToJson(this);
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
      return "Unknown";
    }
  }

  const HistoryType(this.value);

  @override
  bool operator ==(Object other) =>
      other is HistoryType && other.value == value;

  @override
  int get hashCode => value.hashCode;
}