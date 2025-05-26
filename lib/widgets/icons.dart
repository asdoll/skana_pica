import 'package:bootstrap_icons/bootstrap_icons.dart';
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

Widget progressIndicator(BuildContext context, {Color? color, double? size, Duration? duration}) {
  return SpinKitPulse(
    size: size ?? 30,
    color: color ?? context.moonTheme?.tokens.colors.bulma,
    duration: duration ?? const Duration(milliseconds: 1000),
  );
}
