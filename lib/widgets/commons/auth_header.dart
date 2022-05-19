import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shoppingapp/app_url_name_companyid.dart';
import 'package:shoppingapp/utils/commons/colors.dart';
import 'package:shoppingapp/utils/theme_notifier.dart';
import 'package:get/get.dart';
// ignore: prefer_relative_imports

class AuthHeader extends StatelessWidget {
  final String headerTitle;
  final String headerBigTitle;
  final bool isLoginHeader;

  AuthHeader({this.headerTitle, this.headerBigTitle, this.isLoginHeader});

  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<ThemeNotifier>(context);

    return Container(
      decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: themeColor.getColor().withOpacity(0.5),
              blurRadius: 3,
              offset: Offset(0, 0),
            ),
          ],
          color: HeaderColor, //themeColor.getColor(),
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24))),
      padding: EdgeInsets.all(16),
      height: Get.height * 0.35,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              headerTitle,
              style: GoogleFonts.roboto(
                fontSize: 20,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          this.isLoginHeader
              ?SizedBox()
              : Align(
                  alignment: Alignment.topLeft,
                  child: InkWell(
                    onTap: () {

                      Get.back();
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                  ),
                ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8, left: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      child: Image.asset(logoImage),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

//Line no 70 Code inside column
// Text(
// headerBigTitle,
// style: GoogleFonts.roboto(
// fontSize: 40,
// color: Colors.white,
// fontWeight: FontWeight.w700,
// ),
// ),
// Text(
// "Account",
// style: GoogleFonts.roboto(
// fontSize: 23,
// color: Colors.white,
// fontWeight: FontWeight.w300,
// ),
// ),
