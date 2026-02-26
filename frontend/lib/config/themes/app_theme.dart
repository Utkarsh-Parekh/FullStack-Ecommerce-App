import 'package:flutter/material.dart';
import 'package:frontend/config/themes/text_theme.dart';
import 'package:frontend/core/constants/color_constants.dart';
import 'package:frontend/config/themes/elevated_button_theme.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColorConstants.primaryColorDark,
    scaffoldBackgroundColor: AppColorConstants.lightBackground,
    textTheme: appTextTheme.apply(
      bodyColor: AppColorConstants.primaryColorDark,
      displayColor: AppColorConstants.primaryColorDark,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColorConstants.secondaryColorDark),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColorConstants.secondaryColorDark),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: AppColorConstants.secondaryColorDark,
          width: 2,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColorConstants.errorColor),
      ),
    ),
    iconTheme: IconThemeData(color: AppColorConstants.primaryColorDark, size: 24),
    elevatedButtonTheme: CustomElevatedButtonTheme.elevatedButtonThemeLight,

  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColorConstants.primaryColorLight,
    scaffoldBackgroundColor: AppColorConstants.darkBackground,
    textTheme: appTextTheme.apply(
      bodyColor: AppColorConstants.primaryColorLight,
      displayColor: AppColorConstants.primaryColorLight,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColorConstants.secondaryColorLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColorConstants.secondaryColorLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: AppColorConstants.secondaryColorLight,
          width: 2,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColorConstants.errorColor),
      ),
    ),
    iconTheme: IconThemeData(color: AppColorConstants.primaryColorLight),
      elevatedButtonTheme: CustomElevatedButtonTheme.elevatedButtonThemeDark
  );
}
