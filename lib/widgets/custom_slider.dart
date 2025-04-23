import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';

class CustomSlider extends StatefulWidget {
  const CustomSlider({required this.min, required this.max, required this.value, required this.divisions, required this.onChanged, this.reversed = false, super.key});

  final double min;

  final double max;

  final double value;

  final int divisions;

  final void Function(double) onChanged;

  final bool reversed;

  @override
  State<CustomSlider> createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  late double value;

  @override
  void initState() {
    super.initState();
    value = widget.value;
  }

  @override
  void didUpdateWidget(CustomSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      setState(() {
        value = widget.value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
      child: LayoutBuilder(
        builder: (context, constrains) => MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTapDown: (details){
              var dx = details.localPosition.dx;
              if(widget.reversed){
                dx = constrains.maxWidth - dx;
              }
              var gap = constrains.maxWidth / widget.divisions;
              var gapValue = (widget.max - widget.min)  / widget.divisions;
              widget.onChanged.call((dx / gap).round() * gapValue + widget.min);
            },
            onVerticalDragUpdate: (details){
              var dx = details.localPosition.dx;
              if(dx > constrains.maxWidth || dx < 0)  return;
              if(widget.reversed){
                dx = constrains.maxWidth - dx;
              }
              var gap = constrains.maxWidth / widget.divisions;
              var gapValue = (widget.max - widget.min)  / widget.divisions;
              widget.onChanged.call((dx / gap).round() * gapValue + widget.min);
            },
            child: SizedBox(
              height: 24,
              child: Center(
                child: SizedBox(
                  height: 24,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned.fill(
                        child: Center(
                          child: Container(
                            width: double.infinity,
                            height: 6,
                            decoration: BoxDecoration(
                                color: context.moonTheme?.tokens.colors.trunks,
                                borderRadius: const BorderRadius.all(Radius.circular(10))
                            ),
                          ),
                        ),
                      ),
                      if(constrains.maxWidth / widget.divisions > 10)
                        Positioned.fill(
                          child: Row(
                            children: (){
                              var res = <Widget>[];
                              for(int i = 0; i<widget.divisions-1; i++){
                                res.add(const Spacer());
                                res.add(Container(
                                  width: 4,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: context.moonTheme?.tokens.colors.frieza60,
                                    shape: BoxShape.circle,
                                  ),
                                ));
                              }
                              res.add(const Spacer());
                              return res;
                            }.call(),
                          ),
                        ),
                      Positioned(
                        top: 0,
                        bottom: 0,
                        left: widget.reversed ? null : 0,
                        right: widget.reversed ? 0 : null,
                        child: Center(
                          child: Container(
                            width: constrains.maxWidth * ((value - widget.min) / (widget.max - widget.min)),
                            height: 8,
                            decoration: BoxDecoration(
                                color: context.moonTheme?.tokens.colors.frieza60,
                                borderRadius: const BorderRadius.all(Radius.circular(10))
                            ),
                          ),
                        )
                      ),
                      Positioned(
                        top: 0,
                        bottom: 0,
                        left: widget.reversed ? null : constrains.maxWidth * ((value - widget.min) / (widget.max - widget.min))-11,
                        right: !widget.reversed ? null : constrains.maxWidth * ((value - widget.min) / (widget.max - widget.min))-11,
                        child: Center(
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: context.moonTheme?.tokens.colors.frieza,
                              borderRadius: const BorderRadius.all(Radius.circular(8))
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
