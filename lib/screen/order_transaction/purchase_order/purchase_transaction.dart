import 'package:shoppingapp/screen/order_transaction/order_filter.dart';
import 'package:shoppingapp/utils/commons/export_basic_file.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PurchaseTransaction extends StatefulWidget {
  PurchaseTransaction({this.pageRouteType});

  final dynamic pageRouteType;

  @override
  PurchaseTransactionState createState() => PurchaseTransactionState();
}

class PurchaseTransactionState extends State<PurchaseTransaction> {
  PurchaseViewModel model;
  bool isViewShow = true;

  ScrollController controller;
  bool isPaging = false;
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
        model.getPurchaseOrderApi(page);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_statements
    model ?? (model = PurchaseViewModel(this));
    print("Current page --> $runtimeType");
    final themeColor = Provider.of<ThemeNotifier>(context);
    return Container(
      width: double.infinity,
      padding: isViewShow == true
          ? EdgeInsets.only(left: 8, top: 10)
          : EdgeInsets.only(left: 15, top: 5),
      child: model.purchaseOrder == null
          ? Center(
              child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(themeColor.getColor())))
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


                            Get.to(() => OrderFilterScreen()).then((value) {
                              model.getPurchaseOrderApi(page);

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
                model.purchaseOrder.orderList.isNotEmpty ||
                        model.purchaseOrder?.orderList == null
                    ? Expanded(
                        child: ListView.builder(
                          controller: controller,
                          itemCount:
                              model.purchaseOrder?.orderList?.length ?? 0,
                          itemBuilder: (context, index) {
                            DateTime dateTime = DateTime.parse(model
                                    .purchaseOrder
                                    ?.orderList[index]
                                    ?.createdAt ??
                                DateTime.now());
                            DateFormat formatter = new DateFormat.yMMMd();
                            String date1 = formatter.format(dateTime);
                            return purchaseTile(index, themeColor, date1);
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

  purchaseTile(int index, themeColor, date1) {
    return InkWell(
            onTap: () {

              Get.to(() => PlacedOrderPage(
                    productId: model.purchaseOrder.orderList[index].ordId ?? 0,
                  ));

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
                            padding: EdgeInsets.only(
                              top: 8,
                              bottom: 8,
                            ),
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
                                      ? model.purchaseOrder.orderList
                                          .toString()
                                          .replaceAll('Order', 'Return')
                                      : "${Strings.order}" +
                                              model.purchaseOrder
                                                  ?.orderList[index]?.orderId
                                                  .toString() ??
                                          "0",
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
                                  "${Strings.Qty}" +
                                          model.purchaseOrder?.orderList[index]
                                              ?.totalQty
                                              .toString() ??
                                      "0",
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
                                          model.purchaseOrder?.orderList[index]
                                              ?.amount
                                              ?.toStringAsFixed(2)
                                              .toString() ??
                                      "0",
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
                              model.purchaseOrder?.orderList[index]?.status ==
                                          null ||
                                      model.purchaseOrder.orderList[index]
                                          .status.isEmpty
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
                                          model.purchaseOrder?.orderList[index]
                                                  ?.status ??
                                              "",
                                          maxLines: 1,
                                          minFontSize: 7,
                                          maxFontSize: 12,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(
                                            color: model
                                                        .purchaseOrder
                                                        ?.orderList[index]
                                                        ?.status ==
                                                    "PENDING"
                                                ? widget.pageRouteType ==
                                                        OrderTransactionType
                                                            .productReturned
                                                    ? Colors.black
                                                    : Colors.blue
                                                : model
                                                            .purchaseOrder
                                                            ?.orderList[index]
                                                            ?.status ==
                                                        "Placed"
                                                    ? Colors.green
                                                    : model
                                                                .purchaseOrder
                                                                ?.orderList[
                                                                    index]
                                                                ?.status ==
                                                            "CANCELLED"
                                                        ? Colors.red
                                                        : model
                                                                    .purchaseOrder
                                                                    ?.orderList[
                                                                        index]
                                                                    ?.status ==
                                                                "PART SUPPLIED"
                                                            ? widget.pageRouteType ==
                                                                    OrderTransactionType
                                                                        .productReturned
                                                                ? Colors.green
                                                                : Colors
                                                                    .yellow[800]
                                                            : Colors.black,
                                            fontWeight: widget.pageRouteType ==
                                                    OrderTransactionType
                                                        .productReturned
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                            fontSize: 12,
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
                                style: GoogleFonts.poppins(color: Colors.grey),
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
          );
  }
}
