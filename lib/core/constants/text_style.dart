import 'package:flutter/material.dart';
import 'package:pinterest/core/constants/colors.dart';
import 'package:pinterest/reusable_element.dart/common_var.dart';

class AppTextStyles {
  static TextStyle text({
    required double fontSize,
    required String fontFamily,
    FontWeight fontWeight = FontWeight.normal,
    FontStyle fontStyle = FontStyle.normal,
    double lineHeight = 1.5,
    Color color = AppColors.darkText,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontFamily: fontFamily,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      height: lineHeight,
      color: color,
      decoration: decoration,
    );
  }

  static TextStyle heading32({
    Color color = AppColors.darkText,
    FontWeight fontWeight = FontWeight.bold,
    FontStyle fontStyle = FontStyle.normal,
    TextDecoration? decoration,
  }) =>
      text(
        fontSize: 32,
        fontFamily: 'Poppins',
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        lineHeight: 1.5,
        color: color,
        decoration: decoration,
      );
  static TextStyle heading30({
    Color color = AppColors.darkText,
    FontWeight fontWeight = FontWeight.bold,
    FontStyle fontStyle = FontStyle.normal,
    TextDecoration? decoration,
  }) =>
      text(
        fontSize: textVariable * 0.0375, //30
        fontFamily: 'Poppins',
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        lineHeight: 1.3,
        color: color,
        decoration: decoration,
      );

  static TextStyle heading28({
    Color color = AppColors.darkText,
    FontWeight fontWeight = FontWeight.bold,
    FontStyle fontStyle = FontStyle.normal,
    TextDecoration? decoration,
  }) =>
      text(
        fontSize: textVariable * 0.035, //28
        fontFamily: 'Poppins',
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        lineHeight: 1.5,
        color: color,
        decoration: decoration,
      );
  static TextStyle heading26({
    Color color = AppColors.darkText,
    FontWeight fontWeight = FontWeight.bold,
    FontStyle fontStyle = FontStyle.normal,
  }) =>
      text(
        fontSize: 26,
        fontFamily: 'Poppins',
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        lineHeight: 1.4,
        color: color,
      );
  static TextStyle heading24({
    Color color = AppColors.darkText,
    FontWeight fontWeight = FontWeight.bold,
    FontStyle fontStyle = FontStyle.normal,
    TextDecoration? decoration,
  }) =>
      text(
        fontSize: textVariable * 0.03, //24
        fontFamily: 'Poppins',
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        lineHeight: 1.3,
        color: color,
        decoration: decoration,
      );
  static TextStyle heading22({
    Color color = AppColors.darkText,
    FontWeight fontWeight = FontWeight.bold,
    FontStyle fontStyle = FontStyle.normal,
    TextDecoration? decoration,
  }) =>
      text(
        fontSize: 22, //22
        fontFamily: 'Poppins',
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        lineHeight: 1.3,
        color: color,
        decoration: decoration,
      );

  static TextStyle heading20({
    Color color = AppColors.darkText,
    FontWeight fontWeight = FontWeight.w600,
    FontStyle fontStyle = FontStyle.normal,
    TextDecoration? decoration,
  }) =>
      text(
        fontSize: textVariable * 0.025, //20
        fontFamily: 'Poppins',
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        lineHeight: 1.5,
        color: color,
        decoration: decoration,
      );

  static TextStyle heading18({
    Color color = AppColors.darkText,
    FontWeight fontWeight = FontWeight.w600,
    FontStyle fontStyle = FontStyle.normal,
    TextDecoration? decoration,
  }) =>
      text(
        fontSize: textVariable * 0.0225, //18
        fontFamily: 'Poppins',
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        lineHeight: 1.5,
        color: color,
        decoration: decoration,
      );

  static TextStyle heading16({
    Color color = AppColors.darkText,
    FontWeight fontWeight = FontWeight.w600,
    FontStyle fontStyle = FontStyle.normal,
    TextDecoration? decoration,
  }) =>
      text(
        fontSize: textVariable * 0.02,
        fontFamily: 'Poppins',
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        lineHeight: 1.5,
        color: color,
        decoration: decoration,
      );

  static TextStyle heading14({
    Color color = AppColors.darkText,
    FontWeight fontWeight = FontWeight.w600,
    FontStyle fontStyle = FontStyle.normal,
    TextDecoration? decoration,
  }) =>
      text(
        fontSize: textVariable * 0.0175,
        fontFamily: 'Poppins',
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        lineHeight: 1.5,
        color: color,
        decoration: decoration,
      );

  static TextStyle body20({
    Color color = AppColors.lightText,
    FontWeight fontWeight = FontWeight.normal,
    FontStyle fontStyle = FontStyle.normal,
  }) =>
      text(
        fontSize: textVariable * 0.025,
        fontFamily: 'Figtree',
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        lineHeight: 1.5,
        color: color,
      );

  static TextStyle body18({
    Color color = AppColors.lightText,
    FontWeight fontWeight = FontWeight.normal,
    FontStyle fontStyle = FontStyle.normal,
  }) =>
      text(
        fontSize: textVariable * 0.0225,
        fontFamily: 'Figtree',
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        lineHeight: 1.5,
        color: color,
      );
  static TextStyle body16({
    Color color = AppColors.lightText,
    FontWeight fontWeight = FontWeight.normal,
    FontStyle fontStyle = FontStyle.normal,
    TextDecoration? decoration,
  }) =>
      text(
        fontSize: textVariable * 0.02,
        fontFamily: 'Figtree',
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        lineHeight: 1.5,
        color: color,
        decoration: decoration,
      );

  static TextStyle body14({
    Color color = AppColors.lightText,
    FontWeight fontWeight = FontWeight.normal,
    FontStyle fontStyle = FontStyle.normal,
    TextDecoration? decoration,
  }) =>
      text(
        fontSize: textVariable * 0.0175,
        fontFamily: 'Figtree',
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        lineHeight: 1.5,
        color: color,
        decoration: decoration,
      );

  static TextStyle body12({
    Color color = AppColors.lightText,
    FontWeight fontWeight = FontWeight.normal,
    FontStyle fontStyle = FontStyle.normal,
    TextDecoration? decoration,
  }) =>
      text(
        fontSize: textVariable * 0.015,
        fontFamily: 'Figtree',
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        lineHeight: 1.5,
        color: color,
        decoration: decoration,
      );
}
