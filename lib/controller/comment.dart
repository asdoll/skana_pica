import 'package:bot_toast/bot_toast.dart';
import 'package:get/get.dart';
import 'package:skana_pica/api/comic_sources/picacg/pica_api.dart';
import 'package:skana_pica/api/comic_sources/picacg/pica_models.dart';
import 'package:skana_pica/controller/comicstore.dart';
import 'package:skana_pica/util/log.dart';

class CommentController extends GetxController {
  Rx<PicaComment> comment = PicaComment.error().obs;
  RxString comicId = "".obs;
  RxBool isLoading = false.obs;
  Rx<PicaReply> replies = PicaReply("", 0, 0, []).obs;

  void fetch() {
    if (isLoading.value) {
      return;
    }
    isLoading.value = true;
    picaClient.getReply(comment.value.id).then((value) {
      replies.value = value;
      replies.refresh();
    });
    isLoading.value = false;
  }

  bool loadMore() {
    if (isLoading.value) {
      return true;
    }
    isLoading.value = true;
    if (replies.value.total > replies.value.loaded) {
      replies.value.loaded++;
    }
    picaClient.getMoreReply(replies.value).then((value) {
      replies.refresh();
    });
    isLoading.value = false;
    return true;
  }

  void init(PicaComment comment, String comicId) {
    this.comment.value = comment;
    this.comicId.value = comicId;
    fetch();
  }
}

class ReplyController extends GetxController {
  RxBool isLoading = false.obs;

  void reply(String id, String content, bool isComic, {String? masterId}) {
    if (isLoading.value) {
      return;
    }
    isLoading.value = true;
    picaClient.comment(id, content, !isComic).then((value) {
      isLoading.value = false;
      if (!value) {
        BotToast.showText(text: "Failed to reply".tr);
        return;
      }
      if (isComic) {
        try {
          ComicStore store = Get.find<ComicStore>(tag: id);
          store.fetchComments();
        } catch (e) {
          log.e(e);
        }
      } else {
        if (masterId != null) {
          try {
            ComicStore store = Get.find<ComicStore>(tag: masterId);
            store.fetchComments();
          } catch (e) {
            log.e(e);
          }
        }
        try {
          CommentController controller = Get.find<CommentController>(tag: id);
          controller.fetch();
        } catch (e) {
          log.e(e);
        }
      }
    });
  }
}
