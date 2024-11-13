import 'package:path_provider/path_provider.dart';

class Base {
    /// Path to store app cache.
  ///
  /// **Warning: The end of String is not '/'**
  static late final String cachePath;

  /// Path to store app data.
  ///
  /// **Warning: The end of String is not '/'**
  static late final String dataPath;

  static Future<void> init() async {
    cachePath = (await getApplicationCacheDirectory()).path;
    dataPath = (await getApplicationSupportDirectory()).path;
  }

}

const String webUA =
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36";

class Appdata {
  ///搜索历史
  List<String> searchHistory = [];
  Set<String> favoriteTags = {};

  ///设置
  List<String> settings = [
    "1", //0 点击屏幕左右区域翻页
    "dd", //1 排序方式
    "1", //2 启动时检查更新
    "0", //3 Api请求地址, 为0时表示使用哔咔官方Api, 为1表示使用转发服务器
    "1", //4 宽屏时显示前进后退关闭按钮
    "1", //5 是否显示头像框
    "1", //6 启动时签到
    "1", //7 使用音量键翻页
    "0", //8 代理设置, 0代表使用系统代理
    "1", //9 翻页方式: 1从左向右,2从右向左,3从上至下,4从上至下(连续)
    "0", //10 是否第一次使用
    "0", //11 收藏夹浏览方式, 0为正常浏览, 1为分页浏览
    "0", //12 阻止屏幕截图
    "0", //13 需要生物识别
    "1", //14 阅读器中保持屏幕常亮
    "0", //15 Cloudflare IP, //为1表示使用哔咔官方提供的Ip, 为0表示禁用, 其他值表示使用自定义的Ip(废弃)
    "0", //16 Jm分类漫画排序模式, 值为 ComicsOrder 的索引
    "0", //17 Jm分流
    "0", //18 夜间模式降低图片亮度
    "0", //19 Jm搜索漫画排序模式, 值为 ComicsOrder 的索引
    "0", //20 Eh画廊站点, 1表示e-hentai, 2表示exhentai
    "111111", //21 启用的漫画源
    "", //22 下载目录, 仅Windows端, 为空表示使用App数据目录
    "0", //23 初始页面,
    "1111111111", //24 [废弃]分类页面
    "0", //25 漫画列表显示模式
    "00", //26 已下载页面排序模式: 时间, 漫画名, 作者名, 大小
    "0", //27 颜色
    "2", //28 预加载页数
    "0", //29 eh优先加载原图
    "1", //30 picacg收藏夹新到旧
    "https://www.wnacg.com", //31 绅士漫画域名
    "0", //32  深色模式: 0-跟随系统, 1-禁用, 2-启用
    "5", //33 自动翻页时间
    "1000", //34 缓存数量限制
    "500", //35 缓存大小限制
    "1", //36 翻页动画
    "0", //37 禁漫图片分流
    "0", //38 高刷新率
    "0", //39 nhentai搜索排序
    "25", //40 点按翻页识别范围(0-50),
    "0", //41 阅读器图片布局方式, 0-contain, 1-fitWidth, 2-fitHeight
    "0", //42 禁漫收藏夹排序模式, 0-最新收藏, 1-最新更新
    "1", //43 限制图片宽度
    "0,1.0", //44 comic display type
    "", //45 webdav
    "0", //46 webdav version
    "0", //47 eh warning
    "https://nhentai.net", //48 nhentai domain
    "1", //49 阅读器中双击放缩
    "", //50 language, empty=system
    "", //51 默认收藏夹
    "1", //52 favorites
    "0", //53 本地收藏添加位置(尾/首)
    "0", //54 阅读后移动本地收藏(否/尾/首)
    "1", //55 长按缩放
    "https://18comic.vip", //56 jm domain
    "1", //57 show page info in reader
    "0", //58 hosts
    "012345678", //59 explore page(废弃)
    "0", //60 action when local favorite is tapped
    "0", //61 check link in clipboard
    "10000", //62 漫画信息页面工具栏: "快速收藏".tl, "复制标题".tl, "复制链接".tl, "分享".tl, "搜索相似".tl
    "0", //63 初始搜索目标
    "0", //64 启用侧边翻页
    "0", //65 本地收藏显示数量
    "0", //66 缩略图布局: 覆盖, 容纳
    "picacg,ehentai,jm,htmanga,nhentai", //67 分类页面
    "picacg,ehentai,jm,htmanga,nhentai", //68 收藏页面
    "0", //69 自动添加语言筛选
    "0", //70 反转点按识别
    "1", // 71 关联网络收藏夹后每次刷新拉取几页
    "1", //72 漫画块显示收藏状态
    "0", //73 漫画块显示阅读位置
    "1.0", //74 图片收藏大小
    "", //75 eh profile
    "0", //76 阅读器内固定横屏
    "picacg,Eh主页,Eh热门,禁漫主页,禁漫最新,hitomi,绅士漫画,nhentai", //77 探索页面
    "0", //78 已下载的eh漫画优先显示副标题
    "6", //79 下载并行
    "1", //80 启动时检查自定义漫画源的更新
    "0", //81 使用深色背景
    "111111", //82 内置漫画源启用状态,
    "1", //83 完全隐藏屏蔽的作品
  ];


  /// 隐式数据, 用于存储一些不需要用户设置的数据, 此数据通常为某些组件的状态, 此设置不应当被同步
  List<String> implicitData = [
    "1;;", //收藏夹状态
    "0", // 双页模式下第一页显示单页
    "0", // 点击关闭按钮时不显示提示
    webUA, // UA
  ];
}

var appdata = Appdata();