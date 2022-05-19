import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:shoppingapp/models/BookOrderModel.dart';
import 'package:shoppingapp/models/homepage_model.dart';
import 'package:shoppingapp/screen/homepage_deals/trending_deals_screen/trending_deals_page.dart';
import 'package:shoppingapp/screen/product_detail/product_detail_page.dart';
import 'package:shoppingapp/utils/api/api.dart';
import 'package:shoppingapp/utils/navigator.dart';
import 'package:shoppingapp/utils/theme_notifier.dart';
import 'package:shoppingapp/widgets/commons/full_screen_loader.dart';
import 'package:shoppingapp/widgets/commons/string_res.dart';

BookOrderModel bookOrderObj = BookOrderModel.orderModelObj;

class TrendingDeals extends StatefulWidget {
  final Products trendingList;

  TrendingDeals(this.trendingList);

  @override
  TrendingDealsState createState() => TrendingDealsState();
}

class TrendingDealsState extends State<TrendingDeals> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                Strings.trendingpro,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Get.to(() => TrendingDealPage());
              },
              child: Padding(
                padding: EdgeInsets.only(right: 20),
                child: Text(
                  Strings.viewall,
                  style: GoogleFonts.poppins(
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
          padding: EdgeInsets.only(right: 3),
          child: widget.trendingList == null ||
                  widget.trendingList.data.isEmpty ||
                  widget.trendingList.data.length == 0
              ?SizedBox()
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.trendingList.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        int productIndex;
                        for (var i = 0;
                            i < bookOrderObj.productsInCart.length;
                            i++) {
                          if (bookOrderObj.productsInCart[i].productID ==
                              widget.trendingList.data[index].ppProductId
                                  .toString()) {
                            productIndex = i;
                          }
                        }
                        Nav.route(
                          context,
                          ProductDetailPage(
                            productId:
                                widget.trendingList.data[index].ppProductId,
                            productQty: productIndex == null
                                ? 1.0
                                : bookOrderObj.productsInCart[productIndex]
                                    .productQuantity,
                            stock: widget.trendingList.data[index].qtyInCases,
                          ),
                        );
                      },
                      child: listItem(
                          widget.trendingList.data[index].ppProductId
                              .toString(),
                          widget.trendingList.data[index].imageAttached
                                  .isNotEmpty
                              ? widget.trendingList.data[index].imageAttached
                                  .first.uploadPath
                              : "",
                          widget.trendingList.data[index].wishlist == null
                              ? '0'
                              : widget
                                  .trendingList.data[index].wishlist.wishlistId
                                  .toString(),
                          widget.trendingList.data[index].productName,
                          widget.trendingList.data[index].isinWishlist,
                          Strings.mrp1,
                          '₹ ${widget.trendingList.data[index].ppMrp.toStringAsFixed(2) ?? 0.0}',
                          Strings.ourpp,
                          '₹ ${widget.trendingList.data[index].ppPrice.toStringAsFixed(2) ?? 0.0}',
                          index),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget listItem(
      String productId,
      String img,
      String wishlistId,
      String productName,
      String favorite,
      String mrp,
      String mrpPrice,
      String deal,
      String dealPrice,
      index) {
    final themeColor = Provider.of<ThemeNotifier>(context);
    return Container(
      height: 200.0,
      width: 170.0,
      child: Padding(
        padding: EdgeInsets.only(right: 5, left: 10),
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
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Flexible(
              child: productName.length > 25
                  ? Marquee(
                      text: productName,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: themeColor.getColor(),
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
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: themeColor.getColor(),
                        fontWeight: FontWeight.w300,
                      ),
                    ),
            ),
            SizedBox(height: 4),
            Container(color: Colors.blue,height: 15,),
            widget.trendingList.data[index].ppMrp != null
                ? Container(
                    width: Get.width * 0.43,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          mrp,
                          maxLines: 1,
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                        SizedBox(width: 5),
                        Text(
                          mrpPrice,
                          maxLines: 1,
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
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
                    deal,
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      color: Colors.grey[600],
                      fontSize: 13,
                    ),
                  ),
                  SizedBox(width: 5),
                  Text(
                    dealPrice,
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      color: themeColor.getColor(),
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
}
