import 'package:get/get.dart';
import 'package:moon_design/moon_design.dart';
import 'package:flutter/material.dart';
import 'package:skana_pica/controller/main_controller.dart';

// ignore: must_be_immutable
class GoTop extends StatelessWidget {
  GoTop({super.key, this.scrollController});

  ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    scrollController ??= globalScrollController;
    return Obx(() => AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: (homeController.showBackArea.value && scrollController!.offset > 0)
              ? MoonButton.icon(
                  buttonSize: MoonButtonSize.lg,
                  showBorder: true,
                  borderColor: Get
                      .context?.moonTheme?.buttonTheme.colors.borderColor
                      .withValues(alpha: 0.5),
                  backgroundColor: Get.context?.moonTheme?.tokens.colors.zeno,
                  onTap: () {
                    scrollController?.animateTo(0,
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
