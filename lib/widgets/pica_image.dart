import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:moon_design/moon_design.dart';
import 'package:skana_pica/api/comic_sources/picacg/pica_api.dart';
import 'package:skana_pica/api/managers/image_cache_manager.dart'
    show downloadCacheManager, imagesCacheManager;

class PicaImage extends StatefulWidget {
  final String url;
  final Widget? placeWidget;
  final bool fade;
  final BoxFit? fit;
  final bool? enableMemoryCache;
  final double? height;
  final double? width;
  final String? host;
  final bool useProgressIndicator;
  final bool downloaded;

  const PicaImage(this.url,
      {super.key, this.placeWidget,
      this.fade = true,
      this.fit,
      this.enableMemoryCache,
      this.height,
      this.host,
      this.width,
      this.useProgressIndicator = false,
      this.downloaded = false});

  @override
  State<PicaImage> createState() => _PicaImageState();
}

class _PicaImageState extends State<PicaImage> {
  late String url;
  bool already = false;
  bool? enableMemoryCache;
  double? width;
  double? height;
  BoxFit? fit;
  bool fade = true;
  Widget? placeWidget;

  @override
  void initState() {
    url = widget.url;
    enableMemoryCache = widget.enableMemoryCache ?? true;
    width = widget.width;
    height = widget.height;
    fit = widget.fit;
    fade = widget.fade;
    placeWidget = widget.placeWidget;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant PicaImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      setState(() {
        url = widget.url;
        width = widget.width;
        height = widget.height;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (url == defaultAvatarUrl) {
      return Image.asset("assets/images/avatar/default.png",
          width: width, height: height, fit: fit);
    }
    if (url == errorLoadingUrl) {
      return Stack(
        children: [
          Container(
            width: width,
            height: height,
            color: Get.theme.colorScheme.surface.withValues(alpha: 0.5),
          ),
          Center(
            child: TextButton(
              onPressed: () {
                setState(() {});
              },
              child: Icon(Icons.error_outline_sharp),
            ),
          ),
        ],
      );
    }
    if(url.isEmpty) {
      return placeWidget ?? Container(height: height);
    }
    return CachedNetworkImage(
        placeholder: widget.useProgressIndicator
            ? null
            : (context, url) => widget.placeWidget ?? Container(height: height),
        errorWidget: (context, url, _) => SizedBox(
              height: height,
              child: Center(
                child: TextButton(
                  onPressed: () {
                    setState(() {});
                  },
                  child: Icon(Icons.error_outline_sharp),
                ),
              ),
            ),
        progressIndicatorBuilder: widget.useProgressIndicator
            ? (context, url, progress) => SizedBox(
                  height: height,
                  width: width,
                  child: Center(
                    child: MoonCircularProgress(
                      value: progress.progress!,
                      color: context.moonTheme?.tokens.colors.piccolo,
                    ),
                  ),
                )
            : null,
        fadeOutDuration:
            widget.fade ? const Duration(milliseconds: 1000) : null,
        // memCacheWidth: width?.toInt(),
        // memCacheHeight: height?.toInt(),
        imageUrl: url,
        cacheManager: widget.downloaded? downloadCacheManager : imagesCacheManager,
        height: height,
        width: width,
        fit: fit ?? BoxFit.fitWidth);
  }
}
