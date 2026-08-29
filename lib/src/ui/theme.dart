import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// https://github.com/material-foundation/flutter-packages/issues/67

final lightTheme = ThemeData(
  platform: TargetPlatform.iOS,
  useMaterial3: true,
  // https://github.com/material-foundation/flutter-packages/issues/67
  // ThemeData.light().textTheme or ThemeData(brightness: Brightness.light).textTheme
  textTheme: GoogleFonts.ubuntuTextTheme(ThemeData.light().textTheme),
  colorScheme: const ColorScheme.light(
    brightness: Brightness.light,
    primary: Color(0xFF26547C),
    onPrimary: Color.fromARGB(255, 255, 255, 255),
    primaryContainer: Color(0xFFD0E4FF),
    onPrimaryContainer: Color(0xFF001D36),
    secondary: Color(0xFFEF476F),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFFFD9E2),
    onSecondaryContainer: Color(0xFF3E0017),
    tertiary: Color(0xFFFFD166),
    onTertiary: Color(0xFF3E2E00),
    tertiaryContainer: Color(0xFFFFE9AE),
    onTertiaryContainer: Color(0xFF241A00),
    error: Color(0xFFBA1A1A),
    errorContainer: Color(0xFFFFDAD6),
    onError: Color(0xFFFFFFFF),
    onErrorContainer: Color(0xFF410002),
    surface: Color(0xFFFFFCF9),
    onSurface: Color(0xFF1A1C1E),
    surfaceContainerHighest: Color(0xFFDDE3EA),
    onSurfaceVariant: Color(0xFF41484D),
    outline: Color(0xFF71787E),
    onInverseSurface: Color(0xFFF1F0F4),
    inverseSurface: Color(0xFF2F3033),
    inversePrimary: Color(0xFF9ECAFF),
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xFF26547C),
    outlineVariant: Color(0xFFC1C7CE),
    scrim: Color(0xFF000000),
  ),
);

final darkTheme = ThemeData(
  platform: TargetPlatform.iOS,
  useMaterial3: true,
  // https://github.com/material-foundation/flutter-packages/issues/67
  // ThemeData.dark().textTheme or ThemeData(brightness: Brightness.dark).textTheme
  textTheme: GoogleFonts.ubuntuTextTheme(ThemeData.dark().textTheme),
  colorScheme: const ColorScheme.dark(
    brightness: Brightness.dark,
    primary: Color(0xFF86BBD8),
    onPrimary: Color(0xFF00344F),
    primaryContainer: Color(0xFF33658A),
    onPrimaryContainer: Color(0xFFCEE5FF),
    secondary: Color(0xFFF26419),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFAC4000),
    onSecondaryContainer: Color(0xFFFFDBCC),
    tertiary: Color(0xFFF6AE2D),
    onTertiary: Color(0xFF412D00),
    tertiaryContainer: Color(0xFF5D4200),
    onTertiaryContainer: Color(0xFFFFDEA1),
    error: Color(0xFFFFB4AB),
    errorContainer: Color(0xFF93000A),
    onError: Color(0xFF690005),
    onErrorContainer: Color(0xFFFFDAD6),
    surface: Color(0xFF2F4858),
    onSurface: Color(0xFFE1E2E5),
    surfaceContainerHighest: Color(0xFF41484D),
    onSurfaceVariant: Color(0xFFC1C7CE),
    outline: Color(0xFF8B9198),
    onInverseSurface: Color(0xFF1A1C1E),
    inverseSurface: Color(0xFFE1E2E5),
    inversePrimary: Color(0xFF33658A),
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xFF86BBD8),
    outlineVariant: Color(0xFF41484D),
    scrim: Color(0xFF000000),
  ),
);
