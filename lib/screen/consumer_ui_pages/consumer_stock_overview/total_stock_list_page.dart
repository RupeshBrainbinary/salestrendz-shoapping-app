import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class TotalStockListPage extends StatefulWidget {
  @override
  _TotalStockListPageState createState() => _TotalStockListPageState();
}

class _TotalStockListPageState extends State<TotalStockListPage> {
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
          'Current Stock',
          style: GoogleFonts.poppins(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SafeArea(
        child: productListData(),
      ),
    );
  }

// =========================        PRODUCT LIST DATA      ================

  Widget productListData() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          return Container(
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
                        'Apple iPad (Wi - Fi, 32GB)',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            'MRP: 10000',
                            style: GoogleFonts.poppins(fontSize: 12),
                          ),
                          SizedBox(width: 30),
                          Text(
                            'Stock: 500',
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
        },
      ),
    );
  }
}
