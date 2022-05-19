import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LedgerReportPage extends StatefulWidget {
  @override
  _LedgerReportPageState createState() => _LedgerReportPageState();
}

class _LedgerReportPageState extends State<LedgerReportPage> {
  @override
  Widget build(BuildContext context) {
    print("Current page --> $runtimeType");
    return Center(
      child: Container(
        height: Get.height - Get.height * 0.245,
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
              style: GoogleFonts.poppins(
                color: Colors.grey,
                fontSize: 25,
              ),
            )

            // Container(
            //   height: Get.height - Get.height * 0.245,
            //   width: Get.width,
            //   child: Column(
            //     children: [
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Container(
            //             margin: EdgeInsets.only(left: 20),
            //             decoration: BoxDecoration(
            //               color: Colors.grey[300],
            //               borderRadius: BorderRadius.circular(15),
            //             ),
            //             child: Icon(
            //               Icons.keyboard_arrow_left_sharp,
            //               color: Colors.black54,
            //             ),
            //           ),
            //           Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               Row(
            //                 children: [
            //                   Icon(Icons.date_range, color: Colors.grey),
            //                   Text(
            //                     " PERIOD",
            //                     style: GoogleFonts.poppins(
            //                       fontSize: 16,
            //                       fontWeight: FontWeight.w500,
            //                       color: Colors.grey,
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //               Text(
            //                 "MAY 23 - MAY 30, 2020",
            //                 style: GoogleFonts.poppins(
            //                   fontSize: 20,
            //                   fontWeight: FontWeight.w500,
            //                 ),
            //               )
            //             ],
            //           ),
            //           Container(
            //             margin: EdgeInsets.only(right: 20),
            //             decoration: BoxDecoration(
            //               color: Colors.grey[300],
            //               borderRadius: BorderRadius.circular(15),
            //             ),
            //             child: Icon(
            //               Icons.keyboard_arrow_right,
            //               color: Colors.black54,
            //             ),
            //           )
            //         ],
            //       ),
            //       Container(
            //         margin: EdgeInsets.only(top: 10),
            //         color: Colors.grey[200],
            //         padding: EdgeInsets.only(
            //           left: 20,
            //           right: 20,
            //           top: 10,
            //           bottom: 10,
            //         ),
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //           children: [
            //             Text(
            //               Strings.OpenBalance,
            //               style: GoogleFonts.poppins(
            //                 fontSize: 16,
            //                 fontWeight: FontWeight.w500,
            //                 color: Colors.black54,
            //               ),
            //             ),
            //             Text(
            //               "₹ 0",
            //               style: GoogleFonts.poppins(
            //                 fontSize: 16,
            //                 fontWeight: FontWeight.w500,
            //                 color: Colors.black54,
            //               ),
            //             )
            //           ],
            //         ),
            //       ),
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
            //                     padding: EdgeInsets.only(
            //                       top: 7,
            //                       bottom: 10,
            //                       left: 10,
            //                     ),
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
            //                                         fontWeight: FontWeight.w500,
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
            //                                         color:
            //                                             Colors.lightBlueAccent,
            //                                         fontSize: 16,
            //                                         fontWeight: FontWeight.w500,
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
            //                                   Text(
            //                                     "Ref #VB/157",
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
            //       Stack(
            //         children: [
            //           Align(
            //             child: Container(
            //               margin: EdgeInsets.only(
            //                 top: 10,
            //                 bottom: 10,
            //               ),
            //               color: Colors.grey[200],
            //               padding: EdgeInsets.only(
            //                 left: 20,
            //                 right: 20,
            //                 top: 10,
            //                 bottom: 10,
            //               ),
            //               child: Row(
            //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                 children: [
            //                   Text(
            //                     Strings.CloseBalance,
            //                     style: GoogleFonts.poppins(
            //                       fontSize: 16,
            //                       fontWeight: FontWeight.w500,
            //                       color: Colors.black54,
            //                     ),
            //                   ),
            //                   Text(
            //                     "₹ 50,480",
            //                     style: GoogleFonts.poppins(
            //                       fontSize: 16,
            //                       fontWeight: FontWeight.w500,
            //                       color: Colors.black54,
            //                     ),
            //                   )
            //                 ],
            //               ),
            //             ),
            //           )
            //         ],
            //       )
            //     ],
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
