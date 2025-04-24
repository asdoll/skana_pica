import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:skana_pica/api/managers/image_cache_manager.dart';
import 'package:share_plus/share_plus.dart';
import 'package:skana_pica/api/models/objectbox_models.dart';
import 'package:skana_pica/config/setting.dart';
import 'package:skana_pica/util/leaders.dart';

extension ListExtension<T> on List<T> {
  /// Remove all blank value and return the list.
  List<T> getNoBlankList() {
    List<T> newList = [];
    for (var value in this) {
      if (value.toString() != "") {
        newList.add(value);
      }
    }
    return newList;
  }

  T? firstWhereOrNull(bool Function(T element) test) {
    for (var element in this) {
      if (test(element)) {
        return element;
      }
    }
    return null;
  }

  void addIfNotNull(T? value) {
    if (value != null) {
      add(value);
    }
  }

  String listToString(String? separator) {
    String res = "";
    separator ??= ";";
    for (var value in this) {
      res += value.toString() + separator;
    }
    return res;
  }
}

extension StringExtension on String {
  ///Remove all value that would display blank on the screen.
  String get removeAllBlank =>
      replaceAll("\n", "").replaceAll(" ", "").replaceAll("\t", "");

  /// convert this to a one-element list.
  List<String> toList() => [this];

  List<int> stringToIntList(String? separator) {
    separator ??= ";";
    if (isEmpty) {
      return [];
    }
    var list = split(separator);
    List<int> res = [];
    for (var value in list) {
      res.add(int.parse(value));
    }
    return res;
  }

  String _nums() {
    String res = "";
    for (int i = 0; i < length; i++) {
      res += StringExtension(this[i]).isNum ? this[i] : "";
    }
    return res;
  }

  String atMost({int max = 13}) {
    if (length > max) {
      return "${substring(0, max)}...";
    }
    return this;
  }

  String get nums => _nums();

  String setValueAt(String value, int index) {
    return replaceRange(index, index + 1, value);
  }

  String? subStringOrNull(int start, [int? end]) {
    if (start < 0 || (end != null && end > length)) {
      return null;
    }
    return substring(start, end);
  }

  String replaceLast(String from, String to) {
    if (isEmpty || from.isEmpty) {
      return this;
    }

    final lastIndex = lastIndexOf(from);
    if (lastIndex == -1) {
      return this;
    }

    final before = substring(0, lastIndex);
    final after = substring(lastIndex + from.length);
    return '$before$to$after';
  }

  static bool hasMatch(String? value, String pattern) {
    return (value == null) ? false : RegExp(pattern).hasMatch(value);
  }

  bool _isURL() {
    final regex = RegExp(
        r'^((http|https|ftp)://)?[\w-]+(\.[\w-]+)+([\w.,@?^=%&:/~+#-|]*[\w@?^=%&/~+#-])?$',
        caseSensitive: false);
    return regex.hasMatch(this);
  }

  bool get isURL => _isURL();

  bool get isNum => double.tryParse(this) != null;
}

extension MapExtension<S, T> on Map<S, List<T>> {
  int _getTotalLength() {
    int res = 0;
    for (var l in values.toList()) {
      res += l.length;
    }
    return res;
  }

  int get totalLength => _getTotalLength();
}

class ListOrNull {
  static List<T>? from<T>(Iterable<dynamic>? i) {
    return i == null ? null : List.from(i);
  }
}

String getExtensionName(String url) {
  var fileName = url.split('/').last;
  if (fileName.contains('.')) {
    return '.${fileName.split('.').last}';
  }
  return '.jpg';
}

void saveImage(String url, {bool fromDld = false}) async {
  if (Platform.isIOS && (await Permission.photosAddOnly.status.isDenied)) {
    if (await Permission.storage.request().isDenied) {
      showToast("Permission denied".tr);
      return;
    }
  }
  var file = fromDld
      ? await downloadCacheManager.getSingleFile(url)
      : await imagesCacheManager.getSingleFile(url);
  if (file.existsSync()) {
    var fileName = url.split('/').last;
    if (!fileName.contains('.')) {
      fileName += getExtensionName(url);
    }
    await ImageGallerySaverPlus.saveImage(await file.readAsBytes(),
        quality: 100, name: fileName);
    showToast("$fileName ${"Saved".tr}");
  }
}

void shareImage(String url, {bool fromDld = false}) async {
  var file = fromDld
      ? await downloadCacheManager.getSingleFile(url)
      : await imagesCacheManager.getSingleFile(url);
  if (file.existsSync()) {
    var fileName = url.split('/').last;
    if (!fileName.contains('.')) {
      fileName += getExtensionName(url);
    }
    Share.shareXFiles([XFile(file.path)]);
  }
}

void resetOrientation() {
  if (settings.general[6] == '0') {
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
  } else if (settings.general[6] == '1') {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  } else {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  }
}

String getLastRead(VisitHistory? history) {
  if (history == null) {
    return "";
  }
  return "E${history.lastEps + 1}/P${history.lastIndex + 1}";
}

String getLastTime(VisitHistory? history) {
  if (history == null) {
    return "";
  }
  int? time = int.tryParse(history.timestamp);
  if (time == null) {
    return "";
  }
  DateTime Date = DateTime.fromMillisecondsSinceEpoch(time);
  return DateFormat.yMd(Get.locale.toString()).add_Hm().format(Date);
}

extension TimeExts on DateTime {
  String toShortTime() {
    try {
      var formatter = DateFormat('yyyy-MM-dd HH:mm');
      return formatter.format(toLocal());
    } catch (e) {
      return toString();
    }
  }
}