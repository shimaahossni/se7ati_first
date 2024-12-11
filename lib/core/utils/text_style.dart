// core/utils/text_style.dart
import 'package:flutter/material.dart';
import 'package:flutter_application/core/utils/colors.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle getTitleStyle(
        {Color? color,
        double? fontSize = 18,
        FontWeight? fontWeight = FontWeight.bold}) =>
    TextStyle(
      fontSize: fontSize,
      color: color ?? AppColors.blueColor,
      fontWeight: fontWeight,
      fontFamily: GoogleFonts.cairo().fontFamily,
    );

TextStyle getBodyStyle(
        {Color? color,
        double? fontSize = 14,
        FontWeight? fontWeight = FontWeight.w400}) =>
    TextStyle(
        fontSize: fontSize,
        color: color ?? AppColors.blackColor,
        fontWeight: fontWeight,
        fontFamily: GoogleFonts.cairo().fontFamily);

TextStyle getSmallStyle(
        {Color? color,
        double? fontSize = 12,
        FontWeight? fontWeight = FontWeight.w500}) =>
    TextStyle(
        fontSize: fontSize,
        color: color ?? AppColors.blackColor,
        fontWeight: fontWeight,
        fontFamily: GoogleFonts.cairo().fontFamily);
