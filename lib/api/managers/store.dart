import 'package:skana_pica/api/comic_sources/picacg/pica_models.dart';
import 'package:skana_pica/api/models/objectbox_models.dart';

/// Persistent storage used by the browsing history and the download queue.
///
/// There are two implementations:
///
/// * [ObjectBox] (`objectbox.dart`) - the default one, used on Android, iOS,
///   macOS, Linux and Windows.
/// * [SqliteStore] (`sqlite_store.dart`) - used on HarmonyOS, where objectbox
///   ships no native library at all. It is backed by sqlite3, which has an
///   OHOS port (see `dependency_overrides` in pubspec.yaml).
///
/// The models in `api/models/objectbox_models.dart` are shared by both: they
/// are plain Dart classes whose `ToOne`/`ToMany` relations work without a live
/// objectbox store, so the sqlite implementation can rebuild them from disk
/// while the rest of the app keeps using them unchanged.
abstract class AppStore {
  // ---- history of opened comics -------------------------------------------

  Future<void> addHistoryItem(PicaHistoryItem item);

  Future<PicaHistoryItem> addHistoryWithCheck(PicaComicItem item);

  Future<void> addHistoryByComic(PicaComicItem item, {int id});

  Future<PicaComicItem?> getComicHistory(String comicId);

  Future<void> removeHistoryItem(int id);

  Future<void> removeHistoryItemByComic(String comicId);

  int removeAllHistoryItem();

  // ---- where the reader stopped -------------------------------------------

  Future<void> addVisit(String comicId, int eps, int index);

  Future<void> addVisitHistory(VisitHistory history);

  Future<List<VisitHistory>> getVisitHistory();

  Future<int> getVisitHistoryCount();

  Future<List<VisitHistory>> getVisitHistoryByOffset(int offset, int limit);

  Future<VisitHistory?> getVisitHistoryByComic(String comicId);

  Future<void> removeVisitHistory(String comicId);

  int removeAllHistory();

  // ---- download queue ------------------------------------------------------

  Future<void> addDownloadTask(DownloadTask task);

  Future<DownloadTask?> getDownloadTask(int id);

  Future<void> removeDownloadTask(int id);

  Future<int> getDownloadTaskCount();

  Future<void> clearDownloadTask();

  Future<List<DownloadTask>> getDownloadTaskList();

  Future<List<DownloadTask>> getDownloadTaskListWithOffset(
      int offset, int limit);

  /// Every unfinished task, newest first.
  Future<List<DownloadTask>> restoreDownload();

  Future<void> updateTaskEps(DownloadTask task);

  // ---- everything ----------------------------------------------------------

  void clearDB();
}
