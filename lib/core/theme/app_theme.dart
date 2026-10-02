import 'package:flutter/material.dart';

class AppTheme {
  static const primary = Color(0xFF176B5B);
  static const primarylight = Color(0xFFEAF6F2);
  static const primarySoft = Color(0xFFF0F8F6);
  static const secondary = Color(0xFF153B5B);
  static const accent = Color(0xFFF2A65A);
  static const bg = Color(0xFFF5F8F7);
  static const surface = Colors.white;
  static const danger = Color(0xFFD64545);
  static const success = Color(0xFF23815B);
  static const textPrimary = Color(0xFF15241F);
  static const textSecondary = Color(0xFF63716C);

  static final ColorScheme _scheme = ColorScheme.fromSeed(
    seedColor: primary,
    brightness: Brightness.light,
    primary: primary,
    secondary: secondary,
    surface: surface,
    error: danger,
  );

  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        colorScheme: _scheme,
        scaffoldBackgroundColor: bg,
        fontFamily: 'Roboto',
        visualDensity: VisualDensity.adaptivePlatformDensity,
        splashFactory: InkSparkle.splashFactory,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: textPrimary,
          centerTitle: false,
          titleSpacing: 20,
          toolbarHeight: 68,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
            color: textPrimary,
          ),
        ),
        textTheme: const TextTheme(
          displaySmall: TextStyle(
            fontSize: 34,
            height: 1.12,
            fontWeight: FontWeight.w800,
            letterSpacing: -1,
            color: textPrimary,
          ),
          headlineSmall: TextStyle(
            fontSize: 24,
            height: 1.2,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.4,
            color: textPrimary,
          ),
          titleLarge: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w700,
            color: textPrimary,
          ),
          titleMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: textPrimary,
          ),
          bodyLarge: TextStyle(fontSize: 16, height: 1.5, color: textPrimary),
          bodyMedium: TextStyle(fontSize: 14, height: 1.45, color: textPrimary),
          bodySmall: TextStyle(fontSize: 12, height: 1.4, color: textSecondary),
          labelLarge: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
        cardTheme: CardThemeData(
          color: surface,
          elevation: 0,
          margin: EdgeInsets.zero,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
            side: const BorderSide(color: Color(0xFFE5ECE9)),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: surface,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
          labelStyle: const TextStyle(color: textSecondary),
          hintStyle: const TextStyle(color: textSecondary),
          prefixIconColor: primary,
          suffixIconColor: textSecondary,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFDCE6E2)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: primary, width: 1.7),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: danger),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: Colors.white,
            disabledBackgroundColor: const Color(0xFFB9CAC5),
            disabledForegroundColor: Colors.white,
            elevation: 0,
            minimumSize: const Size(64, 54),
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            textStyle:
                const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            minimumSize: const Size(64, 54),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            textStyle:
                const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: primary,
            minimumSize: const Size(64, 54),
            side: const BorderSide(color: Color(0xFFB9D1C9)),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            textStyle:
                const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: primary,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        checkboxTheme: CheckboxThemeData(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          side: const BorderSide(color: Color(0xFFA8BBB5)),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: primarySoft,
          selectedColor: const Color(0xFFD8EEE7),
          side: BorderSide.none,
          labelStyle:
              const TextStyle(fontWeight: FontWeight.w600, color: primary),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        dialogTheme: DialogThemeData(
          backgroundColor: surface,
          surfaceTintColor: Colors.transparent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        ),
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          insetPadding: const EdgeInsets.all(16),
        ),
        dividerTheme:
            const DividerThemeData(color: Color(0xFFE4EBE8), thickness: 1),
        progressIndicatorTheme:
            const ProgressIndicatorThemeData(color: primary),
        iconTheme: const IconThemeData(color: primary),
        navigationBarTheme: const NavigationBarThemeData(
          backgroundColor: surface,
          indicatorColor: Color(0xFFDCEFE9),
          elevation: 0,
          height: 72,
        ),
      );
}
