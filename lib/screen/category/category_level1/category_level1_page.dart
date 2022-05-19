// import 'dart:convert';
//
// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:badges/badges.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:provider/provider.dart';
// import 'package:shoppingapp/app_url_name_companyid.dart';
// import 'package:shoppingapp/models/BookOrderModel.dart';
// import 'package:shoppingapp/models/GlobalModelClass.dart';
// import 'package:shoppingapp/models/LoginModelClass.dart';
// import 'package:shoppingapp/screen/category/widget/vertical_tab_category.dart';
// import 'package:shoppingapp/screen/category/category_level1/category_level1_model.dart';
// import 'package:shoppingapp/screen/drawer/drawer.dart';
// import 'package:shoppingapp/screen/product_detail/product_detail_page.dart';
// import 'package:shoppingapp/utils/commons/colors.dart';
// import 'package:shoppingapp/utils/constants/constants_app_variables.dart';
// import 'package:shoppingapp/utils/theme_notifier.dart';
// import 'package:shoppingapp/widgets/commons/full_screen_loader.dart';
// import 'package:shoppingapp/utils/dummy_data/category.dart';
// import 'package:shoppingapp/widgets/commons/string_res.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:http/http.dart' as http;
// import 'package:shoppingapp/screen/cart_screen/shopping_cart_page.dart' as prefix;
//
// class CategoryLevel1 extends StatefulWidget {
//   @override
//   CategoryLevel1State createState() => CategoryLevel1State();
// }
//
// class CategoryLevel1State extends State<CategoryLevel1> {
//
//   Category1FavoriteViewModel model;
//   bool isShow = false;
//   bool search = false;
//   int counter = 0;
//   int counter1 = 0;
//
//   String categoryName = Strings.shopbycategory;
//   int selectedIndex = 0;
//   int currentSelectedIndex;
//   int selectedTab;
//
//   int cartListIndex = 0;
//   bool categoryEmpty = false;
//   var variant;
//   final searchController = TextEditingController();
//   int tabSelectedProductId = 0;
//   GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
//
//   List searchDataList = [];
//   List productCategories = [];
//   bool allApiCall = true;
//
//   @override
//   void initState() {
//     super.initState();
//     if (subCategoriesImages.length == 0) {
//       getCategoriesFromServer();
//     } else {
//       allApiCall = false;
//       setState(() {});
//     }
//   }
//
//   searchDataFunction(String searchKeyWord) {
//     searchDataList.clear();
//
//     for (var i = 0; i <
//         subCategoriesImages[tabSelectedProductId]['products'].length; i++) {
//       print(
//           subCategoriesImages[tabSelectedProductId]['products'][i]['product_name']
//               .toString()
//               .toLowerCase()
//               .contains(searchKeyWord));
//       if (subCategoriesImages[tabSelectedProductId]['products'][i]['product_name']
//           .toString().toLowerCase()
//           .contains(searchKeyWord)) {
//         searchDataList.add(
//             subCategoriesImages[tabSelectedProductId]['products'][i]);
//       }
//       print(searchDataList);
//     }
//     setState(() {});
//   }
//
//   void getCategoriesFromServer() async {
//     String loggedInUserId = LoginModelClass.loginModelObj
//         .getValueForKeyFromLoginResponse(key: 'user_id');
//
//     http.Response resp = await http.get(
//         Base_URL + getCompanyCategories + '&logged_in_userid=$loggedInUserId');
//
//     if (this.mounted) {
//       setState(() {});
//     }
//
//     if (resp.statusCode == 200) {
//       var jsonBodyResp = jsonDecode(resp.body);
//       print(jsonBodyResp);
//       if (jsonBodyResp['status'] == true) {
//         productCategories = jsonBodyResp['categories'];
//         categories.clear();
//         subCategoriesImages.clear();
//         for (var i = 0; i < productCategories.length; i++) {
//           categories.add(productCategories[i]);
//
//           // =========    For get product list for category list
//           String loggedInUserId = LoginModelClass.loginModelObj
//               .getValueForKeyFromLoginResponse(key: 'user_id');
//
//           http.Response resp = await http.get(
//               Base_URL +
//                   productsList +
//                   '&logged_in_userid=$loggedInUserId&category_id=${productCategories[i]['product_cat_id']}&brand_id&price_min&price_max&sort_by&limit=500&page=1',
//               headers: {
//                 'Authorization': LoginModelClass.loginModelObj
//                     .getValueForKeyFromLoginResponse(key: 'token'),
//                 'Content-Type': 'application/json',
//                 'Accept': 'application/json',
//               });
//
//           bookOrderObj.showLoadingIndicator = false;
//           setState(() {});
//           if (resp.statusCode == 200) {
//             print(resp.statusCode);
//             var jsonBodyResp = jsonDecode(resp.body);
//
//             if (jsonBodyResp['status'] == true) {
//               subCategoriesImages.add(jsonBodyResp);
//             } else {}
//           } else {
//             print('Error occurred while serving request');
//           }
//         }
//         print(categories.length);
//       } else {
//         categoryEmpty = true;
//         allApiCall = false;
//         setState(() {});
//       }
//       bookOrderObj.showLoadingIndicator = false;
//     }
//     else {
//       productCategories = null;
//       print('Error occurred while serving request');
//     }
//     bookOrderObj.showLoadingIndicator = false;
//     allApiCall = false;
//     setState(() {});
//   }
//
//   void refreshView() {
//     setState(() {});
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     // ignore: unnecessary_statements
//     model ?? (model = Category1FavoriteViewModel(this));
//     final themeColor = Provider.of<ThemeNotifier>(context);
//     print("Current page --> $runtimeType");
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: Color.fromARGB(255, 252, 252, 252),
//           iconTheme: IconThemeData(color: themeColor.getColor()),
//           title: AutoSizeText(
//             categoryName ?? "Product By Category",
//             maxLines: 1,
//             minFontSize: 7,
//             maxFontSize: 18,
//             style: GoogleFonts.poppins(
//               color: themeColor.getColor(),
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           actions: [
//             Container(
//               margin: EdgeInsets.only(bottom: 8),
//               child: InkWell(
//                 onTap: () {
//                   if (search == true) {
//                     search = false;
//                   } else {
//                     search = true;
//                   }
//                   setState(() {});
//                 },
//                 child: Icon(Icons.search),),),
//             SizedBox(width: 17),
//             Padding(
//               padding: EdgeInsets.only(right: 16, top: 8),
//               child: InkWell(
//                 onTap: () async {
//                   isShow = false;
//                   searchDataList = [];
//                   searchController.clear();
//                   search = false;
//                   var data = await Get.to(() =>
//                       prefix.ShoppingCartPage(showBackArrow: true),
//                   );
//                   setState(() {
//                     allApiCall = true;
//                     getCategoriesFromServer();
//                   });
//                 },
//                 child: Badge(
//                   badgeColor: Color(0xFF5D6A78),
//                   alignment: Alignment(-0.5, -1.0),
//                   padding: EdgeInsets.all(4),
//                   badgeContent: Text(
//                     '${BookOrderModel.orderModelObj.productsInCart
//                         ?.length ?? 0}',
//                     style:
//                     GoogleFonts.poppins(color: Colors.white, fontSize: 10,),
//                   ),
//                   child: SvgPicture.asset(
//                     "assets/icons/ic_shopping_cart.svg",
//                     color: themeColor.getColor(),
//                     height: 26,
//                   ),
//                 ),
//               ),)
//             // AppBarUpdate(themeColor: themeColor)
//           ],
//         ),
//         drawer: CustomDrawer(),
//         backgroundColor: greyBackground,
//         body:
//         allApiCall || subCategoriesImages == null
//             ? Center(child: CircularProgressIndicator())
//             : categoryEmpty || subCategoriesImages.isEmpty ? Container(
//           height: Get.height * 0.8,
//           child: Center(
//             child: Text(
//               "Category Not Found",
//               style: GoogleFonts.poppins(
//                 fontSize: 25,
//                 color: Colors.grey[500],
//               ),
//             ),
//           ),
//         ) : Stack(
//           children: [
//             listView(),
//             !isShow ?
//               Align(
//                 alignment: Alignment.topRight,
//                 child: InkWell(
//                   onTap: () {
//                     isShow = true;
//                     setState(() {});
//                   },
//                   child: Container(
//                     height: 25,
//                     width: 25,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(30.0),
//                         bottomLeft: Radius.circular(30.0),
//                       ),
//                       color: themeColor.getColor(),),
//                     child: Center(
//                       child: Image.asset(
//                         "assets/icons/double-arrows.png",
//                         height: 12,
//                         width: 12,
//                         color: Colors.white,
//                       ),),),
//                 ),) :
//               Align(
//                 alignment: Alignment.topRight,
//                 child: Container(
//                   height: Get.height,
//                   child: Column(
//                     children: [
//                       InkWell(
//                         onTap: () {
//                           isShow = false;
//                           setState(() {});
//                         },
//                         child: Container(
//                           margin: EdgeInsets.only(left: 1.8),
//                           height: 30,
//                           width: 47,
//                           color: themeColor.getColor(),
//                           child: Center(
//                             child: Image.asset(
//                               "assets/icons/right-arrows.png",
//                               height: 12,
//                               width: 12,
//                               color: Colors.white,
//                             ),),),
//                       ),
//                       Container(
//                         width: 49,
//                         child: ListView.builder(
//                           itemCount: categories.length,
//                           physics: NeverScrollableScrollPhysics(),
//                           shrinkWrap: true,
//                           itemBuilder:
//                               (BuildContext context, int index) {
//                             return InkWell(
//                               onTap: () async {
//                                 // Loader().showLoader(context);
//                                 // selectedTab = index;
//                                 // selectedCatId =
//                                 //     catModel.categories.categories[index]
//                                 //         .productCatId.toString();
//                                 // await catProductModel.categoryProductApiInitial();
//                                 // Loader().hideLoader(context);
//                                 // setState(() {});
//                               },
//                               child: Container(
//                                 color: themeColor.getColor(),
//                                 alignment: Alignment.center,
//                                 child: selectedTab == index
//                                     ? Container(
//                                   decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius:
//                                     BorderRadius.circular(
//                                         24),
//                                   ),
//                                   padding: EdgeInsets.only(
//                                     left: 4,
//                                     right: 4,
//                                     top: 12,
//                                     bottom: 12,
//                                   ),
//                                   child: Align(
//                                     child: RotatedBox(
//                                       quarterTurns: 3,
//                                       child: RichText(
//                                         text: TextSpan(
//                                           text: categories[index]
//                                           ['product_cat_name'],
//                                           style: GoogleFonts
//                                               .poppins(
//                                             fontSize: 12,
//                                             color: themeColor
//                                                 .getColor(),
//                                             fontWeight:
//                                             FontWeight.w700,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     alignment: Alignment.center,
//                                   ),
//                                   width: 24,
//                                   margin:
//                                   EdgeInsets.only(top: 36),
//                                 )
//                                     : Container(
//                                   margin:
//                                   EdgeInsets.only(top: 36),
//                                   padding:
//                                   EdgeInsets.only(top: 12),
//                                   child: RotatedBox(
//                                     quarterTurns: 3,
//                                     child: RichText(
//                                       text: TextSpan(
//                                         text: categories[index]
//                                         ['product_cat_name'],
//                                         style:
//                                         GoogleFonts.poppins(
//                                           fontSize: 12,
//                                           color: Colors.white,
//                                           fontWeight:
//                                           FontWeight.w700,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       )
//                       // Expanded(
//                       //   child: VerticalTabsForCategory(
//                       //     indicatorColor: themeColor.getColor(),
//                       //     selectedTabBackgroundColor: whiteColor,
//                       //     tabBackgroundColor: themeColor.getColor(),
//                       //     backgroundColor: greyBackground,
//                       //     direction: TextDirection.rtl,
//                       //     tabsWidth: 48,
//                       //     onSelect: (int i) {
//                       //       search = false;
//                       //       tabSelectedProductId = i;
//                       //       categoryName = categories[i]
//                       //       ['product_cat_name']
//                       //           .toString();
//                       //       searchController.clear();
//                       //       searchDataList.clear();
//                       //       Future.delayed(Duration.zero, () async {
//                       //         setState(() {});
//                       //       });
//                       //     },
//                       //     tabsTitle: categories
//                       //         .map(
//                       //             (e) => e['product_cat_name'].toString())
//                       //         .toList(),
//                       //     tabs: categories
//                       //         .map(
//                       //           (e) =>
//                       //           Tab(
//                       //             child: RotatedBox(
//                       //               quarterTurns: 1,
//                       //               child: RichText(
//                       //                 text: TextSpan(
//                       //                   text: 'Flutter',
//                       //                   style:
//                       //                   DefaultTextStyle
//                       //                       .of(context)
//                       //                       .style
//                       //                       .copyWith(),
//                       //                 ),
//                       //               ),
//                       //             ),
//                       //             icon: Icon(Icons.phone),),
//                       //     )
//                       //         .toList(),
//                       //     contents: categories
//                       //         .map((e) => tabsContent(themeColor))
//                       //         .toList(),
//                       //   ),
//                       // )
//                     ],
//                   ),
//                 ),)
//           ],
//         ),
//       ),);
//   }
//
//   Widget tabsContent(ThemeNotifier themeColor, [String description = '']) {
//     return Container(
//       child: ListView.builder(
//         itemCount: subCategories.length,
//         itemBuilder: (context, index) {
//           returnSizedBox();
//         },
//       ),
//     );
//   }
//
//   Widget listView() {
//     final themeColor = Provider.of<ThemeNotifier>(context);
//     return SingleChildScrollView(
//       child: subCategoriesImages != null &&categoryName
//           subCategoriesImages.isNotEmpty &&
//           subCategoriesImages[tabSelectedProductId]['products'] != null
//           ? Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           search != true ?SizedBox() : Container(
//             width: isShow
//                 ? Get.width * 0.78
//                 : Get.width * 0.85,
//             margin: EdgeInsets.only(left: 15, top: 14),
//             padding: EdgeInsets.only(left: 18, right: 18),
//             height: 44,
//             decoration: BoxDecoration(
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey[200],
//                   blurRadius: 8.0,
//                   spreadRadius: 1,
//                   offset: Offset(0.0, 3),
//                 )
//               ],
//               color: Theme
//                   .of(context)
//                   .bottomAppBarColor,
//               borderRadius: BorderRadius.circular(24),
//             ),
//             child: Row(
//               children: <Widget>[
//                 SvgPicture.asset(
//                   "assets/icons/ic_search.svg",
//                   color: Colors.black45,
//                   height: 12,
//                 ),
//                 SizedBox(width: 8),
//                 Expanded(
//                   child: Container(
//                     padding: EdgeInsets.only(bottom: 4),
//                     height: 72,
//                     child: TextFormField(
//                       controller: searchController,
//                       key: _formKey,
//                       decoration: InputDecoration(
//                         border: InputBorder.none,
//                         hintText: Strings.searchpro,
//                         hintStyle: GoogleFonts.poppins(
//                           fontSize: 13,
//                           color: Color(0xFF5D6A78),
//                           fontWeight: FontWeight.w400,
//                         ),
//                       ),
//                       onChanged: (searchText) {
//                         searchDataFunction(searchText.toLowerCase());
//                       },
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           search != true ?SizedBox() : Divider(thickness: 1),
//           SingleChildScrollView(
//             child: searchDataList.length == 0 ? ListView.builder(
//               shrinkWrap: true,
//               physics: NeverScrollableScrollPhysics(),
//               itemCount: subCategoriesImages[tabSelectedProductId]['products']
//                   .length,
//               itemBuilder: (BuildContext context, int index) {
//                 List<Map<String, dynamic>> variantList = [];
//
//                 for (var i = 0; i < bookOrderObj.productsInCart.length; i++) {
//                   for (int j = 0; j <
//                       subCategoriesImages[tabSelectedProductId]['products'][index]['product_variants']
//                           .length; j++) {
//                     if (subCategoriesImages[tabSelectedProductId]['products'][index]['product_variants'][j]
//                         .toString() == {
//                       "product_variant_id": bookOrderObj.productsInCart[i]
//                           .productVariantID
//                     }.toString()) {
//                       variantList.add({
//                         "variantName": bookOrderObj.productsInCart[i]
//                             .variantName,
//                         "quantity": bookOrderObj.productsInCart[i]
//                             .productQuantity
//                       });
//                       if (subCategoriesImages[tabSelectedProductId]['products'][index]['selectedvariant'] ==
//                           null) {
//                         subCategoriesImages[tabSelectedProductId]['products'][index]['selectedvariant'] =
//                         {"variantName": bookOrderObj.productsInCart[i]
//                             .variantName, "quantity": bookOrderObj
//                             .productsInCart[i].productQuantity};
//                       }
//                     }
//                   }
//                 }
//
//                 for (var i = 0; i < bookOrderObj.productsInCart.length; i++) {
//                   if (subCategoriesImages[tabSelectedProductId]['products'][index]['product_id']
//                       .toString() ==
//                       bookOrderObj.productsInCart[i].productID) {
//                     cartListIndex = i;
//                   }
//                 }
//
//                 return Row(
//                   children: [
//                     Container(
//                       margin: EdgeInsets.only(top: 5),
//                       width: !isShow ? Get.width : Get.width - 40,
//                       child: Column(
//                         children: [
//                           InkWell(
//                             onTap: () async {
//                               int productIndex;
//                               for (var i = 0; i <
//                                   bookOrderObj.productsInCart.length; i++) {
//                                 if (bookOrderObj.productsInCart[i].productID ==
//                                     subCategoriesImages[tabSelectedProductId]['products'][index]['product_id']
//                                         .toString()) {
//                                   productIndex = i;
//                                 }
//                               }
//                               print(selectedIndex);
//                               isShow = false;
//                               var data = await Get.to(() =>
//                                   ProductDetailPage(
//                                     productId:
//                                     subCategoriesImages[tabSelectedProductId]
//                                     ['products'][index]['product_id'],
//                                     productQty: productIndex == null
//                                         ? 1.0
//                                         : bookOrderObj
//                                         .productsInCart[productIndex]
//                                         .productQuantity,
//                                   ),
//                               );
//
//                               setState(() {
//                                 allApiCall = true;
//                                 getCategoriesFromServer();
//                               });
//                             },
//                             child: Container(
//                               width:
//                               !isShow ? Get.width : Get.width - 50,
//                               child: Row(
//                                 mainAxisAlignment:
//                                 MainAxisAlignment.start,
//                                 crossAxisAlignment:
//                                 CrossAxisAlignment.start,
//                                 children: [
//                                   Column(
//                                       children: [
//                                         Container(
//                                             margin: EdgeInsets.only(
//                                                 top: 10, right: 5),
//                                             width: Get.width * 0.29,
//                                             child:
//                                             subCategoriesImages[tabSelectedProductId]['products'] !=
//                                                 null &&
//                                                 subCategoriesImages[tabSelectedProductId]['products']
//                                                     .isNotEmpty ? ClipRRect(
//                                               child: subCategoriesImages[tabSelectedProductId]['products'][index]['imagesize512x512']
//                                                   .length != 0
//                                                   ? subCategoriesImages[tabSelectedProductId]['products'][index]['imagesize512x512'][0]
//                                                   .toString()
//                                                   .isNotEmpty
//                                                   ? Image.network(
//                                                 subCategoriesImages[tabSelectedProductId]['products'][index]['imagesize512x512'][0]
//                                                     .toString(),
//                                                 height: Get.height * 0.15,
//                                                 width: Get.width * 0.1,
//                                               )
//                                                   : Image.asset(
//                                                 'assets/images/productPlaceaHolderImage.png',
//                                                 height: Get.height * 0.15,
//                                                 width: Get.width * 0.1,
//                                               )
//                                                   : Image.asset(
//                                                 'assets/images/productPlaceaHolderImage.png',
//                                                 height: Get.height * 0.13,
//                                                 width: Get.width * 0.1,
//                                               ),
//                                             ) : Container()
//                                         ),
//                                       ]
//                                   ),
//                                   Container(
//                                     width: !isShow
//                                         ? Get.width * 0.65
//                                         : Get.width * 0.54,
//                                     child: Column(
//                                       children: [
//                                         Column(
//                                           crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                           children: [
//                                             Row(
//                                               children: [
//                                                 Container(
//                                                   width: !isShow
//                                                       ? Get.width * 0.52
//                                                       : Get.width * 0.42,
//                                                   child: Text(
//                                                     subCategoriesImages[tabSelectedProductId]['products'][index]['product_name'],
//                                                     maxLines: 2,
//                                                     overflow: TextOverflow
//                                                         .ellipsis,
//                                                     style: GoogleFonts
//                                                         .poppins(
//                                                       fontSize: 17,
//                                                       fontWeight:
//                                                       FontWeight
//                                                           .w400,),
//                                                   ),
//                                                 ),
//                                                 Container(
//                                                   width: Get.width * 0.09,
//                                                   child: InkWell(
//                                                     onTap: () {
//                                                       if (subCategoriesImages[tabSelectedProductId]['products'][index]['isin_wishlist'] ==
//                                                           'active') {
//                                                         model.getFavoriteApi(
//                                                             productId: subCategoriesImages[tabSelectedProductId]['products']
//                                                             [index]
//                                                             [
//                                                             'product_id']
//                                                                 .toString(),
//                                                             wishListId: subCategoriesImages[tabSelectedProductId]
//                                                             [
//                                                             'products'][index]['wishlist']
//                                                             [
//                                                             'wishlist_id']
//                                                                 .toString(),
//                                                             wishListStatus:
//                                                             'inactive');
//                                                         setState(() {
//                                                           subCategoriesImages[tabSelectedProductId]['products']
//                                                           [
//                                                           index]
//                                                           [
//                                                           'isin_wishlist'] =
//                                                           'inactive';
//                                                         });
//                                                         Scaffold.of(context)
//                                                             .showSnackBar(
//                                                             SnackBar(
//                                                                 backgroundColor:
//                                                                 mainColor,
//                                                                 duration:
//                                                                 Duration(
//                                                                     seconds:
//                                                                     1),
//                                                                 content: Text(
//                                                                     Strings
//                                                                         .removetosts)));
//                                                         setState(() {});
//                                                       } else {
//                                                         model.getFavoriteApi(
//                                                             productId: subCategoriesImages[tabSelectedProductId]['products']
//                                                             [
//                                                             index]
//                                                             [
//                                                             'product_id']
//                                                                 .toString(),
//                                                             wishListId:
//                                                             'new',
//                                                             wishListStatus:
//                                                             'active');
//                                                         setState(() {
//                                                           subCategoriesImages[
//                                                           tabSelectedProductId]
//                                                           [
//                                                           'products'][index]
//                                                           [
//                                                           'isin_wishlist'] =
//                                                           'active';
//                                                         });
//                                                         Scaffold.of(context)
//                                                             .showSnackBar(
//                                                             SnackBar(
//                                                                 backgroundColor:
//                                                                 mainColor,
//                                                                 duration:
//                                                                 Duration(
//                                                                     seconds:
//                                                                     1),
//                                                                 content: Text(
//                                                                     Strings
//                                                                         .addedtosts)));
//                                                         setState(() {});
//                                                       }
//                                                     },
//                                                     child: Icon(
//                                                       Icons.favorite,
//                                                       color: subCategoriesImages[tabSelectedProductId]['products']
//                                                       [
//                                                       index]
//                                                       [
//                                                       'isin_wishlist'] ==
//                                                           'active'
//                                                           ? Colors.red
//                                                           : Colors.black,
//                                                       size: 30,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                             ratingStar(),
//                                           ],
//                                         ),
//                                         SizedBox(
//                                             height: 7
//                                         ),
//                                         subCategoriesImages[tabSelectedProductId]['products'][index]['pp_mrp'] ==
//                                             null
//                                             ? Container()
//                                             : Row(
//                                           mainAxisAlignment: MainAxisAlignment
//                                               .end,
//                                           children: [
//                                             Flexible(
//                                               child: Text(
//                                                 Strings.mrp,
//                                                 style: GoogleFonts
//                                                     .poppins(
//                                                     color: Colors
//                                                         .grey),
//                                               ),
//                                             ),
//                                             Flexible(
//                                               child: Text(
//                                                 subCategoriesImages[tabSelectedProductId]['products'][index]['pp_mrp'] !=
//                                                     null
//                                                     ? " ₹ ${subCategoriesImages[tabSelectedProductId]['products'][index]['pp_mrp']
//                                                     .toString()}"
//                                                     : " ₹ 0",
//                                                 style: GoogleFonts.poppins(
//                                                   color:
//                                                   Colors.grey,
//                                                   decoration:
//                                                   TextDecoration
//                                                       .lineThrough,),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//
//                                         subCategoriesImages[tabSelectedProductId]
//                                         ['products'][index]['pp_price'] ==
//                                             null ? Container() : Container(
//                                           width: Get.width * 0.7,
//                                           child: Row(
//                                             mainAxisAlignment:
//                                             MainAxisAlignment.end,
//                                             children: [
//                                               Flexible(
//                                                 child: Text(
//                                                   Strings.Price,
//                                                   style:
//                                                   GoogleFonts.poppins(
//                                                     color: themeColor
//                                                         .getColor(),
//                                                     fontWeight:
//                                                     FontWeight
//                                                         .w500,
//                                                     fontSize: 16,),
//                                                 ),
//                                               ),
//                                               Flexible(
//                                                 child: Text(
//                                                   subCategoriesImages[tabSelectedProductId]
//                                                   ['products']
//                                                   [index][
//                                                   'pp_price'] !=
//                                                       null
//                                                       ? " ₹ ${subCategoriesImages[tabSelectedProductId]['products'][index]['pp_price']
//                                                       .toString()}"
//                                                       : " ₹ 0",
//                                                   style:
//                                                   GoogleFonts.poppins(
//                                                     color: themeColor
//                                                         .getColor(),
//                                                     fontWeight:
//                                                     FontWeight
//                                                         .w500,
//                                                     fontSize: 16,),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//
//                                         Container(
//                                           child: subCategoriesImages[tabSelectedProductId]
//                                           ['products'][index][
//                                           'saved_percentage'] ==
//                                               null
//                                               ? Container()
//                                               : Row(
//                                             mainAxisAlignment:
//                                             MainAxisAlignment.end,
//                                             children: [
//                                               Text(
//                                                 Strings.yousave,
//                                                 style:
//                                                 GoogleFonts.poppins(
//                                                     color: Colors
//                                                         .grey),
//                                               ),
//                                               Text(
//                                                 '₹' +
//                                                     '${subCategoriesImages[tabSelectedProductId]['products'][index]['pp_mrp'] -
//                                                         subCategoriesImages[tabSelectedProductId]
//                                                         ['products'][index]['pp_price']}'
//                                                     +
//                                                     ' (${subCategoriesImages[tabSelectedProductId]['products'][index]['saved_percentage']
//                                                         .toStringAsFixed(2)}%)',
//                                                 style:
//                                                 GoogleFonts.poppins(
//                                                   color:
//                                                   Colors.grey,
//                                                   fontWeight: FontWeight
//                                                       .w500,),
//                                               )
//                                             ],
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: 10),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               SizedBox(width: 1),
//                               variantList.isEmpty ? Text("") : Container(
//                                   child: InkWell(
//                                     onTap: () async {
//                                       var res = await bottomSheet(
//                                           variantList, index);
//                                       if (res != null) {
//                                         subCategoriesImages[tabSelectedProductId]['products'][index]['selectedvariant'] =
//                                             res;
//                                         print(res);
//                                       }
//                                       setState(() {});
//                                     },
//                                     child: subCategoriesImages[tabSelectedProductId]['products'][index]['selectedvariant']['variantName']
//                                         .toString() == null ||
//                                         subCategoriesImages[tabSelectedProductId]['products'][index]['selectedvariant']['variantName']
//                                             .toString()
//                                             .isEmpty ?
//                                     Container() : Container(
//                                       padding: EdgeInsets.fromLTRB(15, 5, 8, 5),
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(30),
//                                         color: themeColor.getColor(),
//                                       ),
//                                       child: Row(
//                                         children: [
//                                           Text(
//                                             subCategoriesImages[tabSelectedProductId]['products'][index]['selectedvariant'] !=
//                                                 null
//                                                 ? subCategoriesImages[tabSelectedProductId]['products'][index]['selectedvariant']['variantName']
//                                                 .toString()
//                                                 : "Variant",
//                                             style: GoogleFonts.poppins(
//                                                 color: Colors.white),
//                                           ),
//                                           SizedBox(width: 5),
//                                           Image.asset(
//                                             "assets/icons/drop-down.png",
//                                             height: 10,
//                                             width: 10,
//                                             color: Colors.white,
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                   )
//                               ),
//
//                               bookOrderObj.productsInCart.length == 0 ||
//                                   bookOrderObj.productsInCart.length - 1 <
//                                       cartListIndex
//                                   ? addToCartBtnWidget(
//                                   index, themeColor, context) : bookOrderObj
//                                   .productsInCart[cartListIndex].productID
//                                   .toString() ==
//                                   subCategoriesImages[tabSelectedProductId]['products'][index]['product_id']
//                                       .toString()
//                                   ? addQuentityWidgetRow(
//                                   cartListIndex, themeColor, context,
//                                   subCategoriesImages[tabSelectedProductId]['products'][index]['selectedvariant'] ==
//                                       null ? null :
//                                   subCategoriesImages[tabSelectedProductId]['products'][index]['selectedvariant'])
//                                   : addToCartBtnWidget(
//                                   index, themeColor, context),
//                             ],
//                           ),
//                           Divider(
//                               thickness: 1
//                           )
//                         ],
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             )
//                 : ListView.builder(
//               shrinkWrap: true,
//               physics: NeverScrollableScrollPhysics(),
//               itemCount: searchDataList.length,
//               itemBuilder: (BuildContext context, int index) {
//                 List<Map<String, dynamic>> variantlist = [];
//
//                 for (var i = 0; i < bookOrderObj.productsInCart.length; i++) {
//                   for (int j = 0; j <
//                       searchDataList[index]['product_variants'].length; j++) {
//                     if (searchDataList[index]['product_variants'][j]
//                         .toString() == {
//                       "product_variant_id": bookOrderObj.productsInCart[i]
//                           .productVariantID
//                     }.toString()) {
//                       variantlist.add({
//                         "variantName": bookOrderObj.productsInCart[i]
//                             .variantName,
//                         "quantity": bookOrderObj.productsInCart[i]
//                             .productQuantity
//                       });
//                       if (searchDataList[index]['selectedvariant'] == null) {
//                         searchDataList[index]['selectedvariant'] =
//                         {"variantName": bookOrderObj.productsInCart[i]
//                             .variantName, "quantity": bookOrderObj
//                             .productsInCart[i].productQuantity};
//                       }
//                     }
//                   }
//                 }
//
//                 for (var i = 0; i < bookOrderObj.productsInCart.length; i++) {
//                   if (searchDataList[index]['product_id'].toString() ==
//                       bookOrderObj.productsInCart[i].productID) {
//                     cartListIndex = i;
//                   }
//                 }
//
//                 return Row(
//                   children: [
//                     Container(
//                       margin: EdgeInsets.only(top: 5),
//                       width: !isShow ? Get.width : Get.width - 40,
//                       child: Column(
//                         children: [
//                           InkWell(
//                             onTap: () async {
//                               int productIndex;
//                               for (var i = 0; i <
//                                   bookOrderObj.productsInCart.length; i++) {
//                                 if (bookOrderObj.productsInCart[i].productID ==
//                                     searchDataList[index]['product_id']
//                                         .toString()) {
//                                   productIndex = i;
//                                 }
//                               }
//                               print(selectedIndex);
//                               isShow = false;
//                               var data = Get.to(() =>
//                                   ProductDetailPage(
//                                     productId:
//                                     searchDataList[index]['product_id'],
//                                     productQty: productIndex == null
//                                         ? 1.0
//                                         : bookOrderObj
//                                         .productsInCart[productIndex]
//                                         .productQuantity,
//                                   ),
//                               );
//
//                               setState(() {
//                                 allApiCall = true;
//                                 getCategoriesFromServer();
//                               });
//                             },
//                             child: Container(
//                               width:
//                               !isShow ? Get.width : Get.width - 50,
//                               child: Row(
//                                 mainAxisAlignment:
//                                 MainAxisAlignment.start,
//                                 crossAxisAlignment:
//                                 CrossAxisAlignment.start,
//                                 children: [
//                                   Column(
//                                       children: [
//                                         Container(
//                                             margin: EdgeInsets.only(
//                                                 top: 10, right: 5),
//                                             width: Get.width * 0.29,
//                                             child:
//                                             searchDataList != null &&
//                                                 searchDataList.isNotEmpty
//                                                 ? ClipRRect(
//                                               child: searchDataList[index]['imagesize512x512']
//                                                   .length != 0
//                                                   ? searchDataList[index]['imagesize512x512'][0]
//                                                   .toString()
//                                                   .isNotEmpty
//                                                   ? Image.network(
//                                                 searchDataList[index]['imagesize512x512'][0]
//                                                     .toString(),
//                                                 height: Get.height * 0.15,
//                                                 width: Get.width * 0.1,
//                                               )
//                                                   : Image.asset(
//                                                 'assets/images/productPlaceaHolderImage.png',
//                                                 height: Get.height * 0.15,
//                                                 width: Get.width * 0.1,
//                                               )
//                                                   : Image.asset(
//                                                 'assets/images/productPlaceaHolderImage.png',
//                                                 height: Get.height * 0.13,
//                                                 width: Get.width * 0.1,
//                                               ),
//                                             )
//                                                 : Container()
//                                         ),
//                                       ]
//                                   ),
//                                   Container(
//                                     width: !isShow
//                                         ? Get.width * 0.65
//                                         : Get.width * 0.54,
//                                     child: Column(
//                                       children: [
//                                         Column(
//                                           crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                           children: [
//                                             Row(
//                                               children: [
//                                                 Container(
//                                                   width: !isShow
//                                                       ? Get.width * 0.52
//                                                       : Get.width * 0.42,
//                                                   child: Text(
//                                                     searchDataList[index]['product_name'],
//                                                     maxLines: 2,
//                                                     overflow: TextOverflow
//                                                         .ellipsis,
//                                                     style: GoogleFonts
//                                                         .poppins(
//                                                       fontSize: 17,
//                                                       fontWeight:
//                                                       FontWeight
//                                                           .w400,),
//                                                   ),
//                                                 ),
//                                                 Container(
//                                                   width:
//                                                   Get.width * 0.09,
//                                                   child: InkWell(
//                                                     onTap: () {
//                                                       if (searchDataList[index]['isin_wishlist'] ==
//                                                           'active') {
//                                                         model.getFavoriteApi(
//                                                             productId: searchDataList[index]['product_id']
//                                                                 .toString(),
//                                                             wishListId: searchDataList[index]['wishlist']['wishlist_id']
//                                                                 .toString(),
//                                                             wishListStatus: 'inactive');
//                                                         setState(() {
//                                                           searchDataList[index]['isin_wishlist'] =
//                                                           'inactive';
//                                                         });
//                                                         Scaffold.of(context)
//                                                             .showSnackBar(
//                                                           SnackBar(
//                                                             backgroundColor:
//                                                             mainColor,
//                                                             duration:
//                                                             Duration(
//                                                                 seconds:
//                                                                 1),
//                                                             content: Text(
//                                                                 Strings
//                                                                     .removetosts),),);
//                                                         setState(() {});
//                                                       } else {
//                                                         model.getFavoriteApi(
//                                                             productId: searchDataList[index]['product_id']
//                                                                 .toString(),
//                                                             wishListId: 'new',
//                                                             wishListStatus: 'active');
//                                                         setState(() {
//                                                           searchDataList[index]['isin_wishlist'] =
//                                                           'active';
//                                                         });
//                                                         Scaffold.of(context)
//                                                             .showSnackBar(
//                                                             SnackBar(
//                                                                 backgroundColor: mainColor,
//                                                                 duration: Duration(
//                                                                     seconds: 1),
//                                                                 content: Text(
//                                                                     Strings
//                                                                         .addedtosts)));
//                                                         setState(() {});
//                                                       }
//                                                     },
//                                                     child: Icon(
//                                                       Icons.favorite,
//                                                       color: searchDataList[index]['isin_wishlist'] ==
//                                                           'active'
//                                                           ? Colors.red
//                                                           : Colors.black,
//                                                       size: 30,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                             ratingStar(),
//                                           ],
//                                         ),
//                                         SizedBox(
//                                             height: 7
//                                         ),
//                                         searchDataList[index]['pp_mrp'] == null
//                                             ? Container()
//                                             : Row(
//                                           mainAxisAlignment: MainAxisAlignment
//                                               .end,
//                                           children: [
//                                             Flexible(
//                                               child: Text(
//                                                 Strings.mrp,
//                                                 style: GoogleFonts
//                                                     .poppins(
//                                                   color: Colors
//                                                       .grey,),
//                                               ),
//                                             ),
//                                             Flexible(
//                                               child: Text(
//                                                 searchDataList[index]['pp_mrp'] !=
//                                                     null
//                                                     ? " ₹ ${searchDataList[index]['pp_mrp']
//                                                     .toString()}"
//                                                     : " ₹ 0",
//                                                 style: GoogleFonts.poppins(
//                                                   color:
//                                                   Colors.grey,
//                                                   decoration:
//                                                   TextDecoration
//                                                       .lineThrough,),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                         searchDataList[index]['pp_price'] ==
//                                             null ? Container() : Container(
//                                           width: Get.width * 0.7,
//                                           child: Row(
//                                             mainAxisAlignment:
//                                             MainAxisAlignment.end,
//                                             children: [
//                                               Flexible(
//                                                 child: Text(
//                                                   Strings.Price,
//                                                   style:
//                                                   GoogleFonts.poppins(
//                                                     color: themeColor
//                                                         .getColor(),
//                                                     fontWeight:
//                                                     FontWeight
//                                                         .w500,
//                                                     fontSize: 16,),
//                                                 ),
//                                               ),
//                                               Flexible(
//                                                 child: Text(
//                                                   searchDataList[index]['pp_price'] !=
//                                                       null
//                                                       ? " ₹ ${searchDataList[index]['pp_price']
//                                                       .toString()}"
//                                                       : " ₹ 0",
//                                                   style:
//                                                   GoogleFonts.poppins(
//                                                     color: themeColor
//                                                         .getColor(),
//                                                     fontWeight:
//                                                     FontWeight
//                                                         .w500,
//                                                     fontSize: 16,),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//
//                                         Container(
//                                           child: searchDataList[index]['saved_percentage'] ==
//                                               null
//                                               ? Container()
//                                               : Row(
//                                             mainAxisAlignment:
//                                             MainAxisAlignment.end,
//                                             children: [
//                                               Text(
//                                                 Strings.yousave,
//                                                 style:
//                                                 GoogleFonts.poppins(
//                                                     color: Colors
//                                                         .grey),
//                                               ),
//                                               Text(
//                                                 '₹' +
//                                                     '${searchDataList[index]['pp_mrp'] -
//                                                         searchDataList[index]['pp_price']}'
//                                                     +
//                                                     ' (${searchDataList[index]['saved_percentage']
//                                                         .toStringAsFixed(2)}%)',
//                                                 style:
//                                                 GoogleFonts.poppins(
//                                                   color:
//                                                   Colors.grey,
//                                                   fontWeight: FontWeight
//                                                       .w500,),
//                                               )
//                                             ],
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: 10),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               SizedBox(width: 1),
//                               variantlist.isEmpty ? Text("") : Container(
//                                   child: InkWell(
//                                     onTap: () async {
//                                       var res = await bottomSheet(
//                                           variantlist, index);
//                                       if (res != null) {
//                                         subCategoriesImages[tabSelectedProductId]['products'][index]['selectedvariant'] =
//                                             res;
//                                       }
//                                       setState(() {});
//                                     },
//                                     child: Container(
//                                       padding: EdgeInsets.fromLTRB(15, 5, 8, 5),
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(30),
//                                         color: themeColor.getColor(),
//                                       ),
//                                       child: Row(
//                                         children: [
//                                           Text(
//                                             searchDataList[index]['selectedvariant']['variantName'] !=
//                                                 null
//                                                 ? searchDataList[index]['selectedvariant']['variantName']
//                                                 .toString()
//                                                 : "Variant",
//                                             style: GoogleFonts.poppins(
//                                                 color: Colors.white),
//                                           ),
//                                           SizedBox(
//                                               width: 5
//                                           ),
//                                           Image.asset(
//                                             "assets/icons/drop-down.png",
//                                             height: 10,
//                                             width: 10,
//                                             color: Colors.white,
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                   )
//                               ),
//
//                               bookOrderObj.productsInCart.length == 0 ||
//                                   bookOrderObj.productsInCart.length - 1 <
//                                       cartListIndex
//                                   ? addToCartBtnWidget(
//                                   index, themeColor, context) : bookOrderObj
//                                   .productsInCart[cartListIndex].productID
//                                   .toString() ==
//                                   searchDataList[index]['product_id'].toString()
//                                   ? addQuentityWidgetRow(
//                                   cartListIndex, themeColor, context,
//                                   searchDataList[index]['selectedvariant'] ==
//                                       null ? null :
//                                   searchDataList[index]['selectedvariant'])
//                                   : addToCartBtnWidget(
//                                   index, themeColor, context),
//                             ],
//                           ),
//                           Divider(
//                               thickness: 1
//                           )
//                         ],
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             ),
//           )
//         ],
//       )
//           : Container(
//         height: Get
//             .height * 0.8,
//         child: Center(child: Text(
//           Strings.pronotfound, style: GoogleFonts.poppins(
//           fontSize: 25, color: Colors.grey[500],),),),),
//     );
//   }
//
//
//   Widget addQuentityWidgetRow(int selectedIndex, ThemeNotifier themeColor,
//       BuildContext context, Map selectedVarient) {
//     print(selectedVarient);
//     return Container(
//       margin: EdgeInsets.only(right: 15),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Container(
//             padding: EdgeInsets.only(left: 10, right: 10, top: 4, bottom: 4),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(18),
//               color: themeColor.getColor(),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: <Widget>[
//                 InkWell(
//                     onTap: () {
//                       setState(() {
//                         if (selectedVarient != null) {
//                           if (selectedVarient['quantity'] > 1) {
//                             selectedVarient['quantity']--;
//                             bookOrderObj.productsInCart[selectedIndex]
//                                 .productQuantity = selectedVarient['quantity'];
//                           }
//                           bookOrderObj.addSelectedProductInCart(null);
//                         } else {
//                           if (bookOrderObj.productsInCart[selectedIndex]
//                               .minQuantity <
//                               bookOrderObj.productsInCart[selectedIndex]
//                                   .productQuantity) {
//                             bookOrderObj.productsInCart[selectedIndex]
//                                 .productQuantity--;
//                           }
//                           bookOrderObj.addSelectedProductInCart(null);
//                         }
//                       });
//                     },
//                     child: Text(
//                       "-",
//                       style: GoogleFonts.poppins(
//                           fontSize: 24, color: Colors.white),
//                     )),
//                 SizedBox(width: 9),
//                 Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(7),
//                       color: Color(0xFF707070),
//                     ),
//                     child: Container(
//                       alignment: Alignment.center,
//                       width: 30,
//                       padding: EdgeInsets.symmetric(horizontal: 3, vertical: 3),
//                       child: selectedVarient == null ?
//                       Text('${(bookOrderObj.productsInCart[selectedIndex]
//                           .productQuantity).toInt()}',
//                         style: GoogleFonts.poppins(
//                           color: Colors.white, fontSize: 16,),)
//                           : Text('${selectedVarient['quantity'].toInt()}',
//                         style: GoogleFonts.poppins(
//                           color: Colors.white, fontSize: 16,),),
//                     )),
//                 InkWell(
//                   onTap: () {
//                     setState(() {
//                       if (selectedVarient['quantity'] != null) {
//                         selectedVarient['quantity']++;
//                         bookOrderObj.productsInCart[selectedIndex]
//                             .productQuantity = selectedVarient['quantity'];
//                         bookOrderObj.addSelectedProductInCart(null);
//                       } else {
//                         bookOrderObj.productsInCart[selectedIndex]
//                             .productQuantity++;
//                         bookOrderObj.addSelectedProductInCart(null);
//                       }
//                     });
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.only(left: 9.0),
//                     child: Text("+",
//                       style: GoogleFonts.poppins(
//                         color: Colors.white, fontSize: 16,),),
//                   ),),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//   Widget addToCartBtnWidget(int index, ThemeNotifier themeColor,
//       BuildContext context) {
//     return InkWell(
//       onTap: () {
//         Loader().showLoader(context);
//         BookOrderModel.orderModelObj.refreshViewForOrderBooking();
//         searchDataList.length == 0 ?
//         getProductDetailsAndAddToCart(context,
//             subCategoriesImages[tabSelectedProductId]['products'][index]['product_id']
//                 .toString(), index) :
//         getProductDetailsAndAddToCart(
//             context, searchDataList[index]['product_id'].toString(), index);
//         setState(() {});
//       },
//       child: Container(
//         margin: EdgeInsets.only(right: 15),
//         padding: EdgeInsets.fromLTRB(10, 5, 8, 5),
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(30),
//             border: Border.all(color: themeColor.getColor())),
//         child: Row(
//           children: [
//             Image.asset(
//               "assets/icons/shopping-cart.png",
//               height: 18,
//               width: 20,
//               color: themeColor.getColor(),
//             ),
//             SizedBox(
//               width: 5,
//             ),
//             Text(
//               Strings.addToCart,
//               style: GoogleFonts.poppins(color: themeColor.getColor()),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void getProductDetailsAndAddToCart(BuildContext context,
//       String selectedProductID, int index) async {
//     bool isAdded = false;
//     String loggedInUserId = LoginModelClass.loginModelObj
//         .getValueForKeyFromLoginResponse(key: 'user_id');
//     print(selectedProductID);
//     if (GlobalModelClass.internetConnectionAvaiable() == true) {
//       http.Response resp = await http.get(
//           Base_URL +
//               productDetails +
//               '&logged_in_userid=$loggedInUserId&product_id=$selectedProductID',
//           headers: {
//             'Authorization': LoginModelClass.loginModelObj
//                 .getValueForKeyFromLoginResponse(key: 'token'),
//             'Content-Type': 'application/json',
//             'Accept': 'application/json',
//           });
//
//       // ignore: invalid_use_of_protected_member
//       Scaffold.of(context).setState(() {
//         bookOrderObj.showLoadingIndicator = false;
//       });
//       if (resp.statusCode == 200) {
//         var jsonBodyResp = jsonDecode(resp.body);
//
//         if (jsonBodyResp['status'] == true) {
//           // ignore: invalid_use_of_protected_member
//           bookOrderObj.selectedProduct = jsonBodyResp['products'];
//           bookOrderObj.currentProductVariants =
//           bookOrderObj.selectedProduct['available_variants'];
//           bookOrderObj.selectedVariant =
//               bookOrderObj.currentProductVariants.first;
//           if (bookOrderObj.productsInCart == null) {
//             bookOrderObj.productsInCart = [];
//           }
//
//           OrderedProduct tempProduct = bookOrderObj.getProductDetailsObject(
//               selectedVarientId: jsonBodyResp['products'],
//               productID: selectedProductID,
//               callType: 1);
//           setState(() {});
//           Loader().hideLoader(context);
//           if (bookOrderObj.selectedProduct['type'] == 'Variant') {
//             var res = await variantsBottomSheet((value) {
//               isAdded = value;
//               print('======$isAdded');
//               Scaffold.of(context).setState(() {
//                 Scaffold.of(context).showSnackBar(
//                   SnackBar(
//                     backgroundColor: mainColor,
//                     duration: Duration(seconds: 1),
//                     content: Text(
//                       isAdded
//                           ? Strings.aleardyadded
//                           : Strings.proadded,
//                       style: GoogleFonts.poppins(),
//                     ),
//                   ),
//                 );
//               });
//               setState(() {});
//             }, selectedProductID);
//             subCategoriesImages[tabSelectedProductId]['products'][index]['variantName'] =
//                 res;
//             setState(() {});
//           }
//           else {
//             for (var i = 0; i < bookOrderObj.productsInCart.length; i++) {
//               if (bookOrderObj.productsInCart[i].productVariantID ==
//                   tempProduct.productVariantID) {
//                 bookOrderObj.productsInCart.removeAt(i);
//                 isAdded = true;
//               } else {}
//             }
//
//             bookOrderObj.addSelectedProductInCart(tempProduct);
//             //This is comment
//             BookOrderModel.orderModelObj.refreshViewForOrderBooking();
//
//             Scaffold.of(context).setState(() {
//               Scaffold.of(context).showSnackBar(
//                 SnackBar(
//                   backgroundColor: mainColor,
//                   duration: Duration(seconds: 1),
//                   content: Text(
//                     isAdded
//                         ? Strings.aleardyadded
//                         : Strings.proadded,
//                     style: GoogleFonts.poppins(),
//                   ),
//                 ),
//               );
//             });
//           }
//           Scaffold.of(context).setState(() {});
//         } else {
//           //handle false conditions
//         }
//       } else {
//         print(resp.body);
//         print('Error occurred while serving request');
//       }
//     } else {
//       Future.delayed(Duration.zero, () {
//         GlobalModelClass.showAlertForNoInternetConnection(context).show();
//       });
//     }
//   }
//
//   variantsBottomSheet(Function addedCartFunction,
//       String selectedProductID) async {
//     var currrentIndex;
//     print('$selectedProductID?>?>?>');
//     OrderedProduct tempProduct = bookOrderObj.getProductDetailsObject(
//         selectedVarientId: bookOrderObj.selectedProduct,
//         productID: selectedProductID,
//         callType: 1,
//         variantIndex: selectedIndex,
//         isVariantAvailable: true);
//     print(tempProduct.productName);
//     return await showModalBottomSheet(
//       backgroundColor: Colors.white,
//       context: this.context,
//       builder: (BuildContext context) {
//         final themeColor = Provider.of<ThemeNotifier>(context);
//         return StatefulBuilder(
//           builder:
//               (BuildContext context, void Function(void Function()) setState) {
//             return Container(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: <Widget>[
//                   Container(
//                     height: Get
//                         .height * 0.07,
//                     padding: EdgeInsets.all(10),
//                     color: themeColor.getColor(),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           Strings.SelectVariants,
//                           style: GoogleFonts.poppins(color: Colors.white),
//                         ),
//                         InkWell(
//                             onTap: () {
//                               Get.back();
//                             },
//                             child: Icon(
//                               Icons.close,
//                               color: Colors.white,
//                             ))
//                       ],
//                     ),
//                   ),
//                   SizedBox(
//                     height: 5,
//                   ),
//                   Container(
//                     height: Get
//                         .height * 0.25,
//                     child: ListView.builder(
//                       scrollDirection: Axis.horizontal,
//                       shrinkWrap: true,
//                       itemCount: bookOrderObj
//                           .selectedProduct['available_variants'].length,
//                       itemBuilder: (BuildContext context,
//                           int index,) {
//                         return Column(
//                           children: [
//                             InkWell(
//                               onTap: () {
//                                 selectedIndex = index;
//                                 tempProduct =
//                                     bookOrderObj.getProductDetailsObject(
//                                         selectedVarientId:
//                                         bookOrderObj.selectedProduct,
//                                         productID: selectedProductID,
//                                         callType: 1,
//                                         variantIndex: selectedIndex,
//                                         isVariantAvailable: true);
//                                 currrentIndex = bookOrderObj
//                                     .selectedProduct['available_variants'][index]['variant_attri_name'];
//                                 setState(() {});
//                               },
//                               child: Container(
//                                 height: 80,
//                                 // width: 150,
//                                 width: 80,
//                                 decoration: BoxDecoration(
//                                     image: DecorationImage(
//                                       image: bookOrderObj.selectedProduct[
//                                       'available_variants'][index]
//                                           .containsKey(
//                                           'imagesize512x512') &&
//                                           bookOrderObj
//                                               .selectedProduct[
//                                           'available_variants'][index]
//                                           ['imagesize512x512']
//                                               .isNotEmpty
//                                           ? NetworkImage(bookOrderObj
//                                           .selectedProduct['available_variants']
//                                       [index]['imagesize512x512'][0]
//                                           .toString())
//                                           : AssetImage(
//                                           'assets/images/productPlaceaHolderImage.png'),
//                                       fit: BoxFit.cover,
//                                     )),
//                               ),
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 InkWell(
//                                   onTap: () {
//                                     selectedIndex = index;
//                                     tempProduct =
//                                         bookOrderObj.getProductDetailsObject(
//                                             selectedVarientId:
//                                             bookOrderObj.selectedProduct,
//                                             productID: selectedProductID,
//                                             callType: 1,
//                                             variantIndex: selectedIndex,
//                                             isVariantAvailable: true);
//                                     currrentIndex = bookOrderObj
//                                         .selectedProduct['available_variants'][index]['variant_attri_name'];
//                                     setState(() {});
//                                   },
//                                   child: Container(
//                                     margin: EdgeInsets.only(
//                                         top: 20, left: 10, bottom: 10),
//                                     padding: EdgeInsets.only(
//                                         top: 15, left: 15, right: 20),
//                                     decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(5),
//                                         border: Border.all(
//                                             color: currrentIndex ==
//                                                 bookOrderObj.selectedProduct[
//                                                 'available_variants']
//                                                 [index]
//                                                 ['variant_attri_name']
//                                                 ? themeColor.getColor()
//                                                 : Colors.grey[300])),
//                                     child: Container(
//                                         child: Text(
//                                           bookOrderObj.selectedProduct[
//                                           'available_variants'][index]
//                                           ['variant_attri_name'],
//                                           style: GoogleFonts.poppins(
//                                               color: Colors.grey[600]),
//                                         )),
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   width: 5,
//                                 )
//                               ],
//                             ),
//                           ],
//                         );
//                       },
//                     ),
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Container(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Container(
//                             width: Get
//                                 .width * 0.6),
//                         Container(
//                           width: 120,
//                           // height: 100,
//                           padding: EdgeInsets.only(
//                               left: 8, right: 8, top: 4, bottom: 4),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(18),
//                             color: themeColor.getColor(),
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: <Widget>[
//                               InkWell(
//                                   onTap: () {
//                                     setState(() {
//                                       if (tempProduct.minQuantity <
//                                           tempProduct.productQuantity) {
//                                         tempProduct.productQuantity--;
//                                       }
//                                       bookOrderObj
//                                           .addSelectedProductInCart(null);
//                                     });
//                                   },
//                                   child: Padding(
//                                     padding: const EdgeInsets.only(right: 16.0),
//                                     child: Text(
//                                       "-",
//                                       style: GoogleFonts.poppins(
//                                           fontSize: 24, color: Colors.white),
//                                     ),
//                                   )),
//                               Container(
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(10),
//                                     color: Color(0xFF707070),
//                                   ),
//                                   child: Container(
//                                       alignment: Alignment.center,
//                                       width: 40,
//                                       padding: const EdgeInsets.all(8.0),
//                                       child:
//                                       // availableVariants[0]  == currrentIndex?
//                                       // Text(
//                                       //     '${(quantity?.toInt() ?? 1.0).toInt()}',
//                                       //     style: GoogleFonts.poppins(
//                                       //         color: Colors.white, fontSize: 16)) :
//                                       Text(
//                                           '${(tempProduct?.productQuantity ??
//                                               1.0).toInt()}',
//                                           style: GoogleFonts.poppins(
//                                               color: Colors.white,
//                                               fontSize: 16))
//                                   )),
//                               InkWell(
//                                   onTap: () {
//                                     setState(() {
//                                       tempProduct.productQuantity++;
//                                       bookOrderObj
//                                           .addSelectedProductInCart(null);
//                                     });
//                                   },
//                                   child: Padding(
//                                     padding: const EdgeInsets.only(left: 16.0),
//                                     child: Text("+",
//                                         style: GoogleFonts.poppins(
//                                             fontSize: 24, color: Colors.white)),
//                                   )),
//                             ],
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Container(
//                     padding: EdgeInsets.only(right: 10, left: 10),
//                     margin: EdgeInsets.only(bottom: 10),
//                     width: Get
//                         .width,
//                     child: RaisedButton(
//                       color: themeColor.getColor(),
//                       onPressed: () {
//                         bool isAdded = false;
//                         Get.back(result: currrentIndex);
//                         // Navigator.pop(context,currrentIndex);
//                         for (var i = 0;
//                         i < bookOrderObj.productsInCart.length;
//                         i++) {
//                           if (bookOrderObj.productsInCart[i].productVariantID ==
//                               tempProduct.productVariantID) {
//                             bookOrderObj.productsInCart.removeAt(i);
//                             isAdded = true;
//                           } else {}
//                         }
//                         tempProduct.variantName = currrentIndex;
//                         bookOrderObj.addSelectedProductInCart(tempProduct);
//                         BookOrderModel.orderModelObj
//                             .refreshViewForOrderBooking();
//                         addedCartFunction(isAdded);
//                         BookOrderModel.orderModelObj
//                             .refreshViewForOrderBooking();
//                       },
//                       child: Container(
//                         padding: EdgeInsets.only(top: 10, bottom: 10),
//                         child: Text(
//                           Strings.addToCart,
//                           style: GoogleFonts.poppins(color: Colors.white),
//                         ),
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//
//   Widget ratingStar() {
//     final themeColor = Provider.of<ThemeNotifier>(context);
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: <Widget>[
//         RatingBar(
//           initialRating: 4,
//           itemSize: 16.0,
//           minRating: 1,
//           direction: Axis.horizontal,
//           allowHalfRating: true,
//           itemCount: 5,
//           itemBuilder: (context, _) =>
//               Container(
//                 height: 12,
//                 child: SvgPicture.asset(
//                   "assets/icons/ic_star.svg",
//                   color: themeColor.getColor(),
//                   width: 9,
//                 ),
//               ),
//           onRatingUpdate: (rating) {
//             print(rating);
//           },
//         ),
//         SizedBox(
//           width: 12,
//         ),
//         Text(
//           "(315)",
//           style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w400),
//         )
//       ],
//     );
//   }
//
//   bottomSheet(List<Map<String, dynamic>> availableVariants, index) async {
//     return showModalBottomSheet(
//       backgroundColor: Colors.white,
//       context: this.context,
//       builder: (BuildContext context) {
//         final themeColor = Provider.of<ThemeNotifier>(context);
//         return StatefulBuilder(
//           builder:
//               (BuildContext context, void Function(void Function()) setState) {
//             return Container(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: <Widget>[
//                   Container(
//                     height: Get
//                         .height * 0.07,
//                     padding: EdgeInsets.all(10),
//                     color: themeColor.getColor(),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           "Product Variant",
//                           style: GoogleFonts.poppins(color: Colors.white),
//                         ),
//                         InkWell(
//                             onTap: () {
//                               Get.back();
//                             },
//                             child: Icon(
//                               Icons.close,
//                               color: Colors.white,
//                             ))
//                       ],
//                     ),
//                   ),
//                   SizedBox(
//                     height: 5,
//                   ),
//                   SizedBox(height: 20),
//                   Container(
//                     height: 200,
//                     child: SingleChildScrollView(
//                       child: ListView.builder(
//                         shrinkWrap: true,
//                         physics: NeverScrollableScrollPhysics(),
//                         itemCount: availableVariants.length,
//                         itemBuilder: (BuildContext context, int index) {
//                           return Container(
//                               margin: EdgeInsets.only(left: 15),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   InkWell(
//                                     onTap: () {
//                                       Get.back(
//                                           result: availableVariants[index]);
//                                       // Navigator.pop(context,availableVariants[index]);
//                                     },
//                                     child: Text(
//                                       '${availableVariants[index]['variantName'] +
//                                           ' X ' +
//                                           availableVariants[index]['quantity']
//                                               .toString()}',
//                                       overflow: TextOverflow.ellipsis,
//                                       maxLines: 2,
//                                       style: GoogleFonts.poppins(),),
//                                   ),
//                                   SizedBox(height: 10)
//                                 ],
//                               )
//                           );
//                         },),
//                     ),
//                   )
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }
