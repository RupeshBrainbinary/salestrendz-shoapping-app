import 'package:flutter/material.dart';
import 'package:shoppingapp/utils/commons/export_basic_file.dart';

class ReferralsTransaction extends StatefulWidget {
  @override
  _ReferralsTransactionState createState() => _ReferralsTransactionState();
}

class _ReferralsTransactionState extends State<ReferralsTransaction> {
  bool valueFirst = true;
  bool valueSecond = true;
  bool valueThird = true;
  bool valueFourth = true;
  bool valueFive = true;
  bool valueSix = false;

  bool isShow = true;

  List data = [
    {
      'Name': 'David Warner',
      'status': '0',
    },
    {
      'Name': 'Stive Smith',
      'status': '1',
    },
    {
      'Name': 'Aaron Finch',
      'status': '2',
    },
    {
      'Name': 'Rose Pink',
      'status': '3',
    }
  ];

  @override
  Widget build(BuildContext context) {
    print("Current page --> $runtimeType");
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(left: 14),
        child: isShow
            ? Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 7),
                    InkWell(
                      onTap: () {
                        isShow = false;
                        setState(() {});
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: Container(
                          height: Get.height * 0.22,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey[400]),
                          ),
                          child: Row(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Image.asset(
                                      "assets/images/gems.png",
                                      height: 80,
                                      width: 70,
                                    ),
                                  )
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 20, bottom: 20),
                                child: VerticalDivider(
                                  thickness: 1,
                                  color: Colors.grey[400],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(top: 25),
                                    width: Get.width * 0.6,
                                    child: Text(
                                      "Increase earning by 150%",
                                      style: GoogleFonts.roboto(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Container(
                                    width: Get.width * 0.6,
                                    child: Text(
                                      "Increase referral earning on each successful invite",
                                      style: GoogleFonts.roboto(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Expanded(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: 80,
                                          child: Text(
                                            "Your Code: ",
                                            style: GoogleFonts.roboto(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 120,
                                          child: Text(
                                            "STZ197800000",
                                            style: GoogleFonts.roboto(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {},
                                          child: Icon(
                                            Icons.mobile_screen_share,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding:
                              EdgeInsets.only(right: 20, top: 10, bottom: 5),
                          child: Container(
                            height: Get.width * 0.48,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey[400]),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 12),
                                  child: Text(
                                    data[index]['Name'],
                                    style: GoogleFonts.roboto(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 5),
                                  child: Text.rich(
                                    TextSpan(
                                      text: "Referral Status: ",
                                      style: GoogleFonts.roboto(
                                        fontSize: 16,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      children: <InlineSpan>[
                                        TextSpan(
                                          text: "Succesful",
                                          style: TextStyle(
                                            color: Colors.black87,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Row(
                                    children: [
                                      Column(
                                        children: [
                                          Container(
                                            width: Get.width * 0.26,
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: Get.width * 0.07,
                                                  child: Checkbox(
                                                    activeColor: Colors.green,
                                                    value: valueFirst,
                                                    onChanged: (bool value) {},
                                                  ),
                                                ),
                                                Container(
                                                  width: Get.width * 0.18,
                                                  child: Text(
                                                    "Signed Up",
                                                    style: TextStyle(
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        width: Get.width * 0.4,
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  width: Get.width * 0.06,
                                                  child: Checkbox(
                                                    activeColor: Colors.green,
                                                    value: this.valueSecond,
                                                    onChanged: (bool value) {},
                                                  ),
                                                ),
                                                Container(
                                                  width: Get.width * 0.3,
                                                  child: Text(
                                                    "Profile Complete",
                                                    style: TextStyle(
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: Get.width * 0.23,
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  width: Get.width * 0.06,
                                                  child: Checkbox(
                                                    activeColor: Colors.green,
                                                    value: this.valueThird,
                                                    onChanged: (bool value) {},
                                                  ),
                                                ),
                                                Container(
                                                  width: Get.width * 0.17,
                                                  child: Text(
                                                    "Ordered",
                                                    style: TextStyle(
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
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
                                Divider(
                                  height: 1,
                                  thickness: 2,
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        "assets/images/trophy.png",
                                        height: 35,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        "You've Got a Reward!",
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              )
            : Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 7,
                    ),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding:
                              EdgeInsets.only(right: 20, top: 10, bottom: 5),
                          child: Container(
                            height: Get.width * 0.51,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey[400]),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 12),
                                  child: Text(
                                    data[index]['Name'],
                                    style: TextStyle(
                                      fontSize: 23,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 5),
                                  child: Text.rich(
                                    TextSpan(
                                      text: "Referral Status: ",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      children: <InlineSpan>[
                                        TextSpan(
                                          text: "Not Ordered",
                                          style: TextStyle(
                                            color: Colors.black87,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 15),
                                  child: Row(
                                    children: [
                                      Column(
                                        children: [
                                          Container(
                                            width: Get.width * 0.26,
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: Get.width * 0.07,
                                                  child: Checkbox(
                                                    activeColor: Colors.green,
                                                    value: valueFourth,
                                                    onChanged: (bool value) {},
                                                  ),
                                                ),
                                                Container(
                                                  width: Get.width * 0.18,
                                                  child: Text(
                                                    "Signed Up",
                                                    style: TextStyle(
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        width: Get.width * 0.4,
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  width: Get.width * 0.06,
                                                  child: Checkbox(
                                                    activeColor: Colors.green,
                                                    value: this.valueFive,
                                                    onChanged: (bool value) {},
                                                  ),
                                                ),
                                                Container(
                                                  width: Get.width * 0.3,
                                                  child: Text(
                                                    "Profile Complete",
                                                    style: TextStyle(
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: Get.width * 0.23,
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  width: Get.width * 0.06,
                                                  child: Checkbox(
                                                    activeColor: Colors.green,
                                                    value: this.valueSix,
                                                    onChanged: (bool value) {},
                                                  ),
                                                ),
                                                Container(
                                                  width: Get.width * 0.17,
                                                  child: Text(
                                                    "Ordered",
                                                    style: TextStyle(
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
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
                                Divider(
                                  height: 1,
                                  thickness: 2,
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        child: RaisedButton(
                                            child: Text(
                                                "Remind ${data[index]['Name']}"),
                                            onPressed: () {}),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
