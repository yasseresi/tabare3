import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'font_manager.dart';

TextStyle _getTextStyle(
  double fontSize,
  FontWeight fontWeight,
  Color color, {
  double? lineHeight,
}) {
  return GoogleFonts.cairo(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
    height: lineHeight == null ? null : lineHeight / fontSize,
  );
}

TextStyle getRegularStyle({
  double fontSize = FontSize.s12,
  required Color color,
  double? lineHeight,
}) {
  return _getTextStyle(
    fontSize,
    FontWeightManager.regular,
    color,
    lineHeight: lineHeight,
  );
}

TextStyle getMediumStyle({
  double fontSize = FontSize.s12,
  required Color color,
  double? lineHeight,
}) {
  return _getTextStyle(
    fontSize,
    FontWeightManager.medium,
    color,
    lineHeight: lineHeight,
  );
}

TextStyle getSemiBoldStyle({
  double fontSize = FontSize.s12,
  required Color color,
  double? lineHeight,
}) {
  return _getTextStyle(
    fontSize,
    FontWeightManager.semiBold,
    color,
    lineHeight: lineHeight,
  );
}

TextStyle getBoldStyle({
  double fontSize = FontSize.s12,
  required Color color,
  double? lineHeight,
}) {
  return _getTextStyle(
    fontSize,
    FontWeightManager.bold,
    color,
    lineHeight: lineHeight,
  );
}

TextStyle getExtraBoldStyle({
  double fontSize = FontSize.s12,
  required Color color,
  double? lineHeight,
}) {
  return _getTextStyle(
    fontSize,
    FontWeightManager.extraBold,
    color,
    lineHeight: lineHeight,
  );
}

TextStyle getLightStyle({
  double fontSize = FontSize.s12,
  required Color color,
  double? lineHeight,
}) {
  return _getTextStyle(
    fontSize,
    FontWeightManager.light,
    color,
    lineHeight: lineHeight,
  );
}
