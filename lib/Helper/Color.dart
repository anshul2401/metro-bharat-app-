import 'package:flutter/material.dart';

//colors class in all colors define
extension colors on ColorScheme {
  static MaterialColor primary_app = const MaterialColor(
    0xff08B9B7,
    const <int, Color>{
      50: primary,
      100: primary,
      200: primary,
      300: primary,
      400: primary,
      500: primary,
      600: primary,
      700: primary,
      800: primary,
      900: primary,
    },
  );

  static const Color primary = const Color(0xffeb4034);
  static const Color tempboxColor = Color(0xffffffff);
  static const Color bgColor = Color(0xffEEEEEE);
  static const Color templightColor = Color(0xffE5E5E5);
  static const Color tempBorderColor = Color(0xff6B6B6B);
  static const Color tempdarkColor = Color(0xff5A5A5A);
  static const Color darkColor1 = Color(0xff3D3D3D);
  static const Color tempfontColor1 = Color(0xff7F7F7F);

  Color get borderColor =>
      this.brightness == Brightness.dark ? bgColor : tempBorderColor;

  Color get lightColor =>
      this.brightness == Brightness.dark ? tempfontColor1 : templightColor;

  Color get boxColor =>
      this.brightness == Brightness.dark ? tempfontColor1 : tempboxColor;

  Color get fontColor =>
      this.brightness == Brightness.dark ? bgColor : tempfontColor1;

  Color get darkColor =>
      this.brightness == Brightness.dark ? tempboxColor : tempdarkColor;
}
