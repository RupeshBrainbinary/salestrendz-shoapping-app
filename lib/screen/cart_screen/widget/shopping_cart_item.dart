import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shoppingapp/models/BookOrderModel.dart';
import 'package:shoppingapp/screen/auth_screens/login/login_form.dart';
import 'package:shoppingapp/screen/home_screen/widget/blockbuster_deals/blockbuster_deals.dart';
import 'package:shoppingapp/utils/commons/colors.dart';
import 'package:shoppingapp/utils/constants/constants_app_variables.dart';
import 'package:get/get.dart';
import 'package:shoppingapp/utils/theme_notifier.dart';
import 'package:shoppingapp/widgets/commons/custom_alert.dart';

import '../../../app_url_name_companyid.dart';

class ShoppingCartItem extends StatelessWidget {
  const ShoppingCartItem({
    Key key,
    @required
    this.variantName,this.themeColor,
    this.imageUrl,
    this.orderProd,
    this.onCallback,
    this.qtyController,
    this.showOffer,
    this.onAddRemoveTap,
    this.onOfferTap,
  }) : super(key: key);
  final String variantName;
  final ThemeNotifier themeColor;
  final String imageUrl;
  final OrderedProduct orderProd;
  final Function onCallback;
  final bool showOffer;
  final TextEditingController qtyController;
  final VoidCallback onAddRemoveTap;
  final VoidCallback onOfferTap;


  @override
  Widget build(BuildContext context) {
    qtyController..text = this.orderProd.productQuantity.toInt().toString();
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 8, left: 24, bottom: 8, right: 24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey[200],
                blurRadius: 5.0,
                spreadRadius: 1,
                offset: Offset(0.0, 1),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: (orderProd?.productImages != null &&
                          orderProd.productImages.length > 0)
                      ? Image(
                          image: NetworkImage(orderProd.productImages.first),
                          fit: BoxFit.cover,
                          width: Get.width * 0.30,
                        )
                      : Image.asset(
                          'assets/images/productPlaceaHolderImage.png',
                          fit: BoxFit.cover,
                          width: Get.width * 0.30,
                        ),
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                height: 178,
                padding: EdgeInsets.all(10),
              ),
              Container(
                width: Get.width / 2,
                margin: EdgeInsets.only(top: 8, bottom: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    /*GestureDetector(
                      onTap: onOfferTap,
                      child: Container(
                        height: 35,
                        width: 70,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: themeColor.getColor(),
                          //border: Border.all(width: 2)
                        ),
                        child: Text(
                          "Offer",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),*/
                    AutoSizeText(
                      orderProd.productName,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Color(0xFF5D6A78),
                        fontWeight: FontWeight.w300,
                      ),
                      maxLines: 2,
                      minFontSize: 11,
                    ),

                    Row(
                      children: <Widget>[
                        // Text(
                        //   "$currencySymbol ${orderProd.mrp ?? 0}",
                        //   style: GoogleFonts.poppins(
                        //       decoration: TextDecoration.lineThrough,
                        //       fontSize: 14,
                        //       fontWeight: FontWeight.w300),
                        // ),
                        // SizedBox(
                        //   width: 4,
                        // ),
                        Text(
                          "$currencySymbol ${orderProd.productPrice.toStringAsFixed(2)}" +
                              " / " +
                              orderProd.unitsOfMeasurement.toString(),
                          style: GoogleFonts.poppins(
                            color: showMBPrimaryColor
                                ? millBornPrimaryColor
                                : themeColor.getColor(),
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                    AutoSizeText(
                      orderProd.brandName == 'null' ||
                              orderProd.brandName == null
                          ? ""
                          : orderProd.brandName,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Color(0xFF5D6A78),
                        fontWeight: FontWeight.w300,
                      ),
                      maxLines: 2,
                      minFontSize: 11,
                    ),
                    orderProd.variantName == null?variantName == null?Text(""):Text(variantName,
                        style: GoogleFonts.poppins(
                            color: themeColor.getColor(),
                            fontSize: 12,
                            fontWeight: FontWeight.w300)):Text(orderProd.variantName,
                        style: GoogleFonts.poppins(
                            color: themeColor.getColor(),
                            fontSize: 12,
                            fontWeight: FontWeight.w300)),
                  /*  variantName == null?Text(""):Text(variantName,
                        style: GoogleFonts.poppins(
                            color: themeColor.getColor(),
                            fontSize: 12,
                            fontWeight: FontWeight.w300)),*/
                  /*  Text(
                      orderProd.productVariantID,
                    style: GoogleFonts.poppins(
                    color: themeColor.getColor(),
                    fontSize: 10,
                    fontWeight: FontWeight.w300),
                    ),*/
                  ],
                ),
              )
            ],
          ),
        ),
        showOffer == false
            ? SizedBox()
            : Positioned(
                top: 8,
                left: 24,
                child: GestureDetector(
                  onTap: onOfferTap,
                  child: Container(
                    height: 35,
                    width: 70,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: themeColor.getColor(),
                      //border: Border.all(width: 2)
                    ),
                    child: Text(
                      "Offer",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
        Positioned(
          top: 0,
          right: 12,
          child: IconButton(
              icon: Icon(
                Feather.trash,
                size: 18,
                color: Color(0xFF5D6A78),
              ),
              onPressed: () {
                return showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        "Remove Product",
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 19,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      content: Text(
                        "Are you sure want to Remove It?",
                        style: GoogleFonts.poppins(),
                      ),
                      actions: [
                        FlatButton(
                          child: Text(
                            "OK",
                            style: GoogleFonts.poppins(
                              color: Theme.of(context).primaryColor,
                              fontSize: 19,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          onPressed: () {
                            BookOrderModel.orderModelObj
                                .removeSelectedProductFromCart(this.orderProd);
                            BookOrderModel.orderModelObj
                                .refreshViewForOrderBooking();
                            onCallback(() {});
                            onAddRemoveTap();
                            Get.back();
                          },
                        ),
                        FlatButton(
                          child: Text(
                            "Cancel",
                            style: GoogleFonts.poppins(
                              color: Theme.of(context).primaryColor,
                              fontSize: 19,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          onPressed: () {
                            Get.back();
                          },
                        )
                      ],
                    );
                  },
                );
              }),
        ),
        Positioned(
          bottom: 15,
          right: 32,
          child: Container(
            width: 120,
            height: 40.0,
            padding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: themeColor.getColor(),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  onTap: () {

                    if (this.orderProd.minQuantity ==
                        0 &&
                        this.orderProd
                            .productQuantity ==
                            this.orderProd.qtyIncases) {
                      bookOrderObj.addSelectedProductInCart(null);
                      return;
                    }
                    if (this.orderProd.minQuantity <
                        this.orderProd.productQuantity) {
                      this.orderProd.productQuantity -= this.orderProd.minQuantity == 0 ?1:this.orderProd.addQty;
                    }
                    if (this.orderProd.productQuantity == 0) {
                      BookOrderModel.orderModelObj.removeSelectedProductFromCart(this.orderProd);
                    }
                    bookOrderObj.addSelectedProductInCart(null);
                    onCallback(() {});
                    BookOrderModel.orderModelObj.refreshViewForOrderBooking();
                    onAddRemoveTap();
                    FocusScope.of(context).unfocus();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Text(
                      "-",
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        color: showMBPrimaryColor
                            ? millBornPrimaryColor
                            : Colors.white,
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: Colors.white,
                  ),
                  //alignment: Alignment.center,
                  width: 40,
                  height: 30,
                  padding: EdgeInsets.symmetric(horizontal: 3, vertical: 3),
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintStyle: GoogleFonts.poppins(),
                      errorStyle: GoogleFonts.poppins(),
                    ),
                    onChanged: (value) {
                      this.orderProd.productQuantity =
                          double.parse(int.parse(value ?? 1).toString());
                      BookOrderModel.orderModelObj.refreshViewForOrderBooking();
                      if (value != '') {
                        onAddRemoveTap();
                      }
                    },
                    controller: this.qtyController,
                    keyboardType: TextInputType.number,
                  ),
                ),
                InkWell(
                  onTap: () {
                    // this.orderProd.productQuantity += this.orderProd.addQty == 10 ? 1 :this.orderProd.addQty;
                    this.orderProd.productQuantity += this.orderProd.minQuantity == 0 ? 1 : this.orderProd.addQty;
                    bookOrderObj.addSelectedProductInCart(null);
                    BookOrderModel.orderModelObj.refreshViewForOrderBooking();
                    onCallback(() {});
                    onAddRemoveTap();
                    FocusScope.of(context).unfocus();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      "+",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        color: showMBPrimaryColor
                            ? millBornPrimaryColor
                            : Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
