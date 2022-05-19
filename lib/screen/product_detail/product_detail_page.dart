import 'dart:io';
import 'package:shoppingapp/utils/commons/export_basic_file.dart';
import 'package:shoppingapp/screen/cart_screen/shopping_cart_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

BookOrderModel bookOrderObj = BookOrderModel.orderModelObj;
OrderedProduct orderedProduct;

Map selectedVariant = {};

class ProductDetailPage extends StatefulWidget {
  final int productId;
  final double productQty;
  final int stock;

  ProductDetailPage({this.productId, this.productQty, this.stock});

  @override
  ProductDetailPageState createState() =>
      ProductDetailPageState(this.productId);
}

class ProductDetailPageState extends State<ProductDetailPage>
    with TickerProviderStateMixin {
  ProductDetailWishlistViewModel model;
  SuppliersListViewModel supplierModel;
  StockViewModel stockModel;

  final int productId;

  ProductDetailPageState(this.productId);

  int groupValue = 0;
  var selectSupplierId = 0;
  var selectSupplierName;
  var selectAccountId = 0;
  var selectAccountType;
  var stock;

  bool showDialogBox = false;

  AnimationController controller;
  Animation<double> animation;
  int _carouselCurrentPage = 0;

  // ScrollController tempScroll = ScrollController();
  double radius = 40;
  int piece = 1;
  List<dynamic> imageSliders = [];

  ScrollController scrollController;
  bool isPaging = false;
  int initPosition = 0;
  int page = 1;

  var productVariantId;

  TextEditingController qtyController = TextEditingController();

  @override
  void initState() {
    // _orderedProduct = null;
    scrollController = new ScrollController()..addListener(_scrollListener);
    // tempScroll = ScrollController()
    //   ..addListener(() {
    //     setState(() {
    //       print(tempScroll.position.viewportDimension);
    //     });
    //   });

    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    animation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInToLinear));
    controller.forward();
    bookOrderObj.showLoadingIndicator = true;
    getProductsDetailsFromServer(productId.toString());
  }

  void _scrollListener() {
    if (scrollController.position.extentAfter < 100) {
      if (supplierModel.canPaging && !isPaging) {
        setState(() {
          isPaging = true;
        });
        page++;
        supplierModel.getSupplierListApi(page);
      }
    }
  }

  void getStock() async {
    String loggedInUserId = LoginModelClass.loginModelObj
        .getValueForKeyFromLoginResponse(key: 'user_id');
    String url = Base_URL +
        productstock +
        '&logged_in_userid=$loggedInUserId&sup_id=$selectSupplierId&product_id=$productVariantId&account_id=$selectAccountId&account_type=$selectAccountType';
    http.Response resp = await http.get(Uri.parse(url), headers: {
      'Authorization': LoginModelClass.loginModelObj
          .getValueForKeyFromLoginResponse(key: 'token'),
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });
    if (resp.statusCode == 200) {
      stock = null;
      print(resp.statusCode);
      var jsonBodyResp = jsonDecode(resp.body);
      if (jsonBodyResp['status'] == true) {
        if (jsonBodyResp['inventory_product'] != null ||
            jsonBodyResp['inventory_product'].isNotEmpty) {
          stock = jsonBodyResp['inventory_product'][0]['qty'] ?? 0;
          print(stock);
        }
        print(stock);
      } else {}
    } else {
      print('Error occurred while serving request');
    }
    setState(() {});
  }

  void getProductsDetailsFromServer(String selectedProductID) async {
    if (GlobalModelClass.internetConnectionAvaiable() == true) {
      String loggedInUserId = LoginModelClass.loginModelObj
          .getValueForKeyFromLoginResponse(key: 'user_id');
      print(Base_URL +
          productDetails +
          '&logged_in_userid=$loggedInUserId&product_id=$selectedProductID');
      var url = Base_URL +
          productDetails +
          '&logged_in_userid=$loggedInUserId&product_id=$selectedProductID';

      http.Response resp = await http.get(Uri.parse(url), headers: {
        'Authorization': LoginModelClass.loginModelObj
            .getValueForKeyFromLoginResponse(key: 'token'),
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      });

      bookOrderObj.showLoadingIndicator = false;
      setState(() {});

      if (resp.statusCode == 200) {
        var jsonBodyResp = jsonDecode(resp.body);
        if (jsonBodyResp['status'] == true) {
          setState(() {
            bookOrderObj.selectedProduct = jsonBodyResp['products'];
            print(bookOrderObj.selectedProduct);
            bookOrderObj.currentProductVariants =
                bookOrderObj.selectedProduct['available_variants'];
            bookOrderObj.availableVariantsList = availableVariantsFromJson(
                jsonEncode(bookOrderObj.selectedProduct['available_variants']));
            print(
                "GGG = ${bookOrderObj.selectedProduct['available_variants']}");
            bookOrderObj.selectedVariant =
                bookOrderObj.currentProductVariants.first;
            productVariantId =
                bookOrderObj.currentProductVariants[0]['variant_id'] ?? 0;
            print(productVariantId);
            orderedProduct = bookOrderObj.getProductDetailsObject(
              selectedVarientId: jsonBodyResp['products'],
              productID: selectedProductID,
              callType: 1,
              isVariantAvailable: true,
              minQty: jsonBodyResp['products']['min_qty'],
            );

            print(orderedProduct?.productPrice);
            orderedProduct.productQuantity = widget.productQty ?? 1.0;
            imageSliders.clear();
            imageSliders.addAll(
                jsonBodyResp['products']['imagesize512x512'] == null
                    ? []
                    : jsonBodyResp['products']['imagesize512x512']);
            if (imageSliders.length == 0) {
              imageSliders.add('assets/images/productPlaceaHolderImage.png');
            }
          });
        } else {
          //handle false conditions
        }
      } else {
        print('Error occurred while serving request');
      }
    } else {
      Future.delayed(Duration.zero, () {
        GlobalModelClass.showAlertForNoInternetConnection(context).show();
      });
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    controller.dispose();
    super.dispose();
  }

  bool isLiked = false;

  String currentSelectedVariantName;

  Widget _buildBox(
      {Color color, int index, @required String selectedProductID}) {
    print("==>  ${bookOrderObj.currentProductVariants}");
    String variantId =
        (bookOrderObj.currentProductVariants[index])['variant_id'].toString();
    print(variantId);
    String isVariantPresentInPriceList =
        (bookOrderObj.currentProductVariants[index])['variant_in_pricelist'];
    print(isVariantPresentInPriceList);
    if (currentSelectedVariantName == null) {
      currentSelectedVariantName = bookOrderObj.currentProductVariants[index]
              ['variant_attri_name']
          .toString();
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isVariantPresentInPriceList == 'true') {
            print("==> ${bookOrderObj.currentProductVariants[index]}");
            var tempOrderedProduct = bookOrderObj.getProductDetailsObject(
                variantSelectedAs: bookOrderObj.currentProductVariants[index],
                productID: selectedProductID);
            currentSelectedVariantName = bookOrderObj
                .currentProductVariants[index]['variant_attri_name']
                .toString();
            productVariantId =
                bookOrderObj.currentProductVariants[index]['variant_id'] ?? 0;
            print(productVariantId);

            getStock();

            // ignore: null_aware_before_operator
            if ((bookOrderObj.productsInCart
                        ?.where((element) =>
                            element.productVariantID ==
                            tempOrderedProduct.productVariantID)
                        ?.length >
                    0) ??
                false) {
              orderedProduct = bookOrderObj.productsInCart
                  ?.where((element) =>
                      element.productVariantID ==
                      tempOrderedProduct.productVariantID)
                  ?.first;
            } else {
              print('Product was not in cart');
              orderedProduct = tempOrderedProduct;
            }
          } else {
            print('The variant is unavailable');
          }
        });
      },
      child: Container(
        child: Padding(
          padding: EdgeInsets.only(left: 5.0, right: 5.0),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              bookOrderObj.currentProductVariants != null
                  ? bookOrderObj.currentProductVariants[index]
                          ['variant_attri_name']
                      .toString()
                  : '',
              style: GoogleFonts.poppins(
                color: isVariantPresentInPriceList == 'true'
                    ? Color(0xFF5D6A78)
                    : Colors.grey,
                fontSize: 10,
                textStyle: TextStyle(
                    /*decoration: isVariantPresentInPriceList == 'true'
                      ? TextDecoration.none
                      : TextDecoration.lineThrough,*/
                    ),
              ),
            ),
          ),
        ),
        decoration: BoxDecoration(
          color: orderedProduct?.productVariantID == variantId
              ? mainColor.withOpacity(0.1)
              : isVariantPresentInPriceList == 'false'
                  ? Colors.grey.withOpacity(0.15)
                  : null,
          border: Border.all(
            color: orderedProduct?.productVariantID == variantId
                ? mainColor
                : Color(0xFF707070),
            width: 0.7,
          ), //Color(0xFF5D6A78)
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.only(right: 12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<ThemeNotifier>(context);
    // ignore: unnecessary_statements
    model ?? (model = ProductDetailWishlistViewModel(this));
    // ignore: unnecessary_statements
    supplierModel ?? (supplierModel = SuppliersListViewModel(this));
    if (orderedProduct?.productQuantity != 0.0 && orderedProduct?.productQuantity != null ) {
      qtyController..text = orderedProduct.productQuantity.toInt().toString();
    } else {
      if (orderedProduct?.minQuantity != null && orderedProduct?.minQuantity != 0 ) {
        orderedProduct.productQuantity = orderedProduct.minQuantity;
        qtyController..text = orderedProduct.minQuantity.toInt().toString();
      }
     else {
       if(orderedProduct?.qtyIncases == 10) {
         orderedProduct.productQuantity = orderedProduct.qtyIncases.toDouble();

         qtyController
           ..text = orderedProduct?.qtyIncases.toString() == null
               ? 1
               : orderedProduct.qtyIncases.toString();
       }
      }
    }
    return WillPopScope(
      onWillPop: () async {
        Get.back(result: "i");
        return false;
      },
      child: Scaffold(
        body: bookOrderObj.showLoadingIndicator
            ? Center(
                child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(themeColor.getColor())))
            : Stack(
                children: <Widget>[
                  CarouselSlider(
                    items: imageSliders.map((e) {
                      return Container(
                        padding: EdgeInsets.only(bottom: 12),
                        height: Get.height / 1.3,
                        child: Stack(
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                Get.to(() => ShowImage(
                                    image: imageSliders[_carouselCurrentPage]));
                              },
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  width: Get.width,
                                  height: Get.height / 1.3,
                                  color: tempName == "MILLBORN-Jaipur"
                                      ? Colors.white.withOpacity(0.3)
                                      : (themeColor.getColor() as Color)
                                          .withOpacity(0.3),
                                  child: Image(
                                      image: e.contains(
                                              'productPlaceaHolderImage')
                                          ? AssetImage(
                                              'assets/images/productPlaceaHolderImage.png')
                                          : NetworkImage(e)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    options: CarouselOptions(
                      autoPlay: false,
                      height: Get.height / 1.9,
                      viewportFraction: 1.0,
                      enlargeCenterPage: false,
                      onPageChanged: (index, reason) {
                        setState(
                          () {
                            _carouselCurrentPage = index;
                          },
                        );
                      },
                    ),
                  ),
                  Positioned(
                    left: 9,
                    top: 50,
                    child: InkWell(
                      onTap: () {
                        BookOrderModel.orderModelObj
                            .refreshViewForOrderBooking();
                        Get.back();
                        setState(() {});
                      },
                      child: Container(
                        height: 32,
                        width: 32,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                        child: Icon(
                          Platform.isAndroid
                              ? Icons.arrow_back
                              : Icons.chevron_left,
                          color: themeColor.getColor(),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 24,
                    top: 50,
                    child: InkWell(
                      onTap: () async {
                        if (currentSelectedVariantName != null) {
                          currentSelectedVariantName = bookOrderObj
                              .currentProductVariants[0]['variant_attri_name']
                              .toString();
                        }
                        await Nav.route(
                          context,
                          ShoppingCartPage(
                            showBackArrow: false,
                          ),
                        );

                        for (var i = 0;
                            i < bookOrderObj.productsInCart.length;
                            i++) {
                          if (bookOrderObj.productsInCart[i].productID ==
                              widget.productId.toString()) {
                            orderedProduct.productQuantity = bookOrderObj
                                    .productsInCart[i].productQuantity ??
                                0.0;
                            setState(() {});
                          }
                        }
                      },
                      child: Container(
                        height: 42,
                        width: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(8),
                              bottomRight: Radius.circular(8)),
                          color: Colors.white.withOpacity(0.5),
                        ),
                        child: Badge(
                          animationDuration: Duration(milliseconds: 1500),
                          badgeColor: themeColor.getColor(),
                          alignment: Alignment(0, 0),
                          position: BadgePosition.topEnd(),
                          padding: EdgeInsets.all(8),
                          badgeContent: Text(
                            bookOrderObj.productsInCart != null
                                ? '${bookOrderObj.productsInCart.length}'
                                : '0',
                            style: TextStyle(color: whiteColor, fontSize: 10),
                          ),
                          child: SvgPicture.asset(
                            "assets/icons/ic_shopping_cart.svg",
                            color: themeColor.getColor(),
                            height: 26,
                          ),
                        ),
                      ),
                    ),
                  ),
                  DraggableScrollableSheet(
                    maxChildSize: 1,
                    initialChildSize: .53,
                    minChildSize: .53,
                    builder: (context, scrollController) {
                      return Container(
                        decoration: !scrollController.hasClients
                            ? BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(26),
                                  topRight: Radius.circular(26),
                                ))
                            : BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(scrollController
                                              .position.viewportDimension >
                                          660
                                      ? 0
                                      : 26),
                                  topRight: Radius.circular(scrollController
                                              .position.viewportDimension >
                                          660
                                      ? 0
                                      : 26),
                                ),
                                color: Colors.white,
                              ),
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(.2),
                                        blurRadius: 6.0, // soften the shadow
                                        spreadRadius: 0.0, //extend the shadow
                                        offset: Offset(
                                          0.0, // Move to right 10  horizontally
                                          1.0, // Move to bottom 10 Vertically
                                        ),
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(26)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    SliderDotProductDetail(
                                      current: _carouselCurrentPage,
                                      selectedProduct: orderedProduct,
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 15),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Expanded(
                                            child: AutoSizeText.rich(
                                              TextSpan(
                                                text:
                                                    '${orderedProduct?.productName ?? ''}',
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text:
                                                        '\n${Strings.sku} : ${orderedProduct?.sku ?? ''}',
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 14,
                                                      color: Color(0xFF5D6A78),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                  orderedProduct.brandName ==
                                                              null ||
                                                          orderedProduct
                                                                  .brandName ==
                                                              "null"
                                                      ? TextSpan()
                                                      : TextSpan(
                                                          text:
                                                              '\n${Strings.brand} : ${orderedProduct.brandName ?? ''}',
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontSize: 14,
                                                            color: Color(
                                                                0xFF5D6A78),
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                  currentSelectedVariantName ==
                                                          null
                                                      ? TextSpan()
                                                      : TextSpan(
                                                          text:
                                                              '\nVariant Name : ${currentSelectedVariantName ?? ''}',
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontSize: 14,
                                                            color: Color(
                                                                0xFF5D6A78),
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                  //  TextSpan(
                                                  //   text:
                                                  //   '\n${Strings.stock} :  ${orderedProduct?.variantQty?.toInt() ?? 0}',
                                                  //   style: GoogleFonts.poppins(
                                                  //   Fp  fontSize: 14,
                                                  //     color: Color(0xFF5D6A78),
                                                  //     fontWeight: FontWeight.w400,F
                                                  //   ),
                                                  // ),
                                                ],
                                              ),
                                              minFontSize: 14,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 5,
                                              style: GoogleFonts.poppins(
                                                fontSize: 20,
                                                color: Color(0xFF5D6A78),
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: Container(
                                              height: 40,
                                              child: FloatingActionButton(
                                                heroTag: null,
                                                elevation: 0,
                                                onPressed: () {
                                                  BookOrderModel.orderModelObj
                                                      .refreshViewForOrderBooking();
                                                  if (BookOrderModel
                                                              .orderModelObj
                                                              .selectedProduct[
                                                          'isin_wishlist'] ==
                                                      'active') {
                                                    model.getFavoriteApi(
                                                        productId: widget
                                                            .productId
                                                            .toString(),
                                                        wishListId: BookOrderModel
                                                            .orderModelObj
                                                            .selectedProduct[
                                                                'wishlist']
                                                                ['wishlist_id']
                                                            .toString(),
                                                        wishListStatus:
                                                            'inactive');
                                                    setState(() {
                                                      BookOrderModel
                                                                  .orderModelObj
                                                                  .selectedProduct[
                                                              'isin_wishlist'] =
                                                          'inactive';
                                                    });
                                                    // ignore: deprecated_member_use
                                                    Scaffold.of(context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                          backgroundColor: tempName ==
                                                                  "MILLBORN-Jaipur"
                                                              ? millBornPrimaryThemeColor
                                                              : mainColor,
                                                          duration: Duration(
                                                              seconds: 1),
                                                          content: Text(Strings
                                                              .removetosts)),
                                                    );
                                                  } else {
                                                    model.getFavoriteApi(
                                                        productId: widget
                                                            .productId
                                                            .toString(),
                                                        wishListId: 'new',
                                                        wishListStatus:
                                                            'active');
                                                    setState(() {
                                                      BookOrderModel
                                                                  .orderModelObj
                                                                  .selectedProduct[
                                                              'isin_wishlist'] =
                                                          'active';
                                                    });
                                                    // ignore: deprecated_member_use
                                                    Scaffold.of(context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                          backgroundColor: tempName ==
                                                                  "MILLBORN-Jaipur"
                                                              ? millBornPrimaryThemeColor
                                                              : mainColor,
                                                          duration: Duration(
                                                              seconds: 1),
                                                          content: Text(Strings
                                                              .addedtosts)),
                                                    );
                                                  }
                                                  BookOrderModel.orderModelObj
                                                          .selectedProduct[
                                                      'isin_wishlist'];
                                                  setState(() {});
                                                },
                                                backgroundColor:
                                                    Colors.yellow.shade600,
                                                child: Icon(
                                                  Icons.favorite,
                                                  color: BookOrderModel
                                                              .orderModelObj
                                                              .selectedProduct ==
                                                          null
                                                      ? Colors.white
                                                      : BookOrderModel.orderModelObj
                                                                      .selectedProduct[
                                                                  'isin_wishlist'] ==
                                                              'active'
                                                          ? themeColor
                                                              .getColor()
                                                          : Colors.white,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),

                                    (bookOrderObj.currentProductVariants
                                                    ?.length ??
                                                0) >
                                            0
                                        ? bookOrderObj.currentProductVariants ==
                                                null
                                            ? SizedBox()
                                            : bookOrderObj
                                                        .currentProductVariants
                                                        .length ==
                                                    0
                                                ? SizedBox()
                                                : bookOrderObj.currentProductVariants[
                                                                0][
                                                            'variant_attri_name'] ==
                                                        ''
                                                    ? SizedBox()
                                                    : Container(
                                                        margin: EdgeInsets.only(
                                                            top: 12),
                                                        height: 30.0,
                                                        child: ListView.builder(
                                                          itemCount: bookOrderObj
                                                                      .currentProductVariants !=
                                                                  null
                                                              ? bookOrderObj
                                                                  .currentProductVariants
                                                                  .length
                                                              : 0,
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          itemBuilder:
                                                              (_, index) =>
                                                                  _buildBox(
                                                            color:
                                                                Colors.orange,
                                                            index: index,
                                                            selectedProductID:
                                                                this
                                                                    .productId
                                                                    .toString(),
                                                          ),
                                                        ),
                                                      )
                                        : Container(
                                            height: 0,
                                            width: 0,
                                          ),
                                    SizedBox(height: 5.0),
                                    // Padding(
                                    //   padding: const EdgeInsets.all(2.0),
                                    //   child: Text("Unit Per Kg:-",style: TextStyle(fontWeight: FontWeight.bold),),
                                    // ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Text(
                                                  // "S.P:",
                                                  Strings.Price,
                                                  style: GoogleFonts.poppins(
                                                    color: showMBPrimaryColor
                                                        ? millBornPrimaryColor
                                                        : themeColor.getColor(),
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                Text(
                                                  "$currencySymbol ${(orderedProduct?.productPrice?.toStringAsFixed(2) ?? '').toString()}" +
                                                      " / " +
                                                      orderedProduct
                                                          ?.unitsOfMeasurement,
                                                  style: GoogleFonts.poppins(
                                                    color: showMBPrimaryColor
                                                        ? millBornPrimaryColor
                                                        : themeColor.getColor(),
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 6),
                                          ],
                                        ),
                                        Container(
                                          width: 120,
                                          padding: EdgeInsets.only(
                                            left: 8,
                                            right: 8,
                                            top: 4,
                                            bottom: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(18),
                                            color: themeColor.getColor(),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              InkWell(
                                                onTap: () {
                                                  if (orderedProduct
                                                      .minQuantity ==
                                                      0 &&
                                                      orderedProduct
                                                          .productQuantity ==
                                                          orderedProduct.qtyIncases) {
                                                    bookOrderObj
                                                        .addSelectedProductInCart(
                                                        null);
                                                    setState(() {});
                                                    return;
                                                  }
                                                  setState(() {
                                                    if (orderedProduct
                                                            .minQuantity <
                                                        orderedProduct
                                                            .productQuantity) {
                                                      if (orderedProduct
                                                              .productQuantity !=
                                                          1) {
                                                        tempName ==
                                                                "MILLBORN-Jaipur"
                                                            ? orderedProduct
                                                                .productQuantity -= orderedProduct
                                                                        .minQuantity ==
                                                                    0
                                                                ? 1
                                                                : orderedProduct
                                                                    .minQuantity
                                                            : orderedProduct
                                                                .productQuantity--;
                                                      }
                                                    }
                                                    bookOrderObj
                                                        .addSelectedProductInCart(
                                                            null);
                                                  });
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 16.0),
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
                                                  borderRadius:
                                                      BorderRadius.circular(7),
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
                                                    hintStyle:
                                                        GoogleFonts.poppins(),
                                                    errorStyle:
                                                        GoogleFonts.poppins(),
                                                  ),
                                                  onChanged: (value) {
                                                    orderedProduct
                                                            .productQuantity =
                                                        double.parse(int.parse(
                                                                value ?? 0)
                                                            .toString());
                                                    BookOrderModel.orderModelObj
                                                        .refreshViewForOrderBooking();
                                                  },
                                                  controller: qtyController,
                                                  keyboardType:
                                                      TextInputType.number,
                                                ),
                                              ),
                                              // Container(
                                              //   decoration: BoxDecoration(
                                              //     borderRadius:
                                              //         BorderRadius.circular(10),
                                              //     color: Color(0xFF707070),
                                              //   ),
                                              //   child: Container(
                                              //     alignment: Alignment.center,
                                              //     width: 40,
                                              //     padding:
                                              //         const EdgeInsets.all(8.0),
                                              //     child: Text(
                                              //       '${(orderedProduct?.productQuantity ?? 1.0).toInt()}',
                                              //       style: GoogleFonts.poppins(
                                              //         color: Colors.white,
                                              //         fontSize: 16,
                                              //       ),
                                              //     ),
                                              //   ),
                                              // ),
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    tempName ==
                                                            "MILLBORN-Jaipur"
                                                        ? orderedProduct
                                                                .productQuantity +=
                                                            orderedProduct
                                                                        .minQuantity ==
                                                                    0
                                                                ? 1
                                                                : orderedProduct
                                                                    .minQuantity
                                                        : orderedProduct
                                                            .productQuantity++;
                                                    bookOrderObj
                                                        .addSelectedProductInCart(
                                                            null);
                                                  });
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 16.0),
                                                  child: Text(
                                                    "+",
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 18,
                                                      color: showMBPrimaryColor
                                                          ? millBornPrimaryColor
                                                          : Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 24),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            width: 140,
                                            child: GFButton(
                                              onPressed: () {
                                                bool isAdded = false;

                                                setState(() {
                                                  for (var i = 0;
                                                      i <
                                                          bookOrderObj
                                                              .productsInCart
                                                              .length;
                                                      i++) {
                                                    if (bookOrderObj
                                                            .productsInCart[i]
                                                            .productVariantID ==
                                                        orderedProduct
                                                            .productVariantID) {
                                                      bookOrderObj
                                                          .productsInCart
                                                          .removeAt(i);
                                                      isAdded = true;
                                                    } else {}
                                                  }
                                                  orderedProduct.variantName =
                                                      currentSelectedVariantName;
                                                  bookOrderObj
                                                      .addSelectedProductInCart(
                                                          orderedProduct);
                                                  Scaffold.of(context)
                                                      .setState(() {
                                                    // ignore: deprecated_member_use
                                                    Scaffold.of(context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        backgroundColor: tempName ==
                                                                "MILLBORN-Jaipur"
                                                            ? millBornPrimaryThemeColor
                                                            : mainColor,
                                                        duration: Duration(
                                                            seconds: 1),
                                                        content: Text(isAdded
                                                            ? Strings
                                                                .aleardyadded
                                                            : Strings.proadded),
                                                      ),
                                                    );
                                                  });
                                                });
                                              },
                                              icon: Icon(
                                                Icons.shopping_cart,
                                                color: themeColor.getColor(),
                                                size: 16,
                                              ),
                                              child: Text(Strings.addToCart,
                                                  style: GoogleFonts.poppins(
                                                      fontWeight:
                                                          FontWeight.w400)),
                                              type: GFButtonType.outline2x,
                                              shape: GFButtonShape.pills,
                                              color: themeColor.getColor(),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Container(
                                        decoration: BoxDecoration(
                                            // border: Border.all(width:2)
                                            ),
                                        child: ExpandablePanel(
                                          header: Text(
                                            Strings.Offer,
                                            style: GoogleFonts.poppins(
                                                color: themeColor.getColor(),
                                                fontSize: 12),
                                          ),
                                          collapsed: offerList(),
                                          expanded: Text(
                                            '',
                                            softWrap: true,
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w300,
                                              color: Color(0xFF5D6A78),
                                              letterSpacing: 0.6,
                                            ),
                                          ),
                                        )),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(bottom: 12),
                                      child: ExpandablePanel(
                                        header: Text(
                                          Strings.ShowDescription,
                                          style: GoogleFonts.poppins(
                                              color: themeColor.getColor(),
                                              fontSize: 12),
                                        ),
                                        collapsed: Text(
                                          orderedProduct?.productDescription ??
                                              '',
                                          softWrap: true,
                                          maxLines: 4,
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w300,
                                            color: Color(0xFF5D6A78),
                                            letterSpacing: 0.6,
                                          ),
                                        ),
                                        expanded: Text(
                                          orderedProduct?.productDescription ??
                                              '',
                                          softWrap: true,
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w300,
                                            color: Color(0xFF5D6A78),
                                            letterSpacing: 0.6,
                                          ),
                                        ),
                                      ),
                                    ),
                                    supplierModel.supplierModel
                                                    ?.supplierLists ==
                                                null ||
                                            supplierModel.supplierModel
                                                .supplierLists.isEmpty
                                        ? Container(
                                            child: Text(
                                              'No details of stocks available',
                                              style: GoogleFonts.poppins(
                                                  fontSize: 16),
                                            ),
                                          )
                                        : InkWell(
                                            onTap: () async {
                                              showDialogBox = true;
                                              // await supplierListDialog(
                                              //     context, themeColor);
                                              setState(() {});
                                            },
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  Strings.stockavailability,
                                                  style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                SizedBox(height: 10),
                                                Container(
                                                  width: Get.width * 0.9,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.red),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Container(
                                                        width: Get.width * 0.7,
                                                        margin:
                                                            EdgeInsets.all(10),
                                                        child: Text(
                                                          "Supplier ${selectSupplierName ?? "Select"}",
                                                          style: GoogleFonts
                                                              .poppins(
                                                                  color: Colors
                                                                      .black87),
                                                        ),
                                                      ),
                                                      Icon(Icons.chevron_right)
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: 15),
                                                selectSupplierName != null
                                                    ? Container(
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              height:
                                                                  Get.height *
                                                                      0.065,
                                                              width: Get.width *
                                                                  0.435,
                                                              decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                      color: Colors
                                                                          .grey),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5)),
                                                              child: Center(
                                                                child: Text(
                                                                  "${stock ?? 0} Cases",
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                          color:
                                                                              Colors.grey),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(width: 5),
                                                            // Container(
                                                            //     height:ScreenUtil.getHeight(context) * 0.065,
                                                            //     width:ScreenUtil.getWidth(context) * 0.435,
                                                            //     decoration: BoxDecoration(
                                                            //         border: Border.all(color: Colors.grey),
                                                            //         borderRadius: BorderRadius.circular(5)
                                                            //     ),
                                                            //     child: Center(child: Text("0 Units",style: GoogleFonts.poppins(color: Colors.grey),))),
                                                          ],
                                                        ),
                                                      )
                                                    : SizedBox(),
                                              ],
                                            ),
                                          ),
                                    // Container(
                                    //   margin: EdgeInsets.only(top: 5),
                                    //   child: Row(
                                    //     mainAxisAlignment: MainAxisAlignment.center,
                                    //     children: <Widget>[
                                    //       Container(
                                    //         width: 140,
                                    //         child: GFButton(
                                    //           onPressed: () async{
                                    //             print("Helloi");
                                    //           },
                                    //           child: Text(Strings.selectsupplier,
                                    //               style: GoogleFonts.poppins(
                                    //                   fontWeight: FontWeight.w400)),
                                    //           type: GFButtonType.outline2x,
                                    //           shape: GFButtonShape.pills,
                                    //           color: themeColor.getColor(),
                                    //         ),
                                    //       )
                                    //     ],
                                    //   ),
                                    // ),
                                    // SizedBox(height: 10),

                                    // selectsupplier == null ?SizedBox() :
                                    // stockmodel.qtystock != null && stockmodel.qtystock.inventoryProduct.isNotEmpty ?  Container(child: Text("Stock of Product : ${stockmodel.qtystock.inventoryProduct[0]['qty']}",style: GoogleFonts.poppins(),),):
                                    // Text("No Product found in selected supplier",style: GoogleFonts.poppins()) ,
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  GlobalModelClass.globalObject.loadingIndicator(
                      bookOrderObj.showLoadingIndicator ?? false, context),
                  showDialogBox ? customDialog(themeColor, context) : SizedBox()
                ],
              ),
      ),
    );
  }

  Widget offerList() {
    int index = 0;
    if (bookOrderObj.availableVariantsList.length != 0) {
      bookOrderObj.availableVariantsList.forEach((e) {
        if (e.schemeOnProduct != null) {
          e.schemeOnProduct.schemeDetails.forEach((e2) {
            index++;
          });
        }
      });
    }
    return bookOrderObj.availableVariantsList.length == 0 ||
            index == 0 ||
            bookOrderObj.availableVariantsList[_carouselCurrentPage]
                    .schemeOnProduct ==
                null
        ? Text(
            "No offer available",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w300,
              color: Color(0xFF5D6A78),
              letterSpacing: 0.6,
            ),
          )
        : Column(
            children: bookOrderObj.availableVariantsList[_carouselCurrentPage]
                .schemeOnProduct.schemeDetails
                .map<Widget>((e1) {
              return Text(
                e1.name,
                softWrap: true,
                maxLines: 4,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w300,
                  color: Color(0xFF5D6A78),
                  letterSpacing: 0.6,
                ),
              );
            }).toList(),
          );
    return bookOrderObj.availableVariantsList.length == 0 || index == 0
        ? Text(
            "No offer available",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w300,
              color: Color(0xFF5D6A78),
              letterSpacing: 0.6,
            ),
          )
        : Column(
            children: bookOrderObj.availableVariantsList.map<Widget>((e1) {
              if (e1.schemeOnProduct == null) {
                return SizedBox();
              } else {
                return Column(
                  children: e1.schemeOnProduct.schemeDetails.map<Widget>((e2) {
                    return Text(
                      e2.name,
                      softWrap: true,
                      maxLines: 4,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w300,
                        color: Color(0xFF5D6A78),
                        letterSpacing: 0.6,
                      ),
                    );
                  }).toList(),
                );
              }
            }).toList(),
          );
  }

  customDialog(themeColor, context) {
    return Container(
      color: Colors.grey.withOpacity(0.8),
      child: Center(
        child: Container(
          height: Get.height * 0.85,
          width: Get.width * 0.75,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 10, left: 20),
                child: Text(
                  Strings.selectsupplier,
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ),
              Container(
                height: Get.height * 0.7,
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: supplierModel.supplierModel.supplierLists.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      child: Row(
                        children: [
                          Radio<int>(
                            activeColor: Theme.of(context).primaryColor,
                            value: index,
                            groupValue: groupValue,
                            onChanged: (index1) {
                              groupValue = index1;
                              selectSupplierName = supplierModel
                                  .supplierModel.supplierLists[index1].supName;
                              if (supplierModel.supplierModel
                                      .supplierLists[index1].accountType !=
                                  null) {
                                var stringTest = supplierModel.supplierModel
                                    .supplierLists[index1].accountType
                                    .toString()
                                    .split('.');
                                selectAccountType = stringTest[1].toLowerCase();
                                if (selectAccountType == "account") {
                                  selectAccountId = supplierModel.supplierModel
                                      .supplierLists[index1].supId;
                                  selectSupplierId = 0;
                                } else if (selectAccountType == "supplier") {
                                  selectSupplierId = supplierModel.supplierModel
                                      .supplierLists[index1].supId;
                                  selectAccountId = 0;
                                }
                              }

                              setState(() {});
                            },
                          ),
                          Container(
                            width: Get.width * 0.6,
                            child: Text(
                              supplierModel
                                  .supplierModel.supplierLists[index].supName,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 10, top: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () async {
                        if (selectSupplierName == null) {
                          selectSupplierName = supplierModel
                              .supplierModel.supplierLists[0].supName;
                        }
                        if (selectAccountType == null) {
                          if (supplierModel
                                  .supplierModel.supplierLists[0].accountType !=
                              null) {
                            var stringTest = supplierModel
                                .supplierModel.supplierLists[0].accountType
                                .toString()
                                .split('.');
                            selectAccountType = stringTest[1].toLowerCase();
                            if (selectAccountType == "account") {
                              selectAccountId = supplierModel
                                  .supplierModel.supplierLists[0].supId;
                              selectSupplierId = 0;
                            } else if (selectAccountType == "supplier") {
                              selectSupplierId = supplierModel
                                  .supplierModel.supplierLists[0].supId;
                              selectAccountId = 0;
                            }
                          }
                        }

                        showDialogBox = false;
                        Loader().showLoader(context);
                        getStock();
                        Loader().hideLoader(context);
                        setState(() {});
                      },
                      child: Text(
                        "Submit",
                        style: TextStyle(
                          color: themeColor.getColor(),
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  supplierListDialog(BuildContext context, themeColor) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, dialogState) {
            return Container(
              height: 100,
              child: AlertDialog(
                title: Text(
                  Strings.selectsupplier,
                  style: GoogleFonts.poppins(),
                ),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: List<Widget>.generate(
                      supplierModel.supplierModel.supplierLists.length,
                      (int i) => Container(
                        child: Row(
                          children: [
                            Theme(
                              data: Theme.of(context).copyWith(
                                primaryColor: mainColor,
                              ),
                              child: Radio<int>(
                                value: i,
                                activeColor: mainColor,
                                fillColor: MaterialStateColor.resolveWith(
                                    (states) => mainColor),
                                groupValue: groupValue,
                                onChanged: (index) {
                                  groupValue = index;
                                  selectSupplierId = supplierModel
                                      .supplierModel.supplierLists[index].supId;
                                  selectSupplierName = supplierModel
                                      .supplierModel
                                      .supplierLists[index]
                                      .supName;
                                  dialogState(() {});
                                },
                              ),
                            ),
                            Container(
                              width: Get.width * 0.51,
                              child: Text(
                                supplierModel
                                    .supplierModel.supplierLists[i].supName,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text(
                      Strings.Submit,
                      style: GoogleFonts.poppins(
                        color: themeColor.getColor(),
                        fontSize: 18,
                      ),
                    ),
                    onPressed: () async {
                      if (selectSupplierId == null) {
                        selectSupplierId = supplierModel
                            .supplierModel.supplierLists.first.supId;
                        selectSupplierName = supplierModel
                            .supplierModel.supplierLists.first.supName;
                        print(selectSupplierId);
                      }
                      print(selectSupplierId);
                      Navigator.of(context).pop(selectSupplierId);
                    },
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
