import 'package:path_provider/path_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;
import 'package:skana_pica/api/comic_sources/picacg/pica_models.dart';
import 'package:skana_pica/api/models/objectbox_models.dart';

import 'package:skana_pica/objectbox.g.dart';

class ObjectBox {
  late final Store _store;

  late final Box<PicaHistoryItem> _historyBox;
  late final Box<VisitHistory> _visitHistoryBox;

  late final Box<DownloadTask> _downloadTaskBox;


  ObjectBox._create(this._store) {
    _historyBox = Box<PicaHistoryItem>(_store);
    _visitHistoryBox = Box<VisitHistory>(_store);
    _downloadTaskBox = Box<DownloadTask>(_store);
  }

  static Future<ObjectBox> create() async {
    final store = await openStore(
        directory: p.join((await getApplicationDocumentsDirectory()).path,
            "skana_pica_history"),
        macosApplicationGroup: "skana.pica.history");
    return ObjectBox._create(store);
  }

  Future<void> addHistoryItem(PicaHistoryItem item) async {
    _historyBox.put(item);
  }

  Future<void> addVisitHistory(VisitHistory history,
      {PutMode mode = PutMode.put}) async {
    _visitHistoryBox.put(history, mode: mode);
  }

  Future<void> addHistoryByComic(PicaComicItem item, {int id = 0}) async {
    _historyBox.put(PicaHistoryItem.withItem(item, id: id));
  }

  Future<PicaHistoryItem> addHistoryWithCheck(PicaComicItem item) async {
    PicaHistoryItem hItem = PicaHistoryItem.withItem(item);
    final history = _historyBox
        .query(PicaHistoryItem_.comicid.equals(hItem.comicid))
        .build()
        .findFirst();
    if (history == null) {
      _historyBox.put(hItem);
      return hItem;
    } else {
      _historyBox.put(hItem..id = history.id);
      return history;
    }
  }

  Future<void> addVisit(String comicId, int eps, int index) async {
    final history = _visitHistoryBox
        .query(VisitHistory_.comicid.equals(comicId))
        .build()
        .findFirst();
    if (history != null) {
      history.lastEps = eps;
      history.lastIndex = index;
      _visitHistoryBox.put(history);
    } else {
      _visitHistoryBox.put(VisitHistory(
        comicid: comicId,
        lastEps: eps,
        lastIndex: index,
        timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
      ));
    }
  }

  Future<List<VisitHistory>> getVisitHistory() async {
    return _visitHistoryBox
        .query()
        .order(VisitHistory_.timestamp, flags: Order.descending)
        .build()
        .find();
  }

  Future<int> getVisitHistoryCount() async {
    return _visitHistoryBox.count();
  }

  Future<List<VisitHistory>> getVisitHistoryByOffset(
      int offset, int limit) async {
    return (_visitHistoryBox
            .query()
            .order(VisitHistory_.timestamp, flags: Order.descending)
            .build()
          ..offset = offset
          ..limit = limit)
        .find();
  }

  Future<PicaComicItem?> getComicHistory(String comicId) async {
    final history = _historyBox
        .query(PicaHistoryItem_.comicid.equals(comicId))
        .build()
        .findFirst();
    if (history != null) {
      return history.toComicItem();
    }
    return null;
  }

  Future<VisitHistory?> getVisitHistoryByComic(String comicId) async {
    return _visitHistoryBox
        .query(VisitHistory_.comicid.equals(comicId))
        .build()
        .findFirst();
  }

  Future<void> removeHistoryItem(int id) => _historyBox.removeAsync(id);

  Future<void> removeHistoryItemByComic(String comicId) {
    final history = _historyBox
        .query(PicaHistoryItem_.comicid.equals(comicId))
        .build()
        .find();
    if (history.isNotEmpty) {
      return _historyBox.removeManyAsync(history.map((e) => e.id).toList());
    }
    return Future.value();
  }

  int removeAllHistory() => _visitHistoryBox.removeAll();
  int removeAllHistoryItem() => _historyBox.removeAll();

  Future<void> removeVisitHistory(String comicId) {
    final history = _visitHistoryBox
        .query(VisitHistory_.comicid.equals(comicId))
        .build()
        .find();
    if (history.isNotEmpty) {
      return _visitHistoryBox
          .removeManyAsync(history.map((e) => e.id).toList());
    }
    return Future.value();
  }

  Future<DownloadTask?> getDownloadTask(int id) async {
    return _downloadTaskBox.get(id);
  }

  Future<void> addDownloadTask(DownloadTask task) async {
    _downloadTaskBox.put(task);
  }

  Future<void> removeDownloadTask(int id) async {
    _downloadTaskBox.remove(id);
  }

  Future<void> clearDownloadTask() async {
    _downloadTaskBox.removeAll();
  }

  Future<int> getDownloadTaskCount() async {
    return _downloadTaskBox.count();
  }

  Future<List<DownloadTask>> getDownloadTaskListWithOffset(
      int offset, int limit) async {
    return (_downloadTaskBox
            .query()
            .order(DownloadTask_.id, flags: Order.descending)
            .build()
          ..offset = offset
          ..limit = limit)
        .find();
  }

  Future<List<DownloadTask>> getDownloadTaskList() async {
    return _downloadTaskBox
        .query()
        .order(DownloadTask_.id, flags: Order.descending)
        .build()
        .find();
  }

  Future<List<DownloadTask>> restoreDownload() async {
    var list = _downloadTaskBox
        .query()
        .order(DownloadTask_.id, flags: Order.descending)
        .build()
        .find();
    list.removeWhere((element) => isTaskFinished(element));
    return list;
  }

  Future<void> updateTaskEps(DownloadTask task) async {
    _store.box<DownloadEps>().putMany(task.taskEps);
  }

  void clearDB(){
    _historyBox.removeAll();
    _visitHistoryBox.removeAll();
    _downloadTaskBox.removeAll();
  }
}
