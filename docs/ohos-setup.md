# OHOS (HarmonyOS) 构建说明

记录 skana_pica 适配 OHOS 时改动了什么、为什么改，以及在新机器上怎么复现。
可参考同目录风格：[PiliPlusX/docs/ohos-adaptation.md](../../PiliPlusX/docs/ohos-adaptation.md)。

## 前置条件

- **Flutter SDK 必须是 OHOS 分支**（`flutter_flutter`），不是官方 Flutter：
  `flutter --version` 应显示 `3.41.10-ohos-1.0.1` 之类，且 `flutter doctor` 里有
  `HarmonyOS toolchain` 一项。
- DevEco Studio（提供 `hwsdk.dir`、ohpm、hvigorw）。`ohos/local.properties` 已经指向
  `/Applications/DevEco-Studio.app/Contents/sdk`。

## 依赖：为什么需要 dependency_overrides

上游包大多没有 OHOS 实现，或者只在某个 fork 里有。这些 fork 只能写在
`dependency_overrides` 里，因为像 `flutter_cache_manager`、`cached_network_image`
这类包会按名字依赖 pub.dev 上的 `path_provider`，而 pub 不允许同一个包名同时来自两个源。

| 包 | 来源 | 原因 |
| --- | --- | --- |
| `path_provider` / `shared_preferences` / `url_launcher` | openharmony-tpc/flutter_packages | OHOS 实现 |
| `share_plus` | openharmony-sig/flutter_plus_plugins | OHOS 实现（`Share.shareXFiles` 等已废弃 API 仍在，调用点无需改） |
| `image_gallery_saver_plus` | CPF-Flutter | OHOS 走 `photoAccessHelper.showAssetsCreationDialog`，**不需要相册权限** |
| `sqlite3` / `sqlite3_flutter_libs` | SageMik/sqlite3-ohos.dart | 给 ffi loader 加 `OperatingSystem.ohos` |
| `flutter_secure_storage_ohos` | CPF-Flutter | 见下 |
| `moon_design` | asdoll/moon_flutter（普通 dependency） | 见下 |
| `google_fonts` | pub.dev `^8.2.1` | 见下 |

### 两个需要解释的改动

**`moon_design`**：pub.dev 上的 1.1.0 对 `TargetPlatform` 做了穷举 `switch`
但没有 `TargetPlatform.ohos` 分支，OHOS 目标下直接编译报错。asdoll 的 fork 只补了缺的
case，其它平台行为不变，所以固定在那个 revision 上。

**`google_fonts`**：6.2.1 用 `FontWeight` 当 `const` map 的 key，而 dart:ui 的
`FontWeight` 重写了 `==`，常量求值会拒绝（`does not have a primitive operator '=='`）。
8.x 把那个 map 改成了 `final`，所以升到 `^8.2.1`（用到的
`GoogleFonts.notoSansTextTheme` / `GoogleFonts.notoSans()` API 没变）。

**`flutter_secure_storage`**：上游是 federated 插件，没有任何 OHOS 实现；gitee/pub
上那个同名包要求 Dart < 3（本项目是 3.11，用不了）。所以引入 CPF-Flutter fork 的
`flutter_secure_storage_ohos`。

注意**不能**只借它的原生插件、Dart 侧继续用上游 `flutter_secure_storage`：上游的
`_selectOptions` 是一串 `Platform.isLinux/isIOS/isAndroid/isWindows/isMacOS`，OHOS 会
掉进 `throw UnsupportedError('unsupported_platform')`，启动时 `readAll()` 直接抛异常
（`flutter_secure_storage.dart:325`）。fork 的 Dart 侧在这条链上补了
`Platform.operatingSystem == 'ohos'`，所以 Dart 也必须用 fork 的。

两者服务同一个 method channel（`plugins.it_nomads.com/flutter_secure_storage`，
见其 `FlutterSecureStorageOhosPlugin.ets`），差别只在 option 映射。因此
`lib/config/secure_store.dart` 做了一个 `SecureStore` 门面，按 `Platform.isOhos`
选实现，只暴露 App 真正用的 `readAll` / `write` / `deleteAll`，把两套 option 类挡在外面。
`lib/config/setting.dart` 只用这个门面，其余代码不受影响。

### 该 fork 的 `readAll` 是坏的，门面里绕过了它

原生侧写、读、删对 key 的处理是一致的：`FlutterSecureStorageOhosPlugin.getKeyFromCall`
把 key 统一变成 `<prefix>_<key>`（`ELEMENT_PREFERENCES_KEY_PREFIX + '_' + key`）。
但枚举不是：

```ets
// FlutterSecureStorage.ets:136
if (keyWithPrefix.includes(this.getKeyPrefix)) {
  const identifier = rawKey.split('_')[1];   // ← 错在这里
```

存进去的 key 是 `<prefix>_picacg_account`，`split('_')` 得到
`[<prefix>, 'picacg', 'account']`，取 `[1]` 就是 `picacg`。于是
`picacg_account` / `picacg_password` / `picacg_token` 三份数据全部塌成同一个
`picacg` 键，而 App 读的是 `settings.cookies["picacg_account"]`，永远拿不到 ——
表现就是“登录后重启又变回未登录”。

所以 `OhosSecureStorage.readAll()` 不调插件自己的 `readAll`，改成自己维护一份 key 索引
（`__keys__`，存在同一套加密存储里），逐个 `read(key)` 取回。`write` / `read` /
`delete` 三者的前缀是一致的，只有枚举坏，所以这样绕开是安全的。索引的读-改-写用
一个 `_tail` 链串行化，因为 `Appdata.saveSecures` 会连续发起多次 `write`。

`deleteAll()` 仍然走原生实现：它按 `includes(getKeyPrefix)` 过滤，索引键同样带前缀，
会一起被清掉。

顺带把 `saveSecures` 里的 `write` 改成 `await`（并在 `pica_api.dart` 里 await 调用）：
之前是 fire-and-forget，OHOS 下每次 `write` 变成索引读-改-写，不等待更容易丢。

### 没有 OHOS 实现的包

- `permission_handler`：只在 `lib/util/tool.dart` 里给 iOS 用（`Platform.isIOS` 守卫），
  OHOS 上永远不会调用，插件被 Flutter 工具跳过即可。
- `flutter_displaymode`：只有 Android 实现，`main.dart` / `setting_controller.dart`
  里都用 `Platform.isAndroid` 守卫住了。
- `sqflite`：`flutter_cache_manager` 的传递依赖。本项目两个 cache manager 都显式传了
  `repo: JsonCacheInfoRepository(...)`，元数据走 JSON 文件而不是 sqflite，所以运行时用不到。

## 本地补丁：`third_party/photo_view`

`photo_view` 用的是 wgh136/photo_view（App 需要它的 `customChild`），本来以 git 依赖引入，
现在改成 `path: third_party/photo_view` 的 vendored 副本，因为它带了一个本地修复。

问题出在 `lib/src/core/image.dart` 的 `_handleImageFrame`：

```dart
if (!isOnLoadEndCalled) {
  scheduleMicrotask(() {
    isOnLoadEndCalled = true;   // 在 microtask 里才置位
    widget.onLoadEnd?.call(...);
  });
}
```

标志位在 microtask **内部**才置位，所以在同一个事件循环 tick 里触发两次 `onImage`
（先命中图片缓存的同步回调，再是解码完成的那一帧）时，两次都会读到 `false`、各排一个
microtask，`onLoadEnd` 就跑了两遍。HarmonyOS 上稳定复现，于是
`PhotoViewCoreState._onLoadEnd` 抛 `LateInitializationError: Field 'imageSize' has
already been initialized`（它赋值的是 `late final` 的 `imageSize` / `imageScale`）。

修复就是把置位提到 `scheduleMicrotask` **之前**，让守卫变成同步的。

注意上游 `main`（`a1255d1b`）**仍然有这个 bug**，没有可升级的 ref，所以只能 vendored。
改动处留了注释说明原因。`analysis_options.yaml` 里加了 `analyzer.exclude: [third_party/**]`，
避免 vendored 代码被本项目的 lint 规则刷屏。

## 数据存储：OHOS 走 sqlite3，其它平台仍走 objectbox

objectbox **完全没有** OHOS 原生库（`objectbox_flutter_libs` 没有 `ohos/` 目录，
gitcode/pub 上也搜不到适配）。所以：

- `lib/api/managers/store.dart` 定义 `AppStore` 抽象接口。
- `lib/api/managers/objectbox.dart`：`ObjectBox implements AppStore`，Android/iOS/
  macOS/Windows/Linux 继续用，**已有用户数据不受影响**。
- `lib/api/managers/sqlite_store.dart`：OHOS 用，sqlite3 落盘。三个 entity 存成
  带 JSON payload 列的行——因为 App 从不按 comic 的单个字段查询，只按 `comicid` 查、
  按 `timestamp`/`id` 排序，那两列是真实列，其余塞 JSON。
- `lib/api/managers/history_manager.dart` 按 `Platform.isOhos` 二选一。

`objectbox_models.dart` 里的 model 两边共用：`ToOne` / `ToMany` 是纯 Dart 对象，没有
存活的 Store 也能正常读写，所以 sqlite 后端从磁盘重建 `DownloadTask` 后，现有调用方
（`downloadstore.dart` 等）一行都不用改。

## `ohos/build-profile.json5` 不在版本库里

它被 `.gitignore` 排除了（和 skana_pix 一致），因为里面会写入本机签名材料的绝对路径和
DevEco 加密过的密码。**在新机器上需要自己创建**，内容至少要包含 `useNormalizedOHMUrl`：

```json5
{
  "app": {
    "signingConfigs": [],
    "products": [
      {
        "name": "default",
        "signingConfig": "default",
        "compatibleSdkVersion": "5.0.5(17)",
        "targetSdkVersion": "26.0.0",
        "runtimeOS": "HarmonyOS",
        "buildOption": {
          "strictMode": {
            // 必须开。sqlite3_flutter_libs(OHOS) 会带进 sqlite3-native-library
            // 这个 bytecode HAR，不开 hvigor 会报 00306046。
            "useNormalizedOHMUrl": true
          }
        }
      }
    ],
    "buildModeSet": [{"name": "debug"}, {"name": "profile"}, {"name": "release"}]
  },
  "modules": [
    {
      "name": "entry",
      "srcPath": "./entry",
      "targets": [{"name": "default", "applyToProducts": ["default"]}]
    }
  ]
}
```

## 调试签名（必须手动做一次）

`signingConfigs` 为空时：

- hvigor 仍然能构建，产物是
  `ohos/entry/build/default/outputs/default/entry-default-unsigned.hap`；
- 但 flutter 工具会拒绝报成功，并提示：

  > 请通过DevEco Studio打开ohos工程后配置调试签名(File -> Project Structure ->
  > Signing Configs 勾选Automatically generate signature)

这是 flutter 工具的 `checkOhosSignedInfo()` 硬性要求（`signingConfigs` 非空才放行）。
签名材料必须由 DevEco 生成，理由是：

- `.cer` / `.p7b` 由华为签发，本地造不出来（`~/.ohos/config/` 下现有的三个 profile
  分别绑定了 `com.skanaone.skana_pix`、`com.example.piliplusx`、`com.example.hello`，
  没有 `com.skanaone.skana_pica`，bundle name 对不上不能复用）；
- hvigor 26 要求 `storePassword` / `keyPassword` 是 DevEco 加密后的串（长度 ≥ 32），
  明文密码会被 `00303116` 拒绝；
- SDK 里的 `OpenHarmony.p12` 默认材料同理过不了密码校验。

所以最后一步是：用 DevEco Studio 打开 `ohos/` 目录 →
`File -> Project Structure -> Signing Configs` → 勾选
`Automatically generate signature`。它会为 `com.skanaone.skana_pica` 注册应用、
下载调试 profile，并重写 `signingConfigs`（`type` 变成 `HarmonyOS`，
路径指向 `~/.ohos/config`）。之后 `flutter build hap` 就能通过，HAP 也能装到真机。

## 保存图片：图库 title 不能带扩展名

`image_gallery_saver_plus` 的 OHOS 实现把 Dart 传的 `name` 直接当成
`PhotoCreationConfig.title` 交给 `showAssetsCreationDialog`。这个 title 有两条硬性要求：

1. **不能带扩展名**（扩展名是通过 `fileNameExtension` 单独传的）；
2. 不能包含 `\ / : * ? " ' < > | { } [ ]` 这些字符。

违反任意一条时 `showAssetsCreationDialog` 会**静默失败**：确认弹窗根本不出现、什么都
不保存，而 channel 调用本身还是成功的 —— 界面上就是「点了保存没反应，也没有报错」。
pixiv 的图片文件名以 `.jpg` 结尾，正好踩中第 1 条。

`lib/util/tool.dart` 里：

- `_galleryTitle()` 去掉扩展名并替换非法字符（仅 OHOS 调用）；
- `_saveToGallery()` 把保存串行化 —— OHOS 实现对并发调用会返回 `Busy`
  PlatformException，而且每次保存都可能停在系统弹窗上等用户确认；
- 加 90 秒超时，避免弹窗不返回时把队列永久堵死；
- 检查返回的 `isSuccess`（shape 是 `{filePath, errorMessage, isSuccess}`，
  缺字段按失败处理），而不是只看有没有抛异常。

## 构建

```sh
flutter pub get
flutter build hap --debug     # 或 --release
```

产物在 `ohos/entry/build/default/outputs/default/`。
