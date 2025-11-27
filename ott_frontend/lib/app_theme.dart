import 'package:flutter/material.dart';

/// Centralized application theme using the Minimalist Ocean Professional palette.
/// Colors per style guide:
/// - primary:   #374151
/// - secondary: #9CA3AF
/// - success:   #10B981
/// - error:     #EF4444
/// - background:#FFFFFF
/// - surface:   #F9FAFB
/// - text:      #111827
class AppTheme {
  AppTheme._();

  static const Color primary = Color(0xFF374151);
  static const Color secondary = Color(0xFF9CA3AF);
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF9FAFB);
  static const Color textPrimary = Color(0xFF111827);

  static const _oceanColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: primary,
    onPrimary: Colors.white,
    secondary: secondary,
    onSecondary: Colors.white,
    error: error,
    onError: Colors.white,
    // background/onBackground deprecated -> use surface/onSurface per M3 updates
    surface: surface,
    onSurface: textPrimary,
    // Material 3 extended roles
    primaryContainer: Color(0xFF1F2937),
    onPrimaryContainer: Colors.white,
    secondaryContainer: Color(0xFFD1D5DB),
    onSecondaryContainer: Color(0xFF111827),
    // surfaceVariant deprecated -> use surfaceContainerHighest
    surfaceContainerHighest: Color(0xFFE5E7EB),
    outline: Color(0xFF9CA3AF),
    outlineVariant: Color(0xFFD1D5DB),
    tertiary: success,
    onTertiary: Colors.white,
    tertiaryContainer: Color(0xFF34D399),
    onTertiaryContainer: Color(0xFF064E3B),
    inverseSurface: Color(0xFF111827),
    onInverseSurface: Colors.white,
    inversePrimary: Color(0xFF93C5FD),
    scrim: Colors.black54,
    shadow: Colors.black26,
    surfaceTint: primary,
  );

  /// Minimalist, clean Material 3 theme tuned for OTT browsing, with subdued elevation,
  /// generous whitespace, and understated interactive feedback.
  // PUBLIC_INTERFACE
  static ThemeData get lightTheme {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: _oceanColorScheme,
      scaffoldBackgroundColor: background,
      fontFamily: null, // default platform fonts; minimalist
    );

    return base.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: primary,
        unselectedItemColor: secondary,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
        selectedIconTheme: IconThemeData(size: 24),
        unselectedIconTheme: IconThemeData(size: 22),
        showUnselectedLabels: false,
      ),
      cardTheme: CardTheme(
        color: surface,
        elevation: 0,
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        hintStyle: const TextStyle(color: secondary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primary, width: 1.4),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primary,
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: primary,
        textColor: textPrimary,
        dense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFFE5E7EB),
        thickness: 1,
        space: 1,
      ),
      iconTheme: const IconThemeData(color: primary),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: textPrimary,
        contentTextStyle: TextStyle(color: Colors.white),
        behavior: SnackBarBehavior.floating,
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: const Color(0xFFE5E7EB),
        selectedColor: primary,
        labelStyle: const TextStyle(color: textPrimary),
      ),
    );
  }
}
