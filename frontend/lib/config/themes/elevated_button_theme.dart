import 'package:flutter/material.dart';
import 'package:frontend/core/constants/color_constants.dart';

class CustomElevatedButtonTheme {
  static ElevatedButtonThemeData elevatedButtonThemeLight =
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColorConstants.primaryColorDark,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          textStyle: const TextStyle(
            fontSize: 20,
            fontFamily: 'Poppins',
            letterSpacing: 1.3,
            height: 1.3,
            fontWeight: FontWeight.w500,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );

  static ElevatedButtonThemeData elevatedButtonThemeDark =
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColorConstants.primaryColorLight,
          foregroundColor: Colors.black,
          minimumSize: const Size(double.infinity, 56),
          textStyle: const TextStyle(
            fontSize: 20,
            fontFamily: 'Poppins',
            letterSpacing: 1.3,
            height: 1.3,
            fontWeight: FontWeight.w500,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
}
