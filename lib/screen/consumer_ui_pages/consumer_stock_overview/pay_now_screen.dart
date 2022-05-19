import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shoppingapp/utils/theme_notifier.dart';
import 'package:get/get.dart';

class PayNowScreen extends StatefulWidget {
  @override
  _PayNowScreenState createState() => _PayNowScreenState();
}

class _PayNowScreenState extends State<PayNowScreen> {
  int totalAmount = 300000;

  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<ThemeNotifier>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Pay Now',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          elevation: 0.0,
          // backgroundColor: themeColor.getColor(),
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Get.back();
              }),
        ),
        body: Column(
          children: [
            Container(
              height: Get.height * 0.2,
              width: Get.width,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: themeColor.getColor(),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.zero,
                  topRight: Radius.zero,
                  bottomLeft: Radius.circular(22.0),
                  bottomRight: Radius.circular(22.0),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 30),
                  Text(
                    '₹ 5,55,000',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Total Outstanding ',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            paymentProcessData(),
          ],
        ),
      ),
    );
  }

  Widget paymentProcessData() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 10, top: 35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text(
              'To avail cash discounnt min amount to be paid. ₹4,00,000',
              // textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                // color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Text(
                  'Min. amount to be paid',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    // color: Colors.white,
                    fontSize: 16,
                  ),
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
                        if (totalAmount == 400000) {
                          setState(() {
                            totalAmount = totalAmount - 100000;
                          });
                        }
                      },
                      child: Container(
                        child: Text(
                          '-',
                          style: GoogleFonts.poppins(
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
                        totalAmount.toString(),
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(width: 7),
                    InkWell(
                      onTap: () {
                        setState(() {
                          if (totalAmount == 300000) {
                            setState(() {
                              totalAmount = totalAmount + 100000;
                            });
                          }
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
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Text(
                    totalAmount == 400000 ? 'You save (5%)' : 'You save (0%)',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      // color: Colors.white,
                      fontSize: 16,
                    )),
              ),
              Container(
                child: Text(
                  totalAmount == 400000 ? '₹20000' : '0',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: Colors.red,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Text(
                  'Amount to be transfered',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    // color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              Container(
                child: Text(
                  '₹$totalAmount',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    // color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
