import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shoppingapp/screen/category/category_level1/category_level1.dart';
import 'package:shoppingapp/screen/home_screen/widget/search_page/search_page.dart';
import 'package:shoppingapp/utils/navigator.dart';
import 'package:shoppingapp/utils/theme_notifier.dart';
import 'package:shoppingapp/widgets/commons/string_res.dart';

class SearchBox extends StatefulWidget {
  @override
  _SearchBoxState createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<ThemeNotifier>(context);
    return Row(
      children: [
        InkWell(
          onTap: () {
            Nav.route(context, CategoryLevel1());
          },
          child: Container(
            margin: EdgeInsets.only(left: 18, top: 14),
            padding: EdgeInsets.only(
              left: 12,
            ),
            height: 44,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFA1B1C2).withOpacity(0.2),
                  blurRadius: 9.0,
                  offset: Offset(0.0, 6),
                )
              ],
              color: themeColor.getColor(),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
              ),
            ),
            child: Row(
              children: [
                Text(
                  Strings.category,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Container(
                  height: 15,
                  width: 15,
                  margin: EdgeInsets.only(right: 5),
                  child: Image.asset(
                    'assets/icons/drop-down.png',
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: () {
              Nav.route(context, SearchPage());
            },
            child: Container(
              margin: EdgeInsets.only(right: 18, top: 14),
              padding: EdgeInsets.only(left: 18, right: 18),
              height: 44,
              // width: Get.width/1.6,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFA1B1C2).withOpacity(0.2),
                    blurRadius: 9.0,
                    offset: Offset(0.0, 6),
                  )
                ],
                color: Theme.of(context).bottomAppBarColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    Strings.search,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Color(0xFFA1B1C2),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SvgPicture.asset(
                    "assets/icons/ic_search.svg",
                    color: Color(0xFFA1B1C2),
                    height: 12,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}



class NewSearchBox extends StatefulWidget {
  @override
  _NewSearchBoxSearchBoxState createState() => _NewSearchBoxSearchBoxState();
}

class _NewSearchBoxSearchBoxState extends State<NewSearchBox> {
  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<ThemeNotifier>(context);
    return Row(
      children: [
        // InkWell(
        //   onTap: () {
        //     Nav.route(context, CategoryLevel1());
        //   },
        //   child: Container(
        //     margin: EdgeInsets.only(left: 18, top: 14),
        //     padding: EdgeInsets.only(
        //       left: 12,
        //     ),
        //     height: 44,
        //     decoration: BoxDecoration(
        //       boxShadow: [
        //         BoxShadow(
        //           color: Color(0xFFA1B1C2).withOpacity(0.2),
        //           blurRadius: 9.0,
        //           offset: Offset(0.0, 6),
        //         )
        //       ],
        //       color: themeColor.getColor(),
        //       borderRadius: BorderRadius.only(
        //         topLeft: Radius.circular(0.0),
        //         bottomLeft: Radius.circular(0.0),
        //       ),
        //     ),
        //     child: Row(
        //       children: [
        //         Text(
        //           Strings.category,
        //           style: GoogleFonts.poppins(
        //             fontSize: 13,
        //             color: Colors.white,
        //             fontWeight: FontWeight.w400,
        //           ),
        //         ),
        //         Container(
        //           height: 15,
        //           width: 15,
        //           margin: EdgeInsets.only(right: 5),
        //           child: Image.asset(
        //             'assets/icons/drop-down.png',
        //             color: Colors.white,
        //           ),
        //         )
        //       ],
        //     ),
        //   ),
        // ),
        Expanded(
          child: InkWell(
            onTap: () {
              Nav.route(context, SearchPage());
            },
            child: Container(
              margin: EdgeInsets.only(right: 18, top: 14,left: 18),
              padding: EdgeInsets.only(left: 18, right: 18),
              height: 44,
              // width: Get.width/1.6,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFA1B1C2).withOpacity(0.2),
                    blurRadius: 9.0,
                    offset: Offset(0.0, 6),
                  )
                ],
                color: Theme.of(context).bottomAppBarColor,
                borderRadius: BorderRadius.all(Radius.circular(5))/*only(
                  topRight: Radius.circular(5.0),
                  bottomRight: Radius.circular(5.0),
                )*/,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    Strings.search,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Color(0xFFA1B1C2),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SvgPicture.asset(
                    "assets/icons/ic_search.svg",
                    color: Color(0xFFA1B1C2),
                    height: 12,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
