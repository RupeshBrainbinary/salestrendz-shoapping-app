// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import 'package:shoppingapp/screen/consumer_ui_pages/qrcode_screens/offers_qrcode.dart';
// import 'package:shoppingapp/screen/drawer/drawer.dart';
// import 'package:shoppingapp/utils/navigator.dart';
// import 'package:shoppingapp/utils/theme_notifier.dart';
// import 'package:shoppingapp/widgets/commons/string_res.dart';
//
// class DiscountPage extends StatefulWidget {
//   @override
//   _DiscountPageState createState() => _DiscountPageState();
// }
//
// class _DiscountPageState extends State<DiscountPage> {
//   GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
//
//   @override
//   Widget build(BuildContext context) {
//     final themeColor = Provider.of<ThemeNotifier>(context);
//
//     return Scaffold(
//       key: _drawerKey,
//       appBar: AppBar(
//         centerTitle: true,
//         // elevation: 0,
//         leading: InkWell(
//           onTap: () {
//             _drawerKey.currentState.openDrawer();
//           },
//           child: Icon(
//             Icons.menu,
//             color: themeColor.getColor(),
//           ),
//         ),
//         backgroundColor: Colors.white,
//         title: Text(
//           Strings.ClaimYourOffers,
//           style: GoogleFonts.poppins(
//             fontSize: 20,
//             color: Colors.black,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),
//       drawer: CustomDrawer(),
//       body: Container(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               margin: EdgeInsets.only(top: 20, left: 15, bottom: 25),
//               child: Text(
//                 'Current Offeres',
//                 style: GoogleFonts.poppins(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 15,
//                   color: Colors.grey,
//                 ),
//               ),
//             ),
//             offerListData(),
//
//             // notAvalebeleofferListData(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget offerListData() {
//     return Expanded(
//       child: Column(
//         children: [
//           ListView.builder(
//               shrinkWrap: true,
//               physics: NeverScrollableScrollPhysics(),
//               itemCount: 3,
//               itemBuilder: (BuildContext context, int index) {
//                 return InkWell(
//                   onTap: () {
//                     Nav.route(context, OffersQRCode());
//                   },
//                   child: Container(
//                     margin: EdgeInsets.only(top: 10, left: 15, right: 15),
//                     height: Get.height * 0.1,
//                     child: Stack(
//                       children: [
//                         Container(
//                           height: Get.height * 0.2,
//                           width: Get.width,
//                           child: Image.asset(
//                             'assets/images/offer_border.png',
//                             fit: BoxFit.fill,
//                             width: Get.width,
//                             color: Colors.grey.withOpacity(0.4),
//                           ),
//                         ),
//                         Container(
//                           height: Get.height * 0.1,
//                           margin: EdgeInsets.only(left: 20),
//                           width: Get.width,
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Container(
//                                 height: 40,
//                                 width: 40,
//                                 child: Image.asset(
//                                   'assets/images/offer.png',
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                               SizedBox(width: 20),
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Container(
//                                     child: Text(
//                                       '4+1',
//                                       style: GoogleFonts.poppins(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 24,
//                                       ),
//                                     ),
//                                   ),
//                                   Container(
//                                     child: Text(
//                                       'Buy 4 and get 1 free',
//                                       style: GoogleFonts.poppins(
//                                         fontWeight: FontWeight.w500,
//                                         fontSize: 14,
//                                         color: Colors.grey,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               Spacer(),
//                               Container(
//                                 margin: EdgeInsets.only(right: 20),
//                                 child: Icon(
//                                   Icons.arrow_forward_ios_outlined,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               }),
//           Container(
//             margin: EdgeInsets.only(top: 10, left: 15, right: 15),
//             height: Get.height * 0.1,
//             child: Stack(
//               children: [
//                 Container(
//                   height: Get.height * 0.2,
//                   width: Get.width,
//                   child: Image.asset(
//                     'assets/images/offer_border.png',
//                     fit: BoxFit.fill,
//                     width: Get.width,
//                     color: Colors.grey.withOpacity(0.2),
//                   ),
//                 ),
//                 Container(
//                   height: Get.height * 0.1,
//                   margin: EdgeInsets.only(left: 20),
//                   width: Get.width,
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Container(
//                         height: 40,
//                         width: 40,
//                         child: Image.asset(
//                           'assets/images/offer.png',
//                           color: Colors.grey.withOpacity(0.3),
//                         ),
//                       ),
//                       SizedBox(width: 20),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Container(
//                             child: Text(
//                               '20+6',
//                               style: GoogleFonts.poppins(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 24,
//                                 color: Colors.grey.withOpacity(0.3),
//                               ),
//                             ),
//                           ),
//                           Container(
//                             child: Text(
//                               'Buy 20 and get 6 free',
//                               style: GoogleFonts.poppins(
//                                 fontWeight: FontWeight.w500,
//                                 fontSize: 14,
//                                 color: Colors.grey.withOpacity(0.3),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       Spacer(),
//                       Container(
//                         margin: EdgeInsets.only(right: 20),
//                         child: Icon(
//                           Icons.arrow_forward_ios_outlined,
//                           color: Colors.grey.withOpacity(0.3),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// // Widget notAvalebeleofferListData() {
// //   return Expanded(
// //     child: ListView.builder(
// //         shrinkWrap: true,
// //         physics: NeverScrollableScrollPhysics(),
// //         itemCount: 1,
// //         itemBuilder: (BuildContext context, int index) {
// //           return InkWell(
// //             onTap: () {
// //               // Nav.route(context, OffersQRCode());
// //             },
// //             child: Container(
// //              color:Colors.white.withOpacity(0.3),
// //               margin: EdgeInsets.only( left: 15, right: 15),
// //               height: Get.height * 0.1,
// //               child: Stack(
// //                 children: [
// //                   Container(
// //                     height: Get.height * 0.2,
// //                     width: Get.width,
// //                     child: Image.asset(
// //                       'assets/images/offer_border.png',
// //                       fit: BoxFit.fill,
// //                       width: MediaQuery.of(context).size.width,
// //                       color: Colors.grey.withOpacity(0.4),
// //                     ),
// //                   ),
// //                   Container(
// //                     height: Get.height * 0.1,
// //                     margin: EdgeInsets.only(left: 20),
// //                     width: Get.width,
// //                     child: Row(
// //                       crossAxisAlignment: CrossAxisAlignment.center,
// //                       children: [
// //                         Container(
// //                           height: 40,
// //                           width: 40,
// //                           child: Image.asset(
// //                             'assets/images/offer.png',
// //                             color: Colors.grey,
// //                           ),
// //                         ),
// //                         SizedBox(width: 20),
// //                         Column(
// //                           crossAxisAlignment: CrossAxisAlignment.start,
// //                           mainAxisAlignment: MainAxisAlignment.center,
// //                           children: [
// //                             Container(
// //                               child: Text(
// //                                 '4+1',
// //                                 style: GoogleFonts.poppins(
// //                                     fontWeight: FontWeight.bold,
// //                                     fontSize: 24),
// //                               ),
// //                             ),
// //                             Container(
// //                               child: Text(
// //                                 'Buy 4 and get 1 free',
// //                                 style: GoogleFonts.poppins(
// //                                     fontWeight: FontWeight.w500,
// //                                     fontSize: 14,
// //                                     color: Colors.grey),
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                         Spacer(),
// //                         Container(
// //                           margin: EdgeInsets.only(right: 20),
// //                           child: Icon(Icons.arrow_forward_ios_outlined,
// //                               color: Colors.grey),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           );
// //         }),
// //   );
// // }
// }
