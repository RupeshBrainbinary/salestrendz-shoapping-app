import 'package:flutter/material.dart';
import 'package:shoppingapp/models/productMayLikeModel.dart';
import 'package:shoppingapp/utils/commons/export_basic_file.dart';
import 'package:http/http.dart' as http;

class ProductLikeDetailPage extends StatefulWidget {
  @override
  ProductLikeDetailPageState createState() => ProductLikeDetailPageState();
}

class ProductLikeDetailPageState extends State<ProductLikeDetailPage> {
  int selectedIndex = 0;
  ProductLikeDetailPageViewModel model;
  FavoriteViewModel1 model1;

  bool addtocart = false;
  var currrentIndex;
  int cartListIndex = 0;

  ScrollController controller;
  bool isPaging = false;
  int initPosition = 0;
  int page = 1;
  bool search = false;
  final searchController = TextEditingController();
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  bool change = false;

  List<TextEditingController> qtyController = [];
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller = new ScrollController()..addListener(_scrollListener);
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
        model.getProductLikeApi(page);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_statements
    model ?? (model = ProductLikeDetailPageViewModel(this));
    // ignore: unnecessary_statements
    model1 ?? (model1 = FavoriteViewModel1(this));
    final themeColor = Provider.of<ThemeNotifier>(context);
    return WillPopScope(
      onWillPop: () async {
        Get.back(result: "i");
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          actions: [
            InkWell(
              onTap: () {
                if (search == true) {
                  search = false;
                  model.getProductLikeApiInitial();
                } else {
                  search = true;
                }
                setState(() {});
              },
              child: Icon(Icons.search),
            ),
            SizedBox(width: 10),
          ],
          title: Text(
            Strings.productYouLike,
            style: GoogleFonts.roboto(color: Colors.black),
          ),
        ),
        drawer: CustomDrawer(),
        body: model.productLike == null
            ? Center(
                child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(themeColor.getColor())))
            : Container(
                child: Column(
                  children: [
                    search != true
                        ? SizedBox()
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
                                      cursorColor:
                                          Theme.of(context).primaryColor,
                                      controller: searchController,
                                      key: _formKey,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: Strings.searchpro,
                                        hintStyle: GoogleFonts.roboto(
                                          fontSize: 13,
                                          color: Color(0xFF5D6A78),
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      onFieldSubmitted: (searchText) async {
                                        Loader().showLoader(context);
                                        await model.getProductLikeApiInitial();
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
                                          await model
                                              .getProductLikeApiInitial();
                                          page = 1;
                                          Loader().hideLoader(context);
                                          setState(() {});
                                        },
                                        child: Icon(Icons.close),
                                      )
                                    : SizedBox()
                              ],
                            ),
                          ),
                    search != true ? SizedBox() : Divider(thickness: 1),
                    Expanded(
                      child: Container(
                        // height: search != true
                        //     ? Get.height * 0.87
                        //     : Get.height * 0.78,
                        child: model.productLike.products.isEmpty
                            ? Container(
                                height: Get.height * 0.8,
                                child: Center(
                                  child: Text(
                                    Strings.pronotfound,
                                    style: GoogleFonts.roboto(
                                      fontSize: 25,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ),
                              )
                            : ListView.builder(
                                controller: controller,
                                itemCount:
                                    model.productLike.products.length ?? 0,
                                itemBuilder: (BuildContext context, int index) {
                                  qtyController = [];
                                  List.generate(
                                      model.productLike.products.length,
                                      (index) => qtyController
                                          .add(TextEditingController()));
                                  for (var i = 0;
                                      i < bookOrderObj.productsInCart.length;
                                      i++) {
                                    if (model.productLike.products[index]
                                            .productId
                                            .toString() ==
                                        bookOrderObj
                                            .productsInCart[i].productID) {
                                      cartListIndex = i;
                                      change = true;
                                      qtyController[index]
                                        ..text = bookOrderObj
                                                .productsInCart[cartListIndex]
                                                ?.productQuantity
                                                ?.toInt()
                                                ?.toString() ??
                                            "1";
                                    }
                                  }
                                  return productTile(
                                      index, themeColor, context);
                                },
                              ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  productTile(int index, themeColor, context) {
    return Container(
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () async {
          int productIndex;
          for (var i = 0; i < bookOrderObj.productsInCart.length; i++) {
            if (bookOrderObj.productsInCart[i].productID ==
                model.productLike.products[index].productId.toString()) {
              productIndex = i;
            }
          }

          var data = await Get.to(
            () => ProductDetailPage(
              productId: model.productLike.products[index].productId,
              productQty: productIndex == null
                  ? 1.0
                  : bookOrderObj.productsInCart[productIndex].productQuantity,
            ),
          );

          Loader().showLoader(context);
          await model.getProductLikeApiInitial();
          Loader().hideLoader(context);

          setState(() {});
        },
        child:
            // model.productLike.products[index].savedPercentage == 0 ?SizedBox():
            Container(
          margin: EdgeInsets.only(right: 5, top: 5),
          child: Column(
            children: [
              Container(
                child: Row(
                  children: [
                    Column(
                      children: [
                        model.productLike.products[index].imagesize512X512 !=
                                    null &&
                                model.productLike.products[index]
                                    .imagesize512X512.isNotEmpty
                            ? Image.network(
                                // For neelam package
                                // model.productLike.products[index]
                                //     .imagesize512X512.first
                                //     .toString(),
                                // For q-one package
                                model.productLike.products[index]
                                    .imagesize512X512,
                                height: Get.height * 0.1,
                                width: Get.width * 0.29,
                              )
                            : Image.asset(
                                'assets/images/productPlaceaHolderImage.png',
                                height: Get.height * 0.1,
                                width: Get.width * 0.29,
                              ),
                        SizedBox(height: 10),
                        model.productLike.products[index].savedPercentage ==
                                    0 ||
                                model.productLike.products[index]
                                        .savedPercentage ==
                                    null
                            ? SizedBox(width: Get.width * 0.23)
                            : Container(
                                width: Get.width * 0.23,
                                padding: EdgeInsets.only(
                                    top: 2, left: 5, bottom: 2, right: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                    color: themeColor.getColor(),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    (model.productLike.products[index]
                                            .savedPercentage
                                            .toString() +
                                        '% ${Strings.off}'),
                                    maxLines: 1,
                                    style: GoogleFonts.roboto(
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
                                model.productLike.products[index].productName,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.roboto(
                                  color: Colors.grey[500],
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                if (model.productLike.products[index]
                                        .isinWishlist ==
                                    'active') {
                                  model1.getFavoriteApi(
                                    productId: model
                                        .productLike.products[index].productId
                                        .toString(),
                                    wishListId: model.productLike
                                        .products[index].wishlist.wishlistId
                                        .toString(),
                                    wishListStatus: 'inactive',
                                  );
                                  setState(() {
                                    model.productLike.products[index]
                                        .isinWishlist = IsinWishlist.INACTIVE;
                                    //'inactive';
                                    change = true;
                                  });
                                  // ignore: deprecated_member_use
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
                                } else {
                                  model1.getFavoriteApi(
                                    productId: model
                                        .productLike.products[index].productId
                                        .toString(),
                                    wishListId: 'new',
                                    wishListStatus: 'active',
                                  );
                                  setState(() {
                                    model.productLike.products[index]
                                        .isinWishlist = IsinWishlist.ACTIVE;
                                    //'active';
                                  });
                                  // ignore: deprecated_member_use
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
                                }
                                setState(() {});
                              },
                              child: Icon(
                                Icons.favorite,
                                color: model.productLike.products[index]
                                            .isinWishlist ==
                                        'active'
                                    ? themeColor.getColor()
                                    : Colors.black,
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                        // qtyInCases: json["qty_in_cases"],
                        model.productLike.products[index].qtyInCases == 0 ||
                                model.productLike.products[index].qtyInCases ==
                                    null ||
                                model.productLike.products[index].qtyInCases ==
                                    "null"
                            ? SizedBox()
                            : Text(
                                '${Strings.Quantityincase} ${model.productLike.products[index].qtyInCases}',
                                style: GoogleFonts.roboto(
                                  color: Colors.grey,
                                  // decoration:
                                  // TextDecoration.lineThrough,
                                ),
                              ),
                        model.productLike.products[index].minQty == 0 ||
                                model.productLike.products[index].minQty == null
                            ? Text("")
                            : Text(
                                '${Strings.MinQty}: ${model.productLike.products[index].minQty}',
                                style: GoogleFonts.roboto(
                                  color: Colors.black,
                                  // decoration:
                                  // TextDecoration.lineThrough,
                                ),
                              ),

                        // Align(
                        //     child: Text("Unit Per Kg:-")),
                        Container(
                          width: Get.width * 0.69,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              model.productLike.products[index].ppMrp != null
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          tempName == "MILLBORN-Jaipur"
                                              ? "List Price:"
                                              : "MRP:",
                                          // Strings.base_rate,
                                          style: GoogleFonts.roboto(
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Text(
                                          '₹ ${model.productLike.products[index].ppMrp.toStringAsFixed(2) ?? 0.0}',
                                          style: GoogleFonts.roboto(
                                            color: Colors.grey,
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                        ),
                                      ],
                                    )
                                  : SizedBox()
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
                                    "D.P:",
                                    // Strings.Price,
                                    style: GoogleFonts.roboto(
                                      color: showMBPrimaryColor
                                          ? millBornPrimaryColor
                                          : themeColor.getColor(),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    '₹ ${model.productLike.products[index].ppPrice.toStringAsFixed(2) ?? 0.0}',
                                    style: GoogleFonts.roboto(
                                      color: showMBPrimaryColor
                                          ? millBornPrimaryColor
                                          : themeColor.getColor(),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: Get.width * 0.69,
                          child: model.productLike.products[index]
                                          .savedPercentage ==
                                      0 ||
                                  model.productLike.products[index]
                                          .savedPercentage ==
                                      null
                              ? SizedBox()
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      Strings.discount_rate,
                                      style: GoogleFonts.roboto(
                                        color: Colors.grey,
                                        fontSize: 15,
                                      ),
                                    ),
                                    Text(
                                      '₹' +
                                          '${(model.productLike.products[index].ppMrp - model.productLike.products[index].ppPrice).toStringAsFixed(2)}' +
                                          ' (${model.productLike.products[index].savedPercentage == null ? 0 : model.productLike.products[index].savedPercentage.round()}%)',
                                      style: GoogleFonts.roboto(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
                                      ),
                                    )
                                  ],
                                ),
                        ),
                        model.productLike.products[index].schemeOnProduct
                                    .length ==
                                0
                            ? SizedBox()
                            : Container(
                                width: Get.width * 0.69,
                                child: Column(
                                  children: model.productLike.products[index]
                                      .schemeOnProduct
                                      .map<Widget>((e) => Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                //"Offer: hello",
                                                "Offer: ${e.name}",
                                                style: GoogleFonts.roboto(
                                                  color: Colors.grey.shade600,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12.5,
                                                ),
                                              ),
                                            ],
                                          ))
                                      .toList(),
                                ),
                              ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 5),
              Container(
                color: Colors.white10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(width: 10),
                    bookOrderObj.productsInCart.length == 0 ||
                            bookOrderObj.productsInCart.length - 1 <
                                cartListIndex
                        ? addToCartBtnWidget(index, themeColor, context)
                        : bookOrderObj.productsInCart[cartListIndex].productID
                                    .toString() ==
                                model.productLike.products[index].productId
                                    .toString()
                            ? addQuentityWidgetRow(
                                index, cartListIndex, themeColor, context)
                            : addToCartBtnWidget(
                                index,
                                themeColor,
                                context,
                              )
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

  Widget addQuentityWidgetRow(int index, int selectedIndex,
      ThemeNotifier themeColor, BuildContext context) {
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
                    if (bookOrderObj
                                .productsInCart[selectedIndex].minQuantity ==
                            0 &&
                        bookOrderObj.productsInCart[selectedIndex]
                                .productQuantity ==
                            model.productLike.products[index].qtyInCases) {
                      bookOrderObj.productsInCart.removeAt(selectedIndex);
                      setState(() {});
                      return;
                    }
                    setState(() {
                      if (selectedIndex != null) {
                        if (bookOrderObj
                                .productsInCart[selectedIndex].productQuantity >
                            (  model.productLike.products[index].minQty??
                                0)) {
                          tempName == "MILLBORN-Jaipur"
                              ? bookOrderObj.productsInCart[selectedIndex]
                                  .productQuantity -= ( model.productLike.products[index].minQty ==
                                      0
                                  ? 1
                                  : bookOrderObj
                                      .productsInCart[selectedIndex].addQty)
                              : bookOrderObj.productsInCart[selectedIndex]
                                  .productQuantity--;
                          bookOrderObj.productsInCart[selectedIndex]
                                  .productQuantity =
                              bookOrderObj.productsInCart[selectedIndex]
                                  .productQuantity;
                          if (bookOrderObj.productsInCart[selectedIndex]
                                  .productQuantity ==
                              0) {
                            bookOrderObj.productsInCart.removeAt(selectedIndex);
                          }
                        } else if (bookOrderObj.productsInCart[selectedIndex]
                                .productQuantity ==
                            ( model.productLike.products[index].minQty ??
                                0)) {
                          bookOrderObj.productsInCart.removeAt(selectedIndex);
                        }
                        bookOrderObj.addSelectedProductInCart(null);
                      } else {
                        if ( model.productLike.products[index].minQty <
                            bookOrderObj.productsInCart[selectedIndex]
                                .productQuantity) {
                          bookOrderObj
                              .productsInCart[selectedIndex].productQuantity--;
                        }
                        bookOrderObj.addSelectedProductInCart(null);

                        FocusScope.of(context).unfocus();
                      }
                      BookOrderModel.orderModelObj.refreshViewForOrderBooking();
                      FocusScope.of(context).unfocus();
                    });
                    /*   setState(() {
                      if (bookOrderObj
                              .productsInCart[selectedIndex].minQuantity <
                          bookOrderObj
                              .productsInCart[selectedIndex].productQuantity) {
                        if (bookOrderObj.productsInCart[selectedIndex]
                                .productQuantity !=
                            1) {
                          tempName == "MILLBORN-Jaipur"
                              ? bookOrderObj.productsInCart[selectedIndex]
                                  .productQuantity -= (bookOrderObj
                                          .productsInCart[selectedIndex]
                                          .minQuantity ==
                                      0
                                  ? 1
                                  : bookOrderObj.productsInCart[selectedIndex]
                                      .addQty)
                              : bookOrderObj.productsInCart[selectedIndex]
                                  .productQuantity--;
                        } else {
                          bookOrderObj.productsInCart.removeAt(selectedIndex);
                          setState(() {});
                        }
                      }
                      bookOrderObj.addSelectedProductInCart(null);
                      BookOrderModel.orderModelObj.refreshViewForOrderBooking();
                      FocusScope.of(context).unfocus();
                    });*/
                  },
                  child: Text(
                    "-",
                    style: TextStyle(
                        fontSize: 30,
                        color: showMBPrimaryColor
                            ? millBornPrimaryColor
                            : Colors.white),
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
                      hintStyle: GoogleFonts.roboto(),
                      errorStyle: GoogleFonts.roboto(),
                    ),
                    onChanged: (value) {
                      bookOrderObj
                              .productsInCart[selectedIndex].productQuantity =
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
                      tempName == "MILLBORN-Jaipur"
                          ? bookOrderObj.productsInCart[selectedIndex]
                              .productQuantity += (bookOrderObj
                                      .productsInCart[selectedIndex]
                                      .minQuantity ==
                                  0
                              ? 1
                              : bookOrderObj
                                  .productsInCart[selectedIndex].addQty)
                          : bookOrderObj
                              .productsInCart[selectedIndex].productQuantity++;
                      bookOrderObj.addSelectedProductInCart(null);
                      BookOrderModel.orderModelObj.refreshViewForOrderBooking();
                      FocusScope.of(context).unfocus();
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 9.0),
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

  Widget addToCartBtnWidget(
      int index, ThemeNotifier themeColor, BuildContext context) {
    return InkWell(
      onTap: () {
        Loader().showLoader(context);
        addtocart = true;
        getProductDetailsAndAddToCart(
            context,
            model.productLike.products[index].productId.toString(),
            index,
            model.productLike.products[index].minQty == 0 &&
                    model.productLike.products[index].qtyInCases == 10
                ? model.productLike.products[index].qtyInCases
                : model.productLike.products[index].minQty);
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
              style: GoogleFonts.roboto(color: themeColor.getColor()),
            ),
          ],
        ),
      ),
    );
  }

// ------------------------       THIS WIDGET FOR SHOW ADD PRODUCT IN CART BTN WHEN API CALLING      ----------------

  void getProductDetailsAndAddToCart(BuildContext context,
      String selectedProductID, int index, int qty) async {
    bool isAdded = false;
    String loggedInUserId = LoginModelClass.loginModelObj
        .getValueForKeyFromLoginResponse(key: 'user_id');

    var url = Base_URL +
        productDetails +
        '&logged_in_userid=$loggedInUserId&product_id=$selectedProductID';

    if (GlobalModelClass.internetConnectionAvaiable() == true) {
      http.Response resp = await http.get(
        Uri.parse(url),
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
                  callType: 1,
                  productQty: qty == 0 ? 1.0 : qty.toDouble(),
                  isVariantAvailable: true);
              Loader().hideLoader(context);
              setState(() {});
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
                            backgroundColor: tempName == "MILLBORN-Jaipur"
                                ? millBornPrimaryThemeColor
                                : mainC,
                            duration: Duration(seconds: 1),
                            content: Text(
                              isAdded
                                  ? Strings.aleardyadded
                                  : Strings.pronotfound,
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
                      backgroundColor: tempName == "MILLBORN-Jaipur"
                          ? millBornPrimaryThemeColor
                          : mainC,
                      duration: Duration(seconds: 1),
                      content: Text(
                        isAdded ? Strings.aleardyadded : Strings.pronotfound,
                      ),
                    ),
                  );
                });
                setState(() {});
              }
            },
          );
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

  void variantsBottomSheet(int index, OrderedProduct productData,
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
                          style: GoogleFonts.roboto(color: Colors.white),
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
                              .selectedProduct['available_variants'].length ??
                          0,
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
                                            productID: selectedProductID,
                                            callType: 1,
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
                                              : Colors.grey[300]),
                                    ),
                                    child: Container(
                                      child: Text(
                                        bookOrderObj.selectedProduct[
                                                'available_variants'][index]
                                            ['variant_attri_name'],
                                        style: GoogleFonts.roboto(
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
                                            textController
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
                                        hintStyle: GoogleFonts.roboto(),
                                        errorStyle: GoogleFonts.roboto(),
                                      ),
                                      onChanged: (value) {
                                        tempProduct.productQuantity =
                                            double.parse(value);
                                      },
                                      controller: textController,
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(
                                        () {
                                          tempProduct.productQuantity++;
                                          textController
                                            ..text = tempProduct.productQuantity
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
                        tempProduct = bookOrderObj.getProductDetailsObject(
                            selectedVarientId: bookOrderObj.selectedProduct,
                            productID: selectedProductID,
                            callType: 1,
                            variantIndex: selectedIndex,
                            isVariantAvailable: true,
                            productQty: double.parse(textController.text));
                        bookOrderObj.addSelectedProductInCart(tempProduct);
                        BookOrderModel.orderModelObj
                            .refreshViewForOrderBooking();
                        addedCartFunction(isAdded);
                        BookOrderModel.orderModelObj
                            .refreshViewForOrderBooking();
                      },
                      child: Container(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: Text(
                          Strings.addToCart,
                          style: GoogleFonts.roboto(color: Colors.white),
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
