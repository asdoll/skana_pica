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
import 'package:skana_pica/controller/log.dart';
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

/// Chain used to serialise saves to the system gallery.
Future<void> _saveChain = Future<void>.value();

/// Saves one image to the system gallery, queueing it behind pending saves.
///
/// The HarmonyOS implementation of image_gallery_saver_plus rejects overlapping
/// calls with a `Busy` PlatformException, and every save may wait for a system
/// confirmation dialog, so saves triggered from the UI are serialised here
/// instead of racing each other.
Future<void> _saveToGallery(Uint8List bytes, String name,
    {String? successMessage}) {
  final Future<void> previous = _saveChain;
  final Future<void> queued = () async {
    await previous;
    try {
      // HarmonyOS treats `name` as the asset *title* and appends its own
      // extension, so the extension has to go (see _galleryTitle).
      final String title = Platform.isOhos ? _galleryTitle(name) : name;
      log.w("saving to gallery: $title (from '$name', ${bytes.length} bytes)");
      final dynamic result = await _rawSave(bytes, title)
          // A save waits for a system confirmation dialog. If the platform
          // never answers, report it instead of blocking the queue forever.
          .timeout(const Duration(seconds: 90));
      // Reported shape is {filePath, errorMessage, isSuccess}; a missing
      // isSuccess (e.g. an empty response) counts as a failure.
      log.w("gallery save result: $result");
      final bool ok = result is Map && result['isSuccess'] == true;
      showToast(ok ? (successMessage ?? "Saved".tr) : "Save failed".tr);
    } catch (e, s) {
      log.e("failed to save image to gallery: $e", error: "$s");
      showToast("Save failed".tr);
    }
  }();
  _saveChain = queued;
  return queued;
}

/// Characters the media library rejects in a PhotoCreationConfig.title.
const List<String> _invalidTitleChars = [
  r'\',
  '/',
  ':',
  '*',
  '?',
  '"',
  "'",
  '`',
  '<',
  '>',
  '|',
  '{',
  '}',
  '[',
  ']',
];

/// Turns a file name into a title HarmonyOS accepts.
///
/// `PhotoCreationConfig.title` must not contain a file name extension (the
/// extension is passed separately as `fileNameExtension`) and must not contain
/// any of `\ / : * ? " ' ` < > | { } [ ]`. A title that breaks those rules
/// makes `showAssetsCreationDialog` fail silently: no confirmation dialog is
/// shown and nothing gets saved at all. Pixiv file names end in `.jpg`, which is
/// exactly what used to happen here.
String _galleryTitle(String fileName) {
  var title = fileName;
  final int dot = title.lastIndexOf('.');
  if (dot > 0) {
    title = title.substring(0, dot);
  }
  for (final String invalid in _invalidTitleChars) {
    title = title.replaceAll(invalid, '_');
  }
  if (title.isEmpty) {
    title = DateTime.now().millisecondsSinceEpoch.toString();
  }
  return title;
}

/// `ImageGallerySaverPlus.saveImage` is declared `FutureOr<dynamic>`, so it has
/// to be wrapped in an async function before it can be given a timeout.
Future<dynamic> _rawSave(Uint8List bytes, String name) async =>
    ImageGallerySaverPlus.saveImage(bytes, quality: 100, name: name);

/// Images whose save is currently being prepared, so repeated taps on the same
/// image do not re-download it.
final Set<String> _savingUrls = <String>{};

/// Attempts allowed while fetching an image for saving.
///
/// Deliberately small: this is a user triggered action, and pixiv rate limits
/// the image hosts too.
const int _maxSaveDownloadAttempts = 2;

/// Downloads [url] and hands the bytes to the gallery.
Future<void> _saveRemoteImage(String url, String fileName,
    {bool fromDld = false, String? successMessage}) async {
  if (!_savingUrls.add(url)) {
    log.w("a save for $url is already in flight, ignoring duplicate request");
    return;
  }
  try {
    final Uint8List bytes = await _downloadForSave(url, fromDld);
    await _saveToGallery(bytes, fileName, successMessage: successMessage);
  } catch (e, s) {
    log.e("failed to prepare $url for saving: $e", error: "$s");
    showToast("Save failed".tr);
  } finally {
    _savingUrls.remove(url);
  }
}

/// Fetches the image bytes with a capped number of attempts.
///
/// A rate limit is never retried - hammering the host while it is throttling
/// only makes the block last longer.
Future<Uint8List> _downloadForSave(String url, bool fromDld) async {
  Object? lastError;
  for (int attempt = 1; attempt <= _maxSaveDownloadAttempts; attempt++) {
    try {
      final file = fromDld
          ? await downloadCacheManager.getSingleFile(url)
          : await imagesCacheManager.getSingleFile(url);
      if (file.existsSync()) {
        return file.readAsBytes();
      }
      lastError = Exception("cached file for $url does not exist");
    } catch (e) {
      lastError = e;
    }
    if (_looksRateLimited(lastError)) {
      log.w("not retrying $url, the host is rate limiting us");
      break;
    }
    log.w("save: attempt $attempt/$_maxSaveDownloadAttempts for $url failed: "
        "$lastError");
    if (attempt < _maxSaveDownloadAttempts) {
      await Future.delayed(Duration(milliseconds: 300 * attempt));
    }
  }
  throw lastError ?? Exception("failed to load $url");
}

/// True when [error] is the image host throttling us rather than a real failure.
bool _looksRateLimited(Object? error) {
  if (error == null) {
    return false;
  }
  final String text = error.toString().toLowerCase();
  return text.contains('rate limit') ||
      text.contains('too many requests') ||
      text.contains('429');
}

Future<void> saveImage(String url, {bool fromDld = false}) async {
  if (Platform.isIOS && (await Permission.photosAddOnly.status.isDenied)) {
    if (await Permission.storage.request().isDenied) {
      showToast("Permission denied".tr);
      return;
    }
  }
  if (url.isEmpty) {
    return;
  }
  var fileName = url.split('/').last;
  if (!fileName.contains('.')) {
    fileName += getExtensionName(url);
  }
  await _saveRemoteImage(url, fileName,
      fromDld: fromDld, successMessage: "$fileName ${"Saved".tr}");
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
