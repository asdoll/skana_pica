import 'package:bot_toast/bot_toast.dart';
import 'package:get/get.dart';
import 'package:skana_pica/api/comic_sources/picacg/pica_api.dart';
import 'package:skana_pica/api/comic_sources/picacg/pica_models.dart';
import 'package:skana_pica/config/setting.dart';

class ComicListController extends GetxController {
  RxList<PicaComicItemBrief> comics = <PicaComicItemBrief>[].obs;
  RxBool isLoading = false.obs;
  RxInt page = 1.obs;
  RxInt total = 0.obs;
  bool isAuthor = false;
  String keyword = "";
  RxString sort = "".obs;

  bool fetch() {
    if(isLoading.value){
      return true;
    }
    isLoading.value = true;
    sort.value = sort.value.isEmpty ? appdata.pica[4] : sort.value;
    picaClient
        .getCategoryComics(keyword, page.value, sort.value,
            isAuthor ? "a" : "c")
        .then((value) {
      if (value.error) {
        isLoading.value = false;
        BotToast.showText(text: "Failed to load data".tr);
        return false;
      }
      total.value = value.subData;
      comics.addAll(value.data);
      isLoading.value = false;
    });
    comics.refresh();
    return true;
  }

  bool onLoad() {
    if(isLoading.value){
      return true;
    }
    page.value++;
    return fetch();
  }

  bool init(String keyword, {String sort = "", bool isAuthor = false, int page = 1}) {
    this.keyword = keyword;
    this.isAuthor = isAuthor;
    sort.isEmpty ? this.sort.value = appdata.pica[4] : this.sort.value = sort;
    this.page.value = page;
    comics.clear();
    return fetch();
  }

  bool pageFetch(int page) {
    if(isLoading.value){
      return true;
    }
    if (page > total.value || page <= 1) {
      return false;
    }
    this.page.value = page;
    comics.clear();
    return fetch();
  }

  bool reload(bool pageReset) {
    comics.clear();
    if (pageReset) page.value = 1;
    isLoading.value = false;
    return fetch();
  }
}
