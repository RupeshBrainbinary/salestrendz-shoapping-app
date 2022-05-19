import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shoppingapp/utils/commons/export_basic_file.dart';
import 'package:http/http.dart' as http;

class ReceivedOrderPage extends StatefulWidget {
  final int productId;

  const ReceivedOrderPage({Key key, this.productId}) : super(key: key);

  @override
  ReceivedOrderPageState createState() => ReceivedOrderPageState();
}

class ReceivedOrderPageState extends State<ReceivedOrderPage> {
  Map selectedOrderDetails = {};
  List productsInOrderDetails = [];

  List<String> productId = [];

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

      var url = Base_URL + getOrderDetails + '&logged_in_userid=$loggedInUserId&order_id=${widget.productId}';

      print(widget.productId);

      bookOrderObj.showLoadingIndicator = true;
      setState(() {});

      http.Response resp = await http.get(Uri.parse(url), headers: {
        'Authorization': LoginModelClass.loginModelObj
            .getValueForKeyFromLoginResponse(key: 'token'),
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      });

      setState(() {});

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
          bookOrderObj.showLoadingIndicator = false;
        }
      } else {
        bookOrderObj.showLoadingIndicator = false;
        setState(() {});

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
    print("Current page --> $runtimeType");
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: themeColor.getColor(),
          elevation: 0.0,
          centerTitle: true,
          leading: InkWell(
            child: Icon(
              Platform.isAndroid ? Icons.arrow_back : Icons.chevron_left,
            ),
            onTap: () {
              Get.back();
            },
          ),
          title: Text(
            Strings.ReceivedOrder,
            style: GoogleFonts.poppins(),
          ),
        ),
        bottomNavigationBar: InkWell(
          onTap: () {
            Get.back();
          },
          child: Container(
            margin: EdgeInsets.only(left: 30, right: 30, bottom: 10),
            alignment: Alignment.bottomCenter,
            height: Get.height / 18,
            width: Get.width * 0.8,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: themeColor.getColor(),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(22.0),
                topRight: Radius.circular(22.0),
                bottomLeft: Radius.zero,
                bottomRight: Radius.zero,
              ),
            ),
            child: Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Text(
                Strings.Submit,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
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
            : Column(
                children: [
                  topHeader(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    Strings.OrderParticular,
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      productId = [];
                                      for (int i = 0;
                                          i <
                                                  selectedOrderDetails[
                                                          'order_products']
                                                      ?.length ??
                                              0;
                                          i++) {
                                        productId.add(i.toString());
                                        setState(() {});
                                      }
                                      setState(() {});
                                    },
                                    child: Text(
                                      Strings.SelectAll,
                                      style: GoogleFonts.poppins(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: selectedOrderDetails['order_products']
                                      ?.length ??
                                  0,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  margin: EdgeInsets.only(
                                    bottom: 10,
                                    top: 10,
                                    right: 10,
                                    left: 10,
                                  ),
                                  padding: EdgeInsets.only(top: 12, bottom: 12),
                                  height: 105,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.grey[300],
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      productId.contains(index.toString()) ==
                                              true
                                          ? Center(
                                              child: InkWell(
                                                onTap: () {
                                                  productId
                                                      .remove(index.toString());
                                                  setState(() {});
                                                },
                                                child: Icon(
                                                  Icons.check_box,
                                                  color: themeColor.getColor(),
                                                ),
                                              ),
                                            )
                                          : Center(
                                              child: InkWell(
                                                onTap: () {
                                                  productId
                                                      .add(index.toString());
                                                  setState(() {});
                                                },
                                                child: Icon(
                                                  Icons.check_box_outline_blank,
                                                ),
                                              ),
                                            ),
                                      SizedBox(width: 3),
                                      selectedOrderDetails['order_products']
                                                  [index]['product_image']
                                              .isEmpty
                                          ? Image.asset(
                                              'assets/images/productPlaceaHolderImage.png',
                                              fit: BoxFit.cover,
                                              height: 80,
                                              width: 50,
                                            )
                                          : selectedOrderDetails[
                                                              'order_products'][
                                                          index]['product_image']
                                                      ?.first !=
                                                  null
                                              ? Image.network(
                                                  selectedOrderDetails[
                                                              'order_products'][
                                                          index]['product_image']
                                                      .first
                                                      .toString(),
                                                  fit: BoxFit.cover,
                                                  height: 70,
                                                  width: 50,
                                                )
                                              : Image.asset(
                                                  'assets/images/productPlaceaHolderImage.png',
                                                  fit: BoxFit.cover,
                                                  height: 80,
                                                  width: 50,
                                                ),
                                      SizedBox(width: 10),
                                      Container(
                                        width: Get.width * 0.6,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            selectedOrderDetails[
                                                                'order_products']
                                                            [index][
                                                        'product_variant_name'] ==
                                                    null
                                                ?SizedBox()
                                                : selectedOrderDetails['order_products']
                                                                    [index][
                                                                'product_variant_name']
                                                            .length >
                                                        25
                                                    ? Expanded(
                                                        child: Marquee(
                                                          text: selectedOrderDetails[
                                                                          'order_products']
                                                                      [index][
                                                                  'product_variant_name'] ??
                                                              "",
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                          scrollAxis:
                                                              Axis.horizontal,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          blankSpace: 30.0,
                                                          velocity: 100.0,
                                                          pauseAfterRound:
                                                              Duration(
                                                                  seconds: 3),
                                                          accelerationDuration:
                                                              Duration(
                                                                  seconds: 3),
                                                          accelerationCurve:
                                                              Curves.linear,
                                                          decelerationDuration:
                                                              Duration(
                                                                  milliseconds:
                                                                      500),
                                                          decelerationCurve:
                                                              Curves.easeOut,
                                                        ),
                                                      )
                                                    : Expanded(
                                                        child: Text(
                                                          selectedOrderDetails[
                                                                          'order_products']
                                                                      [index][
                                                                  'product_variant_name'] ??
                                                              "",
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                            Row(
                                              children: [
                                                Container(
                                                  width: 45,
                                                  child: Text(
                                                    Strings.Qty,
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  selectedOrderDetails[
                                                                  'order_products']
                                                              [index]['qty']
                                                          ?.toString() ??
                                                      0,
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Container(
                                                  width: 45,
                                                  child: Text(
                                                    Strings.Price,
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  "₹ ${selectedOrderDetails['order_products'][index]['product_total'].toStringAsFixed(2)?.toString() ?? 0}",
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                            Container(
                              margin:
                                  EdgeInsets.only(top: 15, left: 10, bottom: 8),
                              child: Text(
                                "Customer Detail",
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            customerDetail()
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }

  Widget topHeader() {
    final themeColor = Provider.of<ThemeNotifier>(context);
    return Container(
      color: themeColor.getColor(),
      width: double.infinity,
      child: Container(
        padding: EdgeInsets.only(left: 15, right: 15, top: 10),
        child: Column(
          children: [
            Container(
              width: Get.width,
              child: Text(
                selectedOrderDetails['ordered_customer_name'] ?? '',
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: GoogleFonts.poppins(
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Strings.OrderSummary,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                InkWell(
                  onTap: () async {
                    await showCupertinoModalPopup(
                        context: context,
                        builder: (BuildContext childContext) =>
                            GlobalModelClass.globalObject.showAlertWith(
                                parentContext: context,
                                childContext: childContext,
                                alertTitle: Strings.selectAStatus,
                                alertButtons: [
                                  CupertinoActionSheetAction(
                                    onPressed: () async {
                                      Loader().showLoader(context);
                                      await updateStatusForCurrentOrder(
                                        Strings.Confirmed,
                                        childContext,
                                        context,
                                        selectedOrderDetails['ord_id']
                                            .toString(),
                                      );
                                      Loader().hideLoader(context);
                                      Get.back();
                                    },
                                    child: Text(
                                      Strings.Confirmed,
                                      style:
                                          GoogleFonts.poppins(color: mainColor),
                                    ),
                                  ),
                                  CupertinoActionSheetAction(
                                    onPressed: () async {
                                      Loader().showLoader(context);
                                      await updateStatusForCurrentOrder(
                                        Strings.orderDispatched,
                                        childContext,
                                        context,
                                        selectedOrderDetails['ord_id']
                                            .toString(),
                                      );
                                      Loader().hideLoader(context);
                                      Get.back();
                                    },
                                    child: Text(
                                      Strings.orderDispatched,
                                      style:
                                          GoogleFonts.poppins(color: mainColor),
                                    ),
                                  ),
                                  CupertinoActionSheetAction(
                                    onPressed: () async {
                                      Loader().showLoader(context);
                                      await updateStatusForCurrentOrder(
                                          Strings.partOrderDispatched,
                                          childContext,
                                          context,
                                          selectedOrderDetails['ord_id']
                                              .toString());
                                      Loader().hideLoader(context);
                                      Get.back();
                                    },
                                    child: Text(
                                      Strings.partOrderDispatched,
                                      style:
                                          GoogleFonts.poppins(color: mainColor),
                                    ),
                                  ),
                                ])).then((value) => null);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.all(3),
                    child: Text(
                      selectedOrderDetails['status'] ?? '',
                      style: GoogleFonts.poppins(
                        color: Colors.black87,
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Container(
                  width: 100,
                  child: Text(
                    Strings.OrderDate,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(width: 25),
                Text(
                  selectedOrderDetails['created_at'] ?? '',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            SizedBox(height: 3),
            Row(
              children: [
                Container(
                  width: 100,
                  child: Text(
                    Strings.Order + " #",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(width: 25),
                Text(
                  selectedOrderDetails['comp_ord_id'].toString() ?? '0',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            SizedBox(height: 3),
            Row(
              children: [
                Container(
                  width: 100,
                  child: Text(
                    Strings.OrderTotal,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(width: 25),
                Text(
                  '₹ ${selectedOrderDetails['amount'].toStringAsFixed(2)} (${selectedOrderDetails['order_products']?.length ?? '0'} ${Strings.items.toLowerCase()})',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10)
          ],
        ),
      ),
    );
  }

  Widget customerDetail() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
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
            style: GoogleFonts.poppins(
              color: Colors.black.withOpacity(0.7),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          selectedOrderDetails['ordered_customer_phoneNumber'] == null
              ?SizedBox()
              : Row(
                  children: [
                    Text(
                      '${Strings.Contact}: ',
                      style: GoogleFonts.poppins(
                        color: Colors.black.withOpacity(0.7),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      selectedOrderDetails['ordered_customer_phoneNumber'] ?? '',
                      style: GoogleFonts.poppins(
                        color: Colors.black.withOpacity(0.7),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
          selectedOrderDetails['ordered_customer_email'] == null
              ?SizedBox()
              : Row(
                  children: [
                    Text(
                      'E-mail : ',
                      style: GoogleFonts.poppins(
                        color: Colors.black.withOpacity(0.7),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      selectedOrderDetails['ordered_customer_email'] ?? '',
                      style: GoogleFonts.poppins(
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

  updateStatusForCurrentOrder(String updateStatus, BuildContext context,
      BuildContext parentContext, String orderId) async {
    if (GlobalModelClass.internetConnectionAvaiable() == true) {
      String loggedInUserId = LoginModelClass.loginModelObj
          .getValueForKeyFromLoginResponse(key: 'user_id');

      var url = Base_URL +
          changeOrderStatus +
          '&logged_in_userid=$loggedInUserId&status=$updateStatus&order_id=$orderId';

      setState(() {});

      http.Response resp = await http.get(Uri.parse(url), headers: {
        'Authorization': LoginModelClass.loginModelObj
            .getValueForKeyFromLoginResponse(key: 'token'),
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      });

      if (resp.statusCode == 200) {
        var jsonBodyResp = jsonDecode(resp.body);

        if (jsonBodyResp['status'] == true) {
          getOrderDetailsFromServer();
        } else {
          setState(() {
            Loader().hideLoader(context);
          });
          Loader().hideLoader(context);
          showCupertinoDialog(
            context: parentContext,
            builder: (BuildContext context) => CupertinoAlertDialog(
              title: Text(
                Strings.errorOccurred,
                style: GoogleFonts.poppins(
                  fontSize: 13.0,
                ),
              ),
              content: Text(
                jsonBodyResp['message'] ?? '',
                style: GoogleFonts.poppins(
                  fontSize: 15.0,
                ),
              ),
              actions: [
                CupertinoDialogAction(
                  onPressed: () {
                    getOrderDetailsFromServer();
                    Get.back();
                  },
                  child: Text(Strings.Dismiss),
                ),
              ],
            ),
          );
        }
      } else {
        Loader().hideLoader(context);
        setState(() {});

        print('Error occurred while serving request');
      }
    } else {
      Future.delayed(Duration.zero, () {
        GlobalModelClass.showAlertForNoInternetConnection(context).show();
      });
    }
  }
}
