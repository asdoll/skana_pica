import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:moon_design/moon_design.dart';
import 'package:skana_pica/api/managers/image_cache_manager.dart';
import 'package:skana_pica/controller/comiclist.dart' show errorUrl;
import 'package:skana_pica/controller/main_controller.dart';
import 'package:skana_pica/pages/mainscreen.dart';

class CommonBackArea extends StatefulWidget {
  const CommonBackArea({super.key});

  @override
  State<CommonBackArea> createState() => _CommonBackAreaState();
}

class _CommonBackAreaState extends State<CommonBackArea> {
  bool _isLongPress = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: IconButton(
        icon: Icon(
          _isLongPress ? BootstrapIcons.house : BootstrapIcons.arrow_left,
          color: context.moonTheme?.tokens.colors.bulma,
          size: 20,
        ),
        onPressed: () {
          Get.back();
        },
      ),
      onLongPress: () {
        setState(() {
          _isLongPress = true;
        });
        Get.offAll(() => const Mains());
      },
    );
  }
}

class NormalBackButton extends StatelessWidget {
  const NormalBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return MoonButton.icon(
      onTap: () {
        Get.back();
      },
      icon: Icon(
        BootstrapIcons.arrow_left,
        color: context.moonTheme?.tokens.colors.bulma,
        size: 20,
      ),
    );
  }
}

class NormalDrawerButton extends StatelessWidget {

  final VoidCallback onTap;
  
  const NormalDrawerButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return MoonButton.icon(
      onTap: onTap, 
      icon: Icon(
        BootstrapIcons.justify,
        color: context.moonTheme?.tokens.colors.bulma,
        size: 20,
      ),
    );
  }
}

class GoTop extends StatelessWidget {
  
  const GoTop({super.key, this.scrollController});

  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    final controller = scrollController ?? globalScrollController;
    return Obx(() => AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: (homeController.showBackArea.value && controller.offset > 0)
              ? MoonButton.icon(
                  buttonSize: MoonButtonSize.lg,
                  showBorder: true,
                  borderColor: Get
                      .context?.moonTheme?.buttonTheme.colors.borderColor
                      .withValues(alpha: 0.5),
                  backgroundColor: Get.context?.moonTheme?.tokens.colors.zeno,
                  onTap: () {
                    controller.animateTo(0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut);
                  },
                  icon: Icon(
                    Icons.arrow_upward,
                    color: Colors.white,
                  ),
                )
              : Container(),
        ));
  }
}

class ErrorLoading extends StatelessWidget {
  final String text;

  const ErrorLoading({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(image: imageProvider(errorUrl), width: 50, height: 50),
          SizedBox(
            height: 10,
          ),
          Text(
            text,
            style: Get.textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}

class DefaultHeaderFooter {
  static Header header(BuildContext context,
      {IndicatorPosition position = IndicatorPosition.above,
      bool safeArea = true}) {
    return BezierHeader(
      position: position,
      triggerOffset: 50,
      safeArea: safeArea,
      processedDuration: Duration(milliseconds: 50),
      backgroundColor: context.moonTheme?.tokens.colors.trunks,
      spinWidget: SpinKitPulse(
        color: context.moonTheme?.tokens.colors.bulma,
      ),
    );
  }

  static Footer footer(BuildContext context,
      {IndicatorPosition position = IndicatorPosition.above}) {
    return ClassicFooter(
        position: position,
        processingText: "Loading".tr,
        failedText: "Failed".tr,
        showMessage: false,
        processedText: "Successed".tr,
        processedDuration: Duration.zero,
        noMoreText: "No more".tr,
        textStyle: context.moonTheme?.tokens.typography.heading.text14.apply(
          color: context.moonTheme?.tokens.colors.bulma,
        ),
        messageStyle: context.moonTheme?.tokens.typography.heading.text12.apply(
          color: context.moonTheme?.tokens.colors.bulma,
        ));
  }

  static Header refreshHeader(BuildContext context) {
    return BuilderHeader(
      triggerOffset: 70,
      clamping: true,
      position: IndicatorPosition.above,
      processedDuration: Duration.zero,
      builder: (ctx, state) {
        if (state.mode == IndicatorMode.inactive ||
            state.mode == IndicatorMode.done) {
          return const SizedBox();
        }
        return Container(
          padding: const EdgeInsets.only(bottom: 100),
          width: double.infinity,
          height: state.viewportDimension,
          alignment: Alignment.center,
          child: SpinKitFadingFour(
            size: 40,
            color: context.moonTheme?.tokens.colors.bulma,
          ),
        );
      },
    );
  }

  static Widget progressIndicator(BuildContext context, {Color? color}) {
    return SpinKitFadingFour(
      size: 30,
      color: color ?? context.moonTheme?.tokens.colors.bulma,
    );
  }
}