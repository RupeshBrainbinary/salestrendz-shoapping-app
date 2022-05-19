import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shoppingapp/widgets/commons/string_res.dart';

class ReturnProductManager extends StatefulWidget {
  @override
  _ReturnProductManagerState createState() => _ReturnProductManagerState();
}

class ReturnProductManageModel {
  ReturnProductManageModel({this.name, this.counter, this.sku});

  String name;
  int counter;
  String sku;
}

class _ReturnProductManagerState extends State<ReturnProductManager> {
  List<ReturnProductManageModel> dataList = [];

  addListDataFunction() {
    dataList.add(ReturnProductManageModel(
        counter: 0,
        name: 'Fitkit Classic Bottle Shaker 700ml',
        sku: 'QAMLLPWO10'));
    dataList.add(ReturnProductManageModel(
        counter: 0,
        name: 'Abbzorb Nutrition Raw Whey Protein 80% 26.6g Protein (1 kg Jar)',
        sku: 'QAMLLPWO12'));
    dataList.add(ReturnProductManageModel(
        counter: 0,
        name: 'AS - IT - IS Shaker Bottle, 400ml, Black',
        sku: 'QAMLLPWO13'));
    dataList.add(ReturnProductManageModel(
        counter: 0,
        name: 'AS - IT - IS Shaker Bottle, 400ml, Black',
        sku: 'QAMLLPWO15'));
    dataList.add(ReturnProductManageModel(
        counter: 0,
        name: 'Abbzorb Nutrition Raw Whey Protein 80% 26.6g Protein (1 kg Jar)',
        sku: 'QAMLLPWO17'));
    dataList.add(ReturnProductManageModel(
        counter: 0,
        name: 'AS - IT - IS Shaker Bottle, 400ml, Black',
        sku: 'QAMLLPWO18'));
    dataList.add(ReturnProductManageModel(
        counter: 0,
        name: 'Abbzorb Nutrition Raw Whey Protein 80% 26.6g Protein (1 kg Jar)',
        sku: 'QAMLLPWO20'));
    dataList.add(ReturnProductManageModel(
        counter: 0,
        name: 'Fitkit Classic Bottle Shaker 700ml',
        sku: 'QAMLLPWO29'));
    dataList.add(ReturnProductManageModel(
        counter: 0,
        name: 'AS - IT - IS Shaker Bottle, 400ml, Black',
        sku: 'QAMLLPWO24'));
    dataList.add(ReturnProductManageModel(
        counter: 0,
        name: 'AS - IT - IS Shaker Bottle, 400ml, Black',
        sku: 'QAMLLPWO36'));
    dataList.add(ReturnProductManageModel(
        counter: 0,
        name: 'Abbzorb Nutrition Raw Whey Protein 80% 26.6g Protein (1 kg Jar)',
        sku: 'QAMLLPWO45'));
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
          leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            Strings.SelectProducts,
            style: GoogleFonts.poppins(
              color: Colors.black.withOpacity(0.6),
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            Center(
              child: Container(
                margin: EdgeInsets.only(right: 10),
                child: Text(
                  Strings.Filter,
                  style: GoogleFonts.poppins(
                    color: Colors.black.withOpacity(0.6),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            )
          ],
        ),
        body: Container(
          child: productListData(),
        ),
        bottomNavigationBar: bottomAddReturnButton(),
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
            margin: EdgeInsets.only(top: 35),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      child: Image.asset(
                        "assets/images/coke.png",
                        height: 50,
                        width: 50,
                        // color: Colors.white,
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 2,
                      child: dataList[index].counter == 0
                          ?SizedBox()
                          : Icon(Icons.check_circle_sharp,
                              color: Colors.red, size: 16),
                    ),
                  ],
                ),
                SizedBox(width: 5),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dataList[index].name,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        'SKU: ' + dataList[index].sku,
                        style: GoogleFonts.poppins(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 2),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: dataList[index].counter == 0
                                    ? Colors.red
                                    : Color.fromRGBO(114, 170, 2, 1.0)),
                            child: Text(
                              dataList[index].counter.toString(),
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Text(
                            'Stock',
                            style: GoogleFonts.poppins(
                              color: Colors.grey,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 15)
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.red)),
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
                                style: TextStyle(
                                  fontSize: 24,
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
                                style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }

// ====================      BOTTOM ADD RETURN BUTTON      ===================

  Widget bottomAddReturnButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context, dataList);
      },
      child: Container(
        margin: EdgeInsets.only(left: 30, right: 30, top: 5),
        alignment: Alignment.bottomCenter,
        height: Get.height * 0.05,
        width: Get.width * 0.5,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.red,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(22.0),
            topRight: Radius.circular(22.0),
            bottomLeft: Radius.zero,
            bottomRight: Radius.zero,
          ),
        ),
        child: Text(
          Strings.AddToReturn,
          style: GoogleFonts.poppins(
            fontSize: 15,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
