class Config {
  static String get BaseUrl => "http://68.183.234.72/"; // # 获得ip列表接口
  static String get Url => "https://picaapi.picacomic.com/"; //# 域名
  static String get NewChatUrl => "https://live-server.bidobido.xyz/"; // # 域名
  static String get ApiKey => "C69BAF41DA5ABD1FFEDC6D2FEA56B"; //# apiKey
  static String get AppChannel => "3";
  static String get Version => "2.2.1.3.3.4"; // # 版本号
  static String get BuildVersion => "45";
  static String get Accept => "application/vnd.picacomic.com.v1+json";
  static String get Agent => "okhttp/3.8.1";
  static String get Platform => "android";
  static String get ImageQuality =>
      "original"; //# 画质，original, low, medium, high
  static String get Uuid => "defaultUuid";

  static String get ProjectName => "PicACG";
  static int get ThreadNum => 10; //# 线程
  static int get DownloadThreadNum => 5; //# 下载线程
  static int get ResetDownloadCnt => 5; //# 下载图片重试次数
  static int get ResetDownloadCntDefault => 2; //# 下载封面重试次数

  static int get ConvertThreadNum => 3; // # 同时转换数量
  static String get ChatSavePath => "chat";
  static String get SavePathDir => "commies"; //# 下载目录
  static int get ResetCnt => 5; // # 下载重试次数

  static bool get IsUseCache => true; //# 是否使用cache
  static String get CachePathDir => "cache"; //# cache目录
//# CacheExpired = 24 * 60 * 60  # cache过期时间24小时
  static int get PreLoading => 10; //# 预加载5页
  static int get PreLook => 4; // # 预显示
  static bool get IsLoadingPicture => true;

  static String get AppUrl => "https://app.ggo.icu/PicACG";

  static String get UpdateUrlBack => "https://github.com/tonquer/picacg-qt";
  static String get UpdateUrl2Back => "https://hub.ggo.icu/tonquer/picacg-qt";
  static String get UpdateUrl3Back =>
      "https://hub.fastgit.xyz/tonquer/picacg-qt";

  static String get DatabaseUpdate =>
      "https://raw.ggo.icu/bika-robot/picacg-database/main/version3.txt";
  static String get DatabaseDownload =>
      "https://raw.ggo.icu/bika-robot/picacg-database/main/data3/";

  static String get DatabaseUpdate2 =>
      "https://raw.githubusercontent.com/bika-robot/picacg-database/main/version3.txt";
  static String get DatabaseDownload2 =>
      "https://raw.githubusercontent.com/bika-robot/picacg-database/main/data3/";

  static String get DatabaseUpdate3 =>
      "https://raw.fastgit.org/bika-robot/picacg-database/main/version3.txt";
  static String get DatabaseDownload3 =>
      "https://raw.fastgit.org/bika-robot/picacg-database/main/data3/";

  static String get Issues1 => "https://github.com/tonquer/picacg-qt/issues";
  static String get Issues2 => "https://hub.ggo.icu/tonquer/picacg-qt/issues";
  static String get Issues3 =>
      "https://hub.fastgit.xyz/tonquer/picacg-qt/issues";

  static String get UpdateVersion => "v1.5.1.1";
  static String get RealVersion => "v1.5.1.1";
  static String get TimeVersion => "2024-10-29";
  static String get DbVersion => "";

//# waifu2x
  static String get Waifu2xVersion => "1.2.0";

  static bool get CloseWaifu2x => false;
  static bool get CanWaifu2x => true;
  static String get ErrorMsg => "";

  static int get Encode => 0; //# 当前正在使用的索引
  static int get UseCpuNum => 0;
  static String get EncodeGpu => "";

  static String get Format => "jpg";
  static String get Waifu2xPath => "waifu2x";

  static int get IsTips => 1;
//# 代理与分流相关
  static String get ProxyUrl1 =>
      "https://github.com/tonquer/picacg-qt/discussions/48";
  static String get ProxyUrl2 =>
      "https://hub.ggo.icu/tonquer/picacg-qt/discussions/48";
  static String get ProxyUrl3 =>
      "https://hub.fastgit.xyz/tonquer/picacg-qt/discussions/48";
//# Waifu2x相关
  static String get Waifu2xUrl =>
      "https://github.com/tonquer/picacg-qt/discussions/76";

  static String get ProxyApiDomain => "bika-api.ggo.icu";
  static String get ProxyImgDomain => "bika-img.ggo.icu";

  static String get ProxyApiDomain2 => "bika2-api.ggo.icu";
  static String get ProxyImgDomain2 => "bika2-img.ggo.icu";

  static List<String> get ApiDomain =>
      ["picaapi.picacomic.com", "post-api.wikawika.xyz"];

  static List<String> get ImageDomain => [
        "s3.picacomic.com",
        "s2.picacomic.com",
        "storage.diwodiwo.xyz",
        // "img.diwodiwo.xyz",
        "storage1.picacomic.com",
        // "img.tipatipa.xyz",
        // "img.picacomic.com",
        "storage.tipatipa.xyz",
        // "pica-pica.wikawika.xyz",
        "www.picacomic.com",
        "storage-b.picacomic.com",
      ];
//# Address = ["188.114.98.153", "104.21.91.145"]  # 分类2，3 Ip列表
//# AddressIpv6 = ["2606:4700:d:28:dbf4:26f3:c265:73bc", "2a06:98c1:3120:ca71:be2c:c721:d2b5:5dbf"]

//# ImageServer2 = 's3.picacomic.com'          # 分流2 使用的图片服务器
//# ImageServer2Jump = 'img.picacomic.com'          # 分流2 跳转的图片服务器

//# ImageServer3 = 'storage.diwodiwo.xyz'          # 分流3 使用的图片服务器
//# ImageServer3Jump = 'img.diwodiwo.xyz'          # 分流3 使用的图片服务器
}
