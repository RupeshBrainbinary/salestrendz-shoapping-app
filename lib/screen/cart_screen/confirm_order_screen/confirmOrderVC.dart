import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:getflutter/components/button/gf_button.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shoppingapp/app_url_name_companyid.dart';
import 'package:shoppingapp/models/BookOrderModel.dart';
import 'package:shoppingapp/models/GlobalModelClass.dart';
import 'package:shoppingapp/models/LoginModelClass.dart';
import 'package:shoppingapp/screen/auth_screens/forgot_password/forgetpassword.dart';
import 'package:shoppingapp/screen/cart_screen/confirm_order_screen/confirm_order_model.dart';
import 'package:shoppingapp/utils/commons/colors.dart';
import 'package:shoppingapp/utils/commons/export_basic_file.dart';
import 'package:shoppingapp/utils/constants/constants_app_variables.dart';
import 'package:shoppingapp/utils/theme_notifier.dart';
import 'package:shoppingapp/widgets/commons/custom_alert.dart';
import 'package:shoppingapp/widgets/commons/full_screen_loader.dart';
import 'package:shoppingapp/widgets/commons/string_res.dart';
import 'package:http/http.dart' as http;
import 'package:shoppingapp/screen/cart_screen/widget/shopping_cart_item.dart';

Razorpay razorPayObject;

final BookOrderModel bookOrderObj = BookOrderModel.orderModelObj;
List retailerSupplierListForBookOrder = [];

class ConfirmOrderWidgetState extends StatefulWidget {
  ConfirmOrderWidgetState({this.showBackArrow, this.state, this.pincode});

  final bool showBackArrow;
  final String state;
  final String pincode;

  @override
  State<StatefulWidget> createState() {
    return new ConfirmOrderWidgetClass(backArrow: this.showBackArrow);
  }
}

class ConfirmOrderWidgetClass extends State<ConfirmOrderWidgetState>
    with SingleTickerProviderStateMixin {
  ConfirmOrderWidgetClass({this.backArrow});

  ConfirmOrderViewModel model;

  final bool backArrow;

  List payment = [Strings.onlinepayment, Strings.cashondelivery];

  String select = Strings.cashondelivery;

  bool prepaid = false;
  bool cod = false;

  var totalTaxValue;

  ScrollController controller;
  bool isPaging = false;
  int initPosition = 0;
  int page = 1;

  List<TextEditingController> qtyController = [];

  bool search = false;
  bool submit = false;
  final searchController = TextEditingController();
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  String showPayment;

  void updateView() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    controller = new ScrollController()..addListener(_scrollListener);
    razorPayObject = Razorpay();
    razorPayObject.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorPayObject.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    razorPayObject.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    showPayment = LoginModelClass.loginModelObj
        .getValueForKeyFromLoginResponse(key: 'online_payment');
    if (showPayment == "false") {
      select = Strings.cashondelivery;
    }
    getSchemeInfo(BookOrderModel.orderModelObj.getSchemeInfoBody());
  }

  void selectSupplierAuto() {
    Future.delayed(500.milliseconds, () {
      if (bookOrderObj.selectedRetailerSupplier == null) {
        bookOrderObj.selectedRetailerSupplier =
            model.supplierModel.supplierLists[0];
        getSchemeInfo(BookOrderModel.orderModelObj.getSchemeInfoBody());
        reloadView(() {});
      }
    });
  }

  Future<void> showRazorPayView() async {
    Map rawOrderRequestData = BookOrderModel.orderModelObj
        .getBookOrderRequestRawDataForSubmittingTheOrder("paid");

    Map<String, dynamic> options = Map();
    options['amount'] =
        '${rawOrderRequestData['order_total']}'.replaceAll('.', '');
    options['currency'] = 'INR';

    options['key'] = 'rzp_test_4zoKwBSsy1dm90';

    options['name'] =
        '${LoginModelClass.loginModelObj.getValueForKeyFromLoginResponse(key: 'user_fname')}';
    options['description'] = '';

    options['prefill'] = {
      'contact':
          '${LoginModelClass.loginModelObj.getValueForKeyFromLoginResponse(key: 'user_number')}',
      'email':
          '${LoginModelClass.loginModelObj.getValueForKeyFromLoginResponse(key: 'user_email')}'
    };

    razorPayObject.open(options);
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    print('paymentSuccess');
    print(response);

    BookOrderModel.orderModelObj.showLoadingIndicator = true;
    setState(() {});
    placeOrder(
        bookOrderObj.getBookOrderRequestRawDataForSubmittingTheOrder("paid"));
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('paymentError');
    showAlertWith(
      alertContext,
      title: Strings.erroccured,
      message: Strings.ordnotprocessed,
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('External Wallet');
    // Do something when an external wallet is selected
  }

  void reloadView(Function fun) {
    BookOrderModel.orderModelObj.refreshViewForOrderBooking();
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
        model.getSupplierListApi(page);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_statements
    model ?? (model = ConfirmOrderViewModel(this));
    selectSupplierAuto();
    final themeColor = Provider.of<ThemeNotifier>(context);
    print("Current screen => $runtimeType");
    return SafeArea(
      child: Scaffold(
        backgroundColor: whiteColor,
        body: model.supplierModel == null
            ? Center(
                child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(themeColor.getColor())),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 26),
                    shoppingCartInfo(this.backArrow),
                    SizedBox(height: 12),
                    if ((bookOrderObj.productsInCart?.length ?? 0) == 0)
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: Get.height,
                          width: Get.width,
                          child:
                              Image.asset('assets/images/emptyCartIcon.jpeg'),
                        ),
                      )
                    else
                      ListView.builder(
                          physics: ScrollPhysics(),
                          itemCount: (((bookOrderObj.productsInCart?.length ??
                                              0) +
                                          bookOrderObj
                                              .setOrderBookingFooterView(bookOrderObj
                                                          .selectedRetailerSupplier !=
                                                      null
                                                  ? bookOrderObj
                                                      .selectedRetailerSupplier
                                                      .gstApply
                                                      .toString()
                                                  : '')
                                              ?.length) +
                                      (model.supplierModel.supplierLists
                                              ?.length ??
                                          0) ??
                                  0) +
                              1,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (_, index) {
                            qtyController = [];
                            List.generate(
                                bookOrderObj.productsInCart?.length,
                                (index) =>
                                    qtyController.add(TextEditingController()));
                            if ((((bookOrderObj.productsInCart?.length ?? 0) +
                                    (bookOrderObj
                                            .setOrderBookingFooterView(bookOrderObj
                                                        .selectedRetailerSupplier !=
                                                    null
                                                ? bookOrderObj
                                                    .selectedRetailerSupplier
                                                    .gstApply
                                                    .toString()
                                                : '')
                                            ?.length ??
                                        0)) <=
                                index)) {
                              if (((bookOrderObj.productsInCart?.length ?? 0) +
                                      (bookOrderObj
                                              .setOrderBookingFooterView(bookOrderObj
                                                          .selectedRetailerSupplier !=
                                                      null
                                                  ? bookOrderObj
                                                      .selectedRetailerSupplier
                                                      .gstApply
                                                      .toString()
                                                  : '')
                                              ?.length ??
                                          0)) ==
                                  index) {
                                return SizedBox();
                              }
                            } else if ((bookOrderObj.productsInCart?.length ??
                                    0) <=
                                index) {
                              return SizedBox();
                              /*return shoppingCartBottomSummary(
                                themeColor,
                                (index -
                                    (bookOrderObj.productsInCart?.length ?? 0)),
                              );*/
                            } else {
                              return Column(
                                children: [
                                  ShoppingCartItem(
                                    themeColor: themeColor,
                                    imageUrl: "prodcut2.png",
                                    orderProd:
                                        bookOrderObj.productsInCart[index],
                                    onCallback: reloadView,
                                    qtyController: qtyController[index],
                                    onAddRemoveTap: () {
                                      getSchemeInfo(BookOrderModel.orderModelObj
                                          .getSchemeInfoBody());
                                    },
                                    showOffer: !(bookOrderObj
                                                    .schemeInfo['products']
                                                [index]['product_message'] ==
                                            null ||
                                        bookOrderObj.schemeInfo['products']
                                                [index]['product_message']
                                            .toString()
                                            .contains(
                                                'Scheme is not available')),
                                    onOfferTap: () {
                                      openDialog(
                                        context,
                                        offer: [
                                          bookOrderObj.schemeInfo['products']
                                              [index]['product_message']
                                        ],
                                      );
                                    },
                                  ),
                                  productPriceList(index),
                                ],
                              );
                            }
                          }),
                    Container(
                      height: 1.5,
                      margin: EdgeInsets.symmetric(vertical: 10),
                      color: Theme.of(context).primaryColor,
                    ),
                    totalList(
                      "Subtotal",
                      "${getFinalSubtotal().toStringAsFixed(2)}",
                    ),
                    (bookOrderObj.schemeInfo['scheme_Discount_Amount']) == 0
                        ? SizedBox()
                        : totalList(
                            "Scheme Discount",
                            "- ${double.parse(bookOrderObj.schemeInfo['scheme_Discount_Amount'].toString()).toStringAsFixed(2)}",
                          ),
                    (bookOrderObj.setOrderBookingFooterView(
                                    bookOrderObj.selectedRetailerSupplier !=
                                            null
                                        ? bookOrderObj
                                            .selectedRetailerSupplier.gstApply
                                            .toString()
                                        : ''))
                                ?.length ==
                            0
                        ? SizedBox()
                        : totalList(
                            "GST",
                            "+ ${getTotalGstTax().toStringAsFixed(2)}",
                          ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        height: 1.5,
                        width: 100,
                        margin: EdgeInsets.only(right: 22),
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    totalList(
                      "Order Total",
                      "${(double.parse(bookOrderObj.schemeInfo['order_totalAmount'].toString()) + getTotalGstTax()).toStringAsFixed(2)}",
                    ),
                    Container(
                      padding: EdgeInsets.all(5.0),
                      margin: EdgeInsets.all(10.0),
                      child: Text(
                        Strings.toApplySchemeOn,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                          color: Color(0xFF5D6A78),
                        ),
                      ),
                    ),
                    schemeList(),
                    Container(
                      padding: EdgeInsets.all(5.0),
                      margin: EdgeInsets.all(10.0),
                      child: Text(
                        Strings.paymentmethods,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                          color: Color(0xFF5D6A78),
                        ),
                      ),
                    ),
                    /*showPayment == "true"
                        ? addRadioButton(0, Strings.onlinepayment)
                        :SizedBox(),*/
                    addRadioButton(1, Strings.cashondelivery),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 40,
                          padding: EdgeInsets.only(top: 5, left: 5),
                          margin: EdgeInsets.only(top: 10, left: 10),
                          child: Text(
                            Strings.selectsupplier,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 17,
                              color: Color(0xFF5D6A78),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (search == true) {
                              search = false;
                            } else {
                              search = true;
                            }
                            setState(() {});
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 10, right: 20),
                            padding: EdgeInsets.only(
                              top: 5,
                              bottom: 5,
                              left: 15,
                              right: 15,
                            ),
                            child: Center(
                              child: Text(
                                "Search",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    search ? searchContainer() :SizedBox(),
                    Container(
                      height: Get.height * 0.6,
                      child: ListView.builder(
                        controller: controller,
                        shrinkWrap: true,
                        itemCount:
                            model.supplierModel.supplierLists?.length ?? 0,
                        itemBuilder: (BuildContext context, int index) {
                          return buildAddressItem(context, index, reloadView);
                        },
                      ),
                    ),
                  ],
                ),
              ),
        bottomNavigationBar: (bookOrderObj.productsInCart?.length ?? 0) > 0
            ? Container(
                width: Get.width,
                height: 40.0,
                child: GFButton(
                  color: mainColor,
                  onPressed: () async {
                    if (bookOrderObj.selectedRetailerSupplier != null) {
                      if (select == Strings.cashondelivery) {
                        placeOrder(bookOrderObj
                            .getBookOrderRequestRawDataForSubmittingTheOrder(
                                "unpaid"));
                      } else {
                        showRazorPayView();
                      }
                    } else {
                      Alert(
                        context: context,
                        title: Strings.supplierMandatory,
                        desc: Strings.pleaseSelectSupplier,
                        buttons: [
                          DialogButton(
                            child: Text(
                              Strings.ok,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                              ),
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
                    Strings.placeOrder,
                    style: GoogleFonts.poppins(fontSize: 14.0),
                  ),
                ),
              )
            :SizedBox(),
      ),
    );
  }

  Widget productPriceList(int index) {
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
          /*subTitleRow(
            "GST",
            "+ ${(((bookOrderObj.productsInCart[index].productPrice * double.parse(bookOrderObj.schemeInfo['products'][index]['qty'])) *
                (bookOrderObj.productsInCart[index].gst))/100).toStringAsFixed(2)}",
          ),*/
          Container(
            height: 1.5,
            width: 100,
            margin: EdgeInsets.symmetric(vertical: 5),
            color: Theme.of(context).primaryColor,
          ),
          /*subTitleRow(
            "Total",
            "${(double.parse(bookOrderObj.schemeInfo['products'][index]['product_amount'].toString())+
                (((bookOrderObj.productsInCart[index].productPrice * double.parse(bookOrderObj.schemeInfo['products'][index]['qty'])) *
                (bookOrderObj.productsInCart[index].gst))/100)).toStringAsFixed(2)}",
          ),*/
          subTitleRow(
            "Total",
            "${double.parse(bookOrderObj.schemeInfo['products'][index]['product_amount'].toString()).toStringAsFixed(2)}",
          ),
          SizedBox(height: 10),
        ],
      ),
    );
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

  Row addRadioButton(int btnValue, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Radio(
          activeColor: Theme.of(context).primaryColor,
          value: payment[btnValue],
          groupValue: select,
          onChanged: (value) {
            setState(() {
              print(value);
              select = value;
            });
          },
        ),
        Text(title)
      ],
    );
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
                  if(e['product_message'].toString().contains("Scheme is not")){}
                  else
                    index++;
                    return e['product_message'].toString().contains("Scheme is not")?Container(): Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: 15),
                        Text("$index. "),
                        Expanded(
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
              :bookOrderObj.schemeInfo['orderamount_message'].toString().contains("Scheme is not")?Container(): Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: 15),
                    Text("${index + 1}. "),
                    Expanded(
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

  void placeOrder(Map orderData) async {
    print(orderData);
    Loader().showLoader(context);

    if (GlobalModelClass.internetConnectionAvaiable() == true) {
      http.Response resp = await http.post(Uri.parse(Base_URL + bookOrder),
          body: jsonEncode(orderData),
          headers: {
            'Authorization': LoginModelClass.loginModelObj
                .getValueForKeyFromLoginResponse(key: 'token'),
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          });

      if (resp.statusCode == 200) {
        var respBody = jsonDecode(resp.body);
        Loader().hideLoader(context);
        if (respBody['status'] == true) {
          Alert(
            closeFunction: () {
              setState(() {
                bookOrderObj.showLoadingIndicator = false;
                Navigator.popUntil(context, (route) => route.isFirst);
                GlobalModelClass.globalObject.selectedTabBarItem = 0;
                bookOrderObj.resetModel();
                bookOrderObj.refreshViewForOrderBooking();
              });
            },
            context: context,
            title: respBody['message']?.toString() ??
                Strings.PleaseCheckForAllMandatoryFields,
            buttons: [
              DialogButton(
                color:Theme.of(context).primaryColor,
                child: Text(
                  Strings.ok,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    bookOrderObj.showLoadingIndicator = false;
                    Navigator.popUntil(context, (route) => route.isFirst);
                    GlobalModelClass.globalObject.selectedTabBarItem = 0;
                    bookOrderObj.resetModel();
                    bookOrderObj.refreshViewForOrderBooking();
                  });
                },
                width: 120,
              ),
            ],
          ).show();
        }
      } else {
        Loader().hideLoader(context);
      }
    } else {
      Loader().hideLoader(context);
      Future.delayed(Duration.zero, () {
        GlobalModelClass.showAlertForNoInternetConnection(context).show();
      });
    }
  }

  Widget shoppingCartInfo(bool showBackArrow) {
    return Container(
      margin: EdgeInsets.only(left: 24),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Get.back(result: true);
            },
            child: Icon(
              Platform.isAndroid ? Icons.arrow_back : Icons.chevron_left,
              size: 25,
            ),
          ),
          SizedBox(width: 15.0),
          Text(
            Strings.confirmOrder,
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
    return model.supplierModel.supplierLists.isNotEmpty
        ? Container(
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      child: Container(
                        width: Get.width * 0.77,
                        child: Text(
                          '${model.supplierModel.supplierLists[index].supName.toString()}',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      alignment: Alignment.topLeft,
                    ),
                    IconButton(
                      icon: (bookOrderObj.selectedRetailerSupplier != null &&
                              bookOrderObj.selectedRetailerSupplier.supId ==
                                  model
                                      .supplierModel.supplierLists[index].supId)
                          ? Icon(Icons.check_box)
                          : Icon(Icons.check_box_outline_blank),
                      onPressed: () {
                        bookOrderObj.selectedRetailerSupplier =
                            model.supplierModel.supplierLists[index];
                        getSchemeInfo(
                            BookOrderModel.orderModelObj.getSchemeInfoBody());
                        callBack(() {});
                      },
                      iconSize: 30.0,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: AutoSizeText(
                        '${Strings.contactperson} : ${model.supplierModel.supplierLists[index].contactPerson.toString() ?? ""}' +
                            '\n${Strings.phonenumber} : ${model.supplierModel.supplierLists[index].phoneNumber.toString() ?? ""}' +
                            '\n${Strings.email} : ${model.supplierModel.supplierLists[index].emailAddress.toString() ?? ""}'
                                '\n\n${model.supplierModel.supplierLists[index].supplierAddress.toString()}',
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
          )
        : Text(Strings.suppnotfound);
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
                    ?
                    //SizedBox() : bookOrderObj.selectedRetailerSupplier.isEmpty ?
                   SizedBox()
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
            '${(bookOrderObj.footerList[index]).values.first}',
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
    //       ?SizedBox()
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
                  // bookOrderObj.selectedRetailerSupplier['gst_apply'].toString() == "GST" ?
                  bookOrderObj.selectedRetailerSupplier == null
                      ? Center(
                          child: Container(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              "Please Select Supplier",
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 19,
                                  color: Colors.grey),
                            ),
                          ),
                        )
                      : Container(
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        bookOrderObj.selectedRetailerSupplier
                                                    .gstApply ==
                                                "IGST"
                                            ? Text(
                                                "${Strings.gst}${BookOrderModel.orderModelObj.productsInCart[index].gst.toStringAsFixed(2)}"
                                                " ${Strings.on} $currencySymbol ${BookOrderModel.orderModelObj.productsInCart[index].productPrice.toStringAsFixed(2)} = "
                                                "${(BookOrderModel.orderModelObj.productsInCart[index].gst * BookOrderModel.orderModelObj.productsInCart[index].productPrice / 100).toStringAsFixed(2)} x "
                                                "${BookOrderModel.orderModelObj.productsInCart[index].productQuantity.toInt()} = ${((BookOrderModel.orderModelObj.productsInCart[index].gst * BookOrderModel.orderModelObj.productsInCart[index].productPrice / 100) * (BookOrderModel.orderModelObj.productsInCart[index].productQuantity)).toStringAsFixed(2)}",
                                                style: GoogleFonts.poppins())
                                            : Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                    Text(
                                                        "CGST   @ ${BookOrderModel.orderModelObj.productsInCart[index].gst / 2}"
                                                        " on $currencySymbol ${BookOrderModel.orderModelObj.productsInCart[index].productPrice.toStringAsFixed(2)} = "
                                                        "${(BookOrderModel.orderModelObj.productsInCart[index].gst / 2 * BookOrderModel.orderModelObj.productsInCart[index].productPrice / 100).toStringAsFixed(2)} x "
                                                        "${BookOrderModel.orderModelObj.productsInCart[index].productQuantity.toInt()} = ${((BookOrderModel.orderModelObj.productsInCart[index].gst / 2 * BookOrderModel.orderModelObj.productsInCart[index].productPrice / 100) * (BookOrderModel.orderModelObj.productsInCart[index].productQuantity)).toStringAsFixed(2)}",
                                                        style: GoogleFonts
                                                            .poppins()),
                                                    SizedBox(height: 2),
                                                    Text(
                                                        "SGST   @ ${BookOrderModel.orderModelObj.productsInCart[index].gst / 2}"
                                                        " on $currencySymbol ${BookOrderModel.orderModelObj.productsInCart[index].productPrice.toStringAsFixed(2)} = "
                                                        "${(BookOrderModel.orderModelObj.productsInCart[index].gst / 2 * BookOrderModel.orderModelObj.productsInCart[index].productPrice / 100).toStringAsFixed(2)} x "
                                                        "${BookOrderModel.orderModelObj.productsInCart[index].productQuantity.toInt()} = ${((BookOrderModel.orderModelObj.productsInCart[index].gst / 2 * BookOrderModel.orderModelObj.productsInCart[index].productPrice / 100) * (BookOrderModel.orderModelObj.productsInCart[index].productQuantity)).toStringAsFixed(2)}",
                                                        style: GoogleFonts
                                                            .poppins()),
                                                  ]),
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

  searchContainer() {
    return Row(
      children: [
        Container(
          width: submit ? Get.width * 0.83 : Get.width * 0.68,
          margin: EdgeInsets.only(left: 15, top: 14, bottom: 8),
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
                      hintText: "Search Supplier",
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Color(0xFF5D6A78),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    onFieldSubmitted: (searchText) async {
                      Loader().showLoader(context);
                      model.supplierPageLength = 0;
                      await model.getSupplierListInitial();
                      page = 1;
                      Loader().hideLoader(context);
                      submit = true;
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
                        model.supplierPageLength = 0;
                        await model.getSupplierListInitial();
                        page = 1;
                        Loader().hideLoader(context);
                        submit = false;
                        setState(() {});
                      },
                      child: Icon(Icons.close),
                    )
                  :SizedBox()
            ],
          ),
        ),
        SizedBox(width: 10),
        submit
            ?SizedBox()
            : InkWell(
                onTap: () async {
                  Loader().showLoader(context);
                  model.supplierPageLength = 0;
                  await model.getSupplierListInitial();
                  page = 1;
                  Loader().hideLoader(context);
                  submit = true;
                  setState(() {});
                },
                child: Container(
                  margin: EdgeInsets.only(top: 10, right: 20),
                  padding: EdgeInsets.only(
                    top: 10,
                    bottom: 10,
                    left: 10,
                    right: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Center(
                    child: Text(
                      "Submit",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              )
      ],
    );
  }

  double getTotalGstTax() {
    double totalTax = 0;
    if (bookOrderObj.selectedRetailerSupplier != null &&
        bookOrderObj.selectedRetailerSupplier.gstApply != null) {
      for (int i = 0; i < bookOrderObj.productsInCart.length; i++) {
        var prod = bookOrderObj.productsInCart[i];
        totalTax = totalTax +
            ((double.parse(bookOrderObj.schemeInfo['products'][i]
                            ['product_amount']
                        .toString()) *
                    prod.gst) /
                100);
      }
    }

    return totalTax;
  }
}
