import 'dart:collection';

import 'package:skana_pica/api/comic_sources/picacg/pica_api.dart';
import 'package:skana_pica/api/comic_sources/picacg/pica_models.dart';
import 'package:skana_pica/api/models/account_config.dart';
import 'package:skana_pica/api/models/base_comic.dart';
import 'package:skana_pica/api/models/res.dart';
import 'package:skana_pica/config/base.dart';
import 'package:skana_pica/pages/pica_comic.dart';
import 'package:skana_pica/pages/pica_recoms.dart';
import 'package:skana_pica/util/leaders.dart';
import 'package:skana_pica/widgets/pica_comic_tile.dart';

final picacg = ComicSource.named(
  name: "picacg",
  key: "picacg",
  filePath: 'built-in',
  favoriteData: FavoriteData(
    key: "picacg",
    title: "Picacg",
    multiFolder: false,
    loadComic: (i, [folder]) =>
        picaClient.getFavorites(i, appdata.settings[30] == "1"),
    loadFolders: null,
    addOrDelFavorite: (id, folder, isAdding) async {
      var res = await picaClient.favouriteOrUnfavouriteComic(id);
      return res
          ? const Res(true)
          : const Res(false, errorMessage: "Network Error");
    },
  ),
  categoryData: CategoryData(
    title: "Picacg",
    key: "picacg",
    categories: [
      const FixedCategoryPart("分类", _categories, "category"),
    ],
    enableRankingPage: true,
    buttons: [
      CategoryButtonData(
        label: "推荐",
        onTap: (context) => Leader.push(context, PicaRecommendsPage(),root: true),
      ),
    ],
  ),
  account: AccountConfig.named(
    login: (account, pwd) async {
      var picacg = ComicSource.find('picacg')!;
      var res = await picaClient.login(account, pwd);
      if (res.error) {
        return Res.fromErrorRes(res);
      }
      picacg.data['token'] = res.data;
      var profile = await picaClient.getProfile();
      if (profile.error) {
        picacg.data['token'] = null;
        return Res.fromErrorRes(res);
      }
      picaClient.user = profile.data;
      picacg.data['user'] = profile.data.toJson();
      var a = <String>[account, pwd];
      picacg.data['account'] = a;
      return const Res(true);
    },
    logout: () {
      var picacg = ComicSource.find('picacg')!;
      picacg.data['user'] = null;
      picacg.data['token'] = null;
      picacg.saveData();
    },
    infoItems: [
      AccountInfoItem(title: "账号", data: () => picaClient.user?.email ?? ''),
      AccountInfoItem(title: "用户名", data: () => picaClient.user?.name ?? ''),
      AccountInfoItem(
        title: "等级",
        data: () {
          var user = picaClient.user;
          return "Lv${user?.level} ${user?.title} Exp${user?.exp}";
        },
      ),
      AccountInfoItem(title: "简介", data: () => picaClient.user?.slogan ?? ''),
    ],
  ),
  initData: (s) {
    if (s.data['appChannel'] == null) {
      s.data['appChannel'] = '3';
    }
    if (s.data['imageQuality'] == null) {
      s.data['imageQuality'] = "original";
    }
  },
  comicTileBuilderOverride: (context, comic, options) {
    comic as PicaComicItemBrief;
    return PicComicTile(
      comic,
      addonMenuOptions: options,
    );
  },
  explorePages: [
    ExplorePageData.named(
      title: "picacg",
      type: ExplorePageType.singlePageWithMultiPart,
      loadMultiPart: () async {
        var [res0, res1] = await Future.wait(
          [picaClient.getRandomComics(), picaClient.getLatest(1)],
        );
        if (res0.error) {
          return Res.fromErrorRes(res0);
        }
        if (res1.error) {
          return Res.fromErrorRes(res1);
        }
        return Res([
          ExplorePagePart("随机", res0.data, "category:random"),
          ExplorePagePart("最新", res1.data, "category:latest"),
        ]);
      },
    ),
  ],
  categoryComicsData: CategoryComicsData.named(
    load: (category, param, options, page) async {
      if(category == "random") {
        return picaClient.getRandomComics();
      } else if (category == "latest") {
        return picaClient.getLatest(page);
      }
      return picaClient.getCategoryComics(
        category,
        page,
        options[0],
        param ?? 'c',
      );
    },
    options: [
      CategoryComicsOptions.named(
        options: LinkedHashMap.of({
          "dd": "新到旧",
          "da": "旧到新",
          "ld": "最多喜欢",
          "vd": "最多指名",
        }),
        notShowWhen: ["random", "latest"],
      ),
    ],
    rankingData: RankingData.named(
      options: {
        "H24": "24小时",
        "D7": "7天",
        "D30": "30天",
      },
      load: (options, page) {
        return picaClient.getLeaderboard(options);
      },
    ),
  ),
  searchPageData: SearchPageData.named(
    loadPage: (keyword, page, options) {
      return picaClient.search(keyword, options[0], page);
    },
    searchOptions: [
      SearchOptions.named(
        label: "排序",
        options: LinkedHashMap.of({
          "dd": "新到旧",
          "da": "旧到新",
          "ld": "最多喜欢",
          "vd": "最多指名",
        }),
      ),
    ],
  ),
  comicPageBuilder: (context, id, cover) => PicacgComicPage(id, cover),
);

const _categories = [
  "大家都在看",
  "大濕推薦",
  "那年今天",
  "官方都在看",
  "嗶咔漢化",
  "全彩",
  "長篇",
  "同人",
  "短篇",
  "圓神領域",
  "碧藍幻想",
  "CG雜圖",
  "英語 ENG",
  "生肉",
  "純愛",
  "百合花園",
  "耽美花園",
  "偽娘哲學",
  "後宮閃光",
  "扶他樂園",
  "單行本",
  "姐姐系",
  "妹妹系",
  "SM",
  "性轉換",
  "足の恋",
  "人妻",
  "NTR",
  "強暴",
  "非人類",
  "艦隊收藏",
  "Love Live",
  "SAO 刀劍神域",
  "Fate",
  "東方",
  "WEBTOON",
  "禁書目錄",
  "歐美",
  "Cosplay",
  "重口地帶"
];
