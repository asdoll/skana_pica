import 'dart:async';

import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
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