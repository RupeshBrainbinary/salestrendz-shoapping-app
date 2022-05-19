import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shoppingapp/screen/product_may_like_page/products_may_like_page.dart';
import 'package:shoppingapp/utils/theme_notifier.dart';
import 'package:shoppingapp/widgets/commons/string_res.dart';

class ProductListTitleBar extends StatefulWidget {
  const ProductListTitleBar({
    Key key,
    @required this.themeColor,
    this.title,
    this.isCountShow,
    this.refreshApi,
  }) : super(key: key);

  final ThemeNotifier themeColor;

  final String title;
  final bool isCountShow;
  final Function refreshApi;

  @override
  _ProductListTitleBarState createState() => _ProductListTitleBarState();
}

class _ProductListTitleBarState extends State<ProductListTitleBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                widget.title,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              var result = Get.to(() => ProductLikeDetailPage());
              widget.refreshApi.call(0);
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                Strings.viewall,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: Color(0xFF5D6A78),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        /*  !this.widget.isCountShow
              ?SizedBox()
              : Container(
                  padding:
                      EdgeInsets.only(left: 12, right: 12, top: 6, bottom: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(.2),
                        blurRadius: 5.0,
                        spreadRadius: 0.0,
                        offset: Offset(0.0, 3.0),
                      )
                    ],
                  ),
                  child: CountdownTimer(
                    endTime: 1594829147719,
                    defaultDays: "==",
                    defaultHours: "--",
                    defaultMin: "**",
                    defaultSec: "++",
                    daysSymbol: "",
                    hoursSymbol: ":",
                    minSymbol: ":",
                    secSymbol: "",
                    textStyle: GoogleFonts.poppins(
                      fontSize: 12,
                      color: widget.themeColor.getColor(),
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                )*/
        ],
      ),
    );
  }
}
