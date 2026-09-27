import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';

/// Borderless, Moon-styled icon button for the reader bars.
///
/// Ported from skana_pix's `lib/componentwidgets/moonbariconbutton.dart`.
///
/// Every button built from this widget has the exact same footprint
/// ([iconSize] + 8px padding => 36x36 by default), so a row of actions can never
/// look ragged.
class MoonBarIconButton extends StatelessWidget {
  const MoonBarIconButton({
    super.key,
    required this.icon,
    this.color,
    this.onTap,
    this.onLongPress,
    this.iconSize = 20,
    this.tooltip,
  });

  /// Glyph to display.
  final IconData icon;

  /// Colour of the glyph. Defaults to the ambient icon theme, which is what the
  /// themed reader bar wants; pass a colour only to override it.
  final Color? color;

  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  /// Size of the glyph; the touch target is this plus 16px of padding.
  final double iconSize;

  /// Optional tooltip, used where the glyph alone is not self-explanatory.
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final button = MoonButton.icon(
      onTap: onTap ?? () {},
      onLongPress: onLongPress,
      buttonSize: MoonButtonSize.sm,
      showBorder: false,
      backgroundColor: Colors.transparent,
      iconColor: color,
      padding: const EdgeInsets.all(8),
      icon: Icon(icon, size: iconSize, color: color),
    );
    if (tooltip == null) {
      return button;
    }
    return Tooltip(message: tooltip!, child: button);
  }
}
