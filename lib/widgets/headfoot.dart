import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:skana_pica/util/widget_utils.dart';

class DefaultHeaderFooter {
  static Header header(BuildContext context,
      {IndicatorPosition position = IndicatorPosition.above,
      bool safeArea = true}) {
    return BezierHeader(
      position: position,
      triggerOffset: 50,
      safeArea: safeArea,
      processedDuration: Duration(milliseconds: 50),
      spinWidget: SpinKitPulse(
        color: context.colorScheme.primary,
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
        noMoreText: "No more".tr,);
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
          child: SpinKitFadingFour(size: 40, color: context.colorScheme.primary),
        );
      },
    );
  }

  static Widget progressIndicator(BuildContext context, {Color? color}) {
    return SpinKitFadingFour(size: 40);
  }
}
