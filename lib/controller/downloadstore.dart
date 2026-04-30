import 'dart:async';

import 'package:easy_localization/easy_localization.dart' show StringTranslateExtension;
import 'package:skana_pica/api/comic_sources/picacg/pica_models.dart';
import 'package:skana_pica/api/managers/history_manager.dart';
import 'package:skana_pica/api/managers/image_cache_manager.dart';
import 'package:skana_pica/api/models/objectbox_models.dart';
import 'package:skana_pica/util/leaders.dart';
import 'package:skana_pica/controller/log.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'downloadstore.freezed.dart';
part 'downloadstore.g.dart';

@freezed
abstract class DownloadState with _$DownloadState {
  factory DownloadState({
    @Default([]) List<DownloadTask> tasks,
    @Default({}) Map<int, int> progress,
    @Default({}) Map<int, int> total,
    @Default({}) Map<int, bool> stop,
    @Default({}) Map<int, bool> working,
  }) = _DownloadState;
}

@Riverpod(keepAlive: true)
class Download extends _$Download {
  @override
  DownloadState build() {
    return DownloadState();
  }

  Future<void> restore() async {
    List<DownloadTask> tasks = [];
    //log.i(await M.o.getDownloadTaskCount());
    var list = await M.o.getDownloadTaskList();
    for (var task in list) {
      tasks.add(task);
      //log.i(task.taskEps.map((e) => e.progress).toList());
      restoreProgress(task);
    }
    state = state.copyWith(tasks: tasks);
    //logAll();
  }

  void logAll() {
    log.t("DownloadStore");
    for (var task in state.tasks) {
      log.t(task.id);
    }
    for (var p in state.progress.entries) {
      log.t("progress ${p.key} ${p.value}");
    }
  }

  Future<void> addTask(DownloadTask task) async {
    final existingIndex = state.tasks.indexWhere(
      (e) => e.comic.target!.comicid == task.comic.target!.comicid,
    );

    if (existingIndex != -1) {
      mergeTask(existingIndex, task);
      await M.o.addDownloadTask(state.tasks[existingIndex]);
      return;
    }

    await M.o.addDownloadTask(task);

    final newTasks = List<DownloadTask>.from(state.tasks)..add(task);

    state = state.copyWith(tasks: newTasks);

    restoreProgress(task);
  }

  Future<void> removeTask(int id) async {
    final task = state.tasks.firstWhere((element) => element.id == id);

    await Future.wait([
      for (final ep in task.taskEps)
        for (final url in ep.url)
          downloadCacheManager.removeFile(url),
    ]);

    final tmpTask = List<DownloadTask>.from(state.tasks)
      ..removeWhere((element) => element.id == id);

    final tmpProgress = Map<int, int>.from(state.progress)..remove(id);
    final tmpTotal = Map<int, int>.from(state.total)..remove(id);
    final tmpStop = Map<int, bool>.from(state.stop)..remove(id);
    final tmpWorking = Map<int, bool>.from(state.working)..remove(id);

    state = state.copyWith(
      tasks: tmpTask,
      progress: tmpProgress,
      total: tmpTotal,
      stop: tmpStop,
      working: tmpWorking,
    );

    await M.o.removeDownloadTask(id);
  }

  void stopTask(int id) {
    final stopMap = Map<int, bool>.from(state.stop);
    stopMap[id] = true;

    state = state.copyWith(stop: stopMap);

    if (state.tasks.any((task) => task.id == id)) {
      removeTask(id);
    }
  }

  void mergeTask(int index, DownloadTask task) {
    final updatedTask = state.tasks[index];

    for (final newEps in task.taskEps) {
      final exists = updatedTask.taskEps.any((e) => e.eps == newEps.eps);
      if (!exists) {
        updatedTask.taskEps.add(newEps);
      }
    }

    updatedTask.comic.target = task.comic.target;

    final newTasks = List<DownloadTask>.from(state.tasks);
    newTasks[index] = updatedTask;

    state = state.copyWith(tasks: newTasks);

    restoreProgress(updatedTask);
    log.t("mergeTask ${task.id}");
  }

  Future<void> updateTask(DownloadTask task) async {
    final index = state.tasks.indexWhere((e) => e.id == task.id);
    if (index == -1) return;

    final newTasks = List<DownloadTask>.from(state.tasks);
    newTasks[index] = task;

    state = state.copyWith(tasks: newTasks);

    log.i("updateTask ${task.taskEps.map((e) => e.progress).toList()}");

    await M.o.updateTaskEps(task);

    final done = state.progress[task.id] == state.total[task.id];
    if (done) {
      final newWorking = Map<int, bool>.from(state.working)..remove(task.id);
      state = state.copyWith(working: newWorking);

      showToast('${"download".tr()} "${task.comic.target!.title}" ${"done".tr()}');
    }
  }

  DownloadTask createTask(
      PicaComicItem comic, List<int> tasklist, List<PicaEpsImages> eList) {
    DownloadTask task = DownloadTask(DateTime.now().millisecondsSinceEpoch);
    task.comic.target = PicaHistoryItem.withItem(comic);
    List<DownloadEps> epsList = [];
    for (int e in tasklist) {
      epsList.add(DownloadEps(e, eList[e].imageUrl,
          List.generate(eList[e].imageUrl.length, (_) => 0)));
    }
    task.taskEps.addAll(epsList);
    addTask(task);
    return task;
  }

  void continueTask(int id) {
    download(state.tasks.firstWhere((element) => element.id == id));
  }

  void restoreProgress(DownloadTask task) {
    int restoredProgress = 0;
    int total = 0;

    for (final ep in task.taskEps) {
      for (int j = 0; j < ep.url.length; j++) {
        if (ep.progress[j] == 1) {
          restoredProgress++;
        }
      }
      total += ep.url.length;
    }

    final progress = Map<int, int>.from(state.progress);
    final totals = Map<int, int>.from(state.total);

    progress[task.id] = restoredProgress;
    totals[task.id] = total;

    state = state.copyWith(progress: progress, total: totals);
  }

  void download(DownloadTask task) {
    if (state.working[task.id] == true) return;

    showToast('${"download".tr()} "${task.comic.target!.title}"');

    final workingMap = Map<int, bool>.from(state.working);
    workingMap[task.id] = true;
    state = state.copyWith(working: workingMap);

    unawaited(downloadCacheManager.getSingleFile(task.comic.target!.thumbUrl));
    unawaited(downloadCacheManager.getSingleFile(task.comic.target!.creatorAvatarUrl));

    for (int i = 0; i < task.taskEps.length; i++) {
      for (int j = 0; j < task.taskEps[i].url.length; j++) {
        if (task.taskEps[i].progress[j] == 1) continue;

        unawaited(() async {
          try {
            await downloadCacheManager.getSingleFile(task.taskEps[i].url[j]);

            task.taskEps[i].progress[j] = 1;

            final progressMap = Map<int, int>.from(state.progress);
            progressMap[task.id] = (progressMap[task.id] ?? 0) + 1;

            state = state.copyWith(progress: progressMap);

            updateTask(task);
          } catch (e) {
            showToast("network_error".tr());

            final workingMap = Map<int, bool>.from(state.working)..remove(task.id);
            state = state.copyWith(working: workingMap);
          }
        }());
      }
    }
  }

  Future<void> clear() async {
    for (final task in state.tasks) {
      await removeTask(task.id);
    }

    state = state.copyWith(
      tasks: const [],
      progress: const {},
      total: const {},
      stop: const {},
      working: const {},
    );
  }
}

@riverpod
class DownloadPage extends _$DownloadPage {
  static const int perPage = 20;

  @override
  int build() {
    return 0; // current page
  }

  void setPage(int value) {
    state = value;
  }

  void nextPage() {
    state++;
  }

  void prevPage() {
    if (state <= 0) return;
    state--;
  }
}