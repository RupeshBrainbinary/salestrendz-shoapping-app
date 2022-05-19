import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:shoppingapp/models/BookOrderModel.dart';
import 'package:shoppingapp/models/homepage_model.dart';
import 'package:shoppingapp/screen/auth_screens/login/login_form.dart';
import 'package:shoppingapp/screen/homepage_deals/blockbuster_deals_screen/blockbuster_deals_page.dart';
import 'package:shoppingapp/screen/product_detail/product_detail_page.dart';
import 'package:shoppingapp/utils/api/api.dart';
import 'package:shoppingapp/utils/commons/colors.dart';
import 'package:shoppingapp/utils/navigator.dart';
import 'package:shoppingapp/utils/theme_notifier.dart';
import 'package:shoppingapp/widgets/commons/full_screen_loader.dart';
import 'package:shoppingapp/widgets/commons/string_res.dart';

class BlockBasterDeals extends StatefulWidget {
  final Products blockBusterList;

  BlockBasterDeals(this.blockBusterList);

  @override
  BlockBasterDealsState createState() => BlockBasterDealsState();
}

BookOrderModel bookOrderObj = BookOrderModel.orderModelObj;

class BlockBasterDealsState extends State<BlockBasterDeals> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                Strings.blockbusterDeals,
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Get.to(() => BlockBusterDealsPage());
              },
              child: Padding(
                padding: EdgeInsets.only(right: 20),
                child: Text(
                  Strings.viewall,
                  style: GoogleFonts.roboto(
                    fontSize: 15,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 5),
        Divider(height: 3),
        SizedBox(height: 8),
        Container(
          height: Get.height > 840
              ? Get.height * 0.32
              : Get.height > 810
                  ? Get.height * 0.33
                  : Get.height > 660
                      ? Get.height * 0.35
                      : Get.height * 0.37,
          width: double.infinity,
          child: widget.blockBusterList == null ||
                  widget.blockBusterList.data.isEmpty ||
                  widget.blockBusterList.data.length == 0
              ? Container(
                  child: Center(
                    child: Text(
                      Strings.blockdealsnotavail,
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                )
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount:  widget.blockBusterList.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        int productIndex;
                        for (var i = 0;
                            i < bookOrderObj.productsInCart.length;
                            i++) {
                          if (bookOrderObj.productsInCart[i].productID ==
                              widget.blockBusterList.data[index].ppProductId
                                  .toString()) {
                            productIndex = i;
                          }
                        }
                        Nav.route(
                          context,
                          ProductDetailPage(
                            productId:
                                widget.blockBusterList.data[index].ppProductId,
                            productQty: productIndex == null
                                ? 1.0
                                : bookOrderObj.productsInCart[productIndex]
                                    .productQuantity,
                            stock:
                                widget.blockBusterList.data[index].qtyInCases,
                          ),
                        );
                      },
                      child: listItem(
                        widget.blockBusterList.data[index].ppProductId
                            .toString(),
                        widget.blockBusterList.data[index].imageAttached
                                .isNotEmpty
                            ? widget.blockBusterList.data[index].imageAttached
                                .first.uploadPath
                            : "",
                        widget.blockBusterList.data[index].savedPercentage ==
                                null
                            ? ' 0'
                            : widget.blockBusterList.data[index].savedPercentage
                                .round()
                                .toString(),
                        widget.blockBusterList.data[index].isinWishlist,
                        widget.blockBusterList.data[index].wishlist == null
                            ? '0'
                            : widget
                                .blockBusterList.data[index].wishlist.wishlistId
                                .toString(),
                        widget.blockBusterList.data[index].productName,
                        Strings.mrp1,
                        '₹ ${widget.blockBusterList.data[index].ppMrp.toStringAsFixed(2) ?? 0.0}',
                        Strings.dealpp,
                        '₹ ${widget.blockBusterList.data[index].ppPrice.toStringAsFixed(2) ?? 0.0}',
                        index,
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  getFavoriteApi(
      {String wishListStatus, String productId, String wishListId}) async {
    Loader().showLoader(context);
    var wish = await RestApi.getWishListFromServer(
        wishListStatus: wishListStatus,
        wishListId: wishListId,
        productId: productId);
    Loader().hideLoader(context);
    BookOrderModel.orderModelObj.refreshViewForOrderBooking();
    setState(() {});
    return jsonDecode(wish)['wishlist_details'];
  }

  listItem(
      String productId,
      String img,
      String discount,
      String favorite,
      String wishListId,
      String productName,
      String mrp,
      String mrpPrice,
      String dealLabel,
      String dealPrice,
      index) {
    final themeColor = Provider.of<ThemeNotifier>(context);
    return Container(
      width: 170.0,
      child: Padding(
        padding: EdgeInsets.only(right: 10, left: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Stack(
              children: [
                Container(
                  height: Get.height * 0.2,
                  width: Get.width * 0.43,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: img.isNotEmpty
                        ? NetworkImage(img)
                        : AssetImage(
                            'assets/images/productPlaceaHolderImage.png'),
                    fit: BoxFit.cover,
                  )),
                  child: Stack(
                    children: [
                      widget.blockBusterList.data[index].savedPercentage != null
                          ? Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: Container(
                                  height: 42,
                                  width: 42,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: themeColor.getColor(),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(10, 0, 3, 0),
                                    child: Center(
                                      child: Text(
                                        discount + "% ${Strings.off}",
                                        style: GoogleFonts.roboto(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          :SizedBox()
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Flexible(
              child: Container(
                width: Get.width * 0.43,
                child: productName.length > 25
                    ? Marquee(
                        text: productName,
                        style: GoogleFonts.roboto(
                          fontSize: 13,
                          color:showMBPrimaryColor ?millBornPrimaryColor : themeColor.getColor(),
                          fontWeight: FontWeight.w300,
                        ),
                        scrollAxis: Axis.horizontal,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        blankSpace: 30.0,
                        velocity: 100.0,
                        pauseAfterRound: Duration(seconds: 3),
                        accelerationDuration: Duration(seconds: 3),
                        accelerationCurve: Curves.linear,
                        decelerationDuration: Duration(milliseconds: 500),
                        decelerationCurve: Curves.easeOut,
                      )
                    : Text(
                        productName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.roboto(
                          fontSize: 13,
                          color: showMBPrimaryColor ?millBornPrimaryColor :themeColor.getColor(),
                          fontWeight: FontWeight.w300,
                        ),
                      ),
              ),
            ),
            SizedBox(height: 4),
            // Container(
            //     child: Padding(
            //       padding: const EdgeInsets.all(2.0),
            //       child: Text("Unit Per Kg:-",style: TextStyle(fontWeight: FontWeight.bold),),
            //     )),
            widget.blockBusterList.data[index].ppMrp != null
                ? Container(
                    width: Get.width * 0.43,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [

                        Text(tempName == "MILLBORN-Jaipur" ?  "List Price:":
                          mrp,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.roboto(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                        SizedBox(width: 5),
                        Text(
                          mrpPrice,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.roboto(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  )
                :SizedBox(),
            SizedBox(height: 4),
            Container(
              width: Get.width * 0.43,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    dealLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.roboto(
                      color: Colors.grey[600],
                      fontSize: 13,
                    ),
                  ),
                  SizedBox(width: 5),
                  Text(
                    dealPrice,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.roboto(
                      color:showMBPrimaryColor ?millBornPrimaryColor : themeColor.getColor(),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
