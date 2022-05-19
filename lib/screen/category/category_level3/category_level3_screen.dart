import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shoppingapp/app_url_name_companyid.dart';
import 'package:shoppingapp/main.dart';
import 'package:shoppingapp/models/BookOrderModel.dart';
import 'package:shoppingapp/models/GlobalModelClass.dart';
import 'package:shoppingapp/models/LoginModelClass.dart';
import 'package:shoppingapp/screen/auth_screens/login/login_form.dart';
import 'package:shoppingapp/screen/drawer/drawer.dart';
import 'package:shoppingapp/screen/product_detail/product_detail_page.dart';
import 'package:shoppingapp/utils/commons/colors.dart';
import 'package:shoppingapp/utils/constants/constants_app_variables.dart';
import 'package:shoppingapp/utils/dummy_data/category.dart';
import 'package:shoppingapp/utils/navigator.dart';
import 'package:shoppingapp/utils/theme_notifier.dart';
import 'package:shoppingapp/utils/vertical_tab/vertical_tab.dart';
import 'package:shoppingapp/widgets/commons/full_screen_loader.dart';
import 'package:shoppingapp/widgets/commons/string_res.dart';

class CategoryLevel3Page extends StatefulWidget {
  @override
  _CategoryLevel3PageState createState() => _CategoryLevel3PageState();
}

class _CategoryLevel3PageState extends State<CategoryLevel3Page> {
  final searchController = TextEditingController();
  String categoryName = 'Category';
  int tabSelectedProductId = 0;
  List searchDataList = [];
  List productCategories = [];
  bool allApiCall = true;
  bool isShow = false;
  int cartListIndex = 0;
  bool change = false;
  bool addToCart = false;
  int selectedIndex = 0;
  var currrentIndex;

  @override
  void initState() {
    super.initState();
    if (subCategoriesImages.length == 0) {
      getCategoriesFromServer();
    } else {
      allApiCall = false;
      setState(() {});
    }
  }

  searchDataFunction(String searchKeyWord) {
    searchDataList.clear();
    for (var i = 0;
        i < subCategoriesImages[tabSelectedProductId]['products'].length;
        i++) {
      if (subCategoriesImages[tabSelectedProductId]['products'][i]
              ['product_name']
          .toString()
          .toLowerCase()
          .contains(searchKeyWord)) {
        searchDataList
            .add(subCategoriesImages[tabSelectedProductId]['products'][i]);
      }
      setState(() {});
    }
  }

  void getCategoriesFromServer() async {
    String loggedInUserId = LoginModelClass.loginModelObj
        .getValueForKeyFromLoginResponse(key: 'user_id');

    http.Response resp = await http.get(
        Uri.parse(Base_URL + getCompanyCategories + '&logged_in_userid=$loggedInUserId'));

    setState(() {});
    if (resp.statusCode == 200) {
      var jsonBodyResp = jsonDecode(resp.body);
      print(jsonBodyResp);
      if (jsonBodyResp['status'] == true) {
        productCategories = jsonBodyResp['categories'];
        categories.clear();
        subCategoriesImages.clear();
        for (var i = 0; i < productCategories.length; i++) {
          categories.add(productCategories[i]);

          // =========    For get product list for category list
          String loggedInUserId = LoginModelClass.loginModelObj
              .getValueForKeyFromLoginResponse(key: 'user_id');

          http.Response resp = await http.get(
              Uri.parse(Base_URL +
                  productsList +
                  '&logged_in_userid=$loggedInUserId&category_id=${productCategories[i]['product_cat_id']}&brand_id&price_min&price_max&sort_by&limit=50&page=1'),
              headers: {
                'Authorization': LoginModelClass.loginModelObj
                    .getValueForKeyFromLoginResponse(key: 'token'),
                'Content-Type': 'application/json',
                'Accept': 'application/json',
              });

          bookOrderObj.showLoadingIndicator = false;
          setState(() {});
          if (resp.statusCode == 200) {
            print(resp.statusCode);
            var jsonBodyResp = jsonDecode(resp.body);

            if (jsonBodyResp['status'] == true) {
              subCategoriesImages.add(jsonBodyResp);
              // productListArray =
              //     (productListArray ?? []) + jsonBodyResp['products'];

              // print('Getting products' + productListArray.length.toString());
              // productsPageNumber++;

              // totalPages = jsonBodyResp['total_pages'];
              // if (jsonBodyResp['total_pages'] > pageNumber) {
              //   getProductsFromServer(pageNumber++);
              // }
            } else {
              //handle false conditions
            }
          } else {
            print('Error occurred while serving request');
          }
        }

        print(categories.length);
      } else {
        //handle false conditions
      }
      bookOrderObj.showLoadingIndicator = false;
    } else {
      print('Error occurred while serving request');
    }
    bookOrderObj.showLoadingIndicator = false;
    allApiCall = false;
    setState(() {});
  }

  void refreshView() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<ThemeNotifier>(context);
    print("Current page --> $runtimeType");
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 252, 252, 252),
          actions: <Widget>[AppBarUpdate(themeColor: themeColor)],
          iconTheme: IconThemeData(color: themeColor.getColor()),
          title: Text(
            categoryName,
            style: GoogleFonts.poppins(
              fontSize: 20,
              color: themeColor.getColor(),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        drawer: CustomDrawer(),
        backgroundColor: greyBackground,
        body: allApiCall
            ? Center(child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(themeColor.getColor())))
            : Container(
                height: Get.height,
                child: Column(
                  children: [
                    // Container(
                    //   width: Get.width * 0.9,
                    //   margin: EdgeInsets.only(left: 5, top: 14),
                    //   padding: EdgeInsets.only(left: 18, right: 18),
                    //   height: 44,
                    //   decoration: BoxDecoration(
                    //     boxShadow: [
                    //       BoxShadow(
                    //         color: Colors.grey[200],
                    //         blurRadius: 8.0,
                    //         spreadRadius: 1,
                    //         offset: Offset(0.0, 3),
                    //       )
                    //     ],
                    //     color: Theme.of(context).bottomAppBarColor,
                    //     borderRadius: BorderRadius.circular(24),
                    //   ),
                    //   child: Row(
                    //     children: <Widget>[
                    //       SvgPicture.asset(
                    //         "assets/icons/ic_search.svg",
                    //         color: Colors.black45,
                    //         height: 12,
                    //       ),
                    //       SizedBox(width: 8),
                    //       Expanded(
                    //         child: Container(
                    //           padding: EdgeInsets.only(bottom: 4),
                    //           height: 72,
                    //           child: TextFormField(
                    //             controller: searchController,
                    //             key: _formKey,
                    //             decoration: InputDecoration(
                    //               border: InputBorder.none,
                    //               hintText: Strings.searchpro,
                    //               hintStyle: GoogleFonts.poppins(
                    //                 fontSize: 13,
                    //                 color: Color(0xFF5D6A78),
                    //                 fontWeight: FontWeight.w400,
                    //               ),
                    //             ),
                    //             onChanged: (searchText) {
                    //               searchDataFunction(searchText.toLowerCase());
                    //               //Search products here from category
                    //             },
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // SizedBox(height: 5),
                    Expanded(
                      child: VerticalTabs(
                        indicatorColor: themeColor.getColor(),
                        selectedTabBackgroundColor: whiteColor,
                        tabBackgroundColor: themeColor.getColor(),
                        backgroundColor: greyBackground,
                        direction: TextDirection.rtl,
                        tabsWidth: 48,
                        onSelect: (int i) {
                          tabSelectedProductId = i;
                          print("Hello");
                          print(categories[i]['product_cat_name']);
                          categoryName =
                              categories[i]['product_cat_name'].toString();
                          searchController.clear();
                          searchDataList.clear();
                          Future.delayed(Duration.zero, () async {
                            setState(() {});
                          });
                        },
                        tabsTitle: categories
                            .map((e) => e['product_cat_name'].toString())
                            .toList(),
                        tabs: categories
                            .map(
                              (e) => Tab(
                                  child: RotatedBox(
                                    quarterTurns: 1,
                                    child: RichText(
                                      text: TextSpan(
                                        text: 'Flutter',
                                        style: DefaultTextStyle.of(context)
                                            .style
                                            .copyWith(),
                                      ),
                                    ),
                                  ),
                                  icon: Icon(Icons.phone)),
                            )
                            .toList(),
                        contents: categories
                            .map((e) => tabsContent(themeColor))
                            .toList(),
                      ),
                    ),
                  ],
                )),
      ),
    );
  }

  // Widget tabsContent(ThemeNotifier themeColor, String caption,[String description = ''])
  Widget tabsContent(ThemeNotifier themeColor) {
    return Container(
      padding: EdgeInsets.only(left: 5, right: 5),
      color: greyBackground,
      child: expansionTile(themeColor),
      // child: ListView.builder(
      //   itemCount: subCategories.length,
      //   itemBuilder: (context, index) {
      //     return expansionTile(themeColor);
      //   },
      // ),
    );
  }

  Widget expansionTile(themeColor) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          InkWell(
            onTap: (){
              isShow = !isShow;
              setState(() {});
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(isShow ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
                Text("Tv,Audio/Video",style: GoogleFonts.poppins(),),
              ],
            ),
          ),
          isShow ? ListView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              GridView.count(
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                childAspectRatio: 0.92,
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                children: List.generate(
                    searchDataList.length == 0
                        ? subCategoriesImages[tabSelectedProductId]['products'].length
                        : searchDataList.length, (index) {
                  for (var i = 0; i < bookOrderObj.productsInCart.length; i++) {
                    if (bookOrderObj.productsInCart[i].productID == subCategoriesImages[tabSelectedProductId]['products'][index]['product_id'].toString()) {
                      cartListIndex = i;
                      change = true;
                    }
                  }
                  return searchDataList.length == 0
                      ? productData(index,themeColor,context)
                      : searchProductData(index,themeColor);
                }),
              )
            ],
          ) :SizedBox(),
        ],
      ),
    );
  }

  Widget productData(int index,themeColor,context) {
    return Center(
      child: InkWell(
        onTap: () async {
          int productIndex;
          // setState(() {
          //   count = bookOrderObj.productsInCart[selectedIndex].productQuantity;
          //   // bookOrderObj.addSelectedProductInCart(null);
          // });
          for (var i = 0; i < bookOrderObj.productsInCart.length; i++) {
            if (bookOrderObj.productsInCart[i].productID ==
                subCategoriesImages[tabSelectedProductId]['products'][index]['product_id'].toString()) {
              productIndex = i;
            }
          }

          var data = await Get.to(() => ProductDetailPage(
                productId: subCategoriesImages[tabSelectedProductId]['products']
                    [index]['product_id'],
                productQty: productIndex == null
                    ? 1.0
                    : bookOrderObj.productsInCart[productIndex].productQuantity,
              ));
          setState(() {});
        },
        child: Container(
          width: Get.width * 0.42,
          height: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ClipRRect(
                child: subCategoriesImages[tabSelectedProductId]['products']
                                [index]['imagesize512x512']
                            .length !=
                        0
                    ? subCategoriesImages[tabSelectedProductId]['products']
                                [index]['imagesize512x512'][0]
                            .toString()
                            .isNotEmpty
                        ? Image.network(
                            subCategoriesImages[tabSelectedProductId]
                                    ['products'][index]['imagesize512x512'][0]
                                .toString(),
                            height: 80,
                            width: 110,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            'assets/images/productPlaceaHolderImage.png',
                            height: 80,
                            width: 110,
                          )
                    : Image.asset(
                        'assets/images/productPlaceaHolderImage.png',
                        height: 80,
                        width: 110,
                      ),
              ),
              SizedBox(height: 5),
              Center(
                child: Text(
                  subCategoriesImages[tabSelectedProductId]['products'][index]
                      ['product_name'],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Color(0xFF5D6A78),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(height: 5,),
              Center(
                child: Container(
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
                          .toString() == subCategoriesImages[tabSelectedProductId]['products']
                      [index]['product_id'].toString()
                          ? addQuentityWidgetRow(
                          cartListIndex, themeColor, context)
                          : addToCartBtnWidget(index, themeColor, context)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget searchProductData(int index,themeColor) {
    return Center(
      child: InkWell(
        onTap: () {
          Nav.route(
              context,
              ProductDetailPage(
                productId: searchDataList[index]['product_id'],
              ));
        },
        child: Container(
          width: Get.width * 0.4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ClipRRect(
                child: searchDataList[index]['imagesize512x512'][0]
                        .toString()
                        .isNotEmpty
                    ? Image.network(
                        searchDataList[index]['imagesize512x512'][0].toString(),
                        height: 110,
                        width: 110,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        'assets/images/productPlaceaHolderImage.png',
                        height: 110,
                        width: 110,
                      ),
              ),
              SizedBox(height: 5),
              Center(
                child: Text(
                  searchDataList[index]['product_name'],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Color(0xFF5D6A78),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  // ------------------------       THIS WIDGET FOR ADD OR REMOVE QUENTITY      ----------------

  Widget addQuentityWidgetRow(
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
                    });
                  },
                  child: Text(
                    "-",
                    style: TextStyle(fontSize: 24, color:showMBPrimaryColor ?millBornPrimaryColor : Colors.white),
                  ),
                ),
                SizedBox(width: 9),
                Container(
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
                          color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      bookOrderObj
                          .productsInCart[selectedIndex].productQuantity++;
                      bookOrderObj.addSelectedProductInCart(null);
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

  // ------------------------       THIS WIDGET FOR ADD PRODUCT IN CART     ----------------

  Widget addToCartBtnWidget(
      int index, ThemeNotifier themeColor, BuildContext context) {
    return InkWell(
      onTap: () {
        Loader().showLoader(context);
        addToCart = true;
        getProductDetailsAndAddToCart(
            context, subCategoriesImages[tabSelectedProductId]['products']
        [index]['product_id'].toString());
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

  // ------------------------       THIS WIDGET FOR SHOW ADD PRODUCT IN CART BTN WHEN API CALLING      ----------------

  void getProductDetailsAndAddToCart(
      BuildContext context, String selectedProductID) async {
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

              Loader().hideLoader(context);
              setState(() {});

              if (bookOrderObj.selectedProduct['type'] == 'Variant') {
                variantsBottomSheet(
                  tempProduct,
                      (value) {
                    isAdded = value;
                    Scaffold.of(context).setState(
                          () {
                        // ignore: deprecated_member_use
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor:tempName == "MILLBORN-Jaipur" ? millBornPrimaryThemeColor :  main,
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
                      backgroundColor:tempName == "MILLBORN-Jaipur" ? millBornPrimaryThemeColor :  mainC,
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

  void variantsBottomSheet(OrderedProduct productData,
      Function addedCartFunction, String selectedProductID) {
    OrderedProduct tempProduct = bookOrderObj.getProductDetailsObject(
      selectedVarientId: bookOrderObj.selectedProduct,
      productID: selectedProductID,
      callType: 1,
      variantIndex: selectedIndex,
      isVariantAvailable: true,
    );
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(width: Get.width * 0.6),
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
                                  setState(() {
                                    if (tempProduct.minQuantity <
                                        tempProduct.productQuantity) {
                                      tempProduct.productQuantity--;
                                    }
                                    bookOrderObj.addSelectedProductInCart(null);
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 16.0),
                                  child: Text(
                                    "-",
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: showMBPrimaryColor ?millBornPrimaryColor :Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(0xFF707070),
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 40,
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '${(tempProduct?.productQuantity ?? 1.0).toInt()}',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    tempProduct.productQuantity++;
                                    bookOrderObj.addSelectedProductInCart(null);
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
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
