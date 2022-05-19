import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:signature/signature.dart';
import 'package:get/get.dart';

import 'return_product_manage.dart';

class ReturnScreen extends StatefulWidget {
  @override
  _ReturnScreenState createState() => _ReturnScreenState();
}

class _ReturnScreenState extends State<ReturnScreen> {
  List<ReturnProductManageModel> dataList = [];
  final SignatureController signatureController = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    print("Current page --> $runtimeType");
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            'Return',
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          // elevation: 0.5,
          // backgroundColor: themeColor.getColor(),
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () {
                Get.back();
              }),
        ),
        bottomNavigationBar: InkWell(
          onTap: () {
            Get.back();
          },
          child: Container(
            margin: EdgeInsets.only(left: 30, right: 30),
            alignment: Alignment.bottomCenter,
            height: Get.height / 18,
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
              'Submit',
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ),
        body: Container(
          color: Colors.white,
          child: ListView(
            children: [
              Container(
                padding: EdgeInsets.only(
                  left: 15,
                  right: 10,
                  top: 15,
                  bottom: 15,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Supplier',
                          style: GoogleFonts.poppins(
                            color: Colors.black.withOpacity(0.7),
                          ),
                        ),
                        Text(
                          'Raxon Traders',
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.arrow_forward_ios_sharp,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.grey.withOpacity(0.1),
                width: Get.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 10),
                      child: Text('Total Product :' + '${dataList.length}'),
                    ),
                    Container(
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () async {
                              List<ReturnProductManageModel> tempDataList =
                                  await Get.to(() => ReturnProductManager());

                              for (var i = 0; i < tempDataList.length; i++) {
                                if (tempDataList[i].counter != 0) {
                                  dataList.add(tempDataList[i]);
                                }
                              }
                              setState(() {});
                            },
                            child: Container(
                              margin:
                                  EdgeInsets.only(right: 10, top: 8, bottom: 9),
                              child: Icon(
                                Icons.add,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(right: 15, top: 8, bottom: 9),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: Icon(
                              Icons.qr_code_scanner,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              dataList.length == 0
                  ? Container(
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                                top: 30, bottom: 30, right: 20, left: 30),
                            height: 80,
                            width: 80,
                            child: Image.asset(
                              'assets/icons/openbox.png',
                              color: Colors.grey,
                            ),
                          ),
                          Container(
                            child: Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Empty Cart',
                                    style: GoogleFonts.poppins(
                                      color: Colors.black.withOpacity(0.4),
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(
                                    'Your card is currently empty , no product found in '
                                    'your card',
                                    maxLines: 2,
                                    style: GoogleFonts.poppins(
                                      color: Colors.black.withOpacity(0.4),
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : productListData(),
              Divider(height: 10),
              Container(
                padding:
                    EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Sub Total(Rs.):',
                      style: GoogleFonts.poppins(
                        color: Colors.black.withOpacity(0.4),
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      '0',
                      style: GoogleFonts.poppins(
                        color: Colors.black.withOpacity(0.4),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'cGST:',
                      style: GoogleFonts.poppins(
                        color: Colors.black.withOpacity(0.4),
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      '0',
                      style: GoogleFonts.poppins(
                        color: Colors.black.withOpacity(0.4),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'sGST:',
                      style: GoogleFonts.poppins(
                        color: Colors.black.withOpacity(0.4),
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      '0',
                      style: GoogleFonts.poppins(
                        color: Colors.black.withOpacity(0.4),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 10),
              Container(
                padding:
                    EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Cost(Rs.):',
                      style: GoogleFonts.poppins(
                        color: Colors.black.withOpacity(0.4),
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      '0',
                      style: GoogleFonts.poppins(
                        color: Colors.black.withOpacity(0.4),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              noteWidget(),
              signatureWidget(),
            ],
          ),
        ),
      ),
    );
  }

// ===============        NOTE WIDGET ROW         ==================

  Widget noteWidget() {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 15, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Note'),
          Icon(
            Icons.arrow_forward_ios_sharp,
            size: 20,
            color: Colors.black.withOpacity(0.5),
          ),
        ],
      ),
    );
  }

// ===============        SIGNATURE WIDGET ROW         ==================

  Widget signatureWidget() {
    return Container(
      margin: EdgeInsets.only(top: 30, left: 15, right: 15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Signature'),
              Icon(
                Icons.arrow_forward_ios_sharp,
                size: 20,
                color: Colors.black.withOpacity(0.5),
              ),
            ],
          ),
          Signature(
            controller: signatureController,
            height: 150,
            width: Get.width - 94,
            backgroundColor: Theme.of(context).accentColor.withOpacity(0.1),
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
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: dataList.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: EdgeInsets.only(top: 35),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Image.asset(
                    "assets/images/coke.png",
                    height: 50,
                    width: 50,
                    // color: Colors.white,
                  ),
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
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.red),
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
                            style: TextStyle(fontSize: 24, color: Colors.red),
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
                            style: TextStyle(fontSize: 22, color: Colors.red),
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
}
