import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shoppingapp/app_url_name_companyid.dart';
import 'package:shoppingapp/models/LoginModelClass.dart';
import 'package:shoppingapp/screen/auth_screens/login/login_form.dart';
import 'package:shoppingapp/screen/cart_screen/confirm_order_screen/confirmOrderVC.dart';
import 'package:shoppingapp/screen/category/category_level2/category_list.dart';
import 'package:shoppingapp/screen/category/widget/vertical_tab_category.dart';
import 'package:shoppingapp/utils/commons/colors.dart';
import 'package:shoppingapp/utils/constants/constants_app_variables.dart';
import 'package:shoppingapp/utils/dummy_data/category.dart';
import 'package:shoppingapp/utils/theme_notifier.dart';
import 'package:shoppingapp/widgets/commons/string_res.dart';
import 'package:http/http.dart' as http;

class CategoryLevel2Page extends StatefulWidget {
  @override
  _CategoryLevel2PageState createState() => _CategoryLevel2PageState();
}

class _CategoryLevel2PageState extends State<CategoryLevel2Page> {
  bool isShow = true;
  var currrentIndex;
  int counter = 0;
  int counter1 = 0;
  List data = [
    {'name': 'Guruji Thandai', 'status': '1', 'stock': '500'},
    {'name': 'Garnire SkinActive', 'status': '2', 'stock': '54'},
    {'name': "Men's Sport Shoes", 'status': '3', 'stock': '0'},
  ];

  List companyData = [
    {'name': 'ADIDAS'},
    {'name': 'PUMA'},
    {'name': 'GUCCI'},
    {'name': 'REEBOK'},
    {'name': 'NIKE'},
    {'name': 'ZARA'},
  ];

  List productCategories = [];
  bool allApiCall = true;
  bool categoryEmpty = false;

  @override
  void initState() {
    super.initState();
    currrentIndex;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<ThemeNotifier>(context);
    print("Current page --> $runtimeType");
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            Strings.level2title,
            style: GoogleFonts.poppins(color: Colors.black),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              !isShow ? CategoryListPage() : Container(height: 0),
              Stack(
                children: [
                  Container(
                    height: !isShow
                        ? Get.height - Get.height * 0.25
                        : Get.height - Get.height * 0.136,
                    child: !isShow ? productListView() : photoListView(),
                  ),
                  if (!isShow)
                    Align(
                      alignment: Alignment.topRight,
                      child: InkWell(
                        onTap: () {
                          isShow = true;
                          setState(() {});
                        },
                        child: Container(
                          height: 25,
                          width: 25,
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
                  else
                    Align(
                      alignment: Alignment.topRight,
                      child: InkWell(
                        onTap: () {
                          isShow = false;
                          setState(() {});
                        },
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 1.9),
                              height: 30,
                              width: 48,
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
                            Container(
                              // height: Get.height - Get.height * 0.186,
                              child: Expanded(
                                child: VerticalTabsForCategory(
                                  indicatorColor: themeColor.getColor(),
                                  selectedTabBackgroundColor: whiteColor,
                                  tabBackgroundColor: themeColor.getColor(),
                                  backgroundColor: greyBackground,
                                  direction: TextDirection.rtl,
                                  tabsWidth: 48,
                                  tabsTitle: categories.map((e) => e['product_cat_name'].toString()).toList(),
                                    tabs: categories.map((e) =>
                                  Tab(
                                    child: RotatedBox(
                                      quarterTurns: 1,
                                      child: RichText(
                                        text: TextSpan(
                                          text: 'Flutter',
                                          style:
                                          DefaultTextStyle
                                              .of(context)
                                              .style
                                              .copyWith(),
                                        ),
                                      ),
                                    ),
                                    icon: Icon(Icons.phone),))
                                .toList(),
                                    contents: categories
                                        .map((e) => tabsContent(themeColor))
                                      .toList(),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget productListView() {
    final themeColor = Provider.of<ThemeNotifier>(context);
    return SingleChildScrollView(
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          return Row(
            children: [
              Container(
                margin: EdgeInsets.only(top: 5),
                height: Get.height * 0.3,
                width: !isShow ? Get.width : Get.width - 40,
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        width: !isShow ? Get.width : Get.width - 50,
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.only(top: 5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    "assets/images/drink.jpg",
                                    height: Get.height * 0.13,
                                    width: Get.width * 0.3,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width:
                                  !isShow ? Get.width * 0.65 : Get.width * 0.54,
                              child: Column(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Guruji Thandai",
                                        style: GoogleFonts.poppins(
                                          color: Colors.grey[500],
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          Strings.mrp,
                                          style: GoogleFonts.poppins(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          "₹1250",
                                          style: GoogleFonts.poppins(
                                            color: Colors.grey,
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          Strings.Price,
                                          style: GoogleFonts.poppins(
                                            color: showMBPrimaryColor ?millBornPrimaryColor :themeColor.getColor(),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          "₹1000",
                                          style: GoogleFonts.poppins(
                                            color: showMBPrimaryColor ?millBornPrimaryColor :themeColor.getColor(),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          Strings.discount_rate,
                                          style: GoogleFonts.poppins(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          "₹ 250(20%)",
                                          style: GoogleFonts.poppins(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(width: 1),
                        InkWell(
                          onTap: () {
                            // _VariantsBottomSheet();
                          },
                          child: Container(
                            padding: EdgeInsets.fromLTRB(30, 5, 15, 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: themeColor.getColor(),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  "190 ml",
                                  style:
                                      GoogleFonts.poppins(color: Colors.white),
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
                        ),
                        InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 10),
                            padding: EdgeInsets.fromLTRB(10, 5, 8, 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border:
                                    Border.all(color: themeColor.getColor())),
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
                                      color: themeColor.getColor()),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    Divider(thickness: 1)
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget photoListView() {
    return SingleChildScrollView(
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Energy Drinks",
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  height: 200,
                  width: 290,
                  child: Image.asset(
                    "assets/images/category_image3.png",
                    fit: BoxFit.fill,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  void variantsBottomSheet() {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (BuildContext context) {
        final themeColor = Provider.of<ThemeNotifier>(context);
        return StatefulBuilder(
          builder:
              (BuildContext context, void Function(void Function()) setState) {
            return Container(
              height: Get.height * 0.5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                    height: Get.height * 0.21,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: data.length,
                      itemBuilder: (
                        BuildContext context,
                        int index,
                      ) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                currrentIndex = data[index];
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
                                    color: currrentIndex == data[index]
                                        ? themeColor.getColor()
                                        : Colors.grey[300],
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 50,
                                          child: Text(
                                            "Size:",
                                            style: GoogleFonts.poppins(
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "5 UK / 4 US",
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          width: 50,
                                          child: Text(
                                            "Color:",
                                            style: GoogleFonts.poppins(
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "Red",
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          width: 50,
                                          child: Text(
                                            "Style:",
                                            style: GoogleFonts.poppins(
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "Checked",
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 5)
                          ],
                        );
                      },
                    ),
                  ),
                  Container(
                    height: Get.height * 0.11,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          width: Get.width * 0.38,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: themeColor.getColor(),
                                ),
                                width: Get.width * 0.4,
                                height: Get.height * 0.07,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        if (counter != 0) {
                                          setState(() {
                                            counter--;
                                          });
                                        }
                                      },
                                      child: Icon(
                                        Icons.remove,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Container(
                                      width: Get.width * 0.11,
                                      margin:
                                          EdgeInsets.only(top: 5, bottom: 5),
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.white),
                                      ),
                                      child: Center(
                                        child: Text(
                                          counter.toString(),
                                          style: GoogleFonts.poppins(
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        counter++;
                                        setState(() {});
                                      },
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Center(
                                child: Text(
                                  "Cases",
                                  style: GoogleFonts.poppins(),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(width: Get.width * 0.18),
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          width: Get.width * 0.38,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: themeColor.getColor(),
                                ),
                                width: Get.width * 0.4,
                                height: Get.height * 0.07,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        if (counter1 != 0) {
                                          setState(() {
                                            counter1--;
                                          });
                                        }
                                      },
                                      child: Icon(
                                        Icons.remove,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Container(
                                      width: Get.width * 0.11,
                                      margin:
                                          EdgeInsets.only(top: 5, bottom: 5),
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.white),
                                      ),
                                      child: Center(
                                        child: Text(
                                          counter1.toString(),
                                          style: GoogleFonts.poppins(
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        counter1++;
                                        setState(() {});
                                      },
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Center(
                                child: Text(
                                  "Units",
                                  style: GoogleFonts.poppins(),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.only(right: 10, left: 10),
                    width: Get.width,
                    child: RaisedButton(
                      color: themeColor.getColor(),
                      onPressed: () {
                        Get.back();
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

  Widget tabsContent(ThemeNotifier themeColor, [String description = '']) {
    return Container(
      child: ListView.builder(
        itemCount: subCategories.length,
        itemBuilder: (context, index) {
          return SizedBox();
        },
      ),
    );
  }

  // Widget tabsContent(ThemeNotifier themeColor, String caption,
  //     [String description = '']) {
  //   return Container(
  //     padding: EdgeInsets.only(left: 5, right: 5),
  //     color: greyBackground,
  //     child: ListView.builder(
  //       itemCount: 1,
  //       itemBuilder: (context, index) {
  //         return Row(
  //           children: [
  //             Container(
  //               margin: EdgeInsets.only(top: 5),
  //               height: Get.height * 0.3,
  //               child: Column(
  //                 children: [
  //                   Row(
  //                     children: [
  //                       Container(
  //                         padding: EdgeInsets.only(top: 5),
  //                         child: Column(
  //                           mainAxisAlignment: MainAxisAlignment.start,
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             Image.asset(
  //                               "assets/images/drink.jpg",
  //                               height: Get.height * 0.13,
  //                               width: Get.width * 0.3,
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                       Container(
  //                         width: Get.width * 0.67,
  //                         child: Column(
  //                           children: [
  //                             Column(
  //                               crossAxisAlignment: CrossAxisAlignment.start,
  //                               children: [
  //                                 Text(
  //                                   "Guruji Thandai",
  //                                   style: GoogleFonts.poppins(
  //                                     color: Colors.grey[500],
  //                                     fontSize: 20,
  //                                     fontWeight: FontWeight.w400,
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                             Row(
  //                               mainAxisAlignment: MainAxisAlignment.end,
  //                               children: [
  //                                 Text(
  //                                   Strings.mrp,
  //                                   style:
  //                                       GoogleFonts.poppins(color: Colors.grey),
  //                                 ),
  //                                 Text(
  //                                   "₹1250",
  //                                   style: GoogleFonts.poppins(
  //                                     color: Colors.grey,
  //                                     decoration: TextDecoration.lineThrough,
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                             Row(
  //                               mainAxisAlignment: MainAxisAlignment.end,
  //                               children: [
  //                                 Text(
  //                                   Strings.Price,
  //                                   style: GoogleFonts.poppins(
  //                                     color: themeColor.getColor(),
  //                                     fontWeight: FontWeight.w500,
  //                                     fontSize: 16,
  //                                   ),
  //                                 ),
  //                                 Text(
  //                                   "₹1000",
  //                                   style: GoogleFonts.poppins(
  //                                     color: themeColor.getColor(),
  //                                     fontWeight: FontWeight.w500,
  //                                     fontSize: 16,
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                             Row(
  //                               mainAxisAlignment: MainAxisAlignment.end,
  //                               children: [
  //                                 Text(
  //                                   Strings.yousave,
  //                                   style:
  //                                       GoogleFonts.poppins(color: Colors.grey),
  //                                 ),
  //                                 Text(
  //                                   "₹ 250(20%)",
  //                                   style: GoogleFonts.poppins(
  //                                     color: Colors.grey,
  //                                     fontWeight: FontWeight.w500,
  //                                   ),
  //                                 )
  //                               ],
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   SizedBox(height: 10),
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       SizedBox(width: 10),
  //                       InkWell(
  //                         onTap: () {
  //                           _variantsBottomSheet();
  //                         },
  //                         child: Container(
  //                           padding: EdgeInsets.fromLTRB(35, 5, 8, 5),
  //                           decoration: BoxDecoration(
  //                             borderRadius: BorderRadius.circular(30),
  //                             color: themeColor.getColor(),
  //                           ),
  //                           child: Row(
  //                             children: [
  //                               Text(
  //                                 "190 ml",
  //                                 style:
  //                                     GoogleFonts.poppins(color: Colors.white),
  //                               ),
  //                               SizedBox(width: 5),
  //                               Image.asset(
  //                                 "assets/icons/drop-down.png",
  //                                 height: 10,
  //                                 width: 10,
  //                                 color: Colors.white,
  //                               )
  //                             ],
  //                           ),
  //                         ),
  //                       ),
  //                       InkWell(
  //                         onTap: () {
  //                           Get.back();
  //                         },
  //                         child: Container(
  //                           margin: EdgeInsets.only(right: 15),
  //                           padding: EdgeInsets.fromLTRB(10, 5, 8, 5),
  //                           decoration: BoxDecoration(
  //                             borderRadius: BorderRadius.circular(30),
  //                             border: Border.all(color: themeColor.getColor()),
  //                           ),
  //                           child: Row(
  //                             children: [
  //                               Image.asset(
  //                                 "assets/icons/shopping-cart.png",
  //                                 height: 18,
  //                                 width: 20,
  //                                 color: themeColor.getColor(),
  //                               ),
  //                               SizedBox(width: 5),
  //                               Text(
  //                                 Strings.addToCart,
  //                                 style: GoogleFonts.poppins(
  //                                   color: themeColor.getColor(),
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                       )
  //                     ],
  //                   ),
  //                   Divider(thickness: 1)
  //                 ],
  //               ),
  //             ),
  //           ],
  //         );
  //       },
  //     ),
  //   );
  // }

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
                  '&logged_in_userid=$loggedInUserId&category_id=${productCategories[i]['product_cat_id']}&brand_id&price_min&price_max&sort_by&limit=500&page=1'),
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
            } else {}
          } else {
            print('Error occurred while serving request');
          }
        }
        print(categories.length);
      } else {
        categoryEmpty = true;
        allApiCall = false;
        setState(() {});
      }
      bookOrderObj.showLoadingIndicator = false;
    } else {
      productCategories = null;
      print('Error occurred while serving request');
    }
    bookOrderObj.showLoadingIndicator = false;
    allApiCall = false;
    setState(() {});
  }

  void refreshView() {
    setState(() {});
  }
}
