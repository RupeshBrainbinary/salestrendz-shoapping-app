import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shoppingapp/screen/order_transaction/order_transaction.dart';
import 'package:shoppingapp/widgets/commons/string_res.dart';

class ConsumerStockOverViewPage extends StatefulWidget {
  @override
  _ConsumerStockOverViewPageState createState() =>
      _ConsumerStockOverViewPageState();
}

class _ConsumerStockOverViewPageState extends State<ConsumerStockOverViewPage> {
  List<String> productOverViewList = [
    Strings.TotalOrder,
    Strings.PendingOrder,
    Strings.ProductReturn,
    Strings.ProductAboutToExpire,
    Strings.TopSellingProducts,
    Strings.LetestSellingProducts,
    Strings.CurrentStock
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          SizedBox(height: 10),
          dateTimePicker(),
          SizedBox(height: 30),
          totalBudgetRoW(),
          SizedBox(height: 20),
          payNowButtonRoW(),
          SizedBox(height: 20),
          gridViewWidget(),
        ],
      ),
    );
  }

// =========================        DATE TIME PICKER      ================

  Widget dateTimePicker() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.grey[300]),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Text(
              'This year',
              style: GoogleFonts.poppins(color: Colors.grey),
            ),
          ),
          Container(
            child: Icon(
              Icons.date_range,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

// =========================        TOTAL BUDGET ROW      ====================

  Widget totalBudgetRoW() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Strings.ledger,
                  style: GoogleFonts.poppins(),
                ),
                Text(
                  Strings.outstanding,
                  style: GoogleFonts.poppins(
                    color: Colors.grey,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Text(
              '₹ 5,55,000',
              style: GoogleFonts.poppins(
                color: Colors.red,
                fontWeight: FontWeight.w600,
                fontSize: 21,
              ),
            ),
          ),
        ],
      ),
    );
  }

// =========================        PAY NOW BUTTOM ROW      ====================

  Widget payNowButtonRoW() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 15),
      padding: EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.red.withOpacity(0.15),
      ),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.info, size: 15),
          Text(
            '  Hurry! Avail 5% discount',
            style: GoogleFonts.poppins(fontSize: 11),
          ),
          Spacer(),
          InkWell(
            // onTap: () {
            // Get.to(() => PayNowScreen());
            // },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.red,
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Text(
                Strings.payNow,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

// =========================        GRIDVIEW WIDGET      ====================

  Widget gridViewWidget() {
    return Container(
      // color: Colors.grey.withOpacity(0.6),
      margin: EdgeInsets.only(left: 10, right: 15),
      padding: EdgeInsets.only(left: 10),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
          crossAxisCount: 2,
        ),
        itemCount: productOverViewList.length,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              if (index == 0) {
                Get.to(
                  () => OrderTransaction(
                      pageRouteType: OrderTransactionType.totalOrder),
                );
              } else if (index == 1) {
                // Get.to(() => OrderTransaction(
                //               pageRouteType:
                //                   OrderTransactionType.pendingOrder,
                //             ));
              } else if (index == 2) {
                // Get.to(() => OrderTransaction(
                //               pageRouteType:
                //                   OrderTransactionType.productReturned,
                //             ));
              } else if (index == 3) {
                //Get.to(() => OverviewProductList(
                //               title: 'Product(s) Expiring (3)',
                //             ));
              } else if (index == 4) {
                // Get.to(() => OverviewProductList(
                //               title: 'Top Selling Product(s)',
                //             ));
              } else if (index == 5) {
                // Get.to(() => OverviewProductList(
                //               title: 'Last Selling Product(s)',
                //             ));
              } else if (index == 6) {
                // Get.to(() => TotalStockListPage());
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                // color: Colors.grey.withOpacity(0.6),
                borderRadius: BorderRadius.all(Radius.circular(4)),
                boxShadow: [
                  BoxShadow(color: Colors.grey, blurRadius: 1.0),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text(
                      '4832',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 22,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    child: Text(
                      productOverViewList[index],
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
