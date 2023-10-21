import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const kFontFamily = "Roboto";

TextStyle get fontApp => TextStyle(
      fontFamily: kFontFamily,
      fontWeight: FontWeight.normal,
      fontSize: 14.sp,
      color: Colors.black,
      decoration: TextDecoration.none,
    );
TextStyle get text12 => fontApp.copyWith(fontSize: 12.sp);

TextStyle get text14 => fontApp.copyWith(fontSize: 14.sp);

TextStyle get text16 => fontApp.copyWith(fontSize: 16.sp);

TextStyle get text20 => fontApp.copyWith(fontSize: 20.sp);

TextStyle get text24 => fontApp.copyWith(fontSize: 24.sp);

TextStyle get text52 => fontApp.copyWith(fontSize: 52.sp);

extension TextStyleExt on TextStyle {
  //Decoration style
  TextStyle get underLine => copyWith(decoration: TextDecoration.underline);

  TextStyle get overLine => copyWith(decoration: TextDecoration.overline);

  //Weight style
  TextStyle get light => copyWith(fontWeight: FontWeight.w300);

  TextStyle get normal => copyWith(fontWeight: FontWeight.normal);

  TextStyle get medium => copyWith(fontWeight: FontWeight.w500);

  TextStyle get semiBold => copyWith(fontWeight: FontWeight.w600);

  TextStyle get bold => copyWith(fontWeight: FontWeight.w700);

  TextStyle get bold800 => copyWith(fontWeight: FontWeight.w800);

  //Color style

  TextStyle get whiteColor => copyWith(color: Colors.white);
  TextStyle get blackColor => copyWith(color: Colors.black);
}
