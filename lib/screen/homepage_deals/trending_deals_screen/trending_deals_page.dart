import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shoppingapp/app_url_name_companyid.dart';
import 'package:shoppingapp/models/BookOrderModel.dart';
import 'package:shoppingapp/models/GlobalModelClass.dart';
import 'package:shoppingapp/models/LoginModelClass.dart';
import 'package:shoppingapp/screen/auth_screens/login/login_form.dart';
import 'package:shoppingapp/screen/drawer/drawer.dart';
import 'package:shoppingapp/screen/homepage_deals/trending_deals_screen/trending_deal_model.dart';
import 'package:shoppingapp/screen/product_detail/product_detail_page.dart';
import 'package:shoppingapp/utils/commons/colors.dart';
import 'package:shoppingapp/utils/constants/constants_app_variables.dart';
import 'package:shoppingapp/utils/theme_notifier.dart';
import 'package:shoppingapp/widgets/commons/full_screen_loader.dart';
import 'package:shoppingapp/widgets/commons/string_res.dart';
import 'package:http/http.dart' as http;

class TrendingDealPage extends StatefulWidget {
  @override
  TrendingDealPageState createState() => TrendingDealPageState();
}

BookOrderModel bookOrderObj = BookOrderModel.orderModelObj;

class TrendingDealPageState extends State<TrendingDealPage> {
  TrendingDealPageViewModel model;
  TrendingDealFavoriteViewModel model1;

  int selectedIndex = 0;
  int cartListIndex = 0;

  bool check = true;
  final searchController = TextEditingController();
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  bool search = false;

  var currrentIndex;
  List<TextEditingController> qtyController = [];
  TextEditingController textController = TextEditingController();

  ScrollController controller;
  bool isPaging = false;
  int initPosition = 0;
  int page = 1;

  @override
  void initState() {
    super.initState();
    controller = new ScrollController()..addListener(_scrollListener);
    // ignore: unnecessary_statements
    currrentIndex;
    setState(() {});
  }

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (controller.position.extentAfter < 100) {
      if (model.canPaging && !isPaging) {
        setState(() {
          isPaging = true;
        });
        page++;
        model.getHomePageApi(page);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<ThemeNotifier>(context);
    // ignore: unnecessary_statements
    model ?? (model = TrendingDealPageViewModel(this));
    // ignore: unnecessary_statements
    model1 ?? (model1 = TrendingDealFavoriteViewModel(this));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          Strings.trendingDeals,
          style: GoogleFonts.poppins(color: Colors.black),
        ),
        actions: [
          InkWell(
            onTap: () {
              if (search == true) {
                search = false;
              } else {
                search = true;
              }
              setState(() {});
            },
            child: Icon(Icons.search),
          ),
          SizedBox(width: 20),
        ],
      ),
      drawer: CustomDrawer(),
      body: model.homepage == null
          ? Center(child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(themeColor.getColor())))
          : Column(
              children: [
                search != true
                    ?SizedBox()
                    : Container(
                        width: Get.width * 0.85,
                        margin: EdgeInsets.only(left: 15, top: 14),
                        padding: EdgeInsets.only(left: 18, right: 18),
                        height: 44,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey[200],
                              blurRadius: 8.0,
                              spreadRadius: 1,
                              offset: Offset(0.0, 3),
                            )
                          ],
                          color: Theme.of(context).bottomAppBarColor,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          children: <Widget>[
                            SvgPicture.asset(
                              "assets/icons/ic_search.svg",
                              color: Colors.black45,
                              height: 12,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(bottom: 4),
                                height: 72,
                                child: TextFormField(
                                  cursorColor: Theme.of(context).primaryColor,
                                  controller: searchController,
                                  key: _formKey,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: Strings.searchpro,
                                    hintStyle: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: Color(0xFF5D6A78),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  onFieldSubmitted: (searchText) async {
                                    Loader().showLoader(context);
                                    await model.getHomePageApiInitial();
                                    Loader().hideLoader(context);
                                    setState(() {});
                                  },
                                ),
                              ),
                            ),
                            searchController.text.length > 0
                                ? InkWell(
                                    onTap: () async {
                                      searchController.clear();
                                      Loader().showLoader(context);
                                      await model.getHomePageApiInitial();
                                      page = 1;
                                      Loader().hideLoader(context);
                                      setState(() {});
                                    },
                                    child: Icon(Icons.close),
                                  )
                                :SizedBox()
                          ],
                        ),
                      ),
                search != true ?SizedBox() : Divider(thickness: 1),
                Expanded(
                  child: Container(
                    // height:
                    //     search != true ? Get.height * 0.88 : Get.height * 0.77,
                    child: model.homepage.trendingProducts == null
                        ? Container(
                            height: Get.height / 1.5,
                            alignment: Alignment.center,
                            child: Text(
                              Strings.trenddealsnotavail,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                                color: Colors.black54,
                              ),
                            ),
                          )
                        : ListView.builder(
                            controller: controller,
                            itemCount:
                                model.homepage.trendingProducts.data.length,
                            itemBuilder: (BuildContext context, int index) {
                              qtyController = [];
                              List.generate(model.homepage.blockbusterProducts.data.length, (index) => qtyController.add(TextEditingController()));
                              for (var i = 0;
                                  i < bookOrderObj.productsInCart.length;
                                  i++) {
                                if (model.homepage.trendingProducts.data[index]
                                        .ppProductId
                                        .toString() ==
                                    bookOrderObj.productsInCart[i].productID) {
                                  cartListIndex = i;
                                  qtyController[index]..text = bookOrderObj.productsInCart[cartListIndex]?.productQuantity?.toInt()?.toString() ?? "1";
                                }
                              }
                              return productTile(index, themeColor, context);
                            },
                          ),
                  ),
                )
              ],
            ),
    );
  }

  productTile(int index, themeColor, context) {
    return Container(
      child: InkWell(
        onTap: () async {
          int productIndex;
          for (var i = 0; i < bookOrderObj.productsInCart.length; i++) {
            if (bookOrderObj.productsInCart[i].productID ==
                model.homepage.trendingProducts.data[index].ppProductId
                    .toString()) {
              productIndex = i;
            }
          }

          var data = await Get.to(
            () => ProductDetailPage(
              productId:
                  model.homepage.trendingProducts.data[index].ppProductId,
              productQty: productIndex == null
                  ? 1.0
                  : bookOrderObj.productsInCart[productIndex].productQuantity,
              stock: model.homepage.trendingProducts.data[index].qtyInCases,
            ),
          );

          Loader().showLoader(context);
          await model.getHomePageApiInitial();
          Loader().hideLoader(context);
        },
        child: Container(
          margin: EdgeInsets.only(right: 5, top: 5),
          child: Column(
            children: [
              Container(
                child: Row(
                  children: [
                    Column(
                      children: [
                        model.homepage.trendingProducts.data[index]
                                .imageAttached.isNotEmpty
                            ? Image.network(
                                model.homepage.trendingProducts.data[index]
                                    .imageAttached.first.uploadPath,
                                height: Get.height * 0.1,
                                width: Get.width * 0.29,
                              )
                            : Image.asset(
                                'assets/images/productPlaceaHolderImage.png',
                                height: Get.height * 0.1,
                                width: Get.width * 0.29,
                              ),
                        SizedBox(height: 10),
                        model.homepage.trendingProducts.data[index]
                                    .savedPercentage ==
                                null
                            ?SizedBox()
                            : Container(
                                width: Get.width * 0.23,
                                padding: EdgeInsets.only(
                                    top: 2, left: 5, bottom: 2, right: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  border:
                                      Border.all(color: themeColor.getColor()),
                                ),
                                child: Center(
                                  child: Text(
                                    (model.homepage.trendingProducts.data[index]
                                            .savedPercentage
                                            .round()
                                            .toString() +
                                        '% ${Strings.off}'),
                                    maxLines: 1,
                                    style: GoogleFonts.poppins(
                                      color: themeColor.getColor(),
                                    ),
                                  ),
                                ),
                              )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: Get.width * 0.6,
                              child: Text(
                                model.homepage.trendingProducts.data[index]
                                    .productName,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  color: Colors.grey[500],
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                if (model.homepage.trendingProducts.data[index]
                                        .isinWishlist ==
                                    'active') {
                                  model1.getFavoriteApi(
                                    productId: model.homepage.trendingProducts
                                        .data[index].ppProductId
                                        .toString(),
                                    wishListId: model.homepage.trendingProducts
                                        .data[index].wishlist.wishlistId
                                        .toString(),
                                    wishListStatus: 'inactive',
                                  );
                                  setState(() {
                                    model.homepage.trendingProducts.data[index]
                                        .isinWishlist = 'inactive';
                                  });
                                  // ignore: deprecated_member_use
                                  Scaffold.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor:tempName == "MILLBORN-Jaipur" ? millBornPrimaryThemeColor :  mainC,
                                      duration: Duration(seconds: 1),
                                      content: Text(Strings.removetosts),
                                    ),
                                  );
                                  setState(() {});
                                } else {
                                  model1.getFavoriteApi(
                                    productId: model.homepage.trendingProducts
                                        .data[index].ppProductId
                                        .toString(),
                                    wishListId: 'new',
                                    wishListStatus: 'active',
                                  );
                                  setState(() {
                                    model.homepage.trendingProducts.data[index]
                                        .isinWishlist = 'active';
                                  });
                                  // ignore: deprecated_member_use
                                  Scaffold.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor:tempName == "MILLBORN-Jaipur" ? millBornPrimaryThemeColor :  mainC,
                                      duration: Duration(seconds: 1),
                                      content: Text(Strings.addedtosts),
                                    ),
                                  );
                                  setState(() {});
                                }
                              },
                              child: Icon(
                                Icons.favorite,
                                color: model.homepage.trendingProducts
                                            .data[index].isinWishlist ==
                                        'active'
                                    ? Colors.red
                                    : Colors.black,
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                        // ignore: unrelated_type_equality_checks
                        model.homepage.trendingProducts.data[index]
                                    .qtyInCases ==
                                '0'
                            ? Text(
                                Strings.outofstock,
                                style: GoogleFonts.poppins(
                                  color: themeColor.getColor(),
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            : Text(
                                "${Strings.stock}${model.homepage.trendingProducts.data[index].qtyInCases}",
                                style: GoogleFonts.poppins(
                                  color: Colors.grey[500],
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13,
                                ),
                              ),
                        Container(
                          width: Get.width * 0.69,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              model.homepage.trendingProducts.data[index]
                                          .ppMrp !=
                                      null
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          Strings.base_rate,
                                          style: GoogleFonts.poppins(
                                            color: Colors.grey,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          '₹ ${model.homepage.trendingProducts.data[index].ppMrp.toStringAsFixed(2) ?? 0.0}',
                                          style: GoogleFonts.poppins(
                                            color: Colors.grey,
                                            decoration:
                                                TextDecoration.lineThrough,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    )
                                  :SizedBox()
                            ],
                          ),
                        ),
                        Container(
                          width: Get.width * 0.69,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    Strings.Price,
                                    style: GoogleFonts.poppins(
                                      color:showMBPrimaryColor ?millBornPrimaryColor : themeColor.getColor(),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    '₹ ${model.homepage.trendingProducts.data[index].ppPrice.round().toStringAsFixed(2) ?? 0.0}',
                                    style: GoogleFonts.poppins(
                                      color:showMBPrimaryColor ?millBornPrimaryColor : themeColor.getColor(),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: Get.width * 0.69,
                          child: model.homepage.trendingProducts.data[index]
                                      .savedAmount ==
                                  null
                              ?SizedBox()
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      Strings.discount_rate,
                                      style: GoogleFonts.poppins(
                                        color: Colors.grey,
                                        fontSize: 13,
                                      ),
                                    ),
                                    Text(
                                      '₹' +
                                          model.homepage.trendingProducts
                                              .data[index].savedAmount
                                              .toString() +
                                          ' (${model.homepage.trendingProducts.data[index].savedPercentage ?? 0}%)',
                                      style: GoogleFonts.poppins(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                      ),
                                    )
                                  ],
                                ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                color: Colors.white10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(width: 10),
                    bookOrderObj.productsInCart.length == 0 ||
                            bookOrderObj.productsInCart.length - 1 <
                                cartListIndex
                        ?  addToCartBtnWidget(index, themeColor, context)
                        : bookOrderObj.productsInCart[cartListIndex].productID
                                    .toString() ==
                                model.homepage.trendingProducts.data[index]
                                    .ppProductId
                                    .toString()
                            ? addQuentityWidgetRow(index,
                                cartListIndex, themeColor, context)
                            : addToCartBtnWidget(index, themeColor, context)
                  ],
                ),
              ),
              Divider(thickness: 1)
            ],
          ),
        ),
      ),
    );
  }

  // ------------------------       THIS WIDGET FOR ADD OR REMOVE QUENTITY      ----------------

  Widget addQuentityWidgetRow(int index,
      int selectedIndex, ThemeNotifier themeColor, BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 10, right: 10, top: 4, bottom: 4),
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
                    setState(() {
                      if (bookOrderObj
                              .productsInCart[selectedIndex].minQuantity <
                          bookOrderObj
                              .productsInCart[selectedIndex].productQuantity) {
                        bookOrderObj
                            .productsInCart[selectedIndex].productQuantity--;
                      }
                      bookOrderObj.addSelectedProductInCart(null);
                      BookOrderModel.orderModelObj.refreshViewForOrderBooking();
                      FocusScope.of(context).unfocus();
                    });
                  },
                  child: Text(
                    "-",
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      color: showMBPrimaryColor ?millBornPrimaryColor :Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 9),
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
                      bookOrderObj.productsInCart[selectedIndex].productQuantity =
                          double.parse(int.parse(value ?? 1).toString());
                      BookOrderModel.orderModelObj.refreshViewForOrderBooking();
                    },
                    controller: qtyController[index],
                    keyboardType: TextInputType.number,
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      bookOrderObj
                          .productsInCart[selectedIndex].productQuantity++;
                      // print('object');
                      bookOrderObj.addSelectedProductInCart(null);
                      BookOrderModel.orderModelObj.refreshViewForOrderBooking();
                      FocusScope.of(context).unfocus();
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 9.0),
                    child: Text(
                      "+",
                      style: GoogleFonts.poppins(
                        color:showMBPrimaryColor ?millBornPrimaryColor : Colors.white,
                        fontSize: 16,
                      ),
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
  Widget addToCartBtnWidget(
      int index, ThemeNotifier themeColor, BuildContext context) {
    return InkWell(
      onTap: () {
        Loader().showLoader(context);
        BookOrderModel.orderModelObj.refreshViewForOrderBooking();
        getProductDetailsAndAddToCart(index,context,
            model.homepage.trendingProducts.data[index].ppProductId.toString());
        check = false;
        setState(() {});
      },
      child: Container(
        margin: EdgeInsets.only(right: 15),
        padding: EdgeInsets.fromLTRB(10, 5, 8, 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: themeColor.getColor()),
        ),
        child: Row(
          children: [
            Image.asset(
              "assets/icons/shopping-cart.png",
              height: 18,
              width: 20,
              color: themeColor.getColor(),
            ),
            SizedBox(width: 5),
            Text(
              Strings.addToCart,
              style: GoogleFonts.poppins(
                color: themeColor.getColor(),
              ),
            ),
          ],
        ),
      ),
    );
  }

// ------------------------       THIS WIDGET FOR SHOW ADD PRODUCT IN CART BTN WHEN API CALLING      ----------------

  Widget placeHolderAddToCartBtn(
      ThemeNotifier themeColor, BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.only(right: 15),
        padding: EdgeInsets.fromLTRB(10, 5, 8, 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: themeColor.getColor(),
          ),
        ),
        child: Row(
          children: [
            Image.asset(
              "assets/icons/shopping-cart.png",
              height: 18,
              width: 20,
              color: themeColor.getColor(),
            ),
            SizedBox(width: 5),
            Text(
              Strings.addToCart,
              style: GoogleFonts.poppins(color: themeColor.getColor()),
            ),
          ],
        ),
      ),
    );
  }

  void getProductDetailsAndAddToCart(int index,
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
        },
      );

      // ignore: invalid_use_of_protected_member
      Scaffold.of(context).setState(() {
        bookOrderObj.showLoadingIndicator = false;
      });
      if (resp.statusCode == 200) {
        var jsonBodyResp = jsonDecode(resp.body);

        if (jsonBodyResp['status'] == true) {
          // ignore: invalid_use_of_protected_member
          Scaffold.of(context).setState(() {
            bookOrderObj.selectedProduct = jsonBodyResp['products'];
            bookOrderObj.currentProductVariants =
                bookOrderObj.selectedProduct['available_variants'];
            bookOrderObj.availableVariantsList = availableVariantsFromJson(jsonEncode(bookOrderObj.selectedProduct['available_variants']));
            bookOrderObj.selectedVariant =
                bookOrderObj.currentProductVariants.first;
            if (bookOrderObj.productsInCart == null) {
              bookOrderObj.productsInCart = [];
            }

            OrderedProduct tempProduct = bookOrderObj.getProductDetailsObject(
              selectedVarientId: jsonBodyResp['products'],
              productID: selectedProductID,
              callType: 1,
            );

            check = true;
            setState(() {});
            Loader().hideLoader(context);
            if (bookOrderObj.selectedProduct['type'] == 'Variant') {
              variantsBottomSheet(
                index,
                tempProduct,
                (value) {
                  isAdded = value;
                  Scaffold.of(context).setState(
                    () {
                      // ignore: deprecated_member_use
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: tempName == "MILLBORN-Jaipur" ? millBornPrimaryThemeColor : mainC,
                          duration: Duration(seconds: 1),
                          content: Text(
                            isAdded ? Strings.aleardyadded : Strings.proadded,
                            style: GoogleFonts.poppins(),
                          ),
                        ),
                      );
                    },
                  );
                  setState(() {});
                },
                selectedProductID,
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

              bookOrderObj.addSelectedProductInCart(tempProduct);
              //This is comment

              BookOrderModel.orderModelObj.refreshViewForOrderBooking();

              Scaffold.of(context).setState(() {
                // ignore: deprecated_member_use
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor:appName == "MILLBORN-Jaipur" ? millBornPrimaryThemeColor :  mainC,
                    duration: Duration(seconds: 1),
                    content: Text(
                      isAdded ? Strings.aleardyadded : Strings.proadded,
                      style: GoogleFonts.poppins(),
                    ),
                  ),
                );
              });
            }
          });
        } else {
          //handle false conditions
        }
      } else {
        print(resp.body);
        print('Error occurred while serving request');
      }
    } else {
      Future.delayed(Duration.zero, () {
        GlobalModelClass.showAlertForNoInternetConnection(context).show();
      });
    }
  }


  void variantsBottomSheet(int index,OrderedProduct productData,
      Function addedCartFunction, String selectedProductID) {
    OrderedProduct tempProduct = bookOrderObj.getProductDetailsObject(
      selectedVarientId: bookOrderObj.selectedProduct,
      productID: selectedProductID,
      callType: 1,
      variantIndex: selectedIndex,
      productQty: 1.0,
      isVariantAvailable: true,
    );
    textController..text = "1";
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
                  SizedBox(height: 5),
                  Container(
                    height: Get.height * 0.25,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: bookOrderObj
                          .selectedProduct['available_variants'].length,
                      itemBuilder: (
                        BuildContext context,
                        int index,
                      ) {
                        return Column(
                          children: [
                            InkWell(
                              onTap: () {
                                selectedIndex = index;
                                tempProduct =
                                    bookOrderObj.getProductDetailsObject(
                                  selectedVarientId:
                                      bookOrderObj.selectedProduct,
                                  productID: selectedProductID,
                                  callType: 1,
                                  variantIndex: selectedIndex,
                                  isVariantAvailable: true,
                                );
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
                                      productID: selectedProductID,
                                      callType: 1,
                                      variantIndex: selectedIndex,
                                      isVariantAvailable: true,
                                    );
                                    currrentIndex =
                                        bookOrderObj.selectedProduct[
                                                'available_variants'][index]
                                            ['variant_attri_name'];
                                    setState(() {});
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        top: 20, left: 10, bottom: 10),
                                    padding: EdgeInsets.only(
                                        top: 15, left: 15, right: 20),
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
                        SizedBox(width: 5),
                        Row(
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
                                            textController..text = tempProduct.productQuantity.toInt().toString();
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
                                          color:showMBPrimaryColor ?millBornPrimaryColor : Colors.white,
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
                                        tempProduct.productQuantity = double.parse(value);
                                      },
                                      controller: textController,
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: (){
                                      setState(
                                            () {
                                          tempProduct.productQuantity++;
                                          textController..text = tempProduct.productQuantity.toInt().toString();
                                          bookOrderObj
                                              .addSelectedProductInCart(null);
                                          FocusScope.of(context).unfocus();
                                        },
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 16.0),
                                      child: Text(
                                        "+",
                                        style: TextStyle(color:showMBPrimaryColor ?millBornPrimaryColor : Colors.white),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.only(right: 10, left: 10),
                    margin: EdgeInsets.only(bottom: 10),
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
                        tempProduct =
                            bookOrderObj.getProductDetailsObject(
                                selectedVarientId:
                                bookOrderObj.selectedProduct,
                                productID: selectedProductID,
                                callType: 1,
                                variantIndex: selectedIndex,
                                isVariantAvailable: true,
                                productQty: double.parse(textController.text)
                            );
                        bookOrderObj.addSelectedProductInCart(tempProduct);
                        BookOrderModel.orderModelObj
                            .refreshViewForOrderBooking();
                        addedCartFunction(isAdded);
                        BookOrderModel.orderModelObj
                            .refreshViewForOrderBooking();
                        qtyController.clear();
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
