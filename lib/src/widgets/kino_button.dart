import 'package:flutter/material.dart';

import '../theme.dart';

enum KinoButtonVariant { primary, dark, soft, ghost, tertiary }

class KinoButton extends StatelessWidget {
  const KinoButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = KinoButtonVariant.primary,
    this.small = false,
    this.tooltip,
  });

  final String label;
  final VoidCallback? onPressed;
  final KinoButtonVariant variant;
  final bool small;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final colors = kinoColorsOf(context);
    final enabled = onPressed != null;
    late Color bg;
    late Color fg;
    Border? border;
    List<BoxShadow> shadows = const [];
    FontWeight weight = FontWeight.w600;

    switch (variant) {
      case KinoButtonVariant.primary:
        bg = colors.brand;
        fg = Colors.white;
        shadows = [
          BoxShadow(
            color: colors.brand.withValues(alpha: 0.28),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ];
      case KinoButtonVariant.dark:
        bg = colors.ink;
        fg = colors.bg;
        shadows = [
          BoxShadow(
            color: colors.ink.withValues(alpha: 0.18),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ];
      case KinoButtonVariant.soft:
        bg = colors.brandSoft;
        fg = colors.brandDeep;
      case KinoButtonVariant.ghost:
        bg = colors.bgElev;
        fg = colors.ink;
        border = Border.all(color: colors.line);
      case KinoButtonVariant.tertiary:
        bg = Colors.transparent;
        fg = colors.ink3;
        border = Border.all(color: colors.line);
        weight = FontWeight.w500;
    }

    if (!enabled) {
      bg = brightnessAwareDisabled(colors);
      fg = colors.ink3;
      border = null;
      shadows = const [];
    }

    final button = Material(
      color: bg,
      elevation: 0,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(999),
        side: border == null
            ? BorderSide.none
            : BorderSide(color: border.top.color),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          decoration: shadows.isEmpty
              ? null
              : BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: shadows,
                ),
          padding: EdgeInsets.symmetric(
            horizontal: small ? 14 : 18,
            vertical: small ? 8 : 10,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: fg,
              fontWeight: weight,
              fontSize: small ? 13 : 14,
              height: 1.2,
            ),
          ),
        ),
      ),
    );

    if (tooltip == null) return button;
    return Tooltip(message: tooltip!, child: button);
  }
}

Color brightnessAwareDisabled(KinoColors colors) {
  return Color.alphaBlend(colors.ink.withValues(alpha: 0.08), colors.bgElev);
}
