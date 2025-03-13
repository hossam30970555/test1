import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AppTheme {
  // Colors
  static const Color primaryColor = Colors.blue;
  static const Color secondaryColor = Colors.amber;
  
  // Light Theme Colors
  static const Color lightBackgroundColor = Colors.white;
  static const Color lightCardColor = Colors.white;
  static const Color lightTextColor = Colors.black;
  static const Color lightIconColor = Colors.blue;
  static const Color lightDividerColor = Color(0xFFEEEEEE);
  
  // Dark Theme Colors
  static const Color darkBackgroundColor = Colors.black;
  static const Color darkCardColor = Color(0xFF202020);
  static const Color darkTextColor = Colors.white;
  static const Color darkIconColor = Colors.lightBlue;
  static const Color darkDividerColor = Color(0xFF303030);

  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: lightBackgroundColor,
    cardColor: lightCardColor,
    dividerColor: lightDividerColor,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      background: lightBackgroundColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: lightBackgroundColor,
      foregroundColor: lightTextColor,
      elevation: 0,
      iconTheme: IconThemeData(color: lightIconColor),
      titleTextStyle: TextStyle(
        color: lightTextColor,
        fontWeight: FontWeight.w600,
        fontSize: 18,
        fontFamily: 'SF Pro Display',
      ),
    ),
    iconTheme: const IconThemeData(
      color: lightIconColor,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: lightTextColor),
      bodyMedium: TextStyle(color: lightTextColor),
      titleLarge: TextStyle(color: lightTextColor),
      titleMedium: TextStyle(color: lightTextColor),
      titleSmall: TextStyle(color: lightTextColor),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
    ),
    listTileTheme: const ListTileThemeData(
      iconColor: lightIconColor,
      textColor: lightTextColor,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.selected)) {
          return Colors.white;
        }
        return Colors.grey.shade400;
      }),
      trackColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.selected)) {
          return Colors.green;
        }
        return Colors.grey.shade300;
      }),
    ),
    cupertinoOverrideTheme: const CupertinoThemeData(
      brightness: Brightness.light,
      primaryColor: primaryColor,
      textTheme: CupertinoTextThemeData(
        primaryColor: primaryColor,
      ),
    ),
  );

  // Dark Theme
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: darkBackgroundColor,
    cardColor: darkCardColor,
    dividerColor: darkDividerColor,
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      background: darkBackgroundColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: darkBackgroundColor,
      foregroundColor: darkTextColor,
      elevation: 0,
      iconTheme: IconThemeData(color: darkIconColor),
      titleTextStyle: TextStyle(
        color: darkTextColor,
        fontWeight: FontWeight.w600,
        fontSize: 18,
        fontFamily: 'SF Pro Display',
      ),
    ),
    iconTheme: const IconThemeData(
      color: darkIconColor,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: darkTextColor),
      bodyMedium: TextStyle(color: darkTextColor),
      titleLarge: TextStyle(color: darkTextColor),
      titleMedium: TextStyle(color: darkTextColor),
      titleSmall: TextStyle(color: darkTextColor),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
    ),
    listTileTheme: const ListTileThemeData(
      iconColor: darkIconColor,
      textColor: darkTextColor,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.selected)) {
          return Colors.white;
        }
        return Colors.grey.shade700;
      }),
      trackColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.selected)) {
          return Colors.green;
        }
        return Colors.grey.shade800;
      }),
    ),
    cupertinoOverrideTheme: const CupertinoThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      textTheme: CupertinoTextThemeData(
        primaryColor: primaryColor,
      ),
    ),
  );
}
