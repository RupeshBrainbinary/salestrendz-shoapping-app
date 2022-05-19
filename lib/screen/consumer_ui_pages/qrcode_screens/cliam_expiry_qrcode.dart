// import 'dart:io';
// import 'package:get/get.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
//
// class ClaimExpiryQRCode extends StatefulWidget {
//   const ClaimExpiryQRCode({
//     Key key,
//   }) : super(key: key);
//
//   @override
//   State<StatefulWidget> createState() => _ClaimExpiryQRCodeState();
// }
//
// class _ClaimExpiryQRCodeState extends State<ClaimExpiryQRCode> {
//   Barcode result;
//   QRViewController controller;
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
//
//   @override
//   void reassemble() {
//     super.reassemble();
//     if (Platform.isAndroid) {
//       controller.pauseCamera();
//     } else if (Platform.isIOS) {
//       controller.resumeCamera();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: Stack(
//           alignment: Alignment.bottomCenter,
//           children: <Widget>[
//             Expanded(flex: 4, child: _buildQrView(context)),
//             Expanded(
//               flex: 1,
//               child: FittedBox(
//                 fit: BoxFit.contain,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: <Widget>[
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: <Widget>[
//                         InkWell(
//                           child: Container(
//                             margin: EdgeInsets.only(bottom: 80),
//                             child: Icon(
//                               Icons.flip_camera_ios_outlined,
//                               color: Colors.white,
//                               size: 30,
//                             ),
//                           ),
//                           onTap: () async {
//                             await controller?.flipCamera();
//                             setState(() {});
//                           },
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             if (result != null)
//               Container(
//                 width: Get.width / 1.2,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.rectangle,
//                   color: Colors.red,
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(22.0),
//                     topRight: Radius.circular(22.0),
//                     bottomLeft: Radius.zero,
//                     bottomRight: Radius.zero,
//                   ),
//                 ),
//                 child: FlatButton(
//                   child: Text(
//                     'Continue',
//                     style: GoogleFonts.poppins(
//                       fontSize: 18,
//                       color: Colors.white,
//                       fontWeight: FontWeight.w300,
//                     ),
//                   ),
//                   onPressed: () {
//                     Navigator.of(context).push(PageRouteBuilder(
//                         opaque: false,
//                         pageBuilder: (BuildContext context, _, __) =>
//                             Dialog()));
//                   },
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildQrView(BuildContext context) {
//     var scanArea = (Get.width < 400 || Get.height < 400) ? 150.0 : 300.0;
//     return QRView(
//       key: qrKey,
//       cameraFacing: CameraFacing.front,
//       onQRViewCreated: _onQRViewCreated,
//       formatsAllowed: [BarcodeFormat.qrcode],
//       overlay: QrScannerOverlayShape(
//         borderColor: Colors.red,
//         borderRadius: 10,
//         borderLength: 30,
//         borderWidth: 10,
//         cutOutSize: scanArea,
//       ),
//     );
//   }
//
//   void _onQRViewCreated(QRViewController controller) {
//     setState(() {
//       this.controller = controller;
//     });
//     controller.scannedDataStream.listen((scanData) async {
//       if (scanData != null && scanData.code.isNotEmpty) {
//         await controller?.pauseCamera();
//         result = scanData;
//         setState(() {});
//       }
//       setState(() {
//         result = scanData;
//       });
//     });
//   }
//
//   // void adilog(){
//   //   {
//   //     showDialog(
//   //         context: context,
//   //         builder: (context) {
//   //           return Container(
//   //                 padding: EdgeInsets.only(top: 5,bottom: 5,left: 10,right: 10),
//   //                 child: Column(
//   //                   children: [
//   //                     Row(
//   //                     mainAxisAlignment: MainAxisAlignment.end,
//   //                     children: [
//   //                       SizedBox(),
//   //                       IconButton(icon:Icon(Icons.clear,color: Colors.red,), onPressed: () {
//   //                         Get.back();
//   //                         Get.back();
//   //                         Get.back();
//   //                       },),
//   //                     ],
//   //                   ),
//   //                     Row(
//   //                       children: [
//   //                         Column(
//   //                           mainAxisAlignment:MainAxisAlignment.center,
//   //                           children: [
//   //                             Icon(Icons.check_circle,color: Colors.green,size: 50,),
//   //                           ],
//   //                         ),
//   //                         SizedBox(width: 10,),
//   //                         Column(
//   //                           mainAxisAlignment: MainAxisAlignment.start,
//   //                           crossAxisAlignment: CrossAxisAlignment.start,
//   //                           children: [
//   //                             Text(
//   //                               'Congratulation',
//   //                               style: GoogleFonts.poppins(
//   //                                   fontSize: 18, fontWeight: FontWeight.w600),
//   //                             ),
//   //                             Text(
//   //                               'Expiry successfully claimed',
//   //                               style: GoogleFonts.poppins(
//   //                                   fontSize: 12, color: Colors.black.withOpacity(0.8),fontWeight: FontWeight.w500),
//   //                             ),
//   //                             Row(
//   //                               children: [
//   //                                 Text(
//   //                                   'amount added to ',
//   //                                   style: GoogleFonts.poppins(
//   //                                       fontSize: 12, color: Colors.black.withOpacity(0.8),fontWeight: FontWeight.w500),
//   //                                 ),
//   //                                 InkResponse(
//   //                                   onTap: (){
//   //                                     Get.back();
//   //                                     Get.back();
//   //                                     Get.back();
//   //                                   },
//   //                                   child: Text(
//   //                                     'your wallet',
//   //                                     style: GoogleFonts.poppins(
//   //                                       fontSize: 12, color: Colors.red.withOpacity(0.9),fontWeight: FontWeight.w600,decoration: TextDecoration.underline,),
//   //                                   ),
//   //                                 ),
//   //                               ],
//   //                             ),
//   //                             SizedBox(height: 10,),
//   //                           ],
//   //                         ),
//   //                       ],
//   //                     ),],
//   //                 ),
//   //               );
//   //             } ,
//   //           );
//   //   }
//   // }
//
//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }
// }
//
// class Dialog extends StatefulWidget {
//   @override
//   _DialogState createState() => _DialogState();
// }
//
// class _DialogState extends State<Dialog> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white.withOpacity(0.3),
//       body: Center(
//         child: Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.all(Radius.circular(10)),
//             // border: Border.all(width: 3,color: Colors.green,style: BorderStyle.solid)
//           ),
//           height: Get.height / 5,
//           width: Get.width / 1.3,
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   InkResponse(
//                     onTap: () {
//                       Get.back();
//                       Get.back();
//                       Get.back();
//                     },
//                     child: Icon(
//                       Icons.clear,
//                       color: Colors.red,
//                     ),
//                   ),
//                   // IconButton(
//                   //   icon: Icon(
//                   //     Icons.clear,
//                   //     color: Colors.red,
//                   //   ),
//                   //   onPressed: () {
//                   //     Get.back();
//                   //     Get.back();
//                   //     Get.back();
//                   //   },
//                   // ),
//                 ],
//               ),
//               Container(
//                 margin: EdgeInsets.only(top: 5, bottom: 5, left: 10),
//                 child: Row(
//                   children: [
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(Icons.check_circle, color: Colors.green, size: 60),
//                       ],
//                     ),
//                     SizedBox(width: 10),
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Congratulation',
//                           style: GoogleFonts.poppins(
//                             fontSize: 20,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         Text(
//                           'Expiry successfully claimed',
//                           style: GoogleFonts.poppins(
//                             fontSize: 14,
//                             color: Colors.black.withOpacity(0.8),
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         Row(
//                           children: [
//                             Text(
//                               'amount added to ',
//                               style: GoogleFonts.poppins(
//                                 fontSize: 14,
//                                 color: Colors.black.withOpacity(0.8),
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                             InkResponse(
//                               onTap: () {
//                                 Get.back();
//                                 Get.back();
//                                 Get.back();
//                               },
//                               child: Text(
//                                 'your wallet',
//                                 style: GoogleFonts.poppins(
//                                   fontSize: 14,
//                                   color: Colors.red.withOpacity(0.9),
//                                   fontWeight: FontWeight.w600,
//                                   decoration: TextDecoration.underline,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 10),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
