import 'dart:convert';

import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';

import 'package:flutter/material.dart';
import 'package:getflutter/components/button/gf_button.dart';
import 'package:getflutter/getflutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shoppingapp/app_url_name_companyid.dart';
import 'package:shoppingapp/models/BookOrderModel.dart';
import 'package:get/get.dart';
import 'package:shoppingapp/models/GlobalModelClass.dart';
import 'package:shoppingapp/models/LoginModelClass.dart';
import 'package:shoppingapp/screen/cart_screen/confirm_order_screen/confirmOrderVC.dart';
import 'package:shoppingapp/screen/my_profile/profile_setting/address_pages/new_address/new_adress_page.dart';
import 'package:shoppingapp/utils/commons/colors.dart';
import 'package:shoppingapp/utils/constants/constants_app_variables.dart';
import 'package:shoppingapp/utils/navigator.dart';
import 'package:shoppingapp/utils/theme_notifier.dart';
import 'package:shoppingapp/widgets/commons/custom_alert.dart';
import 'package:shoppingapp/widgets/commons/string_res.dart';
import 'package:shoppingapp/screen/cart_screen/widget/shopping_cart_item.dart';
import 'package:http/http.dart' as http;

final BookOrderModel bookOrderObj = BookOrderModel.orderModelObj;
List addressListForBookOrder = [];

// ignore: must_be_immutable
class ShoppingCartPage extends StatefulWidget {
  ShoppingCartPage({this.showBackArrow = false});

  bool showBackArrow;

  @override
  State<StatefulWidget> createState() {
    return new HomeWidgetState(backArrow: this.showBackArrow);
  }
}

class HomeWidgetState extends State<ShoppingCartPage>
    with SingleTickerProviderStateMixin {
  HomeWidgetState({this.backArrow});

  var stateName;
  var pincodeNo;
  var totalTaxValue;
  var gstValue;
  var sGst;
  var cGst;

  final bool backArrow;

  List<TextEditingController> qtyController = [];

  void updateView() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    getAddressListFromServer();
    getSchemeInfo(BookOrderModel.orderModelObj.getSchemeInfoBody());
  }

  void getAddressListFromServer() async {
    String loggedInUserId = LoginModelClass.loginModelObj
        .getValueForKeyFromLoginResponse(key: 'user_id');

    if (GlobalModelClass.internetConnectionAvaiable() == true) {
      http.Response resp = await http.get(
          Uri.parse(
              Base_URL + addressList + '&logged_in_userid=$loggedInUserId'),
          headers: {
            'Authorization': LoginModelClass.loginModelObj
                .getValueForKeyFromLoginResponse(key: 'token'),
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          });

      bookOrderObj.showLoadingIndicator = true;
      if (this.mounted) {
        setState(() {});
      }

      if (resp.statusCode == 200) {
        var jsonBodyResp = jsonDecode(resp.body);

        if (jsonBodyResp['status'] == true) {
          setState(() {
            addressListForBookOrder = jsonBodyResp['result'] ?? [];
            bookOrderObj.showLoadingIndicator = false;
            bookOrderObj.selectedAddressForOrderBooking =
                addressListForBookOrder
                        .where((element) =>
                            element['is_default_address'].toString() == '1')
                        ?.first ??
                    {};
          });
        } else {
          //handle false conditions
        }
      } else {
        bookOrderObj.showLoadingIndicator = false;
        setState(() {});

        print('Error occurred while serving request');
      }
    } else {
      Future.delayed(Duration.zero, () {
        GlobalModelClass.showAlertForNoInternetConnection(context, updateView)
            .show();
      });
    }
  }

  void reloadView(Function fun) {
    BookOrderModel.orderModelObj.refreshViewForOrderBooking();
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getSchemeInfo(Map body) async {
    // Map<String, dynamic> body = bookOrderObj.getSchemeInfoBody();
    http.Response response = await http.post(
      Uri.parse(getSchemeAppliedInfo),
      headers: {
        'Authorization': LoginModelClass.loginModelObj
            .getValueForKeyFromLoginResponse(key: 'token'),
        'Content-Type': 'application/json',
        'Accept-Encoding': "gzip, deflate, br",
      },
      body: jsonEncode(body),
    );
    print("aaa = ${response.body}");

    if (response.statusCode == 200) {
      bookOrderObj.schemeInfo = jsonDecode(response.body);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<ThemeNotifier>(context);
    print("Current screen => $runtimeType");
    return SafeArea(
      child: Scaffold(
        backgroundColor: whiteColor,
        body: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 26),
                  shoppingCartInfo(this.backArrow),
                  SizedBox(height: 12),
                  (bookOrderObj.productsInCart?.length ?? 0) == 0
                      ? Align(
                          alignment: Alignment.center,
                          child: Container(
                            height: Get.height,
                            width: Get.width,
                            child:
                                Image.asset('assets/images/emptyCartIcon.jpeg'),
                          ),
                        )
                      : ListView.builder(
                          physics: ScrollPhysics(),
                          itemCount: (((bookOrderObj.productsInCart?.length ??
                                              0) +
                                          bookOrderObj
                                              .setOrderBookingFooterView()
                                              ?.length) +
                                      (addressListForBookOrder?.length ?? 0) ??
                                  0) +
                              1,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (_, index) {
                         /*   if(bookOrderObj.schemeInfo[
                            'products'].length-1 < index){
                              return SizedBox();
                            }*/
                            qtyController = [];
                            List.generate(
                                bookOrderObj.productsInCart?.length,
                                (index) =>
                                    qtyController.add(TextEditingController()));

                            if ((((bookOrderObj.productsInCart?.length ?? 0) +
                                    (bookOrderObj
                                            .setOrderBookingFooterView()
                                            ?.length ??
                                        0)) <=
                                index)) {
                              if (((bookOrderObj.productsInCart?.length ?? 0) +
                                      (bookOrderObj
                                              .setOrderBookingFooterView()
                                              ?.length ??
                                          0)) ==
                                  index) {
                                return Container(
                                  padding: EdgeInsets.all(5.0),
                                  margin: EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        Strings.shipaddress,
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 17,
                                          color: Color(0xFF5D6A78),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Center(
                                        child: RaisedButton(
                                          color: mainColor,
                                          onPressed: () async {
                                            var data = await Get.to(
                                                () => NewAddressPage());
                                            getAddressListFromServer();
                                          },
                                          child: Text(
                                            Strings.addnewaddress,
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              }

                              return buildAddressItem(
                                  context,
                                  index -
                                      (((bookOrderObj.productsInCart?.length ??
                                                  0) +
                                              (bookOrderObj
                                                      .setOrderBookingFooterView()
                                                      ?.length ??
                                                  0)) +
                                          1),
                                  reloadView);
                            } else if ((bookOrderObj.productsInCart?.length ??
                                    0) ==
                                index) {
                              return Column(
                                children: [
                                  SizedBox(height: 5),
                                  Container(
                                    height: 1.5,
                                    margin: EdgeInsets.symmetric(vertical: 10),
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  bookOrderObj.schemeInfo == null
                                      ? SizedBox()
                                      : totalList(
                                          "Subtotal",
                                          "${getFinalSubtotal().toStringAsFixed(2)}",
                                        ),
                                  bookOrderObj.schemeInfo == null
                                      ? SizedBox()
                                      : bookOrderObj.schemeInfo[
                                                  'scheme_Discount_Amount'] ==
                                              0
                                          ? SizedBox()
                                          : totalList(
                                              "Scheme Discount",
                                              "- ${double.parse(bookOrderObj.schemeInfo['scheme_Discount_Amount'].toString()).toStringAsFixed(2)}",
                                            ),
                                  bookOrderObj.schemeInfo == null
                                      ? SizedBox()
                                      : Align(
                                          alignment: Alignment.centerRight,
                                          child: Container(
                                            height: 1.5,
                                            width: 100,
                                            margin: EdgeInsets.only(right: 22),
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                  bookOrderObj.schemeInfo == null
                                      ? SizedBox()
                                      : totalList(
                                          "Order Total",
                                          "${double.parse(bookOrderObj.schemeInfo['order_totalAmount'].toString()).toStringAsFixed(2)}",
                                        ),
                                  Container(
                                    padding: EdgeInsets.all(5.0),
                                    margin: EdgeInsets.all(10.0),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      Strings.schemes,
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 17,
                                        color: Color(0xFF5D6A78),
                                      ),
                                    ),
                                  ),
                                  schemeList(),
                                ],
                              );
                            } else if ((bookOrderObj.productsInCart?.length ??
                                    0) <
                                index) {
                              return SizedBox();
                              /*return shoppingCartBottomSummary(
                                themeColor,
                                (index -
                                    (bookOrderObj.productsInCart?.length ?? 0)),
                              );*/
                            } else {
                              return InkWell(
                                onTap: () {
                                  int productIndex = 0;
                                  // setState(() {
                                  //   count = bookOrderObj.productsInCart[selectedIndex].productQuantity;
                                  //   // bookOrderObj.addSelectedProductInCart(null);
                                  // });
                                  for (var i = 0;
                                      i < bookOrderObj.productsInCart.length;
                                      i++) {
                                    if (bookOrderObj
                                            .productsInCart[i].productID ==
                                        bookOrderObj
                                            .productsInCart[index].productID
                                            .toString()) {
                                      productIndex = i;
                                    }
                                  }
                                },
                                child: Column(
                                  children: [
                                    bookOrderObj.schemeInfo == null
                                        ? SizedBox()
                                        : ShoppingCartItem(
                                      variantName: "",
                                            themeColor: themeColor,
                                            imageUrl: "prodcut2.png",
                                            orderProd: bookOrderObj
                                                .productsInCart[index],
                                            onCallback: reloadView,
                                            qtyController: qtyController[index],
                                            showOffer:  bookOrderObj.schemeInfo[
                                            'products'].length-1 < index ?false
                                            // bookOrderObj
                                            //             .schemeInfo['products']
                                            //             .length ==
                                            //         0
                                            //     ? false
                                                : !(bookOrderObj.schemeInfo[
                                                                    'products']
                                                                [index][
                                                            'product_message'] ==
                                                        null ||
                                                    bookOrderObj
                                                        .schemeInfo['products']
                                                            [index]
                                                            ['product_message']
                                                        .toString()
                                                        .contains(
                                                            'Scheme is not available')),
                                            onOfferTap: () {
                                              openDialog(
                                                context,
                                                offer: [
                                                  bookOrderObj.schemeInfo[
                                                          'products'][index]
                                                      ['product_message']
                                                ],
                                              );
                                            },
                                            onAddRemoveTap: () {
                                              getSchemeInfo(BookOrderModel
                                                  .orderModelObj
                                                  .getSchemeInfoBody());
                                            },
                                          ),
                                    productPriceList(index),
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                  SizedBox(height: 50.0),
                ],
              ),
            ),
            // ignore: null_aware_before_operator
            bookOrderObj.productsInCart == null
                ? SizedBox()
                : bookOrderObj.productsInCart.length > 0
                    ? Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: Get.width,
                          height: 40.0,
                          child: GFButton(
                            color: mainColor,
                            onPressed: () {
                              if (bookOrderObj.selectedAddressForOrderBooking !=
                                      null &&
                                  (bookOrderObj.selectedAddressForOrderBooking
                                              ?.keys?.length ??
                                          0) >
                                      0) {
                                var data = Nav.route(
                                    context,
                                    ConfirmOrderWidgetState(
                                        pincode: pincodeNo.toString(),
                                        state: stateName.toString(),
                                        showBackArrow: true));
                                if (data != null) {
                                  BookOrderModel.orderModelObj
                                      .refreshViewForOrderBooking();
                                  setState(() {});
                                }
                                bookOrderObj.productsInCart;
                                getAddressListFromServer();
                              } else {
                                Alert(
                                  context: context,
                                  title: Strings.addmandatory,
                                  desc: Strings.pleaseselectaddress,
                                  buttons: [
                                    DialogButton(
                                      child: Text(
                                        Strings.ok,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () {
                                        Get.back();
                                      },
                                    ),
                                  ],
                                ).show();
                              }
                            },
                            child: Text(
                              Strings.proceedtochechout,
                              style: TextStyle(fontSize: 14.0),
                            ),
                          ),
                        ),
                      )
                    : SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget schemeList() {
    int index = 0;
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: Column(
        children: [
          Column(
            children: bookOrderObj.schemeInfo == null
                ? [SizedBox()]
                : bookOrderObj.schemeInfo['products'].map<Widget>((e) {
                    if (e['product_message'].contains("Scheme is not") ==
                        true) {
                    } else {
                      index++;
                    }

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: 15),
                        e['product_message'].contains("Scheme is not")
                            ? SizedBox()
                            : Text("$index. "),
                        e['product_message'].contains("Scheme is not")
                            ? SizedBox()
                            : Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: Text("${e['product_message']}"),
                                ),
                              ),
                      ],
                    );
                  }).toList(),
          ),
          bookOrderObj.schemeInfo == null
              ? SizedBox()
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: 15),
                    bookOrderObj.schemeInfo['orderamount_message']
                            .contains("Scheme is not")
                        ? SizedBox()
                        : Text("${index + 1}. "),
                    bookOrderObj.schemeInfo['orderamount_message']
                            .contains("Scheme is not")
                        ? SizedBox()
                        : Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Text(
                                  "${bookOrderObj.schemeInfo['orderamount_message']}"),
                            ),
                          ),
                  ],
                ),
        ],
      ),
    );
  }

  Widget shoppingCartInfo(bool showBackArrow) {
    return Container(
      margin: EdgeInsets.only(left: 24),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Icon(
              Platform.isAndroid ? Icons.arrow_back : Icons.chevron_left,
              size: 25,
            ),
          ),
          SizedBox(width: 15.0),
          Text(
            Strings.MyShoppingCart,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: Color(0xFF5D6A78),
            ),
          ),
          SizedBox(width: 16),
          Text(
            '${bookOrderObj.productsInCart?.length ?? 0} ${Strings.products}',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w400,
              fontSize: 12,
              color: Color(0xFF5D6A78),
            ),
          ),
        ],
      ),
    );
  }

  Container buildAddressItem(
      BuildContext context, int index, Function callBack) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.2),
            blurRadius: 6.0, // soften the shadow
            offset: Offset(0.0, 1.0),
          )
        ],
      ),
      child: Column(
        children: [
          (addressListForBookOrder[index]['is_default_address']?.toString() ??
                      '') ==
                  '1'
              ? Container(
                  width: Get.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: Get.width * 0.8,
                        child: Align(
                          child: Text(
                            addressListForBookOrder[index]['address_label']
                                .toString(),
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          alignment: Alignment.topLeft,
                        ),
                      ),
                      // Align(
                      //   child: Text(
                      //     Strings.DefaultAddress,
                      //     style: GoogleFonts.poppins(
                      //       fontSize: 16,
                      //       color: Colors.black,
                      //       fontWeight: FontWeight.w400,
                      //     ),
                      //   ),
                      //   alignment: Alignment.topLeft,
                      // ),
                      Container(
                        width: 30,
                        child: IconButton(
                          icon: (bookOrderObj.selectedAddressForOrderBooking !=
                                      null &&
                                  bookOrderObj.selectedAddressForOrderBooking ==
                                      addressListForBookOrder[index])
                              ? Icon(Icons.check_box)
                              : Icon(Icons.check_box_outline_blank),
                          onPressed: () {
                            print(addressListForBookOrder[index]['pincode']
                                .toString());
                            if (bookOrderObj.selectedAddressForOrderBooking ==
                                addressListForBookOrder[index]) {
                              bookOrderObj.selectedAddressForOrderBooking = {};
                            } else {
                              bookOrderObj.selectedAddressForOrderBooking =
                                  addressListForBookOrder[index];
                            }
                            callBack(() {});
                            stateName = addressListForBookOrder[index]['state'];
                            pincodeNo =
                                addressListForBookOrder[index]['pincode'];
                          },
                          iconSize: 30.0,
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox(),
          (addressListForBookOrder[index]['is_default_address']?.toString() ??
                      '') !=
                  '1'
              ? Align(
                  child: IconButton(
                    icon:
                        (bookOrderObj.selectedAddressForOrderBooking != null &&
                                bookOrderObj.selectedAddressForOrderBooking ==
                                    addressListForBookOrder[index])
                            ? Icon(Icons.check_box)
                            : Icon(Icons.check_box_outline_blank),
                    onPressed: () {
                      if (bookOrderObj.selectedAddressForOrderBooking ==
                          addressListForBookOrder[index]) {
                        bookOrderObj.selectedAddressForOrderBooking = {};
                      } else {
                        bookOrderObj.selectedAddressForOrderBooking =
                            addressListForBookOrder[index];
                      }
                      callBack(() {});
                    },
                    iconSize: 30.0,
                  ),
                  alignment: Alignment.topRight,
                )
              : SizedBox(),
          Row(
            children: [
              Expanded(
                child: AutoSizeText(
                  '${addressListForBookOrder[index]['name'].toString()}' +
                      '\n${addressListForBookOrder[index]['street_address'].toString()}' +
                      ', ${addressListForBookOrder[index]['town'].toString()}' +
                      '\n${addressListForBookOrder[index]['state'].toString()}' +
                      '\n${addressListForBookOrder[index]['contry'].toString()}' +
                      ' - ${addressListForBookOrder[index]['pincode'].toString()}',
                  minFontSize: 12.0,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      margin: EdgeInsets.only(bottom: 18),
      padding: EdgeInsets.only(top: 10, left: 24, right: 10, bottom: 15),
    );
  }

  Widget totalList(String title, String value) {
    return Padding(
      padding:
          EdgeInsets.only(left: 22.0, right: 22.0, top: 10.0, bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AutoSizeText(
            title,
            maxLines: 5,
            minFontSize: 17,
            textAlign: TextAlign.right,
          ),
          AutoSizeText(
            value,
            maxLines: 5,
            minFontSize: 17,
            textAlign: TextAlign.left,
          )
        ],
      ),
    );
  }

  double getFinalSubtotal() {
    double fValue = 0;
    if (bookOrderObj.schemeInfo != null) {
      bookOrderObj.schemeInfo['products'].forEach((e) {
        fValue = fValue + e['product_amount'];
      });
    }
    return fValue;
  }

  Widget shoppingCartBottomSummary(ThemeNotifier themeColor, int index) {
    return Padding(
      padding:
          EdgeInsets.only(left: 22.0, right: 22.0, top: 10.0, bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              if ((bookOrderObj.footerList[index]).keys.first == "TotalTax") {
                totalTaxValue = (bookOrderObj.footerList[index]).values.first;
                totalTaxValue == '0.0'
                    ? SizedBox()
                    : bottomSheet(totalTaxValue);
              }
            },
            child: (bookOrderObj.footerList[index]).keys.first == "TotalTax"
                ? Row(
                    children: [
                      AutoSizeText(
                        '${(bookOrderObj.footerList[index]).keys.first}',
                        maxLines: 5,
                        minFontSize: 17,
                        textAlign: TextAlign.right,
                      ),
                      SizedBox(width: 5),
                      Image.asset(
                        "assets/icons/info.png",
                        height: 18,
                        width: 18,
                        color: Colors.red,
                      )
                    ],
                  )
                : AutoSizeText(
                    '${(bookOrderObj.footerList[index]).keys.first}',
                    maxLines: 5,
                    minFontSize: 17,
                    textAlign: TextAlign.right,
                  ),
          ),
          AutoSizeText(
            '$currencySymbol ${(bookOrderObj.footerList[index]).values.first}',
            maxLines: 5,
            minFontSize: 17,
            textAlign: TextAlign.left,
          )
        ],
      ),
    );
    // return Container(
    //   decoration: BoxDecoration(
    //       color: Colors.white,
    //       borderRadius: BorderRadius.only(
    //           topLeft: Radius.circular(12), topRight: Radius.circular(12)),
    //       boxShadow: [
    //         BoxShadow(
    //           color: Colors.grey.withOpacity(.3),
    //           blurRadius: 9.0, // soften the shadow
    //           spreadRadius: 0.0, //extend the shadow
    //           offset: Offset(
    //             0.0, // Move to right 10  horizontally
    //             0.0, // Move to bottom 10 Vertically
    //           ),
    //         )
    //       ]),
    //   height: (bookOrderObj.productsInCart?.length ?? 0) == 0 ? 0 : 80,
    //   padding: EdgeInsets.all(16),
    //   child: (bookOrderObj.productsInCart?.length ?? 0) == 0
    //       ? Container()
    //       : Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: <Widget>[
    //             Column(
    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: <Widget>[
    //                 Text(
    //                   "Total",
    //                   style: GoogleFonts.poppins(
    //                       fontWeight: FontWeight.bold,
    //                       color: themeColor.getColor()),
    //                 ),
    //                 Text(
    //                   bookOrderObj.productsInCart == null
    //                       ? '0'
    //                       : "${(bookOrderObj.productsInCart.map((e) => e.productPrice * e.productQuantity)).fold(0.0, (previousValue, element) => previousValue + element)}",
    //                   style: GoogleFonts.poppins(color: themeColor.getColor()),
    //                 ),
    //               ],
    //             ),
    //             GFButton(
    //               color: themeColor.getColor(),
    //               child: Text(
    //                 "Confirm",
    //                 style: GoogleFonts.poppins(color: whiteColor, fontSize: 10),
    //               ),
    //               onPressed: () {
    //                 Nav.route(context, OrderPage());
    //               },
    //               type: GFButtonType.solid,
    //               shape: GFButtonShape.pills,
    //             )
    //           ],
    //         ),
    // );
  }

  void bottomSheet(String totalTax) {
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
                          Strings.taxdetails,
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
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10, left: 15),
                    child: Text(
                      "${Strings.totaltax} $currencySymbol $totalTax",
                      style: GoogleFonts.poppins(),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 200,
                    child: SingleChildScrollView(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: BookOrderModel
                                ?.orderModelObj?.productsInCart?.length ??
                            0,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            margin: EdgeInsets.only(left: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // bookOrderObj.selectedRetailerSupplier['gst_apply'] == "IGST"
                                //     ?
                                Text(
                                  "${Strings.gst}${BookOrderModel.orderModelObj.productsInCart[index].gst.toStringAsFixed(2)}"
                                  " ${Strings.on} $currencySymbol ${BookOrderModel.orderModelObj.productsInCart[index].productPrice.toStringAsFixed(2)} = "
                                  "${(BookOrderModel.orderModelObj.productsInCart[index].gst * BookOrderModel.orderModelObj.productsInCart[index].productPrice / 100).toStringAsFixed(2)} x "
                                  "${BookOrderModel.orderModelObj.productsInCart[index].productQuantity.toInt()} ="
                                      " ${((BookOrderModel.orderModelObj.productsInCart[index].gst *
                                      BookOrderModel.orderModelObj.productsInCart[index].productPrice / 100) *
                                      (BookOrderModel.orderModelObj.productsInCart[index].productQuantity)).toStringAsFixed(2)}",
                                  style: GoogleFonts.poppins(),
                                ),
                                // : Column(
                                //     crossAxisAlignment:
                                //         CrossAxisAlignment.start,
                                //     children: [
                                //         Text(
                                //             "CGST   @ ${BookOrderModel.orderModelObj.productsInCart[index].gst / 2}"
                                //             " on $currencySymbol ${BookOrderModel.orderModelObj.productsInCart[index].productPrice} = "
                                //             "${BookOrderModel.orderModelObj.productsInCart[index].gst / 2 * BookOrderModel.orderModelObj.productsInCart[index].productPrice / 100} x "
                                //             "${BookOrderModel.orderModelObj.productsInCart[index].productQuantity.toInt()} = ${(BookOrderModel.orderModelObj.productsInCart[index].gst / 2 * BookOrderModel.orderModelObj.productsInCart[index].productPrice / 100) * (BookOrderModel.orderModelObj.productsInCart[index].productQuantity)}",
                                //             style: GoogleFonts.poppins()),
                                //         SizedBox(height: 2),
                                //         Text(
                                //             "SGST   @ ${BookOrderModel.orderModelObj.productsInCart[index].gst / 2}"
                                //             " on $currencySymbol ${BookOrderModel.orderModelObj.productsInCart[index].productPrice} = "
                                //             "${BookOrderModel.orderModelObj.productsInCart[index].gst / 2 * BookOrderModel.orderModelObj.productsInCart[index].productPrice / 100} x "
                                //             "${BookOrderModel.orderModelObj.productsInCart[index].productQuantity.toInt()} = ${(BookOrderModel.orderModelObj.productsInCart[index].gst / 2 * BookOrderModel.orderModelObj.productsInCart[index].productPrice / 100) * (BookOrderModel.orderModelObj.productsInCart[index].productQuantity)}",
                                //             style: GoogleFonts.poppins()),
                                //       ]),
                                SizedBox(height: 10)
                              ],
                            ),
                          );
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

  Widget productPriceList(int index) {
    final themeColor = Provider.of<ThemeNotifier>(context);
    if (bookOrderObj.schemeInfo == null) {
      return SizedBox();
    }
    if (bookOrderObj.schemeInfo['products'].length > index) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            subTitleRow(
              "Subtotal",
              "${(bookOrderObj.productsInCart[index].productPrice * double.parse(bookOrderObj.schemeInfo['products'][index]['qty'].toString())).toStringAsFixed(2)}",
            ),
            (bookOrderObj.schemeInfo['products'][index]
                        ['product_scheme_discount_amount']) ==
                    0
                ? SizedBox()
                : subTitleRow(
                    "Scheme Discount",
                    "- ${double.parse(bookOrderObj.schemeInfo['products'][index]['product_scheme_discount_amount'].toString()).toStringAsFixed(2)}",
                  ),
            Container(
              height: 1.5,
              width: 100,
              margin: EdgeInsets.symmetric(vertical: 5),
              color: Theme.of(context).primaryColor,
            ),
            subTitleRow(
              "Total",
              "${double.parse(bookOrderObj.schemeInfo['products'][index]['product_amount'].toString()).toStringAsFixed(2)}",
            ),
            SizedBox(height: 10),
          ],
        ),
      );
    }
    return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(themeColor.getColor()));
  }

  Widget subTitleRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AutoSizeText(
          title,
          maxLines: 5,
          minFontSize: 15,
          textAlign: TextAlign.right,
        ),
        AutoSizeText(
          value,
          maxLines: 5,
          minFontSize: 15,
          textAlign: TextAlign.right,
        ),
      ],
    );
  }
}
