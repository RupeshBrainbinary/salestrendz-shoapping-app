import 'package:flutter/material.dart';
import 'package:shoppingapp/utils/commons/export_basic_file.dart';

class SpentTransaction extends StatefulWidget {
  @override
  _SpentTransactionState createState() => _SpentTransactionState();
}

class _SpentTransactionState extends State<SpentTransaction> {
  @override
  Widget build(BuildContext context) {
    print("Current page --> $runtimeType");
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(left: 15),
        child: Column(
          children: [
            SizedBox(height: 7),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: data.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Row(
                      children: [
                        Container(
                          height: Get.height * 0.07,
                          width: Get.width * 0.13,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: Colors.red,
                                ),
                                height: Get.height * 0.06,
                                width: Get.width * 0.11,
                                child: Center(
                                  child: Text(
                                    Strings.Or,
                                    style: GoogleFonts.poppins(
                                        color: Colors.white),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: Get.width * 0.52,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      data[index]['Name'],
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
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
                                      "Qty: 5",
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      "Amt: ???2000",
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: Get.width * 0.25,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Flexible(
                                    child: Text(
                                      data[index]['Point'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    child: Icon(
                                      Icons.arrow_downward,
                                      color: Colors.red,
                                      size: 22,
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: Text(
                                      data[index]['Date'],
                                      style: TextStyle(
                                        color: Colors.grey[700],
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
                );
              },
            )
          ],
        ),
      ),
    );
  }

  List data = [
    {
      'status': '1',
      'id': 'Or',
      'Name': 'Order #752',
      'Qty': '5',
      'Amt': '???52,356',
      'Point': '10',
      'Date': 'Dec 23,2020',
      'Cname': ''
    },
    {
      'status': '2',
      'id': 'Pa',
      'Name': 'Order #752',
      'Qty': '#41',
      'Amt': '???52,356',
      'Point': '25',
      'Date': 'Dec 23,2020'
    },
    {
      'status': '3',
      'id': 'Or',
      'Name': 'Order #752',
      'Qty': '1',
      'Amt': '2000',
      'Point': '10',
      'Date': 'Dec 23,2020'
    },
  ];
}
