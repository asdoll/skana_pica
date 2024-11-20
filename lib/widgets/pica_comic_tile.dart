// import 'package:flutter/material.dart';
// import 'package:skana_pica/api/comic_sources/picacg/pica_models.dart';
// import 'package:skana_pica/models/favourites.dart';
// import 'package:skana_pica/widgets/comic_tile.dart';

// class PicComicTile extends ComicTile {
//   final PicaComicItemBrief comic;

//   const PicComicTile(this.comic, {super.key, this.addonMenuOptions});

//   @override
//   String get description => '${comic.likes} likes';

//   @override
//   List<String>? get tags => comic.tags;

//   @override
//   // TODO: implement image
//   Widget get image => throw UnimplementedError();

//   @override
//   void onTap_(BuildContext context) {
//     // TODO: implement onTap_
//   }
//   // @override
//   // Widget get image => AnimatedImage(
//   //       image: CachedImageProvider(
//   //         comic.path,
//   //       ),
//   //       fit: BoxFit.cover,
//   //       height: double.infinity,
//   //       width: double.infinity,
//   //       filterQuality: FilterQuality.medium,
//   //     );

//   // @override
//   // ActionFunc? get read => () async {
//   //       bool cancel = false;
//   //       var dialog = showLoadingDialog(
//   //         App.globalContext!,
//   //         onCancel: () => cancel = true,
//   //       );
//   //       var res = await picaClient.getEps(comic.id);
//   //       if (cancel) {
//   //         return;
//   //       }
//   //       dialog.close();
//   //       if (res.error) {
//   //         showToast(message: res.errorMessage ?? "Error");
//   //       } else {
//   //         var history = await HistoryManager().find(comic.id);
//   //         if (history == null) {
//   //           history = History(
//   //             HistoryType.picacg,
//   //             DateTime.now(),
//   //             comic.title,
//   //             comic.author,
//   //             comic.cover,
//   //             0,
//   //             0,
//   //             comic.id,
//   //           );
//   //           await HistoryManager().addHistory(history);
//   //         }
//   //         App.globalTo(
//   //           () => ComicReadingPage.picacg(
//   //             comic.id,
//   //             history!.ep,
//   //             res.data,
//   //             comic.title,
//   //             initialPage: history.page,
//   //           ),
//   //         );
//   //       }
//   //     };

//   // @override
//   // void onTap_() {
//   //   App.mainNavigatorKey!.currentContext!.to(
//   //     () => ComicPage(
//   //       sourceKey: "picacg",
//   //       id: comic.id,
//   //       cover: comic.cover,
//   //     ),
//   //   );
//   //}

//   @override
//   String get subTitle => comic.author;

//   @override
//   String get title => comic.title;

//   @override
//   int? get pages => comic.pages;

//   @override
//   FavoriteItem? get favoriteItem => FavoriteItem.fromPicacg(comic);

//   @override
//   String get comicID => comic.id;

//   @override
//   final List<ComicTileMenuOption>? addonMenuOptions;
// }
