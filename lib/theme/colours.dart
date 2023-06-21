// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeNotifierProvider =
    StateNotifierProvider<ThemeNotifier, ThemeData>((ref) {
  return ThemeNotifier();
});

class RedditColors {
  static const Color primaryOrange = Color(0xFFFF4500);
  static const Color secondaryOrange = Color(0xFFFF8717);
  static const Color periwinkle = Color(0xFF9494FF);
  static const Color darkGray = Color(0xFF222222);
  static const Color lightGray = Color(0xFFC6C6C6);
  static const Color whiteBackground = Colors.white;
}

class AppThemes {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: RedditColors.primaryOrange,
    backgroundColor: RedditColors.whiteBackground,
    appBarTheme: const AppBarTheme(
      color: RedditColors.whiteBackground,
      textTheme: TextTheme(
        headline6: TextStyle(color: Colors.black, fontSize: 18),
      ),
      iconTheme: IconThemeData(color: Colors.black),
      elevation: 0,
    ),
    textTheme: const TextTheme(
      bodyText1: TextStyle(color: Colors.black),
      bodyText2: TextStyle(color: Colors.black87),
    ),
    colorScheme: const ColorScheme.light().copyWith(
      secondary: RedditColors.secondaryOrange, // Upvote
      surface: RedditColors.periwinkle, // Downvote
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: RedditColors.darkGray,
    backgroundColor: RedditColors.darkGray,
    appBarTheme: const AppBarTheme(
      color: RedditColors.darkGray,
      textTheme: TextTheme(
        headline6: TextStyle(color: Colors.white, fontSize: 18),
      ),
      iconTheme: IconThemeData(color: Colors.white),
      elevation: 0,
    ),
    textTheme: const TextTheme(
      bodyText1: TextStyle(color: Colors.white),
      bodyText2: TextStyle(color: Colors.white70),
    ),
    colorScheme: const ColorScheme.dark().copyWith(
      secondary: RedditColors.secondaryOrange, // Upvote
      surface: RedditColors.periwinkle, // Downvote
    ),
  );
}

class ThemeNotifier extends StateNotifier<ThemeData> {
  ThemeMode _mode;
  ThemeNotifier({
    ThemeMode mode = ThemeMode.light,
  })  : _mode = mode,
        super(
          AppThemes.darkTheme,
        ) {
    getTheme();
  }

  ThemeMode get mode => _mode;

  void getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final theme = prefs.getString('theme');
    if (theme == 'light') {
      _mode = ThemeMode.light;
      state = AppThemes.lightTheme;
    } else {
      _mode = ThemeMode.dark;
      state = AppThemes.darkTheme;
    }
  }

  void toggleTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_mode == ThemeMode.dark) {
      _mode = ThemeMode.light;
      state = AppThemes.lightTheme;
      prefs.setString('theme', 'light');
    } else {
      _mode = ThemeMode.dark;
      state = AppThemes.darkTheme;
      prefs.setString('theme', 'dark');
    }
  }
}
