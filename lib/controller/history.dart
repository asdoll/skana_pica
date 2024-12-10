import 'package:get/get.dart';
import 'package:skana_pica/api/comic_sources/picacg/pica_api.dart';
import 'package:skana_pica/api/comic_sources/picacg/pica_models.dart';
import 'package:skana_pica/api/managers/history_manager.dart';
import 'package:skana_pica/api/models/objectbox_models.dart';

class HistoryController extends GetxController {
  RxList<VisitHistory> history = <VisitHistory>[].obs;
  RxList<PicaComicItemBrief> comics = <PicaComicItemBrief>[].obs;
  RxInt total = 0.obs;
  RxBool isLoading = false.obs;

  int perPage = 20;
  int page = 0;
  int totalPage = 0;

  Future<void> init() async {
    if (isLoading.value) {
      return;
    }
    isLoading.value = true;
    M.o.getVisitHistoryCount().then((value) async {
      total.value = value;
      totalPage = (total.value / perPage).ceil();
      page = 0;
      history.clear();
      var val = await M.o.getVisitHistoryByOffset((page + 1) * 20, 20);
      history.addAll(val);
      history.refresh();
      await fetchComic();
    });
    isLoading.value = false;
  }

  Future<void> nextPage() async {
    if (isLoading.value) {
      return;
    }
    if (page + 1 >= totalPage) {
      return;
    }
    isLoading.value = true;
    page++;
    history.clear();
    var value = await M.o.getVisitHistoryByOffset((page + 1) * 20, 20);
    history.addAll(value);
    history.refresh();
    await fetchComic();
    isLoading.value = false;
  }

  Future<void> fetchComic() async {
    comics.clear();
    comics.refresh();
    for (int i = 0; i < history.length; i++) {
      var item = await M.o.getComicHistory(history[i].comicid);
      if (item != null) {
        comics.add(item.toBrief());
        continue;
      }
      var res = await picaClient.getBriefComicInfo(history[i].comicid);
      if (!res.error) {
        comics.add(res.data);
      } else {
        comics.add(PicaComicItemBrief.error());
      }
    }
  }
}
