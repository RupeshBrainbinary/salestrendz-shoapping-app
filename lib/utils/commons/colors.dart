import 'package:flutter/material.dart';
import 'package:shoppingapp/app_url_name_companyid.dart';

//const Color mainColor = Color(0xFF0055FF);

Color mainColor = appName=="MILLBORN-Jaipur"?colorFromHex("c22e30"): colorFromHex("005cb7");
// Color mainC = colorFromHex("FF2933");
Color mainC = colorFromHex("005cb7");

Color millBornPrimaryColor = Colors.black;
// Color millBornPrimaryThemeColor = Color.fromRGBO(194, 46, 49, 0.9);
Color millBornPrimaryThemeColor = Color(0xffc22e30);

const HeaderColor = Color(0xFFEAEBEC);

Color textColor = Color(0xFFA1B1C2);
Color subTextColor = Color(0xFF707070);
Color greyBackground = Color.fromARGB(255, 252, 252, 252);

Color whiteColor = Colors.white;

Color textFieldFillColor = Colors.grey[50];
const Color textFieldIconColor = Color(0xFF5D6A78);
const Color categoryIconColor = Color(0xFFB3C0C8);

Color colorFromHex(String hexColor) {
  final hexCode = hexColor.replaceAll('#', '');
  return Color(int.parse('FF$hexCode', radix: 16));
}


class LightColor {
  static const Color background = Color(0XFFFFFFFF);

  static const Color titleTextColor = const Color(0xff1d2635);
  static const Color subTitleTextColor = const Color(0xff797878);

  static const Color skyBlue = Color(0xff2890c8);
  static const Color lightBlue = Color(0xff5c3dff);

  static const Color orange = Color(0xffE65829);
  static const Color red = Color(0xffF72804);

  static const Color lightGrey = Color(0xffE1E2E4);
  static const Color grey = Color(0xffA1A3A6);
  static const Color darkgrey = Color(0xff747F8F);

  static const Color iconColor = Color(0xffa8a09b);
  static const Color yellowColor = Color(0xfffbba01);

  static const Color black = Color(0xff20262C);
  static const Color lightblack = Color(0xff5F5F60);
}
