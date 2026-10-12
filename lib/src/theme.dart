import 'package:flutter/material.dart';

@immutable
class KinoColors extends ThemeExtension<KinoColors> {
  const KinoColors({
    required this.bg,
    required this.bgElev,
    required this.ink,
    required this.ink2,
    required this.ink3,
    required this.line,
    required this.brand,
    required this.brandSoft,
    required this.brandDeep,
    required this.ok,
    required this.warn,
    required this.danger,
    required this.warnBg,
    required this.warnLine,
    required this.warnInk,
    required this.infoBg,
    required this.infoInk,
    required this.hero0,
    required this.hero1,
    required this.hero2,
  });

  final Color bg;
  final Color bgElev;
  final Color ink;
  final Color ink2;
  final Color ink3;
  final Color line;
  final Color brand;
  final Color brandSoft;
  final Color brandDeep;
  final Color ok;
  final Color warn;
  final Color danger;
  final Color warnBg;
  final Color warnLine;
  final Color warnInk;
  final Color infoBg;
  final Color infoInk;
  final Color hero0;
  final Color hero1;
  final Color hero2;

  static const light = KinoColors(
    bg: Color(0xFFF4F2F8),
    bgElev: Color(0xFFFFFFFF),
    ink: Color(0xFF1A1523),
    ink2: Color(0xFF4A4458),
    ink3: Color(0xFF7A7389),
    line: Color(0xFFE6E1EF),
    brand: Color(0xFF6B4EFF),
    brandSoft: Color(0xFFEFEAFF),
    brandDeep: Color(0xFF4F35D4),
    ok: Color(0xFF1A9B6C),
    warn: Color(0xFFC47A12),
    danger: Color(0xFFC23B4A),
    warnBg: Color(0xFFFFF8EB),
    warnLine: Color(0xFFF0D7A8),
    warnInk: Color(0xFF7A4A08),
    infoBg: Color(0xFFEEF6FF),
    infoInk: Color(0xFF1D4F8C),
    hero0: Color(0xFF1C1630),
    hero1: Color(0xFF2A2150),
    hero2: Color(0xFF3A2D6A),
  );

  static const dark = KinoColors(
    bg: Color(0xFF121018),
    bgElev: Color(0xFF1C1826),
    ink: Color(0xFFF2EEF8),
    ink2: Color(0xFFC9C2D6),
    ink3: Color(0xFF9A93A8),
    line: Color(0xFF3A3348),
    brand: Color(0xFF8B6DFF),
    brandSoft: Color(0xFF2A2344),
    brandDeep: Color(0xFFC4B5FF),
    ok: Color(0xFF3DCC96),
    warn: Color(0xFFE0A04A),
    danger: Color(0xFFFF8B98),
    warnBg: Color(0xFF2A2116),
    warnLine: Color(0xFF6A5330),
    warnInk: Color(0xFFF0D7A8),
    infoBg: Color(0xFF172433),
    infoInk: Color(0xFFB9D4F5),
    hero0: Color(0xFF120E1C),
    hero1: Color(0xFF241C40),
    hero2: Color(0xFF3A2D6A),
  );

  @override
  KinoColors copyWith({
    Color? bg,
    Color? bgElev,
    Color? ink,
    Color? ink2,
    Color? ink3,
    Color? line,
    Color? brand,
    Color? brandSoft,
    Color? brandDeep,
    Color? ok,
    Color? warn,
    Color? danger,
    Color? warnBg,
    Color? warnLine,
    Color? warnInk,
    Color? infoBg,
    Color? infoInk,
    Color? hero0,
    Color? hero1,
    Color? hero2,
  }) {
    return KinoColors(
      bg: bg ?? this.bg,
      bgElev: bgElev ?? this.bgElev,
      ink: ink ?? this.ink,
      ink2: ink2 ?? this.ink2,
      ink3: ink3 ?? this.ink3,
      line: line ?? this.line,
      brand: brand ?? this.brand,
      brandSoft: brandSoft ?? this.brandSoft,
      brandDeep: brandDeep ?? this.brandDeep,
      ok: ok ?? this.ok,
      warn: warn ?? this.warn,
      danger: danger ?? this.danger,
      warnBg: warnBg ?? this.warnBg,
      warnLine: warnLine ?? this.warnLine,
      warnInk: warnInk ?? this.warnInk,
      infoBg: infoBg ?? this.infoBg,
      infoInk: infoInk ?? this.infoInk,
      hero0: hero0 ?? this.hero0,
      hero1: hero1 ?? this.hero1,
      hero2: hero2 ?? this.hero2,
    );
  }

  @override
  KinoColors lerp(ThemeExtension<KinoColors>? other, double t) {
    if (other is! KinoColors) return this;
    Color mix(Color a, Color b) => Color.lerp(a, b, t)!;
    return KinoColors(
      bg: mix(bg, other.bg),
      bgElev: mix(bgElev, other.bgElev),
      ink: mix(ink, other.ink),
      ink2: mix(ink2, other.ink2),
      ink3: mix(ink3, other.ink3),
      line: mix(line, other.line),
      brand: mix(brand, other.brand),
      brandSoft: mix(brandSoft, other.brandSoft),
      brandDeep: mix(brandDeep, other.brandDeep),
      ok: mix(ok, other.ok),
      warn: mix(warn, other.warn),
      danger: mix(danger, other.danger),
      warnBg: mix(warnBg, other.warnBg),
      warnLine: mix(warnLine, other.warnLine),
      warnInk: mix(warnInk, other.warnInk),
      infoBg: mix(infoBg, other.infoBg),
      infoInk: mix(infoInk, other.infoInk),
      hero0: mix(hero0, other.hero0),
      hero1: mix(hero1, other.hero1),
      hero2: mix(hero2, other.hero2),
    );
  }
}

KinoColors kinoColorsOf(BuildContext context) {
  return Theme.of(context).extension<KinoColors>() ?? KinoColors.light;
}

ThemeData buildKinoTheme(Brightness brightness) {
  final colors = brightness == Brightness.dark
      ? KinoColors.dark
      : KinoColors.light;
  final scheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF6B4EFF),
    brightness: brightness,
    primary: colors.brand,
    surface: colors.bgElev,
  );
  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: scheme,
    scaffoldBackgroundColor: colors.bg,
    fontFamily: 'NotoSansSC',
    extensions: [colors],
    splashFactory: InkRipple.splashFactory,
    textTheme: TextTheme(
      bodyMedium: TextStyle(color: colors.ink, height: 1.55, fontSize: 14),
      bodySmall: TextStyle(color: colors.ink2, height: 1.5, fontSize: 13),
      titleLarge: TextStyle(
        color: colors.ink,
        fontWeight: FontWeight.w700,
        fontSize: 24,
        height: 1.25,
      ),
    ),
  );
}
