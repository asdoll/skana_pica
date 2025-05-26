import 'dart:async';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show clampDouble;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skana_pica/util/widgetplugin.dart';
import 'package:skana_pica/widgets/icons.dart';

class BezierIndicator extends StatefulWidget {
  final Widget child;
  final IndicatorController? controller;
  final Future<void> Function() onRefresh;

  const BezierIndicator({
    super.key,
    required this.child,
    this.controller,
    required this.onRefresh,
  });

  @override
  State<BezierIndicator> createState() => _BezierIndicatorState();
}

class _BezierIndicatorState extends State<BezierIndicator>
    with SingleTickerProviderStateMixin {
  static const _animationDuration = Duration(milliseconds: 300);

  IndicatorState _mode = IndicatorState.idle;

  Axis get _axis => Axis.vertical;

  double get _offset => 50.0;

  double get _actualTriggerOffset => 50.0;

  bool get _reverse => false;

  /// Animation controller.
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: _animationDuration);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Mode change listener.
  void _onModeChange(IndicatorState mode) {
    if (mode == IndicatorState.settling || mode == IndicatorState.loading) {
      if (!_animationController.isAnimating) {
        _animationController.forward(from: 0);
      }
    } else {
      if (_animationController.isAnimating) {
        _animationController.stop();
      }
    }
  }

  /// Build spin widget.
  Widget _buildSpin() {
    Widget spinWidget = progressIndicator(context);
    Widget animatedWidget = AnimatedBuilder(
      animation: _animationController,
      builder: (context, _) {
        return Transform.scale(
          scale: 1,
          child: spinWidget,
        );
      },
    );
    return Positioned(
      top: (_axis == Axis.vertical && !_reverse)
          ? -(_actualTriggerOffset - _offset) / 2
          : null,
      bottom: (_axis == Axis.vertical && _reverse)
          ? -(_actualTriggerOffset - _offset) / 2
          : null,
      left: (_axis == Axis.horizontal && !_reverse)
          ? -(_actualTriggerOffset - _offset) / 2
          : null,
      right: (_axis == Axis.horizontal && _reverse)
          ? -(_actualTriggerOffset - _offset) / 2
          : null,
      height: _axis == Axis.vertical ? _actualTriggerOffset : null,
      width: _axis == Axis.vertical ? null : _actualTriggerOffset,
      child: Center(
        child: animatedWidget,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomRefreshIndicator(
      controller: widget.controller,
      offsetToArmed: _actualTriggerOffset,
      onRefresh: widget.onRefresh,
      onStateChanged: (change) {
        setState(() {
          _mode = change.newState;
        });
        _onModeChange(change.newState);
      },
      builder: (
        BuildContext context,
        Widget child,
        IndicatorController controller,
      ) {
        return Stack(
          children: <Widget>[
            AnimatedBuilder(
              animation: controller,
              builder: (BuildContext context, Widget? _) {
                return SizedBox(
                    height: controller.value * _actualTriggerOffset,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: _axis == Axis.vertical
                              ? double.infinity
                              : _offset,
                          height: _axis == Axis.horizontal
                              ? double.infinity
                              : _offset,
                        ),
                        if (_mode == IndicatorState.settling ||
                            _mode == IndicatorState.loading ||
                            _mode == IndicatorState.dragging ||
                            _mode == IndicatorState.armed)
                          _buildSpin(),
                      ],
                    ));
              },
            ),
            AnimatedBuilder(
              builder: (context, _) {
                return Transform.translate(
                  offset: Offset(0.0, controller.value * _actualTriggerOffset),
                  child: child,
                );
              },
              animation: controller,
            ),
          ],
        );
      },
      child: widget.child,
    );
  }
}

const double _kActivityIndicatorRadius = 40.0;
const double _kActivityIndicatorMargin = 10.0;

Widget buildRefreshIndicator(
  BuildContext context,
  RefreshIndicatorMode refreshState,
  double pulledExtent,
  double refreshTriggerPullDistance,
  double refreshIndicatorExtent,
) {
  final double percentageComplete = clampDouble(
    pulledExtent / refreshTriggerPullDistance,
    0.0,
    1.0,
  );

  return Center(
    child: Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        Positioned(
          top: _kActivityIndicatorMargin,
          left: 0.0,
          right: 0.0,
          child: _buildIndicatorForRefreshState(
            refreshState,
            _kActivityIndicatorRadius,
            percentageComplete,
          ),
        ),
      ],
    ),
  );
}

Widget _buildIndicatorForRefreshState(
  RefreshIndicatorMode refreshState,
  double radius,
  double percentageComplete,
) {
  switch (refreshState) {
    case RefreshIndicatorMode.drag:
      const Curve opacityCurve = Interval(0.0, 0.35, curve: Curves.easeInOut);
      return Opacity(
        opacity: opacityCurve.transform(percentageComplete),
        child: progressIndicator(
          Get.context!,
          size: radius,
          duration: const Duration(milliseconds: 500),
        ),
      );
    case RefreshIndicatorMode.armed:
    case RefreshIndicatorMode.refresh:
      return progressIndicator(
        Get.context!,
        size: radius,
      );
    case RefreshIndicatorMode.done:
      return progressIndicator(
        Get.context!,
        size: radius * percentageComplete,
      );
    case RefreshIndicatorMode.inactive:
      return const SizedBox.shrink();
  }
}

enum LoadingState {
  /// didn't load or success
  idle,
  loading,
  error,

  /// loaded and there isn't any data
  noData,

  /// loaded several pages and there isn't no more data
  noMore,
  success,
}

typedef ErrorTapCallback = void Function();
typedef NoDataTapCallback = void Function();
typedef WidgetBuilder = Widget Function();

/// A widget that change itself when [loadingState] changes
class LoadingStateIndicator extends StatelessWidget {
  final double? height;
  final double? width;
  final LoadingState loadingState;
  final ErrorTapCallback? errorTapCallback;
  final NoDataTapCallback? noDataTapCallback;
  final bool useCupertinoIndicator;
  final double indicatorRadius;
  final Color? indicatorColor;
  final WidgetBuilder? idleWidgetBuilder;
  final WidgetBuilder? loadingWidgetBuilder;
  final Widget? noMoreWidget;
  final Widget? noDataWidget;
  final WidgetBuilder? successWidgetBuilder;
  final WidgetBuilder? errorWidgetBuilder;
  final bool errorWidgetSameWithIdle;
  final bool successWidgetSameWithIdle;

  const LoadingStateIndicator({
    super.key,
    this.height,
    this.width,
    required this.loadingState,
    this.errorTapCallback,
    this.noDataTapCallback,
    this.useCupertinoIndicator = false,
    this.indicatorRadius = 16,
    this.indicatorColor,
    this.idleWidgetBuilder,
    this.loadingWidgetBuilder,
    this.noMoreWidget,
    this.noDataWidget,
    this.successWidgetBuilder,
    this.errorWidgetBuilder,
    this.errorWidgetSameWithIdle = false,
    this.successWidgetSameWithIdle = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget child;

    switch (loadingState) {
      case LoadingState.loading:
        child = loadingWidgetBuilder?.call() ??
            (useCupertinoIndicator
                ? CupertinoActivityIndicator(
                    radius: indicatorRadius, color: indicatorColor)
                : Center(child: progressIndicator(context)));
        break;
      case LoadingState.error:
        child = errorWidgetBuilder?.call() ??
            (errorWidgetSameWithIdle
                ? idleWidgetBuilder!.call()
                : GestureDetector(
                    onTap: errorTapCallback,
                    child: moonIcon(
                        icon: BootstrapIcons.arrow_clockwise,
                        size: indicatorRadius * 2,
                        color: Theme.of(context).colorScheme.outline),
                  ));
        break;
      case LoadingState.idle:
        child = idleWidgetBuilder?.call() ??
            (useCupertinoIndicator
                ? CupertinoActivityIndicator(
                    radius: indicatorRadius, color: indicatorColor)
                : Center(child: progressIndicator(context)));
        break;
      case LoadingState.noMore:
        child = noMoreWidget ??
            Text('No more'.tr,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.outline)).subHeader();
        break;
      case LoadingState.success:
        if (successWidgetSameWithIdle == true) {
          return idleWidgetBuilder!.call();
        }
        if (successWidgetBuilder != null) {
          return successWidgetBuilder!();
        }
        child = const SizedBox();
        break;
      case LoadingState.noData:
        child = GestureDetector(
          onTap: noDataTapCallback,
          child: noDataWidget ??
              Text('Empty'.tr,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.outline))
                  .appHeader(),
        );
        break;
    }

    return Center(
      child: SizedBox(height: height, width: width, child: child),
    );
  }
}
