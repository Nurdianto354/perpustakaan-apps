import 'package:flutter/material.dart';
import 'package:perpustakaan/utils/core/app_color.dart';
import 'package:perpustakaan/utils/core/app_style.dart';

class AppTheme {
  const AppTheme._();
  static var colorPrimary = Color(AppTheme.getColorFromHex('#543884'));
  static var colorPrimaryLight = Color(AppTheme.getColorFromHex('#9A77CF'));
  static var colorPrimaryDark = Color(AppTheme.getColorFromHex('#262254'));
  static var colorAccent = Color(AppTheme.getColorFromHex('#EC4176'));
  static var colorAccentDark = Color(AppTheme.getColorFromHex('#A13670'));
  static var colorYellow = Color(AppTheme.getColorFromHex('#FFA45E'));

  static var lightGrey1 = Color(AppTheme.getColorFromHex('#FAFAFA'));
  static var lightGrey2 = Color(AppTheme.getColorFromHex('#F7F7F7'));
  static var lightGrey3 = Color(AppTheme.getColorFromHex('#F3F3F3'));
  static var white = Color(AppTheme.getColorFromHex("#FFFFFF"));

  static var textLight = Color(AppTheme.getColorFromHex("#BACC5D3"));
  static var textDarker = Color(AppTheme.getColorFromHex("#000000"));
  static var textDark = Color(AppTheme.getColorFromHex("#4C5264"));
  static var transparent = Colors.transparent;

  static int getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: LightThemeColor.primaryLight,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: LightThemeColor.accent,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black45),
      centerTitle: true,
      titleTextStyle: h2Style,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          LightThemeColor.accent,
        ),
      ),
    ),
    hintColor: Colors.black45,
    inputDecorationTheme: InputDecorationTheme(
      border: const OutlineInputBorder(borderSide: BorderSide.none),
      enabledBorder: textFieldStyle,
      focusedBorder: textFieldStyle,
      filled: true,
      contentPadding: const EdgeInsets.all(20),
      fillColor: Colors.white,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: LightThemeColor.accent,
    ),
    textTheme: const TextTheme(
      displayLarge: h1Style,
      displayMedium: h2Style,
      displaySmall: h3Style,
      headlineMedium: h4StyleLight,
      headlineSmall: h5StyleLight,
      bodyLarge: bodyTextLight,
      titleMedium: subtitleLight,
    ),
    iconTheme: const IconThemeData(color: Colors.black45),
    bottomAppBarTheme: const BottomAppBarTheme(color: Colors.white),
  );

  static ThemeData darkTheme = ThemeData(
    canvasColor: DarkThemeColor.primaryDark,
    scaffoldBackgroundColor: DarkThemeColor.primaryDark,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: LightThemeColor.accent,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarTextStyle: TextStyle(color: Colors.white),
      centerTitle: true,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: h2Style,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          LightThemeColor.accent,
        ),
      ),
    ),
    hintColor: Colors.white60,
    inputDecorationTheme: InputDecorationTheme(
      enabledBorder: textFieldStyle,
      focusedBorder: textFieldStyle,
      filled: true,
      contentPadding: const EdgeInsets.all(20),
      fillColor: DarkThemeColor.primaryLight,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      backgroundColor: DarkThemeColor.primaryLight,
      selectedItemColor: LightThemeColor.accent,
      unselectedItemColor: Colors.white70,
    ),
    textTheme: TextTheme(
      displayLarge: h1Style.copyWith(color: Colors.white),
      displayMedium: h2Style.copyWith(color: Colors.white),
      displaySmall: h3Style.copyWith(color: Colors.white),
      headlineMedium: h4StyleLight.copyWith(color: Colors.white),
      headlineSmall: h5StyleLight.copyWith(color: Colors.white),
      bodyLarge: bodyTextLight.copyWith(color: Colors.white),
      titleMedium: subtitleLight.copyWith(color: Colors.white60),
    ),
    iconTheme: const IconThemeData(color: Colors.white),
    bottomAppBarTheme: const BottomAppBarTheme(
      color: DarkThemeColor.primaryLight,
    ),
  );
}
