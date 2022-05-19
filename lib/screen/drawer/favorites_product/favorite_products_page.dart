import 'package:flutter/material.dart';
import 'package:shoppingapp/utils/commons/export_basic_file.dart';
import 'package:http/http.dart' as http;
import 'package:shoppingapp/widgets/commons/custom_alert.dart';

class FavoriteProductsPage extends StatefulWidget {
  FavoriteProductsPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new FavoriteProductsPageState();
  }
}

class FavoriteProductsPageState extends State<FavoriteProductsPage>
    with SingleTickerProviderStateMixin {
  int selectedIndex = 0;
  var currrentIndex;
  bool addToCart = false;
  int cartListIndex = 0;
  FavoriteViewModel model;

  WishlistModel wishlistModel = WishlistModel();

  List<TextEditingController> qtyController = [];
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (GlobalModelClass.internetConnectionAvaiable() != true) {
      Future.delayed(Duration.zero, () {
        GlobalModelClass.showAlertForNoInternetConnection(context).show();
      });
    } else {
      RestApi.favoriteProductApi().then((value) {
        wishlistModel = value;
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_statements
    model ?? (model = FavoriteViewModel(this));
    final themeColor = Provider.of<ThemeNotifier>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: themeColor.getColor()),
          centerTitle: true,
          title: Text(
            Strings.favproduct,
            style: GoogleFonts.poppins(color: themeColor.getColor()),
          ),
          backgroundColor: Colors.white,
        ),
        backgroundColor: whiteColor,
        drawer: CustomDrawer(),
        body: wishlistModel?.wishlistProducts == null
            ? Container(
                child: Center(child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(themeColor.getColor()))),
              )
            : Container(
                child: wishlistModel.wishlistProducts.length == null ||
                        wishlistModel?.wishlistProducts?.length == 0 ||
                        wishlistModel.wishlistProducts.isEmpty
                    ? Container(
                        height: Get.height * 0.8,
                        child: Center(
                          child: Text(
                            Strings.pronotfound,
                            style: GoogleFonts.poppins(
                              fontSize: 25,
                              color: Colors.grey[500],
                            ),
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: wishlistModel.wishlistProducts.length,
                        itemBuilder: (BuildContext context, int index) {
                          qtyController = [];
                          List.generate(
                              wishlistModel.wishlistProducts.length,
                              (index) =>
                                  qtyController.add(TextEditingController()));
                          for (var i = 0;
                              i < bookOrderObj.productsInCart.length;
                              i++) {
                            if (wishlistModel.wishlistProducts[index].productId
                                    .toString() ==
                                bookOrderObj.productsInCart[i].productID) {
                              cartListIndex = i;
                              qtyController[index]
                                ..text = bookOrderObj
                                        .productsInCart[cartListIndex]
                                        ?.productQuantity
                                        ?.toInt()
                                        ?.toString() ??
                                    "1";
                            }
                          }
                          return productTile(index, themeColor, context);
                        },
                      ),
              ),
      ),
    );
  }

  productTile(int index, themeColor, context) {
    return Container(
      child: Stack(
        children: <Widget>[
          InkWell(
            onTap: () async {
              int productIndex;

              for (var i = 0; i < bookOrderObj.productsInCart.length; i++) {
                if (bookOrderObj.productsInCart[i].productID ==
                    wishlistModel.wishlistProducts[index].productId
                        .toString()
                        .toString()) {
                  productIndex = i;
                }
              }

              var data = await Get.to(
                () => ProductDetailPage(
                  productId: wishlistModel.wishlistProducts[index].productId,
                  productQty: productIndex == null
                      ? 1.0
                      : bookOrderObj
                          .productsInCart[productIndex].productQuantity,
                ),
              );

              Loader().showLoader(context);
              final value = await RestApi.favoriteProductApi();
              wishlistModel = value;
              print(wishlistModel?.wishlistProducts?.length);
              Loader().hideLoader(context);
              setState(() {});
            },
            child: Container(
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
                      child: wishlistModel.wishlistProducts[index]
                                      .imagesize512X512 ==
                                  null ||
                              wishlistModel.wishlistProducts[index]
                                  .imagesize512X512.isEmpty
                          ? Image.asset(
                              'assets/images/productPlaceaHolderImage.png',
                              fit: BoxFit.cover,
                              width: Get.width * 0.30,
                            )
                          : Image.network(
                              wishlistModel
                                  .wishlistProducts[index]?.imagesize512X512[0],
                              fit: BoxFit.cover,
                              width: Get.width * 0.30,
                            ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    height: 160,
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
                        AutoSizeText(
                          wishlistModel.wishlistProducts[index].productName ??
                              "",
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
                            Text(
                              "₹${wishlistModel.wishlistProducts[index]?.mrp?.toStringAsFixed(2) ?? 0.0}",
                              style: GoogleFonts.poppins(
                                decoration: TextDecoration.lineThrough,
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            SizedBox(width: 4),
                            Text(
                              "₹${wishlistModel.wishlistProducts[index]?.price?.toStringAsFixed(2) ?? 0.0}",
                              style: GoogleFonts.poppins(
                                color: themeColor.getColor(),
                                fontSize: 18,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 26, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              bookOrderObj.productsInCart.length == 0 ||
                                      bookOrderObj.productsInCart.length - 1 <
                                          cartListIndex
                                  ? addToCartBtnWidget(
                                      index, themeColor, context)
                                  : bookOrderObj.productsInCart[cartListIndex]
                                              .productID
                                              .toString() ==
                                          wishlistModel
                                              .wishlistProducts[index].productId
                                              .toString()
                                      ? addQuentityWidgetRow(index,
                                          cartListIndex, themeColor, context)
                                      : addToCartBtnWidget(
                                          index, themeColor, context)
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: 16,
            right: 32,
            child: InkWell(
              onTap: () {
                if (wishlistModel.wishlistProducts[index].favorite ==
                    'active') {
                  model.getFavoriteApi(
                    productId: wishlistModel.wishlistProducts[index].productId
                        .toString(),
                    wishListId: wishlistModel.wishlistProducts[index].wishlistId
                        .toString(),
                    wishListStatus: 'inactive',
                  );
                  setState(() {
                    // ignore: unnecessary_statements
                    wishlistModel.wishlistProducts[index].favorite ==
                        'inactive';
                    wishlistModel.wishlistProducts.removeAt(index);
                  });
                  // ignore: deprecated_member_use
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: tempName == "MILLBORN-Jaipur" ? millBornPrimaryThemeColor : mainC,
                      duration: Duration(seconds: 1),
                      content: Text(Strings.removetosts),
                    ),
                  );
                } else {
                  model.getFavoriteApi(
                    productId: wishlistModel.wishlistProducts[index].productId
                        .toString(),
                    wishListId: 'new',
                    wishListStatus: 'active',
                  );
                  setState(() {
                    // ignore: unnecessary_statements
                    wishlistModel.wishlistProducts[index].favorite == 'active';
                  });
                  // ignore: deprecated_member_use
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor:tempName == "MILLBORN-Jaipur" ? millBornPrimaryThemeColor :  mainC,
                      duration: Duration(seconds: 1),
                      content: Text(Strings.addedtosts),
                    ),
                  );
                }
                setState(() {});
              },
              child: Icon(
                Icons.favorite,
                color:
                    wishlistModel.wishlistProducts[index].favorite == 'active'
                        ? Colors.red
                        : Colors.white,
                size: 22,
              ),
            ),
          ),
          wishlistModel.wishlistProducts[index]?.schemeOnProduct
                  ?.map<String>((e) => e.name)
                  ?.toList()
                  .isEmpty
              ? SizedBox()
              : Positioned(
                  top: 8,
                  left: 24,
                  child: GestureDetector(
                    onTap: () {
                      openDialog(
                        context,
                        offer: wishlistModel
                            .wishlistProducts[index]?.schemeOnProduct
                            ?.map<String>((e) => e.name)
                            ?.toList(),
                        startTime: wishlistModel
                            .wishlistProducts[index]?.schemeOnProduct
                            ?.map<String>((e) => e.startDate.toString())
                            ?.toList(),
                        endTime: wishlistModel
                            .wishlistProducts[index]?.schemeOnProduct
                            ?.map<String>((e) => e.endDate.toString())
                            ?.toList(),
                      );
                    },
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
                )
        ],
      ),
    );
  }

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
                    setState(() {
                        if (bookOrderObj.productsInCart[selectedIndex]
                                .productQuantity !=
                            1 && bookOrderObj
                            .productsInCart[selectedIndex].minQuantity <
                            bookOrderObj
                                .productsInCart[selectedIndex].productQuantity) {
                          bookOrderObj
                              .productsInCart[selectedIndex].productQuantity--;
                        } else {
                          bookOrderObj.productsInCart.removeAt(selectedIndex);
                          BookOrderModel.orderModelObj
                              .refreshViewForOrderBooking();
                          setState(() {});
                        }
                      bookOrderObj.addSelectedProductInCart(null);
                      BookOrderModel.orderModelObj.refreshViewForOrderBooking();
                      FocusScope.of(context).unfocus();
                    });
                  },
                  child: Text(
                    "-",
                    style: TextStyle(
                      fontSize: 24,
                      color:showMBPrimaryColor ?millBornPrimaryColor : Colors.white,
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
                      bookOrderObj
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
                      style: TextStyle(color:showMBPrimaryColor ?millBornPrimaryColor : Colors.white),
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

  Widget addToCartBtnWidget(
      int index, ThemeNotifier themeColor, BuildContext context) {
    return InkWell(
      onTap: () {
        Loader().showLoader(context);
        addToCart = true;
        getProductDetailsAndAddToCart(
          context,
          wishlistModel.wishlistProducts[index].productId.toString(),
        );
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
              style: GoogleFonts.poppins(color: themeColor.getColor()),
            ),
          ],
        ),
      ),
    );
  }

  Widget placeHolderAddToCartBtn(
      ThemeNotifier themeColor, BuildContext context) {
    return InkWell(
      onTap: () {},
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
              style: GoogleFonts.poppins(color: themeColor.getColor()),
            ),
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
      Loader().showLoader(context);
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

      if (resp.statusCode == 200) {
        Loader().hideLoader(context);
        var jsonBodyResp = jsonDecode(resp.body);

        if (jsonBodyResp['status'] == true) {
          // ignore: invalid_use_of_protected_member
          Scaffold.of(context).setState(() {
            bookOrderObj.selectedProduct = jsonBodyResp['products'];
            bookOrderObj.currentProductVariants =
                bookOrderObj.selectedProduct['available_variants'];
            bookOrderObj.availableVariantsList = availableVariantsFromJson(
                jsonEncode(bookOrderObj.selectedProduct['available_variants']));
            bookOrderObj.selectedVariant =
                bookOrderObj.currentProductVariants.first;

            if (bookOrderObj.productsInCart == null) {
              bookOrderObj.productsInCart = [];
            }

            OrderedProduct tempProduct = bookOrderObj.getProductDetailsObject(
                selectedVarientId: jsonBodyResp['products'],
                productID: selectedProductID,
                callType: 1,
                productQty: jsonBodyResp['products']['min_qty'] != null
                    ? jsonBodyResp['products']['min_qty'].toDouble()
                    : 1.0,
                minQty: jsonBodyResp['products']['min_qty'] ?? 1,
                isVariantAvailable: true);
            Scaffold.of(context).setState(() {
              bookOrderObj.showLoadingIndicator = false;
            });
            if (bookOrderObj.selectedProduct['type'] == 'Variant') {
              variantsBottomSheet(
                tempProduct,
                (value) {
                  isAdded = value;
                  Scaffold.of(context).setState(() {
                    // ignore: deprecated_member_use
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor:tempName == "MILLBORN-Jaipur" ? millBornPrimaryThemeColor :  mainC,
                        duration: Duration(seconds: 1),
                        content: Text(
                          isAdded ? Strings.aleardyadded : Strings.proadded,
                        ),
                      ),
                    );
                  });
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
              setState(() {});
              bookOrderObj.addSelectedProductInCart(tempProduct);
              BookOrderModel.orderModelObj.refreshViewForOrderBooking();
              Loader().hideLoader(context);
              Scaffold.of(context).setState(() {
                // ignore: deprecated_member_use
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor:tempName == "MILLBORN-Jaipur" ? millBornPrimaryThemeColor :  mainC,
                    duration: Duration(seconds: 1),
                    content: Text(
                      isAdded ? Strings.aleardyadded : Strings.proadded,
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

  void variantsBottomSheet(OrderedProduct productData,
      Function addedCartFunction, String selectedProductID) {
    OrderedProduct tempProduct = bookOrderObj.getProductDetailsObject(
      selectedVarientId: bookOrderObj.selectedProduct,
      productID: selectedProductID,
      callType: 1,
      variantIndex: selectedIndex,
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
                            Loader().hideLoader(context);
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
                                        style:showMBPrimaryColor ?millBornPrimaryColor : TextStyle(color: Colors.white),
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
                        tempProduct = bookOrderObj.getProductDetailsObject(
                            selectedVarientId: bookOrderObj.selectedProduct,
                            productID: selectedProductID,
                            callType: 1,
                            variantIndex: selectedIndex,
                            isVariantAvailable: true,
                            productQty: double.parse(textController.text));
                        bookOrderObj.addSelectedProductInCart(tempProduct);
                        addedCartFunction(isAdded);
                        BookOrderModel.orderModelObj
                            .refreshViewForOrderBooking();
                        Loader().hideLoader(context);
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
