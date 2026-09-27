import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';

/// Opaque, bordered surface behind the reader bars.
///
/// The bars float over the comic art, so they need something to sit on. This is
/// a themed surface (`gohan` with the Moon button border colour) rather than a
/// translucent scrim, so it stays legible over both dark and light artwork.
///
/// [radius] defaults to a stadium; lower it for bars that stack several rows.
class ReaderBarSurface extends StatelessWidget {
  const ReaderBarSurface({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    this.radius = 100,
  });

  /// Content of the bar.
  final Widget child;

  /// Padding around [child].
  final EdgeInsetsGeometry padding;

  /// Corner radius. The default turns a single-row bar into a stadium.
  final double radius;

  @override
  Widget build(BuildContext context) {
    final moonTheme = context.moonTheme;
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: moonTheme?.tokens.colors.gohan ??
            Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: moonTheme?.buttonTheme.colors.borderColor ??
              Theme.of(context).dividerColor,
        ),
      ),
      child: child,
    );
  }
}
