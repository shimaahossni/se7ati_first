// core/utils/themes.dart
import 'package:flutter/material.dart';
import 'package:flutter_application/core/utils/colors.dart';
import 'package:flutter_application/core/utils/text_style.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemes {
  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.whiteColor,
    snackBarTheme: const SnackBarThemeData(backgroundColor: AppColors.redColor,),
    scrollbarTheme: const ScrollbarThemeData(
        thumbColor: WidgetStatePropertyAll(AppColors.blueColor,),
        radius: Radius.circular(20)),
    appBarTheme: AppBarTheme(
        titleTextStyle: getTitleStyle(
          color: AppColors.whiteColor,
        ),
        centerTitle: true,
        elevation: 0.0,
        actionsIconTheme: const IconThemeData(
          color: AppColors.blueColor,
        ),
        backgroundColor: AppColors.blueColor),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding:
          const EdgeInsets.only(left: 20, top: 10, bottom: 10, right: 20),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        borderSide: BorderSide.none,
      ),
      filled: true,
      suffixIconColor: AppColors.blueColor,
      prefixIconColor: AppColors.blueColor,
      fillColor: AppColors.accentColor,
      hintStyle: GoogleFonts.poppins(
        color: Colors.grey,
        fontSize: 14,
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.blackColor,
      indent: 10,
      endIndent: 10,
    ),
    fontFamily: GoogleFonts.cairo().fontFamily,
  );
}
