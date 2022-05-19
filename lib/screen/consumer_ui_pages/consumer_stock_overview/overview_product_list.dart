import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'product_expiring_detail.dart';

class OverviewProductList extends StatefulWidget {
  OverviewProductList({this.title});

  @required
  final String title;

  @override
  _OverviewProductListState createState() => _OverviewProductListState();
}

class _OverviewProductListState extends State<OverviewProductList> {
  List<String> listData = [
    'Fitkit Classic Bottle Shaker 700ml',
    'Abbzorb Nutrition Raw Whey Protein 80% 26.6g Protein (1 kg Jar)',
    'AS - IT - IS Shaker Bottle, 400ml, Black'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 252, 252, 252),
        title: Text(
          widget.title,
          style: GoogleFonts.poppins(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              SizedBox(height: 40),
              dateTimePicker(),
              SizedBox(height: 20),
              Expanded(child: productListData()),
            ],
          ),
        ),
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
              'This month',
              style: GoogleFonts.poppins(color: Colors.grey),
            ),
          ),
          Container(
            child: Icon(Icons.date_range, color: Colors.grey),
          ),
        ],
      ),
    );
  }

// =========================        PRODUCT LIST DATA      ================

  Widget productListData() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListView.builder(
        itemCount: listData.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              Get.to(() => ProductExpiringDetail(
                    itemName: listData[index],
                  ));
            },
            child: Container(
              margin: EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1.0,
                  color: Colors.black.withOpacity(0.1),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    child: Image.asset(
                      "assets/images/coke.png",
                      height: 50,
                      width: 50,
                      // color: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(
                            listData[index],
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            'No. Product(s) 2',
                            style: GoogleFonts.poppins(color: Colors.grey),
                          ),
                        ),
                      ],
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
