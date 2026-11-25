import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SkylearnColors {
  SkylearnColors._();

  // Brand & Accent Colors
  static const Color sky = Color(0xFF3B82F6);
  static const Color skyBright = Color(0xFF60A5FA);
  static const Color skyDeep = Color(0xFF1D4ED8);
  static const Color skySoft = Color(0xFFDBEAFE);

  static const Color sun = Color(0xFFFBBF24);
  static const Color sunBright = Color(0xFFFCD34D);
  static const Color sunDeep = Color(0xFFD97706);
  static const Color sunSoft = Color(0xFFFEF3C7);

  static const Color leaf = Color(0xFF22C55E);
  static const Color leafSoft = Color(0xFFDCFCE7);
  static const Color leafDeep = Color(0xFF16A34A);

  static const Color coral = Color(0xFFF87171);
  static const Color coralSoft = Color(0xFFFEE2E2);

  static const Color berry = Color(0xFFA855F7);
  static const Color berrySoft = Color(0xFFF3E8FF);

  // Light Mode Surfaces & Ink
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF8FAFC);
  static const Color surfaceElevated = Color(0xFFFFFFFF);
  static const Color surfaceSunken = Color(0xFFF1F5F9);

  static const Color ink = Color(0xFF0F172A);
  static const Color inkMuted = Color(0xFF475569);
  static const Color inkSubtle = Color(0xFF94A3B8);
  static const Color inkFaint = Color(0xFFCBD5E1);

  static const Color outline = Color(0xFFE2E8F0);
  static const Color outlineStrong = Color(0xFF94A3B8);

  // Dark Mode Surfaces & Ink
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkSurfaceSunken = Color(0xFF0B1120);
  static const Color darkOutline = Color(0xFF334155);
  static const Color darkInk = Color(0xFFF8FAFC);
  static const Color darkInkMuted = Color(0xFFCBD5E1);
}

class AppTheme {
  AppTheme._();

  static TextTheme _buildTextTheme(Color primaryInk, Color secondaryInk) {
    final baseBody = GoogleFonts.atkinsonHyperlegibleTextTheme();
    final baseDisplay = GoogleFonts.nunitoTextTheme();

    return baseBody.copyWith(
      displayLarge: baseDisplay.displayLarge?.copyWith(
        fontSize: 56,
        height: 1.07,
        fontWeight: FontWeight.w700,
        color: primaryInk,
      ),
      headlineLarge: baseDisplay.headlineLarge?.copyWith(
        fontSize: 36,
        height: 1.2,
        fontWeight: FontWeight.w700,
        color: primaryInk,
      ),
      headlineMedium: baseDisplay.headlineMedium?.copyWith(
        fontSize: 28,
        height: 1.25,
        fontWeight: FontWeight.w700,
        color: primaryInk,
      ),
      headlineSmall: baseDisplay.headlineSmall?.copyWith(
        fontSize: 22,
        height: 1.3,
        fontWeight: FontWeight.w700,
        color: primaryInk,
      ),
      titleLarge: baseBody.titleLarge?.copyWith(
        fontSize: 19,
        height: 1.4,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.16,
        color: primaryInk,
      ),
      titleMedium: baseBody.titleMedium?.copyWith(
        fontSize: 18,
        height: 1.45,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.16,
        color: primaryInk,
      ),
      bodyLarge: baseBody.bodyLarge?.copyWith(
        fontSize: 18,
        height: 1.5,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.18,
        color: primaryInk,
      ),
      bodyMedium: baseBody.bodyMedium?.copyWith(
        fontSize: 16,
        height: 1.5,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.16,
        color: secondaryInk,
      ),
      labelLarge: baseBody.labelLarge?.copyWith(
        fontSize: 16,
        height: 1.25,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
        color: primaryInk,
      ),
    );
  }

  static TextStyle monoMetric({
    required double fontSize,
    FontWeight fontWeight = FontWeight.w700,
    Color? color,
  }) {
    return GoogleFonts.jetBrainsMono(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  static ThemeData get lightTheme {
    final textTheme = _buildTextTheme(
      SkylearnColors.ink,
      SkylearnColors.inkMuted,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: SkylearnColors.background,
      colorScheme: const ColorScheme.light(
        primary: SkylearnColors.sky,
        onPrimary: Colors.white,
        primaryContainer: SkylearnColors.skySoft,
        onPrimaryContainer: SkylearnColors.skyDeep,
        secondary: SkylearnColors.sun,
        onSecondary: SkylearnColors.ink,
        secondaryContainer: SkylearnColors.sunSoft,
        onSecondaryContainer: SkylearnColors.sunDeep,
        tertiary: SkylearnColors.leaf,
        onTertiary: Colors.white,
        tertiaryContainer: SkylearnColors.leafSoft,
        onTertiaryContainer: SkylearnColors.leafDeep,
        error: SkylearnColors.coral,
        onError: Colors.white,
        errorContainer: SkylearnColors.coralSoft,
        onErrorContainer: SkylearnColors.ink,
        surface: SkylearnColors.surface,
        onSurface: SkylearnColors.ink,
        onSurfaceVariant: SkylearnColors.inkMuted,
        outline: SkylearnColors.outline,
        outlineVariant: SkylearnColors.outlineStrong,
      ),
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: SkylearnColors.background,
        foregroundColor: SkylearnColors.ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.headlineSmall,
      ),
      cardTheme: CardThemeData(
        color: SkylearnColors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: SkylearnColors.outline, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: SkylearnColors.sky,
          foregroundColor: Colors.white,
          minimumSize: const Size(56, 56),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          elevation: 0,
          textStyle: textTheme.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: SkylearnColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: SkylearnColors.inkSubtle,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: SkylearnColors.outline, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: SkylearnColors.outline, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: SkylearnColors.sky, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: SkylearnColors.coral, width: 1.5),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    final textTheme = _buildTextTheme(
      SkylearnColors.darkInk,
      SkylearnColors.darkInkMuted,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: SkylearnColors.darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: SkylearnColors.skyBright,
        onPrimary: SkylearnColors.darkBackground,
        primaryContainer: Color(0xFF1E3A8A),
        onPrimaryContainer: SkylearnColors.skySoft,
        secondary: SkylearnColors.sun,
        onSecondary: SkylearnColors.darkBackground,
        secondaryContainer: Color(0xFF78350F),
        onSecondaryContainer: SkylearnColors.sunSoft,
        tertiary: SkylearnColors.leaf,
        onTertiary: SkylearnColors.darkBackground,
        tertiaryContainer: Color(0xFF14532D),
        onTertiaryContainer: SkylearnColors.leafSoft,
        error: SkylearnColors.coral,
        onError: SkylearnColors.darkBackground,
        errorContainer: Color(0xFF7F1D1D),
        onErrorContainer: SkylearnColors.coralSoft,
        surface: SkylearnColors.darkSurface,
        onSurface: SkylearnColors.darkInk,
        onSurfaceVariant: SkylearnColors.darkInkMuted,
        outline: SkylearnColors.darkOutline,
        outlineVariant: SkylearnColors.inkSubtle,
      ),
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: SkylearnColors.darkBackground,
        foregroundColor: SkylearnColors.darkInk,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.headlineSmall,
      ),
      cardTheme: CardThemeData(
        color: SkylearnColors.darkSurface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: SkylearnColors.darkOutline, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: SkylearnColors.skyBright,
          foregroundColor: SkylearnColors.darkBackground,
          minimumSize: const Size(56, 56),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          elevation: 0,
          textStyle: textTheme.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: SkylearnColors.darkSurface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: SkylearnColors.inkSubtle,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: SkylearnColors.darkOutline,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: SkylearnColors.darkOutline,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: SkylearnColors.skyBright,
            width: 2,
          ),
        ),
      ),
    );
  }
}