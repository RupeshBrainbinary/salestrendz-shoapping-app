import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:shoppingapp/utils/commons/export_basic_file.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PlacedOrderPage extends StatefulWidget {
  final int productId;

  const PlacedOrderPage({Key key, this.productId}) : super(key: key);

  @override
  PlacedOrderPageState createState() => PlacedOrderPageState();
}

class PlacedOrderPageState extends State<PlacedOrderPage> {
  Map selectedOrderDetails = {};
  List productsInOrderDetails = [];
  bool error = false;

  @override
  void initState() {
    super.initState();
    selectedOrderDetails = {};
    productsInOrderDetails = [];
    getOrderDetailsFromServer();
  }

  void getOrderDetailsFromServer() async {
    if (GlobalModelClass.internetConnectionAvaiable() == true) {
      String loggedInUserId = LoginModelClass.loginModelObj
          .getValueForKeyFromLoginResponse(key: 'user_id');
      var url = Base_URL +
          getOrderDetails +
          '&logged_in_userid=$loggedInUserId&order_id=${widget.productId}';

      bookOrderObj.showLoadingIndicator = true;
      setState(() {});

      http.Response resp = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': LoginModelClass.loginModelObj
              .getValueForKeyFromLoginResponse(key: 'token'),
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (resp.statusCode == 200) {
        var jsonBodyResp = jsonDecode(resp.body);

        if (jsonBodyResp['status'] == true) {
          setState(() {
            bookOrderObj.showLoadingIndicator = false;
            selectedOrderDetails = jsonBodyResp['order_details'];
            productsInOrderDetails = selectedOrderDetails['order_products'];
          });
        } else {
          log(jsonBodyResp);
        }
      } else {
        bookOrderObj.showLoadingIndicator = false;
        setState(() {});
        ToastUtils.showError(message: "Server Error");
        print('Error occurred while serving request');
      }
    } else {
      Future.delayed(Duration.zero, () {
        GlobalModelClass.showAlertForNoInternetConnection(context).show();
      });
    }
  }

  void reloadView(Function fun) {
    BookOrderModel.orderModelObj.refreshViewForOrderBooking();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<ThemeNotifier>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          leading: InkWell(
            child: Icon(
              Platform.isAndroid ? Icons.arrow_back : Icons.chevron_left,
              color:themeColor.getColor(),
            ),
            onTap: () {
              Get.back();
            },
          ),
          title: Text(
            Strings.PlacedOrders,
            style: GoogleFonts.roboto(
                color: themeColor.getColor()
            ),
          ),
          backgroundColor: Colors.white,
        ),
        body: (selectedOrderDetails == null ||
                (selectedOrderDetails?.keys?.length ?? 0) <= 0)
            ? Align(
                alignment: Alignment.center,
                child: Container(
                  height: Get.height,
                  width: Get.width,
                  child: Center(
                    child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(themeColor.getColor())),
                  ),
                ),
              )
            : productsInOrderDetails == null
                ? Container(
                    child: Text(
                      "Order Detail Not Found",
                      style: GoogleFonts.roboto(),
                    ),
                  )
                : Column(
                    children: [
                      topHeaderContentData(),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              orderParticularText(),
                              orderParticular(),
                              Container(
                                margin: EdgeInsets.only(
                                  top: 15,
                                  left: 20,
                                  bottom: 8,
                                ),
                                child: Text(
                                  Strings.paymentDetails,
                                  style: GoogleFonts.roboto(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              paymentDetails(),
                              Container(
                                margin: EdgeInsets.only(
                                  top: 15,
                                  left: 20,
                                  bottom: 8,
                                ),
                                child: Text(
                                  Strings.shippdetail,
                                  style: GoogleFonts.roboto(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              shipmentDetail(),
                              Container(
                                margin: EdgeInsets.only(
                                  top: 15,
                                  left: 20,
                                  bottom: 8,
                                ),
                                child: Text(
                                  Strings.amtdetail,
                                  style: GoogleFonts.roboto(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              amountDetail(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }

  Widget topHeaderContentData() {
    final themeColor = Provider.of<ThemeNotifier>(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      color: themeColor.getColor(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: Get.width,
            child: Text(
              selectedOrderDetails['ordered_customer_name'] ?? '',
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: GoogleFonts.roboto(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Divider(
            thickness: 1,
            color: Colors.white,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Text(
                  Strings.OrderSummary,
                  style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: Colors.white,
                ),
                child: Text(
                  selectedOrderDetails['status']?.toUpperCase() ?? '',
                  style: GoogleFonts.roboto(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Container(
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Strings.OrderDate,
                      style: GoogleFonts.roboto(
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      Strings.order,
                      style: GoogleFonts.roboto(
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      Strings.OrderTotal,
                      style: GoogleFonts.roboto(
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selectedOrderDetails['created_at'] ?? '',
                      style: GoogleFonts.roboto(
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      selectedOrderDetails['comp_ord_id']?.toString() ?? 0,
                      style: GoogleFonts.roboto(
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      '₹ ${selectedOrderDetails['amount'].toStringAsFixed(2)} (${selectedOrderDetails['order_products']?.length ?? '0'} ${Strings.items.toLowerCase()})',
                      style: GoogleFonts.roboto(
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget orderParticularText() {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 20),
      alignment: Alignment.topLeft,
      child: Text(
        Strings.OrderParticular,
        style: GoogleFonts.roboto(
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget orderParticular() {
    return Container(
      padding: EdgeInsets.only(top: 10),
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: selectedOrderDetails['order_products']?.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: EdgeInsets.only(
              left: 10,
              right: 10,
              top: 5,
              bottom: 5,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
              border: Border.all(
                color: Colors.grey.withOpacity(0.6),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '₹${selectedOrderDetails['order_products'][index]['product_total']?.toStringAsFixed(2) ?? 0}',
                        style: GoogleFonts.roboto(
                          color: Colors.black.withOpacity(0.6),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(color: Colors.grey.withOpacity(0.7)),
                Container(
                  width: Get.width * 0.91,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 5),
                        height: 70,
                        width: Get.width * 0.17,
                        child: selectedOrderDetails['order_products'][index]
                                    ['product_image']
                                .isNotEmpty
                            ? Image.network(
                                selectedOrderDetails['order_products'][index]
                                        ['product_image']
                                    ?.first
                                    ?.toString(),
                                fit: BoxFit.cover,
                                errorBuilder: (context, obj, child) {
                                  return Image.asset(
                                    'assets/images/productPlaceaHolderImage.png',
                                    fit: BoxFit.cover,
                                  );
                                },
                              )
                            : Image.asset(
                                'assets/images/productPlaceaHolderImage.png',
                                fit: BoxFit.cover,
                              ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 5),
                        width: Get.width * 0.72,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${selectedOrderDetails['order_products'][index]['product_variant_name'] ?? ''}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.roboto(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '${Strings.Qty} ${selectedOrderDetails['order_products'][index]['unit'] ?? 0}',
                              style: GoogleFonts.roboto(
                                color: Colors.black.withOpacity(0.6),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  width: Get.width * 0.14,
                                  child: Text(
                                    Strings.SoldBy,
                                    style: GoogleFonts.roboto(
                                      color: Colors.black.withOpacity(0.6),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: Get.width * 0.55,
                                  child: Text(
                                    '${selectedOrderDetails['retailer_name'] ?? ''}',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: GoogleFonts.roboto(
                                      color: Colors.black.withOpacity(0.6),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                           /* Container(
                              margin: EdgeInsets.only(right: 15,bottom: 12),
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  widget.selectedProduct == null
                                      ? "135"
                                      : 'D.P: $currencySymbol' +
                                      double.parse(widget.productPrice)
                                          .toStringAsFixed(2),
                                  style: GoogleFonts.roboto(
                                    color: showMBPrimaryColor
                                        ? millBornPrimaryColor
                                        : widget.themeColor.getColor(),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),*/
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5)
              ],
            ),
          );
        },
      ),
    );
  }

  Widget paymentDetails() {
    return Container(
      margin: EdgeInsets.only(
        left: 15,
        right: 15,
        top: 5,
        bottom: 5,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        border: Border.all(
          color: Colors.grey.withOpacity(0.6),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(
              left: 10,
              right: 10,
              top: 5,
              bottom: 5,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Strings.paymethod,
                  style: GoogleFonts.roboto(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  selectedOrderDetails['payment_type'] != null
                      ? selectedOrderDetails['payment_type'] == "COD"
                          ? Strings.cod
                          : Strings.online
                      : "",
                  style: GoogleFonts.roboto(
                    color: Colors.black.withOpacity(0.7),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Divider(thickness: 1),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Strings.billadd,
                  style: GoogleFonts.roboto(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                AutoSizeText(
                  selectedOrderDetails['delivery_address'] ?? '',
                  style: GoogleFonts.roboto(
                    color: Colors.black.withOpacity(0.7),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget shipmentDetail() {
    return Container(
      margin: EdgeInsets.only(
        left: 15,
        right: 15,
        top: 5,
        bottom: 5,
      ),
      padding: EdgeInsets.only(
        left: 10,
        right: 10,
        top: 5,
        bottom: 5,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        border: Border.all(
          color: Colors.grey.withOpacity(0.6),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeText(
            selectedOrderDetails['delivery_address'] ?? '',
            style: GoogleFonts.roboto(
              color: Colors.black.withOpacity(0.7),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          selectedOrderDetails['ordered_customer_phoneNumber'] == null ||
                  selectedOrderDetails['ordered_customer_phoneNumber'].isEmpty
              ?SizedBox()
              : Row(
                  children: [
                    Text(
                      '${Strings.Contact}: ',
                      style: GoogleFonts.roboto(
                        color: Colors.black.withOpacity(0.7),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      selectedOrderDetails['ordered_customer_phoneNumber'] ??
                          '',
                      style: GoogleFonts.roboto(
                        color: Colors.black.withOpacity(0.7),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Widget amountDetail() {
    return Container(
      margin: EdgeInsets.only(
        left: 15,
        right: 15,
        top: 5,
        bottom: 5,
      ),
      padding: EdgeInsets.only(
        left: 10,
        right: 10,
        top: 5,
        bottom: 5,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        border: Border.all(
          color: Colors.grey.withOpacity(0.6),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Strings.items,
                style: GoogleFonts.roboto(
                  color: Colors.black.withOpacity(0.7),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                Strings.taxtotal,
                style: GoogleFonts.roboto(
                  color: Colors.black.withOpacity(0.7),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                Strings.tax,
                style: GoogleFonts.roboto(
                  color: Colors.black.withOpacity(0.7),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                Strings.discount,
                style: GoogleFonts.roboto(
                  color: Colors.black.withOpacity(0.7),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                Strings.schemeDiscount,
                style: GoogleFonts.roboto(
                  color: Colors.black.withOpacity(0.7),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                Strings.total,
                style: GoogleFonts.roboto(
                  color: Colors.black.withOpacity(0.7),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                Strings.ordertotal,
                style: GoogleFonts.roboto(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                selectedOrderDetails['order_products']?.length?.toString() ?? 0,
                style: GoogleFonts.roboto(
                  color: Colors.black.withOpacity(0.8),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '₹${selectedOrderDetails['before_gst_addition_amount']?.toStringAsFixed(2) ?? 0}',
                style: GoogleFonts.roboto(
                  color: Colors.black.withOpacity(0.8),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '₹${selectedOrderDetails['totalgst_amount']?.toStringAsFixed(2) ?? 0}',
                style: GoogleFonts.roboto(
                  color: Colors.black.withOpacity(0.8),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '₹${selectedOrderDetails['discount_value']?.toStringAsFixed(2) ?? 0}',
                style: GoogleFonts.roboto(
                  color: Colors.black.withOpacity(0.8),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '₹${selectedOrderDetails['scheme_discount_amount']?.toStringAsFixed(2) ?? 0}',
                style: GoogleFonts.roboto(
                  color: Colors.black.withOpacity(0.8),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '₹${selectedOrderDetails['amount']?.toStringAsFixed(2) ?? 0}',
                style: GoogleFonts.poppins(
                  color: Colors.black.withOpacity(0.8),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '₹${selectedOrderDetails['amount'].toStringAsFixed(2) ?? 0}',
                style: GoogleFonts.poppins(
                  color: Colors.red,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
