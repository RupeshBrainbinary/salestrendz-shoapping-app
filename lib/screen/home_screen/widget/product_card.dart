import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:shoppingapp/app_url_name_companyid.dart';
import 'package:shoppingapp/models/BookOrderModel.dart';
import 'package:shoppingapp/models/GlobalModelClass.dart';
import 'package:shoppingapp/models/LoginModelClass.dart';
import 'package:shoppingapp/screen/auth_screens/login/login_form.dart';
import 'package:shoppingapp/screen/product_detail/product_detail_page.dart';
import 'package:shoppingapp/utils/commons/colors.dart';
import 'package:shoppingapp/utils/commons/export_basic_file.dart';
import 'package:shoppingapp/utils/constants/constants_app_variables.dart';
import 'package:shoppingapp/utils/theme_notifier.dart';
import 'package:http/http.dart' as http;
import 'package:shoppingapp/widgets/commons/custom_alert.dart';
import 'package:shoppingapp/widgets/commons/full_screen_loader.dart';
import 'package:shoppingapp/screen/home_screen/widget/wishlist_page_model.dart';
import 'package:shoppingapp/widgets/commons/string_res.dart';

final BookOrderModel bookOrderObj = BookOrderModel.orderModelObj;

class ProductCard extends StatefulWidget {
  const ProductCard(
      {Key key,
      @required this.themeColor,
      this.imageUrl,
      this.productTitle,
      this.productPrice,
      this.brandName,
      this.selectedProduct,
      this.index,
      this.refreshPage,
      this.qtyController,
      this.offerList,
      this.minQty,
      this.ppMrp,
      this.qtyInCases})
      : super(key: key);

  final String brandName;
  final String productTitle;
  final String productPrice;
  final ThemeNotifier themeColor;
  final String imageUrl;
  final Map selectedProduct;
  final int index;
  final Function refreshPage;
  final List<TextEditingController> qtyController;
  final List<Map> offerList;
  final minQty;
  final ppMrp;
  final qtyInCases;

  @override
  ProductCardState createState() => ProductCardState();
}

class ProductCardState extends State<ProductCard> {
  int cartListIndex = 0;
  WishListViewModel model;

  var currrentIndex;
  bool check = true;
  bool loading = false;
  int selectedIndex = 0;
  double count;

  bool textFieldSelect = false;
  double productValueIncre;

  @override
  void initState() {
    super.initState();
    // productValueIncre= bookOrderObj
    //     .productsInCart[selectedIndex].productQuantity;
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_statements
    model ?? (model = WishListViewModel(this));
    for (var i = 0; i < bookOrderObj.productsInCart.length; i++) {
      if (widget.selectedProduct['product_id'].toString() ==
          bookOrderObj.productsInCart[i].productID) {
        cartListIndex = i;
        selectedIndex = i;
        widget.qtyController[widget.index]
          ..text = bookOrderObj.productsInCart[selectedIndex]?.productQuantity
                  ?.toInt()
                  ?.toString() ??
              "1";
      }
      setState(() {});
    }
    return Stack(
      children: <Widget>[
        InkWell(
          onTap: () async {
            int productIndex;
            for (var i = 0; i < bookOrderObj.productsInCart.length; i++) {
              if (bookOrderObj.productsInCart[i].productID ==
                  widget.selectedProduct['product_id'].toString()) {
                productIndex = i;
              }
            }
            var data = await Get.to(
              () => ProductDetailPage(
                productId: widget.selectedProduct['product_id'],
                productQty: productIndex == null
                    ? 0.0
                    : bookOrderObj.productsInCart[productIndex].productQuantity,
                stock: widget.selectedProduct[''],
              ),
            );
            widget.refreshPage(0);
          },
          child: Container(
            width: Get.width / 2,
            margin: EdgeInsets.only(left: 16, top: 8, right: 12, bottom: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[200],
                    blurRadius: 5.0,
                    spreadRadius: 1,
                    offset: Offset(0.0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    height: 158,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          width: 300,
                          height: 170,
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                            ),
                            child: (widget.imageUrl != null &&
                                    widget.imageUrl == "" &&
                                    !widget.imageUrl.contains('http'))
                                ? Image.asset(
                                    'assets/images/productPlaceaHolderImage.png')
                                : Image(
                                    image: NetworkImage(widget.imageUrl),
                                  ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                              ),
                            ),
                            width: 240,
                            height: 20,
                            child: Align(
                              alignment: Alignment.center,
                              child: widget.productTitle.length > 25
                                  ? Marquee(
                                      text: widget.productTitle ?? "",
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        // need to change
                                        color: showMBPrimaryColor
                                            ? millBornPrimaryColor
                                            : widget.themeColor.getColor(),
                                        fontWeight: FontWeight.w300,
                                      ),
                                      scrollAxis: Axis.horizontal,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      blankSpace: 30.0,
                                      velocity: 20.0,
                                      pauseAfterRound: Duration(seconds: 3),
                                      accelerationDuration:
                                          Duration(seconds: 3),
                                      accelerationCurve: Curves.linear,
                                      decelerationDuration:
                                          Duration(milliseconds: 500),
                                      decelerationCurve: Curves.easeOut,
                                    )
                                  : Text(
                                      widget.productTitle ?? "",
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        color: showMBPrimaryColor
                                            ? millBornPrimaryColor
                                            : widget.themeColor.getColor(),
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 8,
                          child: InkWell(
                            onTap: () {
                              if (widget.selectedProduct['isin_wishlist'] ==
                                  'active') {
                                model.getAboutusApi(
                                  productId: widget
                                      .selectedProduct['product_id']
                                      .toString(),
                                  wishListId: widget.selectedProduct['wishlist']
                                          ['wishlist_id']
                                      .toString(),
                                  wishListStatus: 'inactive',
                                );
                                setState(
                                  () {
                                    widget.selectedProduct['isin_wishlist'] =
                                        "inactive";
                                  },
                                );
                                Scaffold.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor:
                                        tempName == "MILLBORN-Jaipur"
                                            ? millBornPrimaryThemeColor
                                            : mainC,
                                    duration: Duration(seconds: 1),
                                    content: Text(Strings.removetosts),
                                  ),
                                );
                                setState(() {});
                              } else {
                                model.getAboutusApi(
                                  productId: widget
                                      .selectedProduct['product_id']
                                      .toString(),
                                  wishListId: 'new',
                                  wishListStatus: 'active',
                                );
                                setState(() {
                                  widget.selectedProduct['isin_wishlist'] =
                                      "active";
                                });
                                Scaffold.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor:
                                        tempName == "MILLBORN-Jaipur"
                                            ? millBornPrimaryThemeColor
                                            : mainC,
                                    duration: Duration(seconds: 1),
                                    content: Text(Strings.addedtosts),
                                  ),
                                );
                                setState(() {});
                              }
                            },
                            child: Container(
                              height: 38,
                              width: 32,
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(8),
                                  bottomRight: Radius.circular(8),
                                ),
                              ),
                              child: Icon(
                                Icons.favorite,
                                color:
                                    widget.selectedProduct['isin_wishlist'] ==
                                            'active'
                                        ? Colors.red
                                        : Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                        widget.offerList
                                .map<String>((e) => e['name'])
                                .toList()
                                .isEmpty
                            ? SizedBox()
                            : Positioned(
                                top: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    openDialog(
                                      context,
                                      offer: widget.offerList
                                          .map<String>((e) => e['name'])
                                          .toList(),
                                      endTime: widget.offerList
                                          .map<String>((e) => e['start_date'])
                                          .toList(),
                                      startTime: widget.offerList
                                          .map<String>((e) => e['end_date'])
                                          .toList(),
                                    );
                                  },
                                  child: Container(
                                    height: 35,
                                    width: 70,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: widget.themeColor.getColor(),
                                      //border: Border.all(width: 2)
                                    ),
                                    child: Text(
                                      "Offer",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ))
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    width: 204.0,
                    padding: EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        widget.brandName != null
                            ? AutoSizeText(
                                widget.brandName,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Color(0xFF5D6A78),
                                  fontWeight: FontWeight.w300,
                                ),
                                maxLines: 2,
                                minFontSize: 11,
                              )
                            : AutoSizeText(
                                "",
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Color(0xFF5D6A78),
                                  fontWeight: FontWeight.w300,
                                ),
                                maxLines: 2,
                                minFontSize: 11,
                              ),
                        // SizedBox(height: 2),
                        // Align(
                        //   alignment: Alignment.centerRight,
                        //   // margin: EdgeInsets.only(left: 10,top: 2),
                        //     child: Padding(
                        //       padding: const EdgeInsets.only(right: 20.0,bottom: 0),
                        //       child: Text(
                        //         "Unit Per kg:-",
                        //         style: TextStyle(fontWeight: FontWeight.bold),
                        //       ),
                        //     )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Flexible(
                              child: Text(
                                tempName == "MILLBORN-Jaipur"
                                    ? "List Price:"
                                    : "MRP:",

                                // Strings.base_rate,
                                style: GoogleFonts.poppins(color: Colors.grey),
                              ),
                            ),
                            Flexible(
                              child: Text(
                                widget.ppMrp.toString() != null
                                    ? " ₹ ${widget.ppMrp.toString()}"
                                    : " ₹ 0.0",
                                style: GoogleFonts.poppins(
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 15, bottom: 12),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              widget.selectedProduct == null
                                  ? "135"
                                  : '${appName == "Q-ONE" ? 'S.P' : "D.P"} : $currencySymbol' +
                                      double.parse(widget.productPrice)
                                          .toStringAsFixed(2),
                              style: GoogleFonts.poppins(
                                color: showMBPrimaryColor
                                    ? millBornPrimaryColor
                                    : widget.themeColor.getColor(),
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        // SizedBox(height: 10,)
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        // SizedBox(height: 10,),
        Positioned(
            bottom: 17,
            right: 22,
            child: bookOrderObj.productsInCart.length == 0 ||
                    bookOrderObj.productsInCart.length - 1 < cartListIndex
                ? addToCartBtnWidget()
                : bookOrderObj.productsInCart[cartListIndex].productID ==
                        widget.selectedProduct['product_id'].toString()
                    ? addQuentityWidgetRow(cartListIndex)
                    : addToCartBtnWidget()),
        // SizedBox(height: 18,),
      ],
    );
  }

// ------------------------       THIS WIDGET FOR ADD OR REMOVE QUENTITY      ----------------

  Widget addQuentityWidgetRow(int selectedIndex) {
    final themeColor = Provider.of<ThemeNotifier>(context);
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 10),
            //padding: EdgeInsets.only(left: 10, right: 10, top: 4, bottom: 4),
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
                    if (bookOrderObj
                        .productsInCart[selectedIndex].minQuantity ==
                        0 &&
                        bookOrderObj.productsInCart[selectedIndex]
                            .productQuantity ==
                            widget.qtyInCases) {
                      bookOrderObj.productsInCart.removeAt(selectedIndex);
                      setState(() {});
                      return;
                    }

                    setState(() {
                      if (selectedIndex != null) {

                        if (   bookOrderObj.productsInCart[selectedIndex]
                            .productQuantity >
                            (  bookOrderObj
                                .productsInCart[selectedIndex].minQuantity ?? 0)) {
                          tempName == "MILLBORN-Jaipur"
                              ? bookOrderObj.productsInCart[selectedIndex]
                              .productQuantity -=
                          widget.minQty == 0
                              ? 1
                              : widget.minQty
                              : bookOrderObj.productsInCart[selectedIndex]
                              .productQuantity--;
                          bookOrderObj.productsInCart[selectedIndex]
                              .productQuantity =bookOrderObj.productsInCart[selectedIndex]
                              .productQuantity;
                          if (bookOrderObj.productsInCart[selectedIndex]
                              .productQuantity == 0) {
                            bookOrderObj.productsInCart.removeAt(selectedIndex);
                          }
                        } else if (bookOrderObj.productsInCart[selectedIndex]
                            .productQuantity ==
                            (widget.minQty ?? 0)) {
                          bookOrderObj.productsInCart.removeAt(selectedIndex);
                        }
                        bookOrderObj.addSelectedProductInCart(null);
                      } else {
                        if (bookOrderObj
                            .productsInCart[selectedIndex].minQuantity <
                            bookOrderObj.productsInCart[selectedIndex]
                                .productQuantity) {
                          bookOrderObj.productsInCart[selectedIndex]
                              .productQuantity--;
                        }
                        bookOrderObj.addSelectedProductInCart(null);

                        FocusScope.of(context).unfocus();
                      }
                      BookOrderModel.orderModelObj
                          .refreshViewForOrderBooking();
                      FocusScope.of(context).unfocus();
                    });
                  /*  if (bookOrderObj
                                .productsInCart[selectedIndex].minQuantity ==
                            0 &&
                        bookOrderObj.productsInCart[selectedIndex]
                                .productQuantity ==
                            widget.qtyInCases) {
                      bookOrderObj.productsInCart.removeAt(selectedIndex);
                      setState(() {});
                      return;
                    }
                    setState(
                      () {
                        if (bookOrderObj
                                .productsInCart[selectedIndex].minQuantity <
                            bookOrderObj.productsInCart[selectedIndex]
                                .productQuantity) {
                          if (bookOrderObj.productsInCart[selectedIndex]
                                      .productQuantity >
                                  1 &&
                              bookOrderObj.productsInCart[selectedIndex]
                                      .productQuantity !=
                                  widget.minQty) {
                            tempName == "MILLBORN-Jaipur"
                                ? bookOrderObj.productsInCart[selectedIndex]
                                    .productQuantity -= (widget.minQty ==
                                        0
                                    ? 1
                                    : widget.minQty)
                                : bookOrderObj.productsInCart[selectedIndex]
                                    .productQuantity--;
                            widget.qtyController[widget.index]
                              ..text = bookOrderObj
                                  .productsInCart[selectedIndex].productQuantity
                                  .toInt()
                                  .toString();
                          } else {
                            bookOrderObj.productsInCart.removeAt(selectedIndex);
                            BookOrderModel.orderModelObj
                                .refreshViewForOrderBooking();
                            setState(() {});
                          }
                        }
                        bookOrderObj.addSelectedProductInCart(null);
                        FocusScope.of(context).unfocus();
                      },
                    );*/
                  },
                  child: Padding(
                    padding:
                        EdgeInsets.only(left: 10, top: 4, bottom: 4, right: 15),
                    child: Text(
                      "-",
                      style: TextStyle(
                        fontSize: 24,
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
                  alignment: Alignment.center,
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
                      bookOrderObj
                              .productsInCart[selectedIndex].productQuantity =
                          double.parse(int.parse(value ?? 1).toString());
                    },
                    controller: widget.qtyController[widget.index],
                    keyboardType: TextInputType.number,
                  ),
                ),
                /*       Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: Color(0xFF707070),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    width: 30,
                    padding: EdgeInsets.symmetric(horizontal: 3, vertical: 3),
                    child: Text(
                      '${(bookOrderObj.productsInCart[selectedIndex].productQuantity ?? 1.0).toInt()}',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),*/
                InkWell(
                  onTap: () {
                    tempName == "MILLBORN-Jaipur"
                        ? bookOrderObj.productsInCart[selectedIndex]
                            .productQuantity += (widget.minQty ==
                                0
                            ? 1
                            : widget.minQty)
                        : bookOrderObj
                            .productsInCart[selectedIndex].productQuantity++;
                    widget.qtyController[widget.index]
                      ..text = bookOrderObj
                          .productsInCart[selectedIndex].productQuantity
                          .toInt()
                          .toString();
                    bookOrderObj.addSelectedProductInCart(null);
                    setState(() {});
                    FocusScope.of(context).unfocus();
                  },
                  child: Padding(
                    padding:
                        EdgeInsets.only(left: 15, right: 10, top: 4, bottom: 4),
                    child: Text(
                      "+",
                      style: TextStyle(
                          color: showMBPrimaryColor
                              ? millBornPrimaryColor
                              : Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

// ------------------------       THIS WIDGET FOR ADD PRODUCT IN CART     ----------------

  Widget addToCartBtnWidget() {
    return InkWell(
      onTap: () {
        textFieldSelect = false;
        Loader().showLoader(context);

        BookOrderModel.orderModelObj.refreshViewForOrderBooking();
        getProductDetailsAndAddToCart(
            context, this.widget.selectedProduct['product_id'].toString());
        check = false;
        setState(() {});
      },
      child: Container(
        padding: EdgeInsets.only(top: 10, left: 8, bottom: 8, right: 8),
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
            ]),
        child: Row(
          children: <Widget>[
            SvgPicture.asset(
              "assets/icons/ic_product_shopping_cart.svg",
              height: 12,
            ),
            SizedBox(width: 8),
            Text(
              Strings.addToCart,
              style: GoogleFonts.poppins(
                color: Color(0xFF5D6A78),
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
            )
          ],
        ),
      ),
    );
  }

// ------------------------       THIS WIDGET FOR SHOW ADD PRODUCT IN CART BTN WHEN API CALLING      ----------------

  Widget placeHolderAddToCartBtn() {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.only(top: 10, left: 8, bottom: 8, right: 8),
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
          children: <Widget>[
            SvgPicture.asset(
              "assets/icons/ic_product_shopping_cart.svg",
              height: 12,
            ),
            SizedBox(width: 8),
            Text(
              Strings.addToCart,
              style: GoogleFonts.poppins(
                color: Color(0xFF5D6A78),
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
            )
          ],
        ),
      ),
    );
  }

  void getProductDetailsAndAddToCart(
      BuildContext context, String selectedProductID) async {
    bool isAdded = false;
    String loggedInUserId = LoginModelClass.loginModelObj
        .getValueForKeyFromLoginResponse(key: 'user_id');

    if (GlobalModelClass.internetConnectionAvaiable() == true) {
      http.Response resp = await http.get(
          Uri.parse(Base_URL +
              productDetails +
              '&logged_in_userid=$loggedInUserId&product_id=$selectedProductID'),
          headers: {
            'Authorization': LoginModelClass.loginModelObj
                .getValueForKeyFromLoginResponse(key: 'token'),
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          });
      Loader().hideLoader(context);
      if (resp.statusCode == 200) {
        var jsonBodyResp = jsonDecode(resp.body);

        if (jsonBodyResp['status'] == true) {
          // ignore: invalid_use_of_protected_member
          Scaffold.of(context).setState(
            () {
              bookOrderObj.selectedProduct = jsonBodyResp['products'];
              bookOrderObj.currentProductVariants =
                  bookOrderObj.selectedProduct['available_variants'];
              bookOrderObj.availableVariantsList = availableVariantsFromJson(
                  jsonEncode(
                      bookOrderObj.selectedProduct['available_variants']));
              bookOrderObj.selectedVariant =
                  bookOrderObj.currentProductVariants.first;

              if (bookOrderObj.productsInCart == null) {
                bookOrderObj.productsInCart = [];
              }

              OrderedProduct tempProduct = bookOrderObj.getProductDetailsObject(
                  selectedVarientId: jsonBodyResp['products'],
                  productID: selectedProductID,
                  // this Product Qty only for Millborn
          /*        productQty: double.parse(
                      widget.qtyController[widget.index]?.text != ""
                          ? widget.qtyController[widget.index]?.text
                          : widget.minQty.toString() == "0" &&
                                  widget.qtyInCases.toString() == "10"
                              ? widget.qtyInCases.toString()
                              : widget.minQty.toString() == "0" ? "1":widget.minQty.toString()),*/
                  // this neelam , q-one
                      productQty: double.parse(
                      widget.qtyController[widget.index]?.text != ""
                          ? widget.qtyController[widget.index]?.text
                          : "1"),
                  callType: 1,
                  isVariantAvailable: true);
              Scaffold.of(context).setState(() {
                bookOrderObj.showLoadingIndicator = false;
              });
              if (bookOrderObj.selectedProduct['type'] == 'Variant') {
                check = true;
                variantsBottomSheet(
                  tempProduct,
                  (value) {
                    isAdded = value;
                    Scaffold.of(context).setState(
                      () {
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: tempName == "MILLBORN-Jaipur"
                                ? millBornPrimaryThemeColor
                                : mainC,
                            duration: Duration(seconds: 1),
                            content: Text(
                              isAdded ? Strings.aleardyadded : Strings.proadded,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
                setState(() {});
              } else {
                for (var i = 0; i < bookOrderObj.productsInCart.length; i++) {
                  if (bookOrderObj.productsInCart[i].productVariantID ==
                      tempProduct.productVariantID) {
                    bookOrderObj.productsInCart.removeAt(i);
                    isAdded = true;
                  } else {}
                }
                check = true;
                setState(() {});
                bookOrderObj.addSelectedProductInCart(tempProduct);
                BookOrderModel.orderModelObj.refreshViewForOrderBooking();
                Scaffold.of(context).setState(
                  () {
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: tempName == "MILLBORN-Jaipur"
                            ? millBornPrimaryThemeColor
                            : mainC,
                        duration: Duration(seconds: 1),
                        content: Text(
                          isAdded ? Strings.aleardyadded : Strings.proadded,
                        ),
                      ),
                    );
                  },
                );
              }
            },
          );
        } else {}
      } else {
        print(resp.body);
        print('Error occurred while serving request');
      }
    } else {
      Future.delayed(
        Duration.zero,
        () {
          GlobalModelClass.showAlertForNoInternetConnection(context).show();
        },
      );
    }
  }

  void variantsBottomSheet(
      OrderedProduct productData, Function addedCartFunction) {
    OrderedProduct tempProduct = bookOrderObj.getProductDetailsObject(
        selectedVarientId: bookOrderObj.selectedProduct,
        productID: this.widget.selectedProduct['product_id'].toString(),
        callType: 1,
        variantIndex: selectedIndex,
        productQty: 1.0,
        isVariantAvailable: true);
    widget.qtyController[widget.index]..text = "1";
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: this.context,
      builder: (BuildContext context) {
        final themeColor = Provider.of<ThemeNotifier>(context);
        return StatefulBuilder(
          builder:
              (BuildContext context, void Function(void Function()) setState) {
            return Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    height: Get.height * 0.07,
                    padding: EdgeInsets.all(10),
                    color: themeColor.getColor(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          Strings.SelectVariants,
                          style: GoogleFonts.poppins(color: Colors.white),
                        ),
                        InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    height: Get.height * 0.25,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: bookOrderObj
                              .selectedProduct['available_variants'].length ??
                          0,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            InkWell(
                              onTap: () {
                                selectedIndex = index;
                                tempProduct =
                                    bookOrderObj.getProductDetailsObject(
                                        selectedVarientId:
                                            bookOrderObj.selectedProduct,
                                        productID: this
                                            .widget
                                            .selectedProduct['product_id']
                                            .toString(),
                                        callType: 1,
                                        productQty: double.parse(widget
                                                    .qtyController[widget.index]
                                                    ?.text !=
                                                ""
                                            ? widget.qtyController[widget.index]
                                                ?.text
                                            : "1"),
                                        variantIndex: selectedIndex,
                                        isVariantAvailable: true);
                                currrentIndex = bookOrderObj
                                        .selectedProduct['available_variants']
                                    [index]['variant_attri_name'];
                                setState(() {});
                              },
                              child: Container(
                                height: 80,
                                width: 80,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: bookOrderObj.selectedProduct[
                                                    'available_variants'][index]
                                                .containsKey(
                                                    'imagesize512x512') &&
                                            bookOrderObj
                                                .selectedProduct['available_variants']
                                                    [index]['imagesize512x512']
                                                .isNotEmpty
                                        ? NetworkImage(bookOrderObj
                                            .selectedProduct['available_variants']
                                                [index]['imagesize512x512'][0]
                                            .toString())
                                        : AssetImage(
                                            'assets/images/productPlaceaHolderImage.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    selectedIndex = index;
                                    tempProduct =
                                        bookOrderObj.getProductDetailsObject(
                                            selectedVarientId:
                                                bookOrderObj.selectedProduct,
                                            productID: this
                                                .widget
                                                .selectedProduct['product_id']
                                                .toString(),
                                            callType: 1,
                                            productQty: double.parse(widget
                                                        .qtyController[
                                                            widget.index]
                                                        ?.text !=
                                                    ""
                                                ? widget
                                                    .qtyController[widget.index]
                                                    ?.text
                                                : "1"),
                                            variantIndex: selectedIndex,
                                            isVariantAvailable: true);
                                    currrentIndex =
                                        bookOrderObj.selectedProduct[
                                                'available_variants'][index]
                                            ['variant_attri_name'];
                                    setState(() {});
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      top: 20,
                                      left: 10,
                                      bottom: 10,
                                    ),
                                    padding: EdgeInsets.only(
                                      top: 15,
                                      left: 15,
                                      right: 20,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                        color: currrentIndex ==
                                                bookOrderObj.selectedProduct[
                                                        'available_variants'][
                                                    index]['variant_attri_name']
                                            ? themeColor.getColor()
                                            : Colors.grey[300],
                                      ),
                                    ),
                                    child: Container(
                                      child: Text(
                                        bookOrderObj.selectedProduct[
                                                'available_variants'][index]
                                            ['variant_attri_name'],
                                        style: GoogleFonts.poppins(
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5)
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 35,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          margin: EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: themeColor.getColor())),
                          child: Center(
                            child: Text(
                              //"$currencySymbol ${bookOrderObj.selectedProduct['available_variants'][selectedIndex ?? 0]['variant_attri_name']}",
                              "Price: $currencySymbol ${bookOrderObj.selectedProduct['available_variants'][selectedIndex ?? 0]['price']} / ${bookOrderObj.selectedProduct['available_variants'][selectedIndex ?? 0]['unit_of_measurement']}",
                              style: TextStyle(
                                color: themeColor.getColor(),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          child: Row(
                            children: [
                              Container(
                                width: 120,
                                padding: EdgeInsets.only(
                                  left: 8,
                                  right: 8,
                                  top: 4,
                                  bottom: 4,
                                ),
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
                                        setState(
                                          () {
                                            if (tempProduct.minQuantity <
                                                tempProduct.productQuantity) {
                                              tempProduct.productQuantity--;
                                              widget.qtyController[widget.index]
                                                ..text = tempProduct
                                                    .productQuantity
                                                    .toInt()
                                                    .toString();
                                            }
                                            bookOrderObj
                                                .addSelectedProductInCart(null);
                                            FocusScope.of(context).unfocus();
                                          },
                                        );
                                      },
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 16.0),
                                        child: Text(
                                          "-",
                                          style: TextStyle(
                                            fontSize: 24,
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
                                      alignment: Alignment.center,
                                      width: 40,
                                      height: 30,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 3, vertical: 3),
                                      child: TextFormField(
                                        textAlign: TextAlign.center,
                                        decoration: InputDecoration(
                                          hintStyle: GoogleFonts.poppins(),
                                          errorStyle: GoogleFonts.poppins(),
                                        ),
                                        onChanged: (value) {
                                          tempProduct.productQuantity =
                                              double.parse(value);
                                        },
                                        controller:
                                            widget.qtyController[widget.index],
                                        keyboardType: TextInputType.number,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(
                                          () {
                                            tempProduct.productQuantity++;
                                            widget.qtyController[widget.index]
                                              ..text = tempProduct
                                                  .productQuantity
                                                  .toInt()
                                                  .toString();
                                            bookOrderObj
                                                .addSelectedProductInCart(null);
                                            FocusScope.of(context).unfocus();
                                          },
                                        );
                                      },
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 16.0),
                                        child: Text(
                                          "+",
                                          style: TextStyle(
                                              color: showMBPrimaryColor
                                                  ? millBornPrimaryColor
                                                  : Colors.white),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.only(right: 10, left: 10),
                    margin: EdgeInsets.only(bottom: 20),
                    width: Get.width,
                    child: RaisedButton(
                      color: themeColor.getColor(),
                      onPressed: () {
                        bool isAdded = false;
                        Get.back();
                        for (var i = 0;
                            i < bookOrderObj.productsInCart.length;
                            i++) {
                          if (bookOrderObj.productsInCart[i].productVariantID ==
                              tempProduct.productVariantID) {
                            bookOrderObj.productsInCart.removeAt(i);

                            isAdded = true;
                          } else {}
                        }
                        /*   orderedProduct.variantName =
                            currrentIndex.toString();*/
                        tempProduct = bookOrderObj.getProductDetailsObject(
                            selectedVarientId: bookOrderObj.selectedProduct,
                            productID: this
                                .widget
                                .selectedProduct['product_id']
                                .toString(),
                            callType: 1,
                            variantIndex: selectedIndex,
                            isVariantAvailable: true,
                            productQty: double.parse(
                                widget.qtyController[widget.index].text));
                        bookOrderObj.addSelectedProductInCart(tempProduct);

                        addedCartFunction(isAdded);
                        BookOrderModel.orderModelObj
                            .refreshViewForOrderBooking();
                        widget.qtyController.clear();
                      },
                      child: Container(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: Text(
                          Strings.addToCart,
                          style: GoogleFonts.poppins(color: Colors.white),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}
