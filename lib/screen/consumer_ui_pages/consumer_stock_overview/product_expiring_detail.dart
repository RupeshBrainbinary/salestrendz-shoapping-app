import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shoppingapp/widgets/commons/string_res.dart';
import 'package:get/get.dart';

class ProductExpiringDetail extends StatefulWidget {
  ProductExpiringDetail({this.itemName});

  final String itemName;

  @override
  _ProductExpiringDetailState createState() => _ProductExpiringDetailState();
}

class ProductExpiringDetailModel {
  ProductExpiringDetailModel({this.mtfDate, this.expiryDate, this.counter});

  String mtfDate;
  String expiryDate;
  int counter;
}

class _ProductExpiringDetailState extends State<ProductExpiringDetail> {
  List<ProductExpiringDetailModel> dataList = [];

  addListDataFunction() {
    dataList.add(ProductExpiringDetailModel(
        counter: 0, expiryDate: 'Dec 31, 2020', mtfDate: 'Jan 01, 2020'));
    dataList.add(ProductExpiringDetailModel(
        counter: 0, expiryDate: 'Dec 31, 2020', mtfDate: 'Jan 01, 2020'));
    dataList.add(ProductExpiringDetailModel(
        counter: 0, expiryDate: 'Dec 31, 2020', mtfDate: 'Jan 01, 2020'));
    dataList.add(ProductExpiringDetailModel(
        counter: 0, expiryDate: 'Dec 31, 2020', mtfDate: 'Jan 01, 2020'));
    dataList.add(ProductExpiringDetailModel(
        counter: 0, expiryDate: 'Dec 31, 2020', mtfDate: 'Jan 01, 2020'));
    dataList.add(ProductExpiringDetailModel(
        counter: 0, expiryDate: 'Dec 31, 2020', mtfDate: 'Jan 01, 2020'));
    dataList.add(ProductExpiringDetailModel(
        counter: 0, expiryDate: 'Dec 31, 2020', mtfDate: 'Jan 01, 2020'));
    dataList.add(ProductExpiringDetailModel(
        counter: 0, expiryDate: 'Dec 31, 2020', mtfDate: 'Jan 01, 2020'));
    dataList.add(ProductExpiringDetailModel(
        counter: 0, expiryDate: 'Dec 31, 2020', mtfDate: 'Jan 01, 2020'));
    dataList.add(ProductExpiringDetailModel(
        counter: 0, expiryDate: 'Dec 31, 2020', mtfDate: 'Jan 01, 2020'));
    dataList.add(ProductExpiringDetailModel(
        counter: 0, expiryDate: 'Dec 31, 2020', mtfDate: 'Jan 01, 2020'));
    dataList.add(ProductExpiringDetailModel(
        counter: 0, expiryDate: 'Dec 31, 2020', mtfDate: 'Jan 01, 2020'));
  }

  @override
  void initState() {
    addListDataFunction();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          // elevation: 0,
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
            'Product Expiring',
            style: GoogleFonts.poppins(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: Container(
          child: Column(
            children: [
              productDetailHeader(),
              SizedBox(height: 20),
              dateTimePicker(),
              Expanded(
                child: productListData(),
              ),
            ],
          ),
        ),
        bottomNavigationBar: bottomButtonRow(),
      ),
    );
  }

// ========================         PROUCT DETAIL HEADER          ======================

  Widget productDetailHeader() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Container(
            child: Image.asset(
              "assets/images/coke.png",
              height: 50,
              width: 50,
            ),
          ),
          SizedBox(width: 5),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SKU-PSBS-4526',
                  style: GoogleFonts.poppins(fontSize: 12),
                ),
                Text(
                  widget.itemName ?? '',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'MRP: 80000',
                      style: GoogleFonts.poppins(fontSize: 12),
                    ),
                    SizedBox(width: 30),
                    Text(
                      'Stock: 480',
                      style: GoogleFonts.poppins(fontSize: 12),
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
              'This Month',
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
        itemCount: dataList.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: EdgeInsets.only(top: 20),
            // decoration: BoxDecoration(
            //   border: Border.all(
            //     width: 1.0,
            //     color: Colors.black.withOpacity(0.1),
            //   ),
            // ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Batch #BN100${index + 1}',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Mft Date:',
                                  style: GoogleFonts.poppins(fontSize: 12),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Expiry Date:',
                                  style: GoogleFonts.poppins(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 30),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  dataList[index].mtfDate,
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  dataList[index].expiryDate,
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: Colors.red,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          if (dataList[index].counter != 0) {
                            setState(() {
                              dataList[index].counter--;
                            });
                          }
                        },
                        child: Container(
                          child: Text(
                            '-',
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 7),
                      Container(
                        margin: EdgeInsets.only(top: 4),
                        child: Text(
                          dataList[index].counter.toString(),
                          style: GoogleFonts.poppins(),
                        ),
                      ),
                      SizedBox(width: 7),
                      InkWell(
                        onTap: () {
                          setState(() {
                            dataList[index].counter++;
                          });
                        },
                        child: Container(
                          child: Text(
                            '+',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

// ====================         BOTTOM BUTTON ROW       =================

  Widget bottomButtonRow() {
    return Container(
      height: 45,
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                Get.back();
              },
              child: Container(
                child: Column(
                  children: [
                    SizedBox(height: 5),
                    Text(
                      Strings.ViewExpiryList,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${dataList.length} Products in list',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                Get.back();
              },
              child: Container(
                height: 60,
                color: Colors.red,
                child: Center(
                  child: Text(
                    Strings.AddToExpiryList,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
