import 'package:shoppingapp/screen/order_transaction/order_filter.dart';
import 'package:shoppingapp/utils/commons/export_basic_file.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SalesTransaction extends StatefulWidget {
  SalesTransaction({this.pageRouteType});

  final dynamic pageRouteType;

  @override
  SalesTransactionState createState() => SalesTransactionState();
}

class SalesTransactionState extends State<SalesTransaction> {
  SalesOrderViewModel model;
  bool isViewShow = true;

  ScrollController controller;
  bool isPaging = false;
  int initPosition = 0;
  int page = 1;

  @override
  void initState() {
    super.initState();
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
        model.getSalesOrderApi(page);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_statements
    model ?? (model = SalesOrderViewModel(this));
    final themeColor = Provider.of<ThemeNotifier>(context);
    print("Current page --> $runtimeType");
    return Container(
      width: double.infinity,
      padding: isViewShow == true
          ? EdgeInsets.only(left: 8, top: 10)
          : EdgeInsets.only(left: 15, top: 5),
      child: model.salesOrder == null
          ? Center(child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(themeColor.getColor())))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 45,
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 5,
                        offset: Offset(0, 0), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset(
                                "assets/images/sort.png",
                                height: 25,
                                color: Colors.grey,
                              ),
                              //SizedBox(width: 10),
                              Text(
                                "Sort by",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Get.to(() => OrderFilterScreen()).then((value){
                              model.getSalesOrderApi(page);
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Image.asset(
                                "assets/images/filter.png",
                                height: 20,
                                color: Colors.grey,
                              ),
                              SizedBox(width: 5),
                              Text(
                                "Filter",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                model.salesOrder.orders != null &&
                        model.salesOrder.orders.isNotEmpty
                    ? Expanded(
                        child: ListView.builder(
                          controller: controller,
                          itemCount: model.salesOrder.orders?.length ?? 0,
                          itemBuilder: (context, index) {
                            DateTime dateTime = DateTime.parse(model
                                .salesOrder.orders[index].createdAt
                                .toString());

                            DateFormat formatter = new DateFormat.yMMMd();
                            String date1 = formatter.format(dateTime);

                            return orderTile(index, themeColor, date1);
                          },
                        ),
                      )
                    : Center(
                        child: Text(
                          Strings.ordernotfound,
                          style: GoogleFonts.poppins(fontSize: 25),
                        ),
                      ),
              ],
            ),
    );
  }

  String getQtyString(String productCount) {
    if (productCount == 'null') {
      return Strings.Qty + "0";
    }
    return Strings.Qty + "" + productCount.toString();
  }

  orderTile(int index, themeColor, date1) {
    return Container(
      child: InkWell(
        onTap: () async {
          var data = await Get.to(
            () => ReceivedOrderPage(
              productId: model.salesOrder.orders[index].ordId,
            ),
          );

          await model.getSalesOrderApiInitial();
        },
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(5),
            child: Row(
              children: [
                Container(
                  width: Get.width * 0.13,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 8, bottom: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: themeColor.getColor(),
                        ),
                        width: Get.width * 0.11,
                        child: Center(
                          child: Text(
                            widget.pageRouteType ==
                                    OrderTransactionType.productReturned
                                ? Strings.Re
                                : Strings.Or,
                            style: GoogleFonts.poppins(color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  width: Get.width * 0.5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              widget.pageRouteType ==
                                      OrderTransactionType.productReturned
                                  ? model.salesOrder.orders
                                      .toString()
                                      .replaceAll('Order', 'Return')
                                  : Strings.order +
                                      model.salesOrder.orders[index]?.compOrdId
                                          .toString() ??  "",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              getQtyString(model.salesOrder.orders[index]?.productCount?.toString() ?? 0),
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w300,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              "${Strings.Amt}" +
                                      " ₹" +
                                      model.salesOrder.orders[index].amount.toStringAsFixed(2).toString() ?? 0,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w300,
                                fontSize: 13,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          model.salesOrder.orders[index].status.toString() == "" || model.salesOrder.orders[index].status == null
                              ?SizedBox()
                              : Container(
                                  width: Get.width * 0.275,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey[200],
                                    ),
                                  ),
                                  padding: EdgeInsets.fromLTRB(7, 2, 7, 2),
                                  child: Center(
                                    child: AutoSizeText(
                                      model.salesOrder.orders[index].status,
                                      maxLines: 1,
                                      maxFontSize: 12,
                                      minFontSize: 7,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                        color: model.salesOrder.orders[index]
                                                    ?.status ==
                                                "PENDING"
                                            ? widget.pageRouteType ==
                                                    OrderTransactionType
                                                        .productReturned
                                                ? Colors.black
                                                : Colors.blue
                                            : model.salesOrder.orders[index]
                                                        ?.status ==
                                                    "Placed"
                                                ? Colors.green
                                                : model.salesOrder.orders[index]
                                                            ?.status ==
                                                        "CANCELLED"
                                                    ? Colors.red
                                                    : model
                                                                .salesOrder
                                                                .orders[index]
                                                                ?.status ==
                                                            "PART SUPPLIED"
                                                        ? widget.pageRouteType ==
                                                                OrderTransactionType
                                                                    .productReturned
                                                            ? Colors.green
                                                            : Colors.yellow[800]
                                                        : Colors.black,
                                        fontWeight: widget.pageRouteType ==
                                                OrderTransactionType
                                                    .productReturned
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            date1.toString(),
                            style: GoogleFonts.poppins(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
