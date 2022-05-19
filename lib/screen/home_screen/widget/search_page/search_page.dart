import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shoppingapp/app_url_name_companyid.dart';
import 'package:shoppingapp/models/BookOrderModel.dart';
import 'package:shoppingapp/models/GlobalModelClass.dart';
import 'package:shoppingapp/models/LoginModelClass.dart';
import 'package:shoppingapp/screen/auth_screens/login/login_form.dart';
import 'package:shoppingapp/screen/home_screen/widget/search_page/search_page_model.dart';
import 'package:shoppingapp/screen/product_detail/product_detail_page.dart';
import 'package:shoppingapp/utils/commons/colors.dart';
import 'package:shoppingapp/utils/constants/constants_app_variables.dart';
import 'package:shoppingapp/utils/navigator.dart';
import 'package:shoppingapp/utils/theme_notifier.dart';
import 'package:shoppingapp/widgets/commons/full_screen_loader.dart';
import 'package:shoppingapp/widgets/commons/string_res.dart';
import 'package:shoppingapp/screen/cart_screen/shopping_cart_page.dart'
    as prefix;
import 'package:http/http.dart' as http;

BookOrderModel bookOrderObj = BookOrderModel.orderModelObj;

class SearchPage extends StatefulWidget {
  SearchPage({this.categoryID});

  final String categoryID;

  @override
  SearchPageState createState() =>
      SearchPageState(selectedCategoryID: categoryID);
}

class SearchPageState extends State<SearchPage> {
  SearchPageState({this.selectedCategoryID});

  HomeSearchViewModel model;

  ScrollController controller;
  bool isPaging = false;
  int initPosition = 0;
  int page = 1;
  int cartListIndex = 0;
  List<TextEditingController> qtyController = [];
  TextEditingController textController = TextEditingController();
  int selectedIndex = 0;
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller = new ScrollController()..addListener(_scrollListener);

    print(bookOrderObj.productsInCart.length);
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
        model.getSearchProductApi(page);
      }
    }
  }

  final String selectedCategoryID;

  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  Widget addQuentityWidgetRow(
    int index,
    int selectedIndex,
    ThemeNotifier themeColor,
    BuildContext context,
  ) {
    //  print(selectedVarient);
    return Container(
      margin: EdgeInsets.only(right: 15),
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
                        /*             if (selectedVarient != null) {
                          if (selectedVarient['quantity'] >
                              (model.product.products[index].productVariants ?? 0)) {
                            selectedVarient['quantity']--;
                            bookOrderObj.productsInCart[selectedIndex]
                                .productQuantity = selectedVarient['quantity'];
                            if (selectedVarient['quantity'] == 0) {
                              prefix.bookOrderObj.productsInCart
                                  .removeAt(selectedIndex);
                            }
                          } else if (selectedVarient['quantity'] ==
                              (model.product.products[index].productVariants ?? 0)) {
                            prefix.bookOrderObj.productsInCart
                                .removeAt(selectedIndex);
                          }
                          bookOrderObj.addSelectedProductInCart(null);
                        } else {*/
                        //   if (bookOrderObj
                        //       .productsInCart[selectedIndex].minQuantity <
                        //       bookOrderObj.productsInCart[selectedIndex]
                        //           .productQuantity) {
                        //     bookOrderObj.productsInCart[selectedIndex]
                        //         .productQuantity--;
                        //   }
                        //   bookOrderObj.addSelectedProductInCart(null);
                        //
                        //   FocusScope.of(context).unfocus();
                        //
                        // BookOrderModel.orderModelObj
                        //     .refreshViewForOrderBooking();
                        // FocusScope.of(context).unfocus();
                        if (bookOrderObj
                                .productsInCart[selectedIndex].minQuantity <
                            bookOrderObj.productsInCart[selectedIndex]
                                .productQuantity) {
                          // bookOrderObj.productsInCart[selectedIndex]
                          //         .productQuantity--;
                          if (bookOrderObj.productsInCart[selectedIndex]
                                  .productQuantity >
                              1) {
                            bookOrderObj.productsInCart[selectedIndex]
                                .productQuantity--;
                            // widget.qtyController[widget.index]
                            //   ..text = bookOrderObj
                            //       .productsInCart[selectedIndex].productQuantity
                            //       .toInt()
                            //       .toString();
                          } else {
                            bookOrderObj.productsInCart.removeAt(selectedIndex);
                            BookOrderModel.orderModelObj
                                .refreshViewForOrderBooking();
                            setState(() {});
                          }
                        }
                        bookOrderObj.addSelectedProductInCart(null);
                        FocusScope.of(context).unfocus();
                      });
                    },
                    child: Text(
                      "-",
                      style: GoogleFonts.poppins(
                          fontSize: 24,
                          color: showMBPrimaryColor
                              ? millBornPrimaryColor
                              : Colors.white),
                    )),
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
                      /*     if (selectedVarient['quantity'] != null) {
                        selectedVarient['quantity'] =
                            double.parse(int.parse(value ?? 1).toString());
                        bookOrderObj.productsInCart[selectedIndex]
                            .productQuantity = selectedVarient['quantity'];
                      } else {*/
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
                      /*         if (selectedVarient['quantity'] != null) {
                        selectedVarient['quantity']++;
                        bookOrderObj.productsInCart[selectedIndex]
                            .productQuantity = selectedVarient['quantity'];
                        bookOrderObj.addSelectedProductInCart(null);
                      } else {*/
                      //   bookOrderObj
                      //       .productsInCart[selectedIndex].productQuantity++;
                      //   bookOrderObj.addSelectedProductInCart(null);
                      //   BookOrderModel.orderModelObj
                      //       .refreshViewForOrderBooking();
                      //
                      //
                      // FocusScope.of(context).unfocus();
                      bookOrderObj
                          .productsInCart[selectedIndex].productQuantity++;
                      // widget.qtyController[widget.index]
                      //   ..text = bookOrderObj
                      //       .productsInCart[selectedIndex].productQuantity
                      //       .toInt()
                      //       .toString();
                      bookOrderObj.addSelectedProductInCart(null);
                      setState(() {});
                      FocusScope.of(context).unfocus();
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 9.0),
                    child: Text(
                      "+",
                      style: GoogleFonts.poppins(
                        color: showMBPrimaryColor
                            ? millBornPrimaryColor
                            : Colors.white,
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

  Widget addToCartBtnWidget(
      int index, ThemeNotifier themeColor, BuildContext context) {
    return InkWell(
      onTap: () {
        Loader().showLoader(context);
        BookOrderModel.orderModelObj.refreshViewForOrderBooking();
        getProductDetailsAndAddToCart(
          context,
          model.product.products[index].productId.toString(),
          index,
          /*catProduct[index]['min_qty'] ??*/ 1,
        );
        BookOrderModel.orderModelObj.refreshViewForOrderBooking();
        setState(() {});
      },
      child: Container(
        margin: EdgeInsets.only(right: 15),
        padding: EdgeInsets.fromLTRB(10, 5, 8, 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: themeColor.getColor())),
        child: Row(
          children: [
            Image.asset(
              "assets/icons/shopping-cart.png",
              height: 18,
              width: 20,
              color: themeColor.getColor(),
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              Strings.addToCart,
              style: GoogleFonts.poppins(color: themeColor.getColor()),
            ),
          ],
        ),
      ),
    );
  }

  void getProductDetailsAndAddToCart(BuildContext context,
      String selectedProductID, int index, int qty) async {
    bool isAdded = false;
    String loggedInUserId = LoginModelClass.loginModelObj
        .getValueForKeyFromLoginResponse(key: 'user_id');
    print(selectedProductID);
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

      // ignore: invalid_use_of_protected_member
      Scaffold.of(context).setState(() {
        bookOrderObj.showLoadingIndicator = false;
      });
      if (resp.statusCode == 200) {
        var jsonBodyResp = jsonDecode(resp.body);

        if (jsonBodyResp['status'] == true) {
          // ignore: invalid_use_of_protected_member
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
            //productQty:appName =="MILLBORN-Jaipur"?3.0: 1.0,
            productQty: qty == 0 ? 1.0 : qty.toDouble(),
            callType: 1,
            isVariantAvailable: true,
          );
          setState(() {});
          Loader().hideLoader(context);
          if (bookOrderObj.selectedProduct['type'] == 'Variant') {
            var res = await variantsBottomSheet((value) {
              isAdded = value;
              print('======$isAdded');
              Scaffold.of(context).setState(() {
                // ignore: deprecated_member_use
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: tempName == "MILLBORN-Jaipur"
                        ? millBornPrimaryThemeColor
                        : mainC,
                    duration: Duration(seconds: 1),
                    content: Text(
                      isAdded ? Strings.aleardyadded : Strings.proadded,
                      style: GoogleFonts.poppins(),
                    ),
                  ),
                );
              });
              setState(() {});
            }, selectedProductID);
            // model.product.products[index].pr = res;
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
            // qtyController.clear();
            Scaffold.of(context).setState(() {
              // ignore: deprecated_member_use
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: tempName == "MILLBORN-Jaipur"
                      ? millBornPrimaryThemeColor
                      : mainC,
                  duration: Duration(seconds: 1),
                  content: Text(
                    isAdded ? Strings.aleardyadded : Strings.proadded,
                    style: GoogleFonts.poppins(),
                  ),
                ),
              );
            });
          }
          Scaffold.of(context).setState(() {});
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

  variantsBottomSheet(
      Function addedCartFunction, String selectedProductID) async {
    var currrentIndex;
    print('$selectedProductID?>?>?>');
    OrderedProduct tempProduct = bookOrderObj.getProductDetailsObject(
        selectedVarientId: bookOrderObj.selectedProduct,
        productID: selectedProductID,
        callType: 1,
        variantIndex: selectedIndex,
        productQty: appName == "MILLBORN-Jaipur" ? 3.0 : 1.0,
        isVariantAvailable: true);
    print(tempProduct.productName);
    textController..text = "1";
    return await showModalBottomSheet(
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
                            ))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
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
                                        productQty: appName == "MILLBORN-Jaipur"
                                            ? 3.0
                                            : 1.0,
                                        isVariantAvailable: true);
                                currrentIndex = bookOrderObj
                                        .selectedProduct['available_variants']
                                    [index]['variant_attri_name'];
                                setState(() {});
                              },
                              child: Container(
                                height: 80,
                                // width: 150,
                                width: 80,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                  image: bookOrderObj.selectedProduct[
                                                  'available_variants'][index]
                                              .containsKey(
                                                  'imagesize512x512') &&
                                          bookOrderObj
                                              .selectedProduct[
                                                  'available_variants'][index]
                                                  ['imagesize512x512']
                                              .isNotEmpty
                                      ? NetworkImage(bookOrderObj
                                          .selectedProduct['available_variants']
                                              [index]['imagesize512x512'][0]
                                          .toString())
                                      : AssetImage(
                                          'assets/images/productPlaceaHolderImage.png'),
                                  fit: BoxFit.cover,
                                )),
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
                                            productQty:
                                                appName == "MILLBORN-Jaipur"
                                                    ? 3.0
                                                    : 1.0,
                                            isVariantAvailable: true);
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
                                                                'available_variants']
                                                            [index]
                                                        ['variant_attri_name']
                                                ? themeColor.getColor()
                                                : Colors.grey[300])),
                                    child: Container(
                                        child: Text(
                                      bookOrderObj.selectedProduct[
                                              'available_variants'][index]
                                          ['variant_attri_name'],
                                      style: GoogleFonts.poppins(
                                          color: Colors.grey[600]),
                                    )),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                )
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
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
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 10, left: 10),
                    margin: EdgeInsets.only(bottom: 10),
                    width: Get.width,
                    child: RaisedButton(
                      color: themeColor.getColor(),
                      onPressed: () {
                        bool isAdded = false;
                        Get.back(result: currrentIndex);
                        // Navigator.pop(context,currrentIndex);
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
                            productQty: double.parse(textController.text == "0"
                                ? "1"
                                : textController.text));
                        tempProduct.variantName = currrentIndex;
                        bookOrderObj.addSelectedProductInCart(tempProduct);
                        BookOrderModel.orderModelObj
                            .refreshViewForOrderBooking();
                        addedCartFunction(isAdded);
                        BookOrderModel.orderModelObj
                            .refreshViewForOrderBooking();
                        // qtyController.clear();
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

  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_statements
    model ?? (model = HomeSearchViewModel(this));
    final themeColor = Provider.of<ThemeNotifier>(context);

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Color.fromARGB(255, 252, 252, 252),
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
      ),
    );

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 252, 252, 252),
        body: model.product == null
            ? Center(
                child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(themeColor.getColor())))
            : Stack(
                children: <Widget>[
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: Get.height * 0.09,
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 32,
                                padding: const EdgeInsets.only(top: 8.0),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.chevron_left,
                                    color: themeColor.getColor(),
                                    size: 32,
                                  ),
                                  onPressed: () {
                                    Get.back();
                                  },
                                ),
                              ),
                              Container(
                                width: Get.width - 80,
                                margin: EdgeInsets.only(left: 22, top: 14),
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
                                          key: _formKey,
                                          controller: searchController,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: Strings.BrandSearch,
                                            hintStyle: GoogleFonts.poppins(
                                              fontSize: 13,
                                              color: Color(0xFF5D6A78),
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          onChanged: (searchText) async {
                                            //Loader().showLoader(context);
                                            page = 1;
                                            await model
                                                .getSearchProductInitial();
                                            //Loader().hideLoader(context);
                                            setState(() {});
                                          },
                                          /*     onFieldSubmitted: (searchText) async {
                                            Loader().showLoader(context);
                                            page = 1;
                                            await model
                                                .getSearchProductInitial();
                                            Loader().hideLoader(context);
                                            setState(() {});
                                          },*/
                                        ),
                                      ),
                                    ),
                                    searchController.text.length > 0
                                        ? InkWell(
                                            onTap: () async {
                                              searchController.clear();
                                              Loader().showLoader(context);
                                              await model
                                                  .getSearchProductInitial();
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
                            ],
                          ),
                        ),
                        SizedBox(height: 15.0),
                        model?.product?.products == null
                            ? Container(
                                height: Get.height / 1.5,
                                alignment: Alignment.center,
                                child: Text(
                                  "Products Not Found",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20,
                                    color: Colors.black54,
                                  ),
                                ),
                              )
                            : model.product.products.isEmpty
                                ? Container(
                                    height: Get.height / 1.5,
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Products Not Found",
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  )
                                : SingleChildScrollView(
                                    child: Container(
                                      height: Get.height * 0.89,
                                      child: GridView.builder(
                                        controller: controller,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          childAspectRatio: 0.8,
                                        ),
                                        shrinkWrap: true,
                                        itemCount:
                                            model?.product?.products?.length ??
                                                0,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          List<Map<String, dynamic>>
                                              variantList = [];
                                          // saved_percentage
                                          qtyController = [];
                                          List.generate(
                                              model.product.products.length,
                                              (index) => qtyController.add(
                                                  TextEditingController()));

                                          for (var i = 0;
                                              i <
                                                  bookOrderObj
                                                      .productsInCart.length;
                                              i++) {
                                            if (model.product.products[index]
                                                    .productId
                                                    .toString() ==
                                                bookOrderObj.productsInCart[i]
                                                    .productID) {
                                              cartListIndex = i;
                                              if (model.product.products[index]
                                                      .productVariants !=
                                                  null) {
                                                // qtyController[index]
                                                //   ..text =  bookOrderObj.productsInCart[i].variantQty
                                                //       ?.toInt()
                                                //       ?.toString() ??
                                                //       "0";

                                                // } else {
                                                qtyController[index]
                                                  ..text = bookOrderObj
                                                          .productsInCart[
                                                              cartListIndex]
                                                          .productQuantity
                                                          ?.toInt()
                                                          ?.toString() ??
                                                      0;
                                              }
                                            }
                                          }
                                          return Stack(
                                            children: <Widget>[
                                              InkWell(
                                                onTap: () {
                                                  int productIndex;
                                                  Nav.route(
                                                    context,
                                                    ProductDetailPage(
                                                      productId: model
                                                          .product
                                                          .products[index]
                                                          .productId,
                                                      productQty: productIndex ==
                                                              null
                                                          ? 1.0
                                                          : bookOrderObj
                                                              .productsInCart[
                                                                  productIndex]
                                                              .productQuantity,
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  width: Get.width / 2,
                                                  margin: EdgeInsets.only(
                                                    left: 16,
                                                    top: 5,
                                                    right: 12,
                                                    bottom: 5,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      color: Colors.white,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color:
                                                              Colors.grey[200],
                                                          blurRadius: 5.0,
                                                          spreadRadius: 1,
                                                          offset:
                                                              Offset(0.0, 2),
                                                        ),
                                                      ],
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Container(
                                                          child: Stack(
                                                            children: <Widget>[
                                                              Container(
                                                                width: 300,
                                                                height:
                                                                    Get.height /
                                                                        11,
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            8),
                                                                    topRight: Radius
                                                                        .circular(
                                                                            8),
                                                                  ),
                                                                  child: (model.product.products[index].imagesize512X512 !=
                                                                              null &&
                                                                          model.product.products[index].imagesize512X512.length !=
                                                                              0)
                                                                      ? Image(
                                                                          image: NetworkImage(model
                                                                              .product
                                                                              .products[index]
                                                                              .imagesize512X512
                                                                              .first),
                                                                        )
                                                                      : Image
                                                                          .asset(
                                                                          'assets/images/productPlaceaHolderImage.png',
                                                                          fit: BoxFit
                                                                              .fill,
                                                                        ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          color: Colors.white,
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 10,
                                                                  top: 4),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: <Widget>[
                                                              Container(
                                                                height:
                                                                    Get.height *
                                                                        0.06,
                                                                child:
                                                                    AutoSizeText(
                                                                  model
                                                                          .product
                                                                          .products[
                                                                              index]
                                                                          .productName ??
                                                                      '',
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    fontSize:
                                                                        12,
                                                                    color: Color(
                                                                        0xFF5D6A78),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300,
                                                                  ),
                                                                  maxLines: 2,
                                                                  minFontSize:
                                                                      11,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  height: 2),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: <
                                                                    Widget>[
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: <
                                                                        Widget>[
                                                                      SizedBox(
                                                                          height:
                                                                              2),
                                                                      Text(
                                                                        "$currencySymbol ${model.product.products[index].ppMrp.toStringAsFixed(2) ?? 0}",
                                                                        style: GoogleFonts.poppins(
                                                                            color: themeColor
                                                                                .getColor(),
                                                                            fontSize:
                                                                                10,
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            decoration: TextDecoration.lineThrough),
                                                                      ),
                                                                      Text(
                                                                        "$currencySymbol ${model.product.products[index].ppPrice.toStringAsFixed(2) ?? 0}",
                                                                        style: GoogleFonts
                                                                            .poppins(
                                                                          color:
                                                                              themeColor.getColor(),
                                                                          fontSize:
                                                                              18,
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                              // bookOrderObj.productsInCart.length == 0 ||
                                                              // bookOrderObj.productsInCart.length - 1 < cartListIndex
                                                              // ? addToCartBtnWidget()
                                                              //     : bookOrderObj.productsInCart[cartListIndex].productID ==
                                                              // widget.selectedProduct['product_id'].toString()
                                                              // ? addQuentityWidgetRow(cartListIndex)
                                                              //     : addToCartBtnWidget()),
                                                              bookOrderObj.productsInCart
                                                                              .length ==
                                                                          0 ||
                                                                      bookOrderObj.productsInCart.length -
                                                                              1 <
                                                                          cartListIndex
                                                                  ? addToCartBtnWidget(
                                                                      index,
                                                                      themeColor,
                                                                      context)
                                                                  : bookOrderObj
                                                                              .productsInCart[
                                                                                  cartListIndex]
                                                                              .productID
                                                                              .toString() ==
                                                                          model
                                                                              .product
                                                                              .products[
                                                                                  index]
                                                                              .productId
                                                                              .toString()
                                                                      ? addQuentityWidgetRow(
                                                                          index,
                                                                          cartListIndex,
                                                                          themeColor,
                                                                          context,
                                                                          /*   model.product.products[index].productVariants ==
                                                                      null
                                                                      ? null
                                                                      : model.product.products[index]
                                                                  ['selectedvariant']*/
                                                                        )
                                                                      : addToCartBtnWidget(
                                                                          index,
                                                                          themeColor,
                                                                          context),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  )
                      ],
                    ),
                  ),
                  // GlobalModelClass.globalObject
                  //     .loadingIndicator(bookOrderObj.showLoadingIndicator ?? false),
                ],
              ),
      ),
    );
  }

  productView(int index, themeColor) {
/*    for (var i = 0; i < bookOrderObj.productsInCart.length; i++) {
      if (model.product.products[index].productId.toString() ==
          bookOrderObj.productsInCart[i].productID) {
        cartListIndex = i;
        if (model.product.products[index].productVariants != null) {
          qtyController[index]
            ..text = catProduct[index]['selectedvariant']['quantity']
                ?.toInt()
                ?.toString() ??
                "1";
        } else {
          qtyController[index]
            ..text = bookOrderObj
                .productsInCart[cartListIndex].productQuantity
                ?.toInt()
                ?.toString() ??
                "1";
        }
      }
    }*/
    return Stack(
      children: <Widget>[
        InkWell(
          onTap: () {
            int productIndex;
            Nav.route(
              context,
              ProductDetailPage(
                productId: model.product.products[index].productId,
                productQty: productIndex == null
                    ? 1.0
                    : bookOrderObj.productsInCart[productIndex].productQuantity,
              ),
            );
          },
          child: Container(
            width: Get.width / 2,
            margin: EdgeInsets.only(
              left: 16,
              top: 5,
              right: 12,
              bottom: 5,
            ),
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
                children: <Widget>[
                  Container(
                    child: Stack(
                      children: <Widget>[
                        Container(
                          width: 300,
                          height: 120,
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                            ),
                            child: model.product.products[index]
                                        .imagesize512X512.length !=
                                    0
                                ? Image(
                                    image: NetworkImage(model
                                        .product
                                        .products[index]
                                        .imagesize512X512
                                        .first),
                                  )
                                : Image.asset(
                                    'assets/images/productPlaceaHolderImage.png',
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.only(left: 10, top: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        AutoSizeText(
                          model.product.products[index].productName ?? '',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Color(0xFF5D6A78),
                            fontWeight: FontWeight.w300,
                          ),
                          maxLines: 2,
                          minFontSize: 11,
                        ),
                        SizedBox(height: 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: 17),
                                Text(
                                  "$currencySymbol ${model.product.products[index].ppPrice.toStringAsFixed(2) ?? 0}",
                                  style: GoogleFonts.poppins(
                                    color: themeColor.getColor(),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
