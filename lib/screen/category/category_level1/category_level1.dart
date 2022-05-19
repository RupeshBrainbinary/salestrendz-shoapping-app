import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:shoppingapp/app_url_name_companyid.dart';
import 'package:shoppingapp/models/BookOrderModel.dart';
import 'package:shoppingapp/models/GlobalModelClass.dart';
import 'package:shoppingapp/models/LoginModelClass.dart';
import 'package:shoppingapp/screen/auth_screens/login/login_form.dart';
import 'package:shoppingapp/screen/category/category_level1/category1_model.dart';
import 'package:shoppingapp/screen/drawer/drawer.dart';
import 'package:shoppingapp/screen/product_detail/product_detail_page.dart';
import 'package:shoppingapp/utils/commons/colors.dart';
import 'package:shoppingapp/utils/commons/export_basic_file.dart';
import 'package:shoppingapp/utils/constants/constants_app_variables.dart';
import 'package:shoppingapp/utils/theme_notifier.dart';
import 'package:shoppingapp/widgets/commons/custom_alert.dart';
import 'package:shoppingapp/widgets/commons/full_screen_loader.dart';
import 'package:shoppingapp/widgets/commons/string_res.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shoppingapp/screen/cart_screen/shopping_cart_page.dart'
    as prefix;

class CategoryLevel1 extends StatefulWidget {
  @override
  CategoryLevel1State createState() => CategoryLevel1State();
}

class CategoryLevel1State extends State<CategoryLevel1> {
  Category1FavoriteViewModel model;

  bool isShow = false;
  bool isShowSubCat = false;
  bool search = false;
  int counter = 0;
  int counter1 = 0;

  String categoryName = Strings.shopbycategory;
  String priceListName;
  int selectedIndex = 0;
  String selectedCatId = "";
  List<dynamic> categories = [];
  List<dynamic> catProduct = [];
  List<dynamic> subCategories = [];
  List<dynamic> subSubCategories = [];
  bool showSubCat = false;
  bool showSubSubCat = false;
  var currrentIndex;
  bool categoryLevel2 = false;

  int cartListIndex = 0;
  bool categoryEmpty = false;
  final searchController = TextEditingController();

  ScrollController controller;
  bool isPaging = false;
  int initPosition = 0;
  int page = 1;
  bool canPaging = true;
  int productPageLength = 0;

  bool allApiCall = true;

  var versionCode;
  var forceUpdate;
  var alertDialog;
  String version;
  String buildNumber;

  List<TextEditingController> qtyController = [];
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (GlobalModelClass.internetConnectionAvaiable() != true) {
      if (alertDialog == null) {
        Future.delayed(Duration.zero, () {
          alertDialog = GlobalModelClass.showAlertForNoInternetConnection(
              context, refreshView);
          alertDialog.show();
        });
      }
    }
    initPackageInfo();
    controller = new ScrollController()..addListener(_scrollListener);
    if (categories.length == 0) {
      getCategoriesFromServer();
    } else {
      allApiCall = false;
      setState(() {});
    }
  }

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (controller.position.extentAfter < 100) {
      if (canPaging && !isPaging) {
        print("Hello1");
        setState(() {
          isPaging = true;
        });
        page++;
        Loader().showLoader(context);
        getProductFromServer(selectedCatId, searchController.text.trim(), page);
        Loader().hideLoader(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_statements
    model ?? (model = Category1FavoriteViewModel(this));

    final themeColor = Provider.of<ThemeNotifier>(context);
    print("Current page --> $runtimeType");
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 252, 252, 252),
          iconTheme: IconThemeData(color: themeColor.getColor()),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoSizeText(
                categoryName ?? "Product By Category",
                maxLines: 1,
                minFontSize: 7,
                maxFontSize: 18,
                style: GoogleFonts.poppins(
                  color: themeColor.getColor(),
                  fontWeight: FontWeight.w600,
                ),
              ),
              AutoSizeText(
                priceListName ?? "",
                maxLines: 1,
                minFontSize: 5,
                maxFontSize: 13,
                style: GoogleFonts.poppins(
                  color: themeColor.getColor(),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          actions: [
            Container(
              margin: EdgeInsets.only(bottom: 8),
              child: InkWell(
                onTap: () {
                  if (!categoryLevel2) {
                    if (search == true) {
                      search = false;
                    } else {
                      search = true;
                    }
                  }
                  setState(() {});
                },
                child: Icon(Icons.search),
              ),
            ),
            SizedBox(width: 17),
            Padding(
              padding: EdgeInsets.only(right: 16, top: 8),
              child: InkWell(
                onTap: () async {
                  isShow = false;
                  searchController.clear();
                  search = false;
                  var data = await Get.to(
                    () => prefix.ShoppingCartPage(showBackArrow: true),
                  );
                  setState(() {
                    allApiCall = true;
                    getCategoriesFromServer();
                  });
                },
                child: Badge(
                  badgeColor: Color(0xFF5D6A78),
                  alignment: Alignment(-0.5, -1.0),
                  padding: EdgeInsets.all(4),
                  badgeContent: Text(
                    '${BookOrderModel.orderModelObj.productsInCart?.length ?? 0}',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                  child: SvgPicture.asset(
                    "assets/icons/ic_shopping_cart.svg",
                    color: themeColor.getColor(),
                    height: 26,
                  ),
                ),
              ),
            )
            // AppBarUpdate(themeColor: themeColor)
          ],
        ),
        drawer: CustomDrawer(),
        body: allApiCall
            ? Center(
                child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(themeColor.getColor()),
              ))
            : categoryEmpty
                ? Container(
                    height: Get.height * 0.8,
                    child: Center(
                      child: Text(
                        "Category Not Found",
                        style: GoogleFonts.poppins(
                          fontSize: 25,
                          color: Colors.grey[500],
                        ),
                      ),
                    ),
                  )
                : Column(
                    children: [
                      !isShow ? categoryList() : Container(height: 0),
                      Expanded(
                        child: Stack(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: !isShow ? Get.width : Get.width - 50,
                                  child: categories != null
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            search != true
                                                ? SizedBox()
                                                : searchBar(),
                                            search != true
                                                ? SizedBox()
                                                : Divider(thickness: 1),
                                            categoryLevel2
                                                ? photoListView()
                                                : catProduct.isNotEmpty ||
                                                        catProduct.length != 0
                                                    ? productList(themeColor)
                                                    : SingleChildScrollView(
                                                        child: Container(
                                                          height:
                                                              Get.height * 0.5,
                                                          child: Center(
                                                            child: Text(
                                                              "",
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                fontSize: 25,
                                                                color: Colors
                                                                    .grey[500],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    /* catProduct.isNotEmpty
                                                ? !isShowSubCat ? productList(themeColor) :  photoListView()
                                                : Container(
                                                    height:
                                                        Get.height * 0.8,
                                                    child: Center(
                                                      child: Text(
                                                        "Product Not Found",
                                                        style: GoogleFonts
                                                            .poppins(
                                                          fontSize: 25,
                                                          color: Colors
                                                              .grey[500],
                                                        ),
                                                      ),
                                                    ),
                                                  )*/
                                          ],
                                        )
                                      : Container(
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
                                        ),
                                ),
                                isShow
                                    ? Expanded(
                                        child: categoryTab(themeColor, context),
                                      )
                                    : SizedBox()
                              ],
                            ),
                            !isShow
                                ? Align(
                                    alignment: Alignment.topRight,
                                    child: InkWell(
                                      onTap: () {
                                        isShow = true;
                                        setState(() {});
                                      },
                                      child: Container(
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(30.0),
                                            bottomLeft: Radius.circular(30.0),
                                          ),
                                          color: themeColor.getColor(),
                                        ),
                                        child: Center(
                                          child: Image.asset(
                                            "assets/icons/double-arrows.png",
                                            height: 12,
                                            width: 12,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : SizedBox()
                          ],
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }

  searchBar() {
    return Container(
      width: isShow ? Get.width * 0.78 : Get.width * 0.85,
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
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: Strings.searchpro,
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Color(0xFF5D6A78),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                onChanged: (searchText) async {
                  // Loader().showLoader(context);
                  page = 0;
                  productPageLength = 0;
                  canPaging = true;
                  isPaging = false;
                  catProduct = [];
                  selectedCatId = "";
                  await getProductFromServer(
                      selectedCatId, searchController.text.trim(), page);
                  // Loader().hideLoader(context);
                },
                onEditingComplete: () async {},
              ),
            ),
          ),
          searchController.text.length > 0
              ? InkWell(
                  onTap: () async {
                    searchController.clear();
                    Loader().showLoader(context);
                    page = 1;
                    productPageLength = 0;
                    catProduct = [];
                    getProductFromServer(
                        selectedCatId, searchController.text.trim(), page);
                    Loader().hideLoader(context);
                    setState(() {});
                  },
                  child: Icon(Icons.close),
                )
              : SizedBox()
        ],
      ),
    );
  }

  productList(themeColor) {
    return Expanded(
      child: Container(
        child: ListView.builder(
          shrinkWrap: true,
          controller: controller,
          // physics: NeverScrollableScrollPhysics(),
          itemCount: catProduct.isNotEmpty ? catProduct.length : 0,
          itemBuilder: (BuildContext context, int index) {
            List<Map<String, dynamic>> variantList = [];
            // saved_percentage
            qtyController = [];
            List.generate(catProduct.length,
                (index) => qtyController.add(TextEditingController()));

            for (var i = 0; i < bookOrderObj.productsInCart.length; i++) {
              for (int j = 0;
                  j < catProduct[index]['product_variants'].length;
                  j++) {
                if (catProduct[index]['product_variants'][j].toString() ==
                    {
                      "product_variant_id":
                          bookOrderObj.productsInCart[i].productVariantID
                    }.toString()) {
                  variantList.add({
                    "variantName": bookOrderObj.productsInCart[i].variantName,
                    "quantity": bookOrderObj.productsInCart[i].productQuantity
                  });
                  if (catProduct[index]['selectedvariant'] == null) {
                    catProduct[index]['selectedvariant'] = {
                      "variantName": bookOrderObj.productsInCart[i].variantName,
                      "quantity": bookOrderObj.productsInCart[i].productQuantity
                    };
                  }
                }
              }
            }

            for (var i = 0; i < bookOrderObj.productsInCart.length; i++) {
              if (catProduct[index]['product_id'].toString() ==
                  bookOrderObj.productsInCart[i].productID) {
                cartListIndex = i;
                if (catProduct[index]['selectedvariant'] != null) {
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
            }

            return Row(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 5),
                  width: !isShow ? Get.width : Get.width - 50,
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () async {
                          int productIndex;
                          for (var i = 0;
                              i < bookOrderObj.productsInCart.length;
                              i++) {
                            if (bookOrderObj.productsInCart[i].productID ==
                                catProduct[index]['product_id'].toString()) {
                              productIndex = i;
                            }
                          }
                          print(selectedIndex);
                          isShow = false;
                          var data = await Get.to(
                            () => ProductDetailPage(
                              productId: catProduct[index]['product_id'],
                              productQty: productIndex == null
                                  ? appName == "MILLBORN-Jaipur"
                                      ? 3.0
                                      : 1.0
                                  : bookOrderObj.productsInCart[productIndex]
                                      .productQuantity,
                            ),
                          );

                          setState(() {
                            allApiCall = true;
                            getCategoriesFromServer();
                          });
                        },
                        child: Container(
                          width: !isShow ? Get.width : Get.width - 50,
                          child: Stack(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(children: [
                                    Container(
                                        margin:
                                            EdgeInsets.only(top: 10, right: 5),
                                        width: Get.width * 0.29,
                                        child: catProduct != null &&
                                                catProduct.isNotEmpty
                                            ? ClipRRect(
                                                child: catProduct[
                                                                    index][
                                                                'imagesize512x512'] !=
                                                            null &&
                                                        !(catProduct[index][
                                                                'imagesize512x512']
                                                            is bool) &&
                                                        catProduct[index][
                                                                    'imagesize512x512']
                                                                .length !=
                                                            0
                                                    ? catProduct[index][
                                                                'imagesize512x512'][0]
                                                            .toString()
                                                            .isNotEmpty
                                                        ? Image.network(
                                                            catProduct[index][
                                                                    'imagesize512x512'][0]
                                                                .toString(),
                                                            height: Get.height *
                                                                0.15,
                                                            width:
                                                                Get.width * 0.1,
                                                          )
                                                        : Image.asset(
                                                            'assets/images/productPlaceaHolderImage.png',
                                                            height: Get.height *
                                                                0.15,
                                                            width:
                                                                Get.width * 0.1,
                                                          )
                                                    : Image.asset(
                                                        'assets/images/productPlaceaHolderImage.png',
                                                        height:
                                                            Get.height * 0.13,
                                                        width: Get.width * 0.1,
                                                      ),
                                              )
                                            : SizedBox()),
                                  ]),
                                  Container(
                                    width: !isShow
                                        ? Get.width * 0.66
                                        : Get.width * 0.54,
                                    child: Column(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  width: !isShow
                                                      ? Get.width * 0.52
                                                      : Get.width * 0.42,
                                                  child: Text(
                                                    catProduct[index]
                                                            ['product_name'] ??
                                                        "",
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: Get.width * 0.09,
                                                  child: InkWell(
                                                    onTap: () {
                                                      if (catProduct[index][
                                                              'isin_wishlist'] ==
                                                          'active') {
                                                        model.getFavoriteApi(
                                                            productId: catProduct[
                                                                        index][
                                                                    'product_id']
                                                                .toString(),
                                                            wishListId: catProduct[
                                                                            index]
                                                                        [
                                                                        'wishlist']
                                                                    [
                                                                    'wishlist_id']
                                                                .toString(),
                                                            wishListStatus:
                                                                'inactive');
                                                        setState(() {
                                                          catProduct[index][
                                                                  'isin_wishlist'] =
                                                              'inactive';
                                                        });
                                                        // ignore: deprecated_member_use
                                                        Scaffold.of(context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                              backgroundColor:
                                                                  appName ==
                                                                          "MILLBORN-Jaipur"
                                                                      ? millBornPrimaryThemeColor
                                                                      : mainC,
                                                              duration:
                                                                  Duration(
                                                                      seconds:
                                                                          1),
                                                              content: Text(Strings
                                                                  .removetosts)),
                                                        );
                                                        setState(() {});
                                                      } else {
                                                        model.getFavoriteApi(
                                                            productId: catProduct[
                                                                        index][
                                                                    'product_id']
                                                                .toString(),
                                                            wishListId: 'new',
                                                            wishListStatus:
                                                                'active');
                                                        setState(() {
                                                          catProduct[index][
                                                                  'isin_wishlist'] =
                                                              'active';
                                                        });
                                                        // ignore: deprecated_member_use
                                                        Scaffold.of(context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                              backgroundColor: appName ==
                                                                      "MILLBORN-Jaipur"
                                                                  ? millBornPrimaryThemeColor
                                                                  : mainColor,
                                                              duration:
                                                                  Duration(
                                                                      seconds:
                                                                          1),
                                                              content: Text(Strings
                                                                  .addedtosts)),
                                                        );
                                                        setState(() {});
                                                      }
                                                    },
                                                    child: Icon(
                                                      Icons.favorite,
                                                      color: catProduct[index][
                                                                  'isin_wishlist'] ==
                                                              'active'
                                                          ? Colors.red
                                                          : Colors.black,
                                                      size: 30,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            // Align(alignment: Alignment.centerRight,
                                            //   child: Padding(
                                            //     padding: const EdgeInsets.only(right: 20.0,bottom: 2,top: 5),
                                            //     // padding: const EdgeInsets.all(8.0),
                                            //     child: Text(
                                            //       "",
                                            //       style: TextStyle(fontWeight: FontWeight.bold),
                                            //     ),
                                            //   ),
                                            // ),
                                            catProduct[index]["qty_in_cases"] ==
                                                        0 ||
                                                    catProduct[index]
                                                            ["qty_in_cases"] ==
                                                        null ||
                                                    catProduct[index]
                                                            ["qty_in_cases"] ==
                                                        "null"
                                                ? SizedBox()
                                                : Text(
                                                    '${Strings.Quantityincase} ${catProduct[index]["qty_in_cases"]}',
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.grey,
                                                      // decoration:
                                                      // TextDecoration.lineThrough,
                                                    ),
                                                  ),
                                          ],
                                        ),
                                        Container(
                                          width: Get.width * 0.7,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              catProduct[index]['min_qty'] ==
                                                          null ||
                                                      catProduct[index]
                                                              ['min_qty'] ==
                                                          0
                                                  ? SizedBox()
                                                  : Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Flexible(
                                                          child: Text(
                                                            Strings.MinQty +
                                                                ":",
                                                            style: GoogleFonts
                                                                .poppins(
                                                              color: showMBPrimaryColor
                                                                  ? millBornPrimaryColor
                                                                  : themeColor
                                                                      .getColor(),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        ),
                                                        Flexible(
                                                          child: Text(
                                                            catProduct[index][
                                                                        'min_qty'] !=
                                                                    null
                                                                ? "${catProduct[index]['min_qty'].toString()}" +
                                                                    " "
                                                                : " 0 ",
                                                            style: GoogleFonts
                                                                .poppins(
                                                              color: showMBPrimaryColor
                                                                  ? millBornPrimaryColor
                                                                  : themeColor
                                                                      .getColor(),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        catProduct[index]['pp_mrp'] == null
                                            ? SizedBox()
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Flexible(
                                                    child: Text(
                                                      tempName ==
                                                              "MILLBORN-Jaipur"
                                                          ? "List Price:"
                                                          : "MRP:",
                                                      // Strings.base_rate,
                                                      style:
                                                          GoogleFonts.poppins(
                                                              color:
                                                                  Colors.grey),
                                                    ),
                                                  ),
                                                  Flexible(
                                                    child: Text(
                                                      catProduct[index]
                                                                  ['pp_mrp'] !=
                                                              null
                                                          ? " ₹ ${catProduct[index]['pp_mrp'].toStringAsFixed(2).toString()}"
                                                          : " ₹ 0.0",
                                                      style:
                                                          GoogleFonts.poppins(
                                                        color: Colors.grey,
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                        catProduct[index]['pp_price'] == null
                                            ? SizedBox()
                                            : Container(
                                                width: Get.width,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Flexible(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                            appName == "Q-ONE"
                                                                ? 'S.P'
                                                                : "D.P",
                                                            // Strings.Price,
                                                            style: GoogleFonts
                                                                .poppins(
                                                              color: showMBPrimaryColor
                                                                  ? millBornPrimaryColor
                                                                  : themeColor
                                                                      .getColor(),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                          Text(
                                                            catProduct[index][
                                                                        'pp_price'] !=
                                                                    null
                                                                ? " ₹ ${catProduct[index]['pp_price'].toStringAsFixed(2).toString()}"
                                                                : " ₹ 0.0",
                                                            style: GoogleFonts
                                                                .poppins(
                                                              color: showMBPrimaryColor
                                                                  ? millBornPrimaryColor
                                                                  : themeColor
                                                                      .getColor(),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                          Text(
                                                            catProduct[index][
                                                                        'unit_of_measurement'] !=
                                                                    null
                                                                ? " / " +
                                                                    catProduct[
                                                                            index]
                                                                        [
                                                                        'unit_of_measurement']
                                                                : " ",
                                                            style: GoogleFonts
                                                                .poppins(
                                                              color: showMBPrimaryColor
                                                                  ? millBornPrimaryColor
                                                                  : themeColor
                                                                      .getColor(),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                        /*Container(
                                          alignment: Alignment.centerRight,
                                          child: GestureDetector(
                                            onTap: () {
                                              openDialog(
                                                context,
                                                offer: catProduct[index]
                                                        ['scheme_on_product']
                                                    .map<String>(
                                                        (e) => e['name'].toString())
                                                    .toList(),
                                                startTime: catProduct[index]
                                                        ['scheme_on_product']
                                                    .map<String>((e) =>
                                                        e['start_date'].toString())
                                                    .toList(),
                                                endTime: catProduct[index]
                                                        ['scheme_on_product']
                                                    .map<String>((e) =>
                                                        e['end_date'].toString())
                                                    .toList(),
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
                                                style:
                                                    TextStyle(color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),*/
                                        catProduct[index]['saved_percentage'] ==
                                                    0 ||
                                                catProduct[index]
                                                        ['saved_percentage'] ==
                                                    null
                                            ? SizedBox()
                                            : Container(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      Strings.discount_rate,
                                                      style:
                                                          GoogleFonts.poppins(
                                                              color:
                                                                  Colors.grey),
                                                    ),
                                                    Text(
                                                      '₹' +
                                                          '${(catProduct[index]['pp_mrp'] - catProduct[index]['pp_price']).toStringAsFixed(2)}' +
                                                          ' (${catProduct[index]['saved_percentage'].toStringAsFixed(2)}%)',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              catProduct[index]['scheme_on_product']
                                      .map<String>((e) => e['name'].toString())
                                      .toList()
                                      .isEmpty
                                  ? SizedBox()
                                  : Positioned(
                                      left: 8,
                                      top: 9.5,
                                      child: Container(
                                        alignment: Alignment.centerRight,
                                        child: GestureDetector(
                                          onTap: () {
                                            openDialog(
                                              context,
                                              offer: catProduct[index]
                                                      ['scheme_on_product']
                                                  .map<String>((e) =>
                                                      e['name'].toString())
                                                  .toList(),
                                              startTime: catProduct[index]
                                                      ['scheme_on_product']
                                                  .map<String>((e) =>
                                                      e['start_date']
                                                          .toString())
                                                  .toList(),
                                              endTime: catProduct[index]
                                                      ['scheme_on_product']
                                                  .map<String>((e) =>
                                                      e['end_date'].toString())
                                                  .toList(),
                                            );
                                          },
                                          child: Container(
                                            height: 30,
                                            width: 60,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: themeColor.getColor(),
                                              //border: Border.all(width: 2)
                                            ),
                                            child: Text(
                                              "Offer",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 2),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(width: 1),
                            variantList.isEmpty
                                ? Text("")
                                : Container(
                                    child: InkWell(
                                    onTap: () async {
                                      var res =
                                          await bottomSheet(variantList, index);
                                      if (res != null) {
                                        catProduct[index]['selectedvariant'] =
                                            res;
                                        print(res);
                                      }
                                      setState(() {});
                                    },
                                    child: catProduct[index]['selectedvariant']
                                                        ['variantName']
                                                    .toString() ==
                                                null ||
                                            catProduct[index]['selectedvariant']
                                                    ['variantName']
                                                .toString()
                                                .isEmpty ||
                                            catProduct[index]['selectedvariant']
                                                        ['variantName']
                                                    .toString() ==
                                                "null"
                                        ? SizedBox()
                                        : Container(
                                            padding: EdgeInsets.fromLTRB(
                                                15, 5, 8, 5),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              color: themeColor.getColor(),
                                            ),
                                            child: Row(
                                              children: [
                                                Text(
                                                  catProduct[index][
                                                              'selectedvariant'] !=
                                                          null
                                                      ? catProduct[index][
                                                                  'selectedvariant']
                                                              ['variantName']
                                                          .toString()
                                                      : "Variant",
                                                  style: GoogleFonts.poppins(
                                                      color: Colors.white),
                                                ),
                                                SizedBox(width: 5),
                                                Image.asset(
                                                  "assets/icons/drop-down.png",
                                                  height: 10,
                                                  width: 10,
                                                  color: Colors.white,
                                                )
                                              ],
                                            ),
                                          ),
                                  )),
                            // Container(
                            //   width: Get.width - 1,
                            //   child: Row(
                            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //     children: [
                            //       Container(
                            //         padding: EdgeInsets.only(left: 10),
                            //         child: Row(
                            //           mainAxisAlignment: MainAxisAlignment.start,
                            //           children: [
                            //             catProduct[index]
                            //                         ['unit_of_measurement'] ==
                            //                     null /*||
                            //                           catProduct[index][
                            //                           'unit_of_measurement'] ==
                            //                               0*/
                            //                 ? SizedBox()
                            //                 : Row(
                            //                     mainAxisSize: MainAxisSize.min,
                            //                     children: [
                            //                       Flexible(
                            //                         child: Text(
                            //                           "Product is sold in ",
                            //                           style: GoogleFonts.poppins(
                            //                               color: Colors.grey),
                            //                         ),
                            //                       ),
                            //                       Flexible(
                            //                         child: Text(
                            //                           catProduct[index][
                            //                                       'unit_of_measurement'] !=
                            //                                   null
                            //                               ? "${catProduct[index]['unit_of_measurement'].toString()}"
                            //                               : " ",
                            //                           style: GoogleFonts.poppins(
                            //                               color: Colors.grey),
                            //                         ),
                            //                       ),
                            //                     ],
                            //                   ),
                            //           ],
                            //         ),
                            //       ),
                            //       bookOrderObj.productsInCart.length == 0 ||
                            //               bookOrderObj.productsInCart.length - 1 <
                            //                   cartListIndex
                            //           ? addToCartBtnWidget(
                            //               index, themeColor, context)
                            //           : bookOrderObj.productsInCart[cartListIndex]
                            //                       .productID
                            //                       .toString() ==
                            //                   catProduct[index]['product_id']
                            //                       .toString()
                            //               ? addQuentityWidgetRow(
                            //                   index,
                            //                   cartListIndex,
                            //                   themeColor,
                            //                   context,
                            //                   catProduct[index]
                            //                               ['selectedvariant'] ==
                            //                           null
                            //                       ? null
                            //                       : catProduct[index]
                            //                           ['selectedvariant'])
                            //               : addToCartBtnWidget(
                            //                   index, themeColor, context),
                            //     ],
                            //   ),
                            // )
                          ],
                        ),
                      ),
                      Container(
                        width: Get.width - 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  catProduct[index]['unit_of_measurement'] ==
                                          null /*||
                                                    catProduct[index][
                                                    'unit_of_measurement'] ==
                                                        0*/
                                      ? SizedBox()
                                      : Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                "Product is sold in ",
                                                style: GoogleFonts.poppins(
                                                    color: Colors.grey),
                                              ),
                                            ),
                                            Flexible(
                                              child: Text(
                                                catProduct[index][
                                                            'unit_of_measurement'] !=
                                                        null
                                                    ? "${catProduct[index]['unit_of_measurement'].toString()}"
                                                    : " ",
                                                style: GoogleFonts.poppins(
                                                    color: Colors.grey),
                                              ),
                                            ),
                                          ],
                                        ),
                                ],
                              ),
                            ),
                            bookOrderObj.productsInCart.length == 0 ||
                                    bookOrderObj.productsInCart.length - 1 <
                                        cartListIndex
                                ? addToCartBtnWidget(index, themeColor, context)
                                : bookOrderObj.productsInCart[cartListIndex]
                                            .productID
                                            .toString() ==
                                        catProduct[index]['product_id']
                                            .toString()
                                    ? addQuentityWidgetRow(
                                        index,
                                        cartListIndex,
                                        themeColor,
                                        context,
                                        catProduct[index]['selectedvariant'] ==
                                                null
                                            ? null
                                            : catProduct[index]
                                                ['selectedvariant'])
                                    : addToCartBtnWidget(
                                        index, themeColor, context),
                          ],
                        ),
                      ),
                      Divider(thickness: 1)
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  categoryTab(themeColor, context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              height: Get.height,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: 50,
                      color: themeColor.getColor(),
                      height: Get.height,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    isShow = false;
                                    if (categoryLevel2) {
                                      isShowSubCat = false;
                                    }
                                    setState(() {});
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(left: 1.8),
                                    height: 30,
                                    width: 50,
                                    color: themeColor.getColor(),
                                    child: Center(
                                      child: Image.asset(
                                        "assets/icons/right-arrows.png",
                                        height: 12,
                                        width: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                ListView.builder(
                                  itemCount: categories.length,
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return InkWell(
                                      onTap: () async {
                                        Loader().showLoader(context);
                                        catProduct = [];
                                        subCategories =
                                            categories[index]['children'];
                                        page = 1;
                                        productPageLength = 0;
                                        selectedCatId = categories[index]
                                                ['product_cat_id']
                                            .toString();
                                        search = false;
                                        categoryName = categories[index]
                                            ['product_cat_name'];
                                        if (categories[index]['is_children']
                                                .toString() ==
                                            "true") {
                                          categoryLevel2 = true;
                                        } else {
                                          categoryLevel2 = false;
                                        }
                                        canPaging = true;
                                        isPaging = false;
                                        await getProductFromServer(
                                            selectedCatId, '', page);

                                        Loader().hideLoader(context);
                                        setState(() {});
                                      },
                                      child: Container(
                                        color: themeColor.getColor(),
                                        alignment: Alignment.center,
                                        child: selectedCatId ==
                                                categories[index]
                                                        ['product_cat_id']
                                                    .toString()
                                            ? Column(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              24),
                                                    ),
                                                    padding: EdgeInsets.only(
                                                      left: 4,
                                                      right: 4,
                                                      top: 12,
                                                      bottom: 12,
                                                    ),
                                                    child: Align(
                                                      child: RotatedBox(
                                                        quarterTurns: 3,
                                                        child: RichText(
                                                          text: TextSpan(
                                                            text: categories[
                                                                    index][
                                                                'product_cat_name'],
                                                            style: GoogleFonts
                                                                .poppins(
                                                              fontSize: 12,
                                                              color: themeColor
                                                                  .getColor(),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      alignment:
                                                          Alignment.center,
                                                    ),
                                                    width: 24,
                                                    margin: EdgeInsets.only(
                                                        top: 36),
                                                  ),
                                                ],
                                              )
                                            : Container(
                                                margin:
                                                    EdgeInsets.only(top: 36),
                                                padding:
                                                    EdgeInsets.only(top: 12),
                                                child: RotatedBox(
                                                  quarterTurns: 3,
                                                  child: RichText(
                                                    text: TextSpan(
                                                      text: categories[index]
                                                          ['product_cat_name'],
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 12,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(
                                  height: 300,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget addQuentityWidgetRow(int index, int selectedIndex,
      ThemeNotifier themeColor, BuildContext context, Map selectedVarient) {
    print(selectedVarient);
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
                      //qty_in_cases

                      if( catProduct[index]['min_qty'] == 0 &&   selectedVarient['quantity'] ==  catProduct[index]['qty_in_cases']){
                        prefix.bookOrderObj.productsInCart
                            .removeAt(selectedIndex);
                        setState(() {});
                        return;
                      }
                      setState(() {
                        if (selectedVarient != null) {
                          if (selectedVarient['quantity'] >
                              (catProduct[index]['min_qty'] ?? 0)) {
                            tempName == "MILLBORN-Jaipur"
                                ? selectedVarient['quantity'] -=
                                    catProduct[index]['min_qty'] == 0
                                        ? 1
                                        : catProduct[index]['min_qty']
                                : selectedVarient['quantity']--;
                            bookOrderObj.productsInCart[selectedIndex]
                                .productQuantity = selectedVarient['quantity'];
                            if (selectedVarient['quantity'] == 0) {
                              prefix.bookOrderObj.productsInCart
                                  .removeAt(selectedIndex);
                            }
                          } else if (selectedVarient['quantity'] ==
                              (catProduct[index]['min_qty'] ?? 0)) {
                            prefix.bookOrderObj.productsInCart
                                .removeAt(selectedIndex);
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
                      if (selectedVarient['quantity'] != null) {
                        selectedVarient['quantity'] =
                            double.parse(int.parse(value ?? 1).toString());
                        bookOrderObj.productsInCart[selectedIndex]
                            .productQuantity = selectedVarient['quantity'];
                      } else {
                        bookOrderObj
                                .productsInCart[selectedIndex].productQuantity =
                            double.parse(int.parse(value ?? 1).toString());
                      }
                      BookOrderModel.orderModelObj.refreshViewForOrderBooking();
                    },
                    controller: qtyController[index],
                    keyboardType: TextInputType.number,
                  ),
                ),
                InkWell(
                  onTap: () {
                    /*catProduct[index]
                    ["qty_in_cases"]*/
                    setState(() {
                      if (selectedVarient['quantity'] != null) {
                        tempName == "MILLBORN-Jaipur"
                            ? selectedVarient['quantity'] +=
                                catProduct[index]['min_qty']  == 0
                                    ? 1
                                    : catProduct[index]['min_qty']

                            : selectedVarient['quantity']++;
                        bookOrderObj.productsInCart[selectedIndex]
                            .productQuantity = selectedVarient['quantity'];
                        bookOrderObj.addSelectedProductInCart(null);
                      } else {
                        bookOrderObj
                            .productsInCart[selectedIndex].productQuantity++;
                        bookOrderObj.addSelectedProductInCart(null);
                        BookOrderModel.orderModelObj
                            .refreshViewForOrderBooking();
                      }
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
          catProduct[index]['product_id'].toString(),
          index,
          catProduct[index]['min_qty'] == 0 && catProduct[index]
          ["qty_in_cases"] ==10 ? catProduct[index]
          ["qty_in_cases"]:catProduct[index]['min_qty'] ,
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
      print("url");
      print(Base_URL +
          productDetails +
          '&logged_in_userid=$loggedInUserId&product_id=$selectedProductID');
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
            catProduct[index]['variantName'] = res;
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

  bottomSheet(List<Map<String, dynamic>> availableVariants, index) async {
    return showModalBottomSheet(
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
                          "Product Variant",
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
                  SizedBox(height: 20),
                  Container(
                    height: 200,
                    child: SingleChildScrollView(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: availableVariants.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                              margin: EdgeInsets.only(left: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Get.back(
                                          result: availableVariants[index]);
                                      // Navigator.pop(context,availableVariants[index]);
                                    },
                                    child: Text(
                                      '${availableVariants[index]['variantName'] + ' X ' + availableVariants[index]['quantity'].toString()}',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: GoogleFonts.poppins(),
                                    ),
                                  ),
                                  SizedBox(height: 10)
                                ],
                              ));
                        },
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

  void getCategoriesFromServer() async {
    String loggedInUserId = LoginModelClass.loginModelObj
        .getValueForKeyFromLoginResponse(key: 'user_id');

    http.Response resp = await http.get(Uri.parse(
        Base_URL + getCompanyCategories + '&logged_in_userid=$loggedInUserId'));

    if (this.mounted) {
      setState(() {});
    }

    if (resp.statusCode == 200) {
      var jsonBodyResp = jsonDecode(resp.body);
      print(jsonBodyResp);
      if (jsonBodyResp['status'] == true) {
        categories = jsonBodyResp['categories'];
        priceListName = jsonBodyResp['pricelist_info'];
        setState(() {
          jsonBodyResp['categories'].isEmpty
              ? categoryEmpty = true
              : categoryEmpty = false;
        });

        if (jsonBodyResp['categories'].length >= 1) {
          int index = 0;

          for (int i = 0; i < categories.length; i++) {
            if (categories[i]['total_products'] > 0) {
              index = i;
              break;
            }
          }

          catProduct.clear();
          selectedCatId = categories[index]['product_cat_id'].toString();
          categoryName = categories[index]['product_cat_name'].toString();
          subCategories = categories[index]['children'];
          getProductFromServer(
              selectedCatId, searchController.text.trim(), page);
          if (categories[0]['is_children'].toString() == "true") {
            categoryLevel2 = true;
          }
        } else {
          categoryEmpty = true;
          allApiCall = false;
          setState(() {});
        }
        setState(() {});
      } else {
        categoryEmpty = true;
        allApiCall = false;
      }
      bookOrderObj.showLoadingIndicator = false;
    } else {
      categoryEmpty = true;
      categories = null;
      allApiCall = false;
      setState(() {});
      print('Error occurred while serving request');
    }
    bookOrderObj.showLoadingIndicator = false;
    setState(() {});
  }

  getProductFromServer(String catID, String search, int page) async {
    // catProduct = [];
    String loggedInUserId = LoginModelClass.loginModelObj
        .getValueForKeyFromLoginResponse(key: 'user_id');

    http.Response resp = await http.get(
        Uri.parse(Base_URL +
            productsList +
            '&logged_in_userid=$loggedInUserId&category_id=$catID&brand_id&price_min&price_max&sort_by&limit=15&page=$page&product_name=$search'),
        headers: {
          'Authorization': LoginModelClass.loginModelObj
              .getValueForKeyFromLoginResponse(key: 'token'),
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        });

    if (resp.statusCode == 200) {
      print(resp.statusCode);
      var jsonBodyResp = jsonDecode(resp.body);
      if (jsonBodyResp['status'] == true) {
        catProduct.addAll(jsonBodyResp['products']);
        allApiCall = false;
        productPageLength++;
        isPaging = false;
        if (jsonBodyResp['products'].length < 15) {
          canPaging = false;
        }
        if (productPageLength == jsonBodyResp['total_pages']) {
          canPaging = false;
        }
        setState(() {});
      } else {}
    } else {
      allApiCall = false;
      print('Error occurred while serving request');
    }
    bookOrderObj.showLoadingIndicator = false;
    allApiCall = false;
    setState(() {});
  }

  void refreshView() {
    setState(() {});
  }

  Future<void> initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      version = info.version;
      buildNumber = info.buildNumber;
    });
    versionCode = await LoginModelClass.loginModelObj.getVersionCode();
    forceUpdate = await LoginModelClass.loginModelObj.getForceUpdate();
    if (GlobalModelClass.internetConnectionAvaiable() == true) {
      if (forceUpdate.toString().toLowerCase() == "true") {
        if (versionCode.toString() != version.toString()) {
          if (alertDialog == null) {
            Future.delayed(Duration.zero, () {
              alertDialog =
                  GlobalModelClass.showAlertForUpdate(context, refreshView);
              alertDialog.show();
            });
          }
        }
      }
    }
  }

  categoryList() {
    return Container(
      color: Colors.grey[200],
      height: 60,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return categories[index]['total_products'] == 0
              ? SizedBox()
              : Padding(
                  padding: EdgeInsets.only(left: 8, right: 2),
                  child: InkWell(
                    splashColor: Colors.transparent,
                    onTap: () async {
                      Loader().showLoader(
                        context,
                      );
                      catProduct = [];
                      page = 1;
                      productPageLength = 0;
                      subCategories = categories[index]['children'];
                      selectedCatId =
                          categories[index]['product_cat_id'].toString();
                      categoryName = categories[index]['product_cat_name'];
                      canPaging = true;
                      isPaging = false;
                      search = false;
                      await getProductFromServer(
                          selectedCatId, searchController.text.trim(), page);
                      if (categories[index]['is_children'].toString() ==
                          "true") {
                        categoryLevel2 = true;
                      } else {
                        categoryLevel2 = false;
                      }
                      Loader().hideLoader(context);
                      setState(() {});
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 10, bottom: 10),
                      height: 30,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(30, 5, 30, 5),
                        child: Center(
                          child: categories[index]['total_products'] == 0
                              ? Text("")
                              : search != true
                                  ? Text(
                                      categories[index]['product_cat_name'] ??
                                          "",
                                      style: GoogleFonts.poppins(
                                        color: categoryName ==
                                                categories[index]
                                                    ['product_cat_name']
                                            ? Colors.white
                                            : Colors.grey,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  : Text(
                                      categories[index]['product_cat_name'] ??
                                          "",
                                      style: GoogleFonts.poppins(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                        ),
                      ),
                      decoration: search != true
                          ? BoxDecoration(
                              color: categoryName ==
                                      categories[index]['product_cat_name']
                                  ? Colors.grey[600]
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(25),
                            )
                          : BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25),
                            ),
                    ),
                  ),
                );
        },
      ),
    );
  }

  Widget photoListView() {
    return Expanded(
      child: Container(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: subCategories.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () async {
                Loader().showLoader(context);
                catProduct = [];
                page = 1;
                productPageLength = 0;
                selectedCatId =
                    subCategories[index]['product_cat_id'].toString();
                categoryName = subCategories[index]['product_cat_name'];
                subCategories = [];
                categoryLevel2 = false;
                canPaging = true;
                isPaging = false;
                await getProductFromServer(
                    selectedCatId, searchController.text.trim(), page);
                Loader().hideLoader(context);
                setState(() {});
              },
              child: Container(
                margin: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subCategories[index]['product_cat_name'] ?? "",
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    catProduct.length > 0 &&
                            catProduct[0]['imagesize512x512'][0] != null
                        ? Container(
                            height: 200,
                            width: 290,
                            child: Image.network(
                              catProduct[0]['imagesize512x512'][0],
                              fit: BoxFit.fill,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          )
                        : Container(
                            height: 200,
                            width: 290,
                            child: Image.asset(
                              'assets/images/productPlaceaHolderImage.png',
                              fit: BoxFit.fill,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
