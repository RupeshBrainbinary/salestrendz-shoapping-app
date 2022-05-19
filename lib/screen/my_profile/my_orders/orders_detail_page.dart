import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shoppingapp/models/GlobalModelClass.dart';
import 'package:shoppingapp/screen/auth_screens/login/login_form.dart';
import 'package:shoppingapp/screen/my_profile/my_orders/order_detail_model.dart';
import 'package:shoppingapp/screen/order_transaction/purchase_order/placed_order.dart';
import 'package:shoppingapp/utils/commons/colors.dart';
import 'package:shoppingapp/utils/constants/constants_app_variables.dart';
import 'package:shoppingapp/utils/theme_notifier.dart';
import 'package:shoppingapp/widgets/commons/string_res.dart';

class OrdersDetailPage extends StatefulWidget {
  @override
  OrdersDetailPageState createState() => OrdersDetailPageState();
}

class OrdersDetailPageState extends State<OrdersDetailPage> {
  OrderViewModel model;

  ScrollController controller;
  bool isPaging = false;
  int page = 1;

  @override
  void initState() {
    super.initState();
    if (GlobalModelClass.internetConnectionAvaiable() != true) {
      Future.delayed(Duration.zero, () {
        GlobalModelClass.showAlertForNoInternetConnection(context).show();
      });
    }
    controller = new ScrollController()..addListener(_scrollListener);
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
        model.getOrderApi(page);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_statements
    model ?? (model = OrderViewModel(this));
    final themeColor = Provider.of<ThemeNotifier>(context);

    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(42.0), // here the desired height
          child: AppBar(
            backgroundColor: greyBackground,
            elevation: 0,
            centerTitle: true,
            title: Text(
              Strings.orderDetails,
              style: GoogleFonts.poppins(
                color: Color(0xFF5D6A78),
                fontSize: 15,
              ),
            ),
            leading: IconButton(
              icon: Icon(
                Platform.isAndroid ? Icons.arrow_back : Icons.chevron_left,
                size: 25,
                color: themeColor.getColor(),
              ),
              onPressed: () {
                Get.back();
              },
            ),
          ),
        ),
        backgroundColor: greyBackground,
        body: model.myOrdersList == null
            ? Center(
                child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(themeColor.getColor())),
              )
            : Stack(
                children: <Widget>[
                  model.myOrdersList.orderList.isEmpty
                      ? Container(
                          height: Get.height * 0.8,
                          child: Center(
                            child: Text(
                              Strings.ordernotfound,
                              style: GoogleFonts.poppins(
                                fontSize: 25,
                                color: Colors.grey[500],
                              ),
                            ),
                          ),
                        )
                      : Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                controller: controller,
                                itemCount:
                                    model.myOrdersList.orderList?.length ?? 0,
                                itemBuilder: (context, index) {
                                  return orderTile(index, context);
                                },
                              ),
                            ),
                          ],
                        ),
                ],
              ),
      ),
    );
  }

  orderTile(int index, context) {
    return Container(
      child: InkWell(
        onTap: () {
          Get.to(() => PlacedOrderPage(
              productId: model.myOrdersList.orderList[index].ordId));
        },
        child: Container(
          margin: EdgeInsets.only(
            top: 8,
            left: 16,
            bottom: 8,
            right: 16,
          ),
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
          width: Get.width / 1.25,
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            "assets/images/productPlaceaHolderImage.png",
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        width: 110,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        height: 160,
                        padding: EdgeInsets.all(10),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          AutoSizeText(
                            '${Strings.orderid} : ${model.myOrdersList.orderList[index].ordId ?? 0}',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Color(0xFF5D6A78),
                              fontWeight: FontWeight.w300,
                            ),
                            maxLines: 2,
                            minFontSize: 11,
                          ),
                          SizedBox(height: 2),
                          AutoSizeText(
                            '${Strings.OrderDate} : ${GlobalModelClass.globalObject.convertDateToLocal(fromDate: model.myOrdersList.orderList[index].createdAt) ?? 0}',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Color(0xFF5D6A78),
                              fontWeight: FontWeight.w300,
                            ),
                            maxLines: 2,
                            minFontSize: 11,
                          ),
                          SizedBox(height: 2),
                          AutoSizeText(
                            '${Strings.orderitems}: ${model.myOrdersList.orderList[index].totalQty ?? 0}',
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
                              Container(
                                width: Get.width * 0.6,
                                child: Text(
                                  "${Strings.total} : $currencySymbol ${model.myOrdersList.orderList[index].amount.toStringAsFixed(2) ?? 0}",
                                  style: GoogleFonts.poppins(
                                    color: showMBPrimaryColor ?millBornPrimaryColor :Colors.red,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(3),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(.2),
                                        blurRadius: 6.0,
                                        spreadRadius: 0.0,
                                        offset: Offset(0.0, 1.0),
                                      )
                                    ],
                                  ),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        model.myOrdersList.orderList[index]
                                                .status ??
                                            '${Strings.na}',
                                        style: GoogleFonts.poppins(
                                          color: Color(0xFF5D6A78),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      Icon(
                                        FontAwesome5.dot_circle,
                                        size: 12,
                                        color: Colors.blue,
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(width: 36),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
