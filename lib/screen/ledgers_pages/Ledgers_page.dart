import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LedgersPage extends StatefulWidget {
  @override
  _LedgersPageState createState() => _LedgersPageState();
}

class _LedgersPageState extends State<LedgersPage> {
  bool show = true;
  bool show1 = false;

  @override
  Widget build(BuildContext context) {
    print("Current page --> $runtimeType");
    return Container(
      height: Get.height - Get.height * 0.245,
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/ledger.png",
                height: Get.height * 0.12,
              ),
              SizedBox(height: 10),
              Text(
                "No Ledger Data Found",
                style: GoogleFonts.poppins(color: Colors.grey, fontSize: 25),
              ),

              // Container(
              //   margin: EdgeInsets.only(left: 15),
              //   height: Get.height - Get.height * 0.25,
              //   width: Get.width,
              //   child: Column(
              //     children: [
              //       Row(
              //         children: [
              //           Container(
              //             width: Get.width * 0.72,
              //             child: Column(
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               mainAxisAlignment: MainAxisAlignment.start,
              //               children: [
              //                 Row(
              //                   children: [
              //                     Text(
              //                       Strings.AsOFDate,
              //                       style: GoogleFonts.poppins(
              //                         fontSize: 16,
              //                         fontWeight: FontWeight.w500,
              //                       ),
              //                     ),
              //                     SizedBox(
              //                       width: 5,
              //                     ),
              //                     Container(
              //                       padding: EdgeInsets.all(5),
              //                       color: Colors.grey[300],
              //                       child: Text(
              //                         Strings.PayNow,
              //                         style: GoogleFonts.poppins(
              //                           fontSize: 12,
              //                           color: Colors.black54,
              //                           fontWeight: FontWeight.w500,
              //                         ),
              //                       ),
              //                     )
              //                   ],
              //                 ),
              //                 Row(
              //                   mainAxisAlignment: MainAxisAlignment.start,
              //                   children: [
              //                     Image.asset(
              //                       "assets/images/money.jpg",
              //                       height: 25,
              //                       width: 50,
              //                     ),
              //                     SizedBox(width: 1),
              //                     Flexible(
              //                       child: Text(
              //                         "14000",
              //                         style: GoogleFonts.poppins(
              //                           fontWeight: FontWeight.w500,
              //                           fontSize: 35,
              //                         ),
              //                       ),
              //                     )
              //                   ],
              //                 ),
              //                 Row(
              //                   children: [
              //                     Text(
              //                       Strings.CreditPeriod,
              //                       style: GoogleFonts.poppins(
              //                         fontWeight: FontWeight.w400,
              //                       ),
              //                     ),
              //                     Flexible(
              //                       child: Text(
              //                         "35 days",
              //                         style: GoogleFonts.poppins(
              //                           fontWeight: FontWeight.w400,
              //                         ),
              //                       ),
              //                     )
              //                   ],
              //                 ),
              //                 SizedBox(height: 2),
              //                 Row(
              //                   children: [
              //                     Text(
              //                       Strings.CreditLimit,
              //                       style: GoogleFonts.poppins(
              //                         fontWeight: FontWeight.w400,
              //                       ),
              //                     ),
              //                     Flexible(
              //                       child: Text(
              //                         "150000",
              //                         style: GoogleFonts.poppins(
              //                           fontWeight: FontWeight.w300,
              //                         ),
              //                       ),
              //                     )
              //                   ],
              //                 ),
              //                 SizedBox(height: 2),
              //                 Row(
              //                   children: [
              //                     Text(
              //                       Strings.CreditPeriod,
              //                       style: GoogleFonts.poppins(
              //                         fontWeight: FontWeight.w400,
              //                       ),
              //                     ),
              //                     Flexible(
              //                       child: Text(
              //                         "50000",
              //                         style: GoogleFonts.poppins(
              //                           fontWeight: FontWeight.w300,
              //                         ),
              //                       ),
              //                     )
              //                   ],
              //                 ),
              //               ],
              //             ),
              //           ),
              //           Container(
              //             alignment: Alignment.topRight,
              //             width: Get.width * 0.2,
              //             height: Get.height * 0.2,
              //             child: Column(
              //               mainAxisAlignment: MainAxisAlignment.start,
              //               crossAxisAlignment: CrossAxisAlignment.end,
              //               children: [
              //                 Image.asset(
              //                   "assets/images/ledger.png",
              //                   height: Get.height * 0.12,
              //                 )
              //               ],
              //             ),
              //           )
              //         ],
              //       ),
              //       SizedBox(height: 7),
              //       Center(
              //           child: Icon(
              //         Icons.keyboard_arrow_up,
              //         color: Colors.grey[400],
              //       )),
              //       Divider(thickness: 1),
              //       show
              //           ? Row(
              //               children: [
              //                 Container(
              //                   height: Get.height * 0.1,
              //                   width: Get.width * 0.92,
              //                   decoration: BoxDecoration(
              //                     borderRadius: BorderRadius.circular(10),
              //                     border: Border.all(
              //                       color: Colors.grey[400],
              //                     ),
              //                   ),
              //                   child: Row(
              //                     children: [
              //                       Container(
              //                         width: Get.width * 0.2,
              //                         child: Column(
              //                           mainAxisAlignment:
              //                               MainAxisAlignment.center,
              //                           children: [
              //                             Image.asset(
              //                               "assets/images/gems.png",
              //                               width: 50,
              //                             )
              //                           ],
              //                         ),
              //                       ),
              //                       Padding(
              //                         padding:
              //                             EdgeInsets.only(top: 10, bottom: 10),
              //                         child: VerticalDivider(
              //                           thickness: 1,
              //                           color: Colors.grey[300],
              //                         ),
              //                       ),
              //                       Container(
              //                         width: Get.width * 0.55,
              //                         child: Column(
              //                           crossAxisAlignment:
              //                               CrossAxisAlignment.start,
              //                           children: [
              //                             Padding(
              //                               padding: EdgeInsets.only(top: 10),
              //                               child: Text(
              //                                 "Pay Now and get",
              //                                 style: TextStyle(
              //                                   fontSize: 17,
              //                                   color: Colors.grey,
              //                                   fontWeight: FontWeight.w500,
              //                                 ),
              //                               ),
              //                             ),
              //                             Flexible(
              //                               child: Padding(
              //                                 padding: EdgeInsets.only(top: 5),
              //                                 child: Text(
              //                                   "15% Discount",
              //                                   style: TextStyle(
              //                                     fontSize: 16,
              //                                     fontWeight: FontWeight.w700,
              //                                   ),
              //                                 ),
              //                               ),
              //                             ),
              //                           ],
              //                         ),
              //                       ),
              //                       Container(
              //                         padding:
              //                             EdgeInsets.only(top: 5, left: 15),
              //                         child: Column(
              //                           crossAxisAlignment:
              //                               CrossAxisAlignment.end,
              //                           children: [
              //                             InkWell(
              //                               onTap: () {
              //                                 setState(() {
              //                                   show = false;
              //                                 });
              //                               },
              //                               child: Icon(
              //                                 Icons.close,
              //                                 color: Colors.grey,
              //                               ),
              //                             ),
              //                           ],
              //                         ),
              //                       )
              //                     ],
              //                   ),
              //                 ),
              //               ],
              //             )
              //           : Container(height: 0),
              //       SizedBox(height: 3),
              //       show ? Divider(thickness: 1) : Container(height: 0),
              //       Expanded(
              //         child: SingleChildScrollView(
              //           child: ListView.builder(
              //             physics: NeverScrollableScrollPhysics(),
              //             shrinkWrap: true,
              //             itemCount: 5,
              //             itemBuilder: (context, index) {
              //               return Column(
              //                 children: [
              //                   Container(
              //                     padding: EdgeInsets.only(top: 7, bottom: 10),
              //                     child: Row(
              //                       children: [
              //                         Container(
              //                           width: Get.width * 0.63,
              //                           child: Column(
              //                             crossAxisAlignment:
              //                                 CrossAxisAlignment.start,
              //                             children: [
              //                               Row(
              //                                 children: [
              //                                   Expanded(
              //                                     child: Text(
              //                                       "May 23, 2020",
              //                                       style: GoogleFonts.poppins(
              //                                         color: Colors.grey,
              //                                         fontSize: 16,
              //                                         fontWeight:
              //                                             FontWeight.w500,
              //                                       ),
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     width: 1.5,
              //                                     height: 15,
              //                                     color: Colors.grey,
              //                                   ),
              //                                   SizedBox(width: 8),
              //                                   Expanded(
              //                                     child: Text(
              //                                       "SALES",
              //                                       style: GoogleFonts.poppins(
              //                                         color: Colors
              //                                             .lightBlueAccent,
              //                                         fontSize: 16,
              //                                         fontWeight:
              //                                             FontWeight.w500,
              //                                       ),
              //                                     ),
              //                                   ),
              //                                 ],
              //                               ),
              //                               Text(
              //                                 "Invoice #152634",
              //                                 style: GoogleFonts.poppins(
              //                                   color: Colors.black87,
              //                                   fontSize: 16,
              //                                   fontWeight: FontWeight.w500,
              //                                 ),
              //                               ),
              //                               Row(
              //                                 children: [
              //                                   show1
              //                                       ? Text(
              //                                           "300 days",
              //                                           style:
              //                                               GoogleFonts.poppins(
              //                                             color: Colors.red,
              //                                             fontSize: 16,
              //                                             fontWeight:
              //                                                 FontWeight.w500,
              //                                           ),
              //                                         )
              //                                       :SizedBox(),
              //                                   show1
              //                                       ? SizedBox(width: 8)
              //                                       :SizedBox(),
              //                                   show1
              //                                       ? Container(
              //                                           width: 1.5,
              //                                           height: 15,
              //                                           color: Colors.grey,
              //                                         )
              //                                       :SizedBox(),
              //                                   show1
              //                                       ? SizedBox(width: 8)
              //                                       :SizedBox(),
              //                                   Text(
              //                                     "${Strings.Due} Feb 27,2021",
              //                                     style: GoogleFonts.poppins(
              //                                       color: Colors.grey,
              //                                       fontSize: 16,
              //                                       fontWeight: FontWeight.w500,
              //                                     ),
              //                                   ),
              //                                 ],
              //                               )
              //                             ],
              //                           ),
              //                         ),
              //                         Container(
              //                           width: Get.width * 0.3,
              //                           child: Column(
              //                             children: [
              //                               Text(
              //                                 "75,000",
              //                                 style: GoogleFonts.poppins(
              //                                   color: Colors.blueAccent[200],
              //                                   fontSize: 16,
              //                                   fontWeight: FontWeight.w500,
              //                                 ),
              //                               ),
              //                               Text(
              //                                 "(90,000)",
              //                                 style: GoogleFonts.poppins(
              //                                   color: Colors.grey,
              //                                   fontSize: 16,
              //                                   fontWeight: FontWeight.w500,
              //                                 ),
              //                               ),
              //                             ],
              //                           ),
              //                         ),
              //                       ],
              //                     ),
              //                   ),
              //                   Divider(thickness: 1)
              //                 ],
              //               );
              //             },
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
