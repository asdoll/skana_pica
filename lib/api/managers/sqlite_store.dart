import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:skana_pica/api/comic_sources/picacg/pica_models.dart';
import 'package:skana_pica/api/managers/store.dart';
import 'package:skana_pica/api/models/objectbox_models.dart';
import 'package:sqlite3/sqlite3.dart';

/// [AppStore] implementation for HarmonyOS.
///
/// objectbox ships no native library for OHOS, so the app cannot open a store
/// there at all. This backend is backed by sqlite3 instead, which does have an
/// OHOS port (see `dependency_overrides` in pubspec.yaml).
///
/// The three objectbox entities are kept as rows with a JSON payload column.
/// That is enough because the app never queries on individual fields of a
/// stored comic: it looks entries up by `comicid`, or lists them ordered by
/// `timestamp`/`id`. Those two columns are therefore real columns, everything
/// else is JSON.
///
/// The models themselves (`api/models/objectbox_models.dart`) are shared with
/// the objectbox backend. Their `ToOne`/`ToMany` relations are plain Dart
/// objects that work without a live store, so a [DownloadTask] can be rebuilt
/// from disk and handed to the existing callers unchanged.
class SqliteStore implements AppStore {
  /// Folder used by the objectbox backend as well, so the databases of both
  /// implementations live side by side and neither can pick up the other's
  /// half-written state.
  static const String _folder = "skana_pica_history";

  static const String _dbFile = "store.db";

  final Database _db;

  SqliteStore._(this._db);

  static Future<SqliteStore> create() async {
    final dir =
        p.join((await getApplicationDocumentsDirectory()).path, _folder);
    Directory(dir).createSync(recursive: true);
    final db = sqlite3.open(p.join(dir, _dbFile));
    // The reader writes a row on every page turn, so WAL is worth it here.
    db.execute('pragma journal_mode = wal;');
    return SqliteStore._(db).._migrate();
  }

  void _migrate() {
    _db.execute('''
      create table if not exists pica_history (
        id integer primary key autoincrement,
        comicid text not null unique,
        payload text not null
      );

      -- timestamp is text (epoch millis) exactly like the objectbox property,
      -- and ordered as text below, so both backends order identically.
      create table if not exists visit_history (
        id integer primary key autoincrement,
        comicid text not null unique,
        last_eps integer not null,
        last_index integer not null,
        timestamp text not null
      );
      create index if not exists idx_visit_history_timestamp
        on visit_history (timestamp);

      create table if not exists download_task (
        id integer primary key autoincrement,
        timestamp integer not null,
        comic text not null,
        eps text not null
      );
    ''');
  }

  // ---- history of opened comics -------------------------------------------

  @override
  Future<void> addHistoryItem(PicaHistoryItem item) async {
    _storeHistory(item);
  }

  @override
  Future<PicaHistoryItem> addHistoryWithCheck(PicaComicItem item) async {
    final stored = _historyByComicId(item.id);
    final history = PicaHistoryItem.withItem(item, id: stored?.id ?? 0);
    _storeHistory(history);
    return history;
  }

  @override
  Future<void> addHistoryByComic(PicaComicItem item, {int id = 0}) async {
    _storeHistory(PicaHistoryItem.withItem(item, id: id));
  }

  @override
  Future<PicaComicItem?> getComicHistory(String comicId) async {
    final history = _historyByComicId(comicId);
    return history?.toComicItem();
  }

  @override
  Future<void> removeHistoryItem(int id) async {
    _db.execute('delete from pica_history where id = ?', [id]);
  }

  @override
  Future<void> removeHistoryItemByComic(String comicId) async {
    _db.execute('delete from pica_history where comicid = ?', [comicId]);
  }

  @override
  int removeAllHistoryItem() {
    _db.execute('delete from pica_history');
    return _db.updatedRows;
  }

  // ---- where the reader stopped -------------------------------------------

  @override
  Future<void> addVisit(String comicId, int eps, int index) async {
    await addVisitHistory(VisitHistory(
      comicid: comicId,
      lastEps: eps,
      lastIndex: index,
      timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
    ));
  }

  @override
  Future<void> addVisitHistory(VisitHistory history) async {
    _db.execute(
        'insert into visit_history (comicid, last_eps, last_index, timestamp) '
        'values (?, ?, ?, ?) '
        'on conflict(comicid) do update set '
        '  last_eps = excluded.last_eps, '
        '  last_index = excluded.last_index, '
        '  timestamp = excluded.timestamp',
        [
          history.comicid,
          history.lastEps,
          history.lastIndex,
          history.timestamp,
        ]);
    final rows = _db.select(
        'select id from visit_history where comicid = ?', [history.comicid]);
    if (rows.isNotEmpty) history.id = rows.first['id'] as int;
  }

  @override
  Future<List<VisitHistory>> getVisitHistory() async {
    return _visitHistoryRows(
        'select * from visit_history order by timestamp desc');
  }

  @override
  Future<int> getVisitHistoryCount() async {
    return _db.select('select count(*) as c from visit_history').first['c']
        as int;
  }

  @override
  Future<List<VisitHistory>> getVisitHistoryByOffset(
      int offset, int limit) async {
    return _visitHistoryRows(
        'select * from visit_history order by timestamp desc limit ? offset ?',
        [limit, offset]);
  }

  @override
  Future<VisitHistory?> getVisitHistoryByComic(String comicId) async {
    final rows = _visitHistoryRows(
        'select * from visit_history where comicid = ?', [comicId]);
    return rows.isEmpty ? null : rows.first;
  }

  @override
  Future<void> removeVisitHistory(String comicId) async {
    _db.execute('delete from visit_history where comicid = ?', [comicId]);
  }

  @override
  int removeAllHistory() {
    _db.execute('delete from visit_history');
    return _db.updatedRows;
  }

  // ---- download queue ------------------------------------------------------

  @override
  Future<void> addDownloadTask(DownloadTask task) async {
    final comic = jsonEncode({
      'id': task.comic.target?.id ?? 0,
      'data': _encodeHistory(task.comic.target),
    });
    final eps = jsonEncode(task.taskEps.map(_encodeEps).toList());
    if (task.id == 0) {
      _db.execute(
          'insert into download_task (timestamp, comic, eps) values (?, ?, ?)',
          [task.timestamp, comic, eps]);
      task.id = _db.lastInsertRowId;
    } else {
      _db.execute(
          'update download_task set timestamp = ?, comic = ?, eps = ? '
          'where id = ?',
          [task.timestamp, comic, eps, task.id]);
    }
  }

  @override
  Future<DownloadTask?> getDownloadTask(int id) async {
    final rows =
        _downloadRows('select * from download_task where id = ?', [id]);
    return rows.isEmpty ? null : rows.first;
  }

  @override
  Future<void> removeDownloadTask(int id) async {
    _db.execute('delete from download_task where id = ?', [id]);
  }

  @override
  Future<int> getDownloadTaskCount() async {
    return _db.select('select count(*) as c from download_task').first['c']
        as int;
  }

  @override
  Future<void> clearDownloadTask() async {
    _db.execute('delete from download_task');
  }

  @override
  Future<List<DownloadTask>> getDownloadTaskList() async {
    return _downloadRows('select * from download_task order by id desc');
  }

  @override
  Future<List<DownloadTask>> getDownloadTaskListWithOffset(
      int offset, int limit) async {
    return _downloadRows(
        'select * from download_task order by id desc limit ? offset ?',
        [limit, offset]);
  }

  @override
  Future<List<DownloadTask>> restoreDownload() async {
    final list = await getDownloadTaskList();
    list.removeWhere(isTaskFinished);
    return list;
  }

  @override
  Future<void> updateTaskEps(DownloadTask task) async {
    // The comic is rewritten as well: a merge can swap it out, and keeping the
    // whole row in one statement makes the two backends behave the same way.
    await addDownloadTask(task);
  }

  // ---- everything ----------------------------------------------------------

  @override
  void clearDB() {
    _db.execute('delete from pica_history');
    _db.execute('delete from visit_history');
    _db.execute('delete from download_task');
  }

  // ---- history helpers -----------------------------------------------------

  /// Inserts or updates by `comicid`, which is the only key the app looks
  /// history up by. `comicid` is unique, so the id of an existing row is kept.
  void _storeHistory(PicaHistoryItem item) {
    _db.execute(
        'insert into pica_history (comicid, payload) values (?, ?) '
        'on conflict(comicid) do update set payload = excluded.payload',
        [item.comicid, jsonEncode(_encodeHistory(item))]);
    final rows = _db.select(
        'select id from pica_history where comicid = ?', [item.comicid]);
    if (rows.isNotEmpty) item.id = rows.first['id'] as int;
  }

  PicaHistoryItem? _historyByComicId(String comicId) {
    final rows = _db.select(
        'select id, payload from pica_history where comicid = ?', [comicId]);
    if (rows.isEmpty) return null;
    final row = rows.first;
    return _decodeHistory(
        row['id'] as int, jsonDecode(row['payload'] as String) as Map);
  }

  List<VisitHistory> _visitHistoryRows(String sql,
      [List<Object?> params = const []]) {
    return _db.select(sql, params).map((row) {
      return VisitHistory(
        comicid: row['comicid'] as String,
        lastEps: row['last_eps'] as int,
        lastIndex: row['last_index'] as int,
        timestamp: row['timestamp'] as String,
      )..id = row['id'] as int;
    }).toList();
  }

  List<DownloadTask> _downloadRows(String sql,
      [List<Object?> params = const []]) {
    return _db.select(sql, params).map((row) {
      final task = DownloadTask(row['timestamp'] as int, id: row['id'] as int);
      final comic = jsonDecode(row['comic'] as String) as Map;
      task.comic.target =
          _decodeHistory(comic['id'] as int, comic['data'] as Map);
      final eps = (jsonDecode(row['eps'] as String) as List)
          .map((e) => _decodeEps(e as Map))
          .toList();
      task.taskEps.addAll(eps);
      return task;
    }).toList();
  }

  // ---- model codec ---------------------------------------------------------
  //
  // Hand written: the models are objectbox entities, so json_serializable never
  // generated codecs for them.

  Map<String, dynamic> _encodeHistory(PicaHistoryItem? item) => {
        'comicid': item?.comicid ?? '',
        'creatorName': item?.creatorName ?? '',
        'creatorAvatarUrl': item?.creatorAvatarUrl ?? '',
        'title': item?.title ?? '',
        'description': item?.description ?? '',
        'thumbUrl': item?.thumbUrl ?? '',
        'author': item?.author ?? '',
        'chineseTeam': item?.chineseTeam ?? '',
        'categories': item?.categories ?? const <String>[],
        'tags': item?.tags ?? const <String>[],
        'likes': item?.likes ?? 0,
        'totalViews': item?.totalViews ?? 0,
        'comments': item?.comments ?? 0,
        'isLiked': item?.isLiked ?? false,
        'isFavourite': item?.isFavourite ?? false,
        'epsCount': item?.epsCount ?? 0,
        'pagesCount': item?.pagesCount ?? 0,
        'time': item?.time ?? '',
        'eps': item?.eps ?? const <String>[],
        'finished': item?.finished ?? false,
      };

  /// The row id is passed in separately: [PicaHistoryItem] has no `id`
  /// constructor argument, only the `withItem` factory takes one.
  PicaHistoryItem _decodeHistory(int id, Map json) {
    final item = PicaHistoryItem(
      comicid: json['comicid'] as String,
      creatorName: json['creatorName'] as String,
      creatorAvatarUrl: json['creatorAvatarUrl'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      thumbUrl: json['thumbUrl'] as String,
      author: json['author'] as String,
      chineseTeam: json['chineseTeam'] as String,
      categories: (json['categories'] as List).cast<String>(),
      tags: (json['tags'] as List).cast<String>(),
      likes: json['likes'] as int,
      totalViews: json['totalViews'] as int,
      comments: json['comments'] as int,
      isLiked: json['isLiked'] as bool,
      isFavourite: json['isFavourite'] as bool,
      epsCount: json['epsCount'] as int,
      pagesCount: json['pagesCount'] as int,
      time: json['time'] as String,
      eps: (json['eps'] as List).cast<String>(),
      finished: json['finished'] as bool,
    );
    item.id = id;
    return item;
  }

  Map<String, dynamic> _encodeEps(DownloadEps eps) => {
        'id': eps.id,
        'eps': eps.eps,
        'url': eps.url,
        'progress': eps.progress,
      };

  DownloadEps _decodeEps(Map json) => DownloadEps(
        json['eps'] as int,
        (json['url'] as List).cast<String>(),
        (json['progress'] as List).cast<int>(),
        id: json['id'] as int,
      );
}
