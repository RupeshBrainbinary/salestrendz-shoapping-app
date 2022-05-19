import 'package:flutter/material.dart';
import 'package:shoppingapp/utils/commons/export_basic_file.dart';

class RewardProgram extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("Current page --> $runtimeType");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        centerTitle: true,
        title: Text(
          "Reward Program",
          style: GoogleFonts.poppins(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.grey[200],
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                width: double.infinity,
                margin: EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "How it works",
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      child: Row(
                        children: [
                          Container(
                            width: 45,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(150),
                              color: Colors.pink[100],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Icon(
                                Icons.star,
                                color: Colors.red[600],
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Container(
                            width: Get.width * 0.65,
                            child: Column(
                              children: [
                                Text(
                                  "Start Properly Rewarding Your Customers for Their Referrals",
                                  style: GoogleFonts.poppins(
                                    color: Colors.grey[400],
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      width: double.infinity,
                      child: Row(
                        children: [
                          Container(
                            width: 45,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(150),
                              color: Colors.pink[100],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Icon(
                                Icons.star,
                                color: Colors.red[600],
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Container(
                            width: Get.width * 0.65,
                            child: Column(
                              children: [
                                Text(
                                  "Ensuring you have the right rewards for your referral program will maximize.",
                                  style: GoogleFonts.poppins(
                                    color: Colors.grey[400],
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      width: double.infinity,
                      child: Row(
                        children: [
                          Container(
                            width: 45,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(150),
                              color: Colors.pink[100],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Icon(
                                Icons.star,
                                color: Colors.red[600],
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Container(
                            width: Get.width * 0.65,
                            child: Column(
                              children: [
                                Text(
                                  "Each new referral represents one customer that you didn't need to spend.",
                                  style: GoogleFonts.poppins(
                                    color: Colors.grey[400],
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                width: double.infinity,
                margin: EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "FAQs",
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    Divider(thickness: 1),
                    Text(
                      "What is the referral program?",
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Your referrals can start their trial for SalesTrendz by singing up through your unique referrals link, they will have the option to apply one to your promomotion"
                          " codes when they enter their billing information anytime within the 14-day trial period.",
                          style: GoogleFonts.poppins(
                            color: Colors.grey[400],
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "What can i refer?",
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "What is the Crireria for an eligible referral?",
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Where can i find my referral link?",
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "How much can i earn?",
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Is there a way for me to track the status of my referral?",
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    )
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
