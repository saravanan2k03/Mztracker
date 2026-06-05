import 'package:flutter/material.dart';

// ── Semantic color palette ─────────────────────────────────────────────────

class AppColors {
  final Color primary;       // accent / CTA
  final Color background;    // scaffold background
  final Color surface;       // card / container background
  final Color text;          // primary text
  final Color textMuted;     // secondary / hint text
  final Color shadow;        // box-shadow base colour
  final Color inputBorder;   // text-field border
  final Color navBackground; // bottom navigation bar
  final Color navIndicator;  // selected nav indicator chip

  const AppColors({
    required this.primary,
    required this.background,
    required this.surface,
    required this.text,
    required this.textMuted,
    required this.shadow,
    required this.inputBorder,
    required this.navBackground,
    required this.navIndicator,
  });

  // ── Light palette ──────────────────────────────────────────────────────

  static const light = AppColors(
    primary:       Color(0xFFFF4940),
    background:    Color(0xFFFFFAFA),
    surface:       Color(0xFFFFFFFF),
    text:          Color(0xFF1A1A1A),
    textMuted:     Color(0xFF757575),
    shadow:        Color(0xFFC2CBD0),
    inputBorder:   Color(0xFF1A1A1A),
    navBackground: Color(0xFFFFFFFF),
    navIndicator:  Color(0xFFFF8077),
  );

  // ── Dark palette ───────────────────────────────────────────────────────

  static const dark = AppColors(
    primary:       Color(0xFFFF6B63),
    background:    Color(0xFF121212),
    surface:       Color(0xFF1E1E1E),
    text:          Color(0xFFF0F0F0),
    textMuted:     Color(0xFFAAAAAA),
    shadow:        Color(0xFF000000),
    inputBorder:   Color(0xFFAAAAAA),
    navBackground: Color(0xFF1E1E1E),
    navIndicator:  Color(0xFFFF6B63),
  );
}

// ── BuildContext extension ─────────────────────────────────────────────────

extension AppColorsExt on BuildContext {
  AppColors get appColors =>
      Theme.of(this).brightness == Brightness.dark
          ? AppColors.dark
          : AppColors.light;
}

// ── ThemeData factory ──────────────────────────────────────────────────────

class AppTheme {
  static ThemeData get light => _build(AppColors.light, Brightness.light);
  static ThemeData get dark  => _build(AppColors.dark,  Brightness.dark);

  static ThemeData _build(AppColors c, Brightness brightness) {
    return ThemeData(
      brightness: brightness,
      primaryColor: c.primary,
      scaffoldBackgroundColor: c.background,
      cardColor: c.surface,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary:          c.primary,
        onPrimary:        Colors.white,
        secondary:        c.primary,
        onSecondary:      Colors.white,
        error:            Colors.red,
        onError:          Colors.white,
        surface:          c.surface,
        onSurface:        c.text,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: c.text),
        titleTextStyle: TextStyle(color: c.text, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: c.navBackground,
        indicatorColor: c.navIndicator,
        labelTextStyle: WidgetStateProperty.all(
          TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: c.text),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: c.textMuted, fontSize: 12),
        contentPadding: const EdgeInsets.all(15),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: c.inputBorder),
          borderRadius: BorderRadius.circular(30),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: c.inputBorder),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? c.primary : c.textMuted,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? c.primary.withOpacity(0.5)
              : c.textMuted.withOpacity(0.3),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? c.primary : Colors.transparent,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(backgroundColor: c.primary),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: c.primary,
      ),
      dividerColor: c.textMuted.withOpacity(0.2),
    );
  }
}
