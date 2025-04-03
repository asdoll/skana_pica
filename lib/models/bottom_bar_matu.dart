import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:skana_pica/pages/mainscreen.dart';

typedef BottomBarMatuIconBuilder = Widget Function(Color color);

class BottomBarItem {
  final IconData? iconData;
  final double iconSize;
  final String? label;
  final TextStyle? labelTextStyle;
  final double labelMarginTop;
  final BottomBarMatuIconBuilder? iconBuilder;

  BottomBarItem({
    this.iconData,
    this.iconSize = 30,
    this.label,
    this.iconBuilder,
    this.labelMarginTop = 0,
    this.labelTextStyle,
  }) : assert(iconData != null || iconBuilder != null);
}

class BottomBarDoubleBullet extends StatefulWidget {
  const BottomBarDoubleBullet({
    super.key,
    required this.items,
    this.selectedIndex = 0,
    this.height = 71,
    this.bubbleSize = 10,
    this.color = Colors.green,
    this.circle1Color = Colors.blue,
    this.circle2Color = Colors.red,
    this.backgroundColor = Colors.white,
    this.onSelect,
  });

  final int selectedIndex;
  final double height;
  final double bubbleSize;
  final Color color;
  final Color circle1Color;
  final Color circle2Color;
  final Color backgroundColor;
  final ValueChanged<int>? onSelect;
  final List<BottomBarItem> items;

  @override
  State<BottomBarDoubleBullet> createState() => _BottomBarDoubleBulletState();
}

class BottomBarDoubleBulletIcon extends StatefulWidget {
  const BottomBarDoubleBulletIcon({
    super.key,
    required this.item,
    required this.color,
    this.isSelected = false,
  });

  final BottomBarItem item;
  final Color color;
  final bool isSelected;

  @override
  BottomBarDoubleBulletIconState createState() =>
      BottomBarDoubleBulletIconState();
}

class BottomBarDoubleBulletIconState extends State<BottomBarDoubleBulletIcon>
    with SingleTickerProviderStateMixin {
  static const duration = Duration(milliseconds: 500);

  late AnimationController _animationController;
  late Tween<double> _colorTween;
  late Animation<double> _animation;
  bool _isSelect = false;
  bool _isLeftToRight = false;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: duration);
    _colorTween = Tween(begin: 0, end: 1);
    _animation = _colorTween.animate(_animationController);
    if (widget.isSelected) {
      _isSelect = widget.isSelected;
      _animationController.forward();
    }
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: Stack(
        children: [
          Positioned(bottom: 5, left: 0, right: 0, child: _labelWidget()),
          Positioned(
              bottom: 10,
              top: 0,
              left: 0,
              right: 0,
              child: _iconWidget()),
        ],
      ),
    );
  }

  Widget _iconWidget() {
    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedBuilder(
          animation: _animation,
          builder: (BuildContext context, Widget? child) {
            var value = _animation.value * 2;
            value = value < 0 ? 0 : value;
            value = value > 1 ? 1 : value;
            final color = Color.lerp(colorGrey5, widget.color, value);

            final scaleValue =
                -5 * (pow(_animation.value, 2) - _animation.value);

            if (scaleValue == 0) {
              return _buildIconWidget(color!);
            } else {
              return Transform.rotate(
                angle: -pi /
                    (_isLeftToRight ? (8 * scaleValue) : -(8 * scaleValue)),
                child: _buildIconWidget(color!),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildIconWidget(Color color) {
    if (widget.item.iconBuilder != null) {
      return Padding(
          padding: const EdgeInsets.all(10),
          child: widget.item.iconBuilder!.call(color));
    } else {
      return Icon(widget.item.iconData!,
          size: widget.item.iconSize, color: color);
    }
  }

  Widget _labelWidget() {
    if (widget.item.label != null) {
      return Text(
        widget.item.label!,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: (widget.item.labelTextStyle ?? const TextStyle()).copyWith(
          color: _isSelect ? widget.color : colorGrey5,
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  void updateSelect(bool isSelect, bool isLeftToRight) {
    setState(() {
      _isSelect = isSelect;
      _isLeftToRight = isLeftToRight;
    });

    if (!isSelect) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
  }
}

class _BottomBarDoubleBulletState extends State<BottomBarDoubleBullet>
    with SingleTickerProviderStateMixin {
  static const duration = Duration(milliseconds: 500);
  List<GlobalKey<BottomBarDoubleBulletIconState>> iconsKey = [];

  late int _iconCount = 0;
  late int _selectedIndex;
  late int _oldSelectedIndex;
  late AnimationController _animationController;
  late Tween<double> _colorTween;
  late Animation<double?> _animation;

  @override
  void initState() {
    _colorTween = Tween(begin: 0, end: 1);
    _animationController = AnimationController(vsync: this, duration: duration);
    _animation = _colorTween.animate(_animationController);

    _selectedIndex = widget.selectedIndex;
    _oldSelectedIndex = widget.selectedIndex;
    _handleTextChangeFromOutside();

    super.initState();
  }

  @override
  void didUpdateWidget(covariant BottomBarDoubleBullet oldWidget) {
    super.didUpdateWidget(oldWidget);
    _handleTextChangeFromOutside();
  }

  void _handleTextChangeFromOutside() {
    _iconCount = widget.items.length;

    iconsKey.clear();
    for (var i = 0; i < _iconCount; i++) {
      final key = GlobalKey<BottomBarDoubleBulletIconState>();
      iconsKey.add(key);
    }

    if (widget.selectedIndex >= _iconCount || widget.selectedIndex < 0) {
      throw RangeError('selectedIndex is out of range');
    }
    _onChangeIndex(widget.selectedIndex);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.backgroundColor,
      height: widget.height,
      child: Stack(
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _animation,
              builder: (BuildContext context, Widget? child) {
                if (_oldSelectedIndex == _selectedIndex) {
                  return const SizedBox();
                }
                final startOffSet = _getStartOffset();
                final endOffSet = _getEndOffset();

                return ClipPath(
                    clipper: BottomBarDoubleBulletClipper(
                      _getAnimationValue(),
                      startOffSet.dx,
                      endOffSet.dx,
                      _oldSelectedIndex > _selectedIndex,
                    ),
                    child: CustomPaint(
                        painter: BulletLinePainter(_getPath1(), widget.color)));
              },
            ),
          ),
          AnimatedBuilder(
            animation: _animation,
            builder: (BuildContext context, Widget? child) {
              if (_oldSelectedIndex == _selectedIndex) {
                return const SizedBox();
              }

              final path = _getPath1();
              return Positioned(
                top: calculate(path).dy - 3,
                left: calculate(path).dx +
                    (_oldSelectedIndex < _selectedIndex ? 13 : -17),
                child: Opacity(
                  opacity: _getAnimationValue() * 1.5 >= 0.9 ? 0 : 1,
                  child: Container(
                    decoration: BoxDecoration(
                        color: widget.circle1Color,
                        borderRadius: BorderRadius.circular(10)),
                    width: 5,
                    height: 5,
                  ),
                ),
              );
            },
          ),
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _animation,
              builder: (BuildContext context, Widget? child) {
                if (_oldSelectedIndex == _selectedIndex) {
                  return const SizedBox();
                }

                final startOffSet = _getStartOffset();
                final endOffSet = _getEndOffset();

                return ClipPath(
                    clipper: BottomBarDoubleBulletClipper(
                      _getAnimationValue(),
                      startOffSet.dx,
                      endOffSet.dx,
                      _oldSelectedIndex > _selectedIndex,
                    ),
                    child: CustomPaint(
                        painter: BulletLinePainter(_getPath2(), widget.color)));
              },
            ),
          ),
          AnimatedBuilder(
            animation: _animation,
            builder: (BuildContext context, Widget? child) {
              if (_oldSelectedIndex == _selectedIndex) {
                return const SizedBox();
              }

              final path = _getPath2();
              return Positioned(
                top: calculate(path).dy - 3,
                left: calculate(path).dx +
                    (_oldSelectedIndex < _selectedIndex ? 13 : -17),
                child: Opacity(
                  opacity: _getAnimationValue() * 1.5 >= 0.9 ? 0 : 1,
                  child: Container(
                    decoration: BoxDecoration(
                        color: widget.circle2Color,
                        borderRadius: BorderRadius.circular(10)),
                    width: 5,
                    height: 5,
                  ),
                ),
              );
            },
          ),
          Row(children: _iconsWidget()),
        ],
      ),
    );
  }

  List<Widget> _iconsWidget() {
    List<Widget> iconWidgets = [];

    widget.items.asMap().forEach((index, item) {
      iconWidgets.add(Expanded(
        child: InkWell(
          onTap: () => _onChangeIndex(index),
          child: 
            BottomBarDoubleBulletIcon(
              key: iconsKey[index],
              isSelected: _selectedIndex == index,
              item: item,
              color: widget.color,
            ),
        ),
      ));
    });

    return iconWidgets;
  }

  Future _onChangeIndex(int index,{bool refresh = false}) async {
    if (!refresh && index == _selectedIndex) {
      if (globalScrollController.hasClients &&
          globalScrollController.offset > 0) {
        globalScrollController.animateTo(0,
            duration: Duration(milliseconds: 300), curve: Curves.ease);
      }
      return;
    }

    _oldSelectedIndex = _selectedIndex;
    iconsKey[_oldSelectedIndex]
        .currentState
        ?.updateSelect(false, _oldSelectedIndex < _selectedIndex);
    // await Future.delayed(const Duration(milliseconds: 200));

    if (_animationController.status == AnimationStatus.completed) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }

    setState(() {
      _selectedIndex = index;
    });

    await Future.delayed(const Duration(milliseconds: 200));
    iconsKey[_selectedIndex]
        .currentState
        ?.updateSelect(true, _oldSelectedIndex < _selectedIndex);

    widget.onSelect?.call(_selectedIndex);
  }

  double _getAnimationValue() {
    final value = _animation.value!;

    if (_animation.status == AnimationStatus.dismissed) {
      return 1;
    }
    return _animation.status == AnimationStatus.reverse ? 1 - value : value;
  }

  Offset _getStartOffset() {
    double screenWidth = MediaQuery.of(context).size.width;
    final iconWidth = screenWidth / _iconCount;

    return Offset(
        (_oldSelectedIndex * iconWidth) + (iconWidth / 2), widget.height / 2);
  }

  Offset _getEndOffset() {
    double screenWidth = MediaQuery.of(context).size.width;
    final iconWidth = screenWidth / _iconCount;

    return Offset(
        (_selectedIndex * iconWidth) + (iconWidth / 2), widget.height / 2);
  }

  Path _getPath1() {
    final isReverse = _oldSelectedIndex > _selectedIndex;

    final startOffSet = _getStartOffset();
    final endOffSet = _getEndOffset();

    final width = (startOffSet.dx - endOffSet.dx).abs();

    double sx, sy, p1x, p1y, p2x, p2y, ex, ey;
    if (!isReverse) {
      sx = startOffSet.dx;
      sy = widget.height / 4 * 1.5;

      p1x = startOffSet.dx + width / 4;
      p1y = widget.height / 4 * 0.5;

      p2x = startOffSet.dx + 3 * width / 4;
      p2y = widget.height / 4 * 3.5;

      ex = endOffSet.dx;
      ey = widget.height / 4 * 2.5;
    } else {
      sx = startOffSet.dx;
      sy = widget.height / 4 * 2.5;

      p1x = endOffSet.dx + 3 * width / 4;
      p1y = widget.height / 4 * 3.5;

      p2x = endOffSet.dx + width / 4;
      p2y = widget.height / 4 * 0.5;

      ex = endOffSet.dx;
      ey = widget.height / 4 * 1.5;
    }

    Path path = Path();
    path.moveTo(sx, sy);

    path.cubicTo(p1x, p1y, p2x, p2y, ex, ey);
    return path;
  }

  Path _getPath2() {
    final isReverse = _oldSelectedIndex > _selectedIndex;

    final startOffSet = _getStartOffset();
    final endOffSet = _getEndOffset();

    final width = (startOffSet.dx - endOffSet.dx).abs();

    double sx, sy, p1x, p1y, p2x, p2y, ex, ey;
    if (!isReverse) {
      sx = startOffSet.dx;
      sy = widget.height / 4 * 2.5;

      p1x = startOffSet.dx + width / 4;
      p1y = widget.height / 4 * 3.5;

      p2x = startOffSet.dx + 3 * width / 4;
      p2y = widget.height / 4 * 0.5;

      ex = endOffSet.dx;
      ey = widget.height / 4 * 1.5;
    } else {
      sx = startOffSet.dx;
      sy = widget.height / 4 * 1.5;

      p1x = endOffSet.dx + 3 * width / 4;
      p1y = widget.height / 4 * 0.5;

      p2x = endOffSet.dx + width / 4;
      p2y = widget.height / 4 * 3.5;

      ex = endOffSet.dx;
      ey = widget.height / 4 * 2.5;
    }

    Path path = Path();
    path.moveTo(sx, sy);

    path.cubicTo(p1x, p1y, p2x, p2y, ex, ey);
    return path;
  }

  Offset calculate(Path path) {
    var value = _getAnimationValue() * 1.5;
    PathMetrics pathMetrics = path.computeMetrics();
    PathMetric pathMetric = pathMetrics.elementAt(0);
    value = pathMetric.length * value;
    Tangent pos = pathMetric.getTangentForOffset(value)!;
    return pos.position;
  }
}

class BulletLinePainter extends CustomPainter {
  final Path path;
  final Color color;

  BulletLinePainter(this.path, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
        path,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5);
  }

  @override
  bool shouldRepaint(BulletLinePainter oldDelegate) {
    return oldDelegate.path != path;
  }
}

class BottomBarDoubleBulletClipper extends CustomClipper<Path> {
  final double progress;
  final double startX;
  final double endX;
  final bool isReverse;

  BottomBarDoubleBulletClipper(
    this.progress,
    this.startX,
    this.endX,
    this.isReverse,
  );

  @override
  Path getClip(Size size) {
    final value = progress;

    final width = (endX - startX).abs();

    final path = Path();
    if (!isReverse) {
      path.moveTo(startX + width * value * 1.5 - 30, 0.0);
      path.lineTo(startX + width * value * 1.5 + 10, 0.0);
      path.lineTo(startX + width * value * 1.5 + 10, size.height);
      path.lineTo(startX + width * value * 1.5 - 30, size.height);
    } else {
      path.moveTo(startX - width * value * 1.5 + 30, 0.0);
      path.lineTo(startX - width * value * 1.5 - 10, 0.0);
      path.lineTo(startX - width * value * 1.5 - 10, size.height);
      path.lineTo(startX - width * value * 1.5 + 30, size.height);
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(BottomBarDoubleBulletClipper oldClipper) {
    return oldClipper.progress != progress;
  }
}

const colorPrimary = Color(0xFF279656);

const colorPurpleAS = Color(0xFFC566FE);
const colorPurpleDarkAS = Color(0xFF792DD4);
const colorPinkAS = Color(0xFFB149DA);
const colorBlueLightAS = Color(0xFF6AC1FF);
const colorBlueAS = Color(0xFF33BAE5);
const colorBlueDarkAS = Color(0xFF4D97FF);
const colorBlueDark2AS = Color(0xFF006AFF);
const colorGreenAS = Color(0xFF36B97C);
const colorOrangeAS = Color(0xFFFF6161);
const colorOrangeLightAS = Color(0xFFFF7D7D);
const colorGreyAS = Color(0xFF8A8A8A);
const colorYellowDarkAS = Color(0xFFFF9900);

const colorBgrRedAS = Color(0xFFFFE2E2);
const colorBgrGreenAS = Color(0xFFE2FFE4);
const colorBgrPurpleAS = Color(0xFFEEE2F5);
const colorBgrBlueAS = Color(0xFFE2EFFB);

const colorYellow = Color(0xFFFED463);
const colorYellowDark = Color(0xFFF18A81);

const colorRed = Color(0xFFef5350);
const colorRedDark = Color(0xFFE50000);

const colorBlue = Color(0xFF42a5f5);
const colorBlueDark = Color(0xFF1565c0);

const colorGreen = Color(0xFF66bb6a);
const colorGreenOpacity10 = Color(0xFFE9F5EE);

const colorError = Color(0xffff5544);
const colorErrorOpacity10 = Color(0xFFFDEBED);

const colorGrey1 = Color(0xFF5D5D5D);
const colorGrey2 = Color(0xFF636363);
const colorGrey3 = Color(0xFF7D7D7D);
const colorGrey4 = Color(0xFF8D8D8D);
const colorGrey5 = Color(0xFFADADAD);
const colorGrey6 = Color(0xFFD4D4D4);
const colorGrey7 = Color(0xFFEEEEEE);

const Color kError01Color = Color(0xFFFDEBED);
const Color kError02Color = Color(0xFFFCD8DB);
const Color kError03Color = Color(0xFFF9B1B8);
const Color kError04Color = Color(0xFFF58A94);
const Color kError05Color = Color(0xFFF26371);
const Color kError06Color = Color(0xFFBF303E);
const Color kError07Color = Color(0xFF8F242E);
const Color kError08Color = Color(0xFF60181F);
const Color kError09Color = Color(0xFF300C0F);
const Color kError10Color = Color(0xFF180608);

const Color kOtherBlue01Color = Color(0xFFE5F4FB);
const Color kOtherBlue02Color = Color(0xFFCCE9F8);
const Color kOtherBlue03Color = Color(0xFF99D3F0);
const Color kOtherBlue04Color = Color(0xFF66BCE9);
const Color kOtherBlue05Color = Color(0xFF33A6E1);
const Color kOtherBlue06Color = Color(0xFF0073AE);
const Color kOtherBlue07Color = Color(0xFF005683);
const Color kOtherBlue08Color = Color(0xFF003A57);
const Color kOtherBlue09Color = Color(0xFF001D2C);
const Color kOtherBlue10Color = Color(0xFF000E16);

const Color kOtherGreen01Color = Color(0xFFE9F5EE);
const Color kOtherGreen02Color = Color(0xFFD4EADD);
const Color kOtherGreen03Color = Color(0xFFA9D5BB);
const Color kOtherGreen04Color = Color(0xFF7DC09A);
const Color kOtherGreen05Color = Color(0xFF52AB78);
const Color kOtherGreen06Color = Color(0xFF1F7845);
const Color kOtherGreen07Color = Color(0xFF175A34);
const Color kOtherGreen08Color = Color(0xFF103C22);
const Color kOtherGreen09Color = Color(0xFF081E11);
const Color kOtherGreen10Color = Color(0xFF040F09);
const Color kOtherGreen11Color = Color(0xFF2BC48A);
const Color kOtherGreen12Color = Color(0xFF2BE29D);

const Color kGray01Color = Color(0xFF111111);
const Color kGray02Color = Color(0xFF414141);
const Color kGray03Color = Color(0xFF707070);
const Color kGray04Color = Color(0xFFA0A0A0);
const Color kGray05Color = Color(0xFFC4C4C4);
const Color kGray06Color = Color(0xFFDBDBDB);
const Color kGray08Color = Color(0xFFEAEAEA);
