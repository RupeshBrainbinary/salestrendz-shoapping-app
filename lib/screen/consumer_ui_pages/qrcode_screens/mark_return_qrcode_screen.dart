// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:get/get.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
//
// class MarkReturnQRCode extends StatefulWidget {
//   const MarkReturnQRCode({
//     Key key,
//   }) : super(key: key);
//
//   @override
//   State<StatefulWidget> createState() => _MarkReturnQRCodeState();
// }
//
// class _MarkReturnQRCodeState extends State<MarkReturnQRCode> {
//   Barcode result;
//   QRViewController controller;
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
//
//   // In order to get hot reload to work we need to pause the camera if the platform
//   // is android, or resume the camera if the platform is iOS.
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
//                     Navigator.of(context).push(
//                       PageRouteBuilder(
//                           opaque: false,
//                           pageBuilder: (BuildContext context, _, __) =>
//                               Dialog()),
//                     );
//                   },
//                 ),
//               ),
//             /*FittedBox(
//               fit: BoxFit.contain,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: <Widget>[
//                   if (result != null)
//                     Container(
//                       height: 50,
//                       child: RaisedButton(
//                         onPressed: () async {
//                           // await controller?.pauseCamera();
//                         },
//                         child: Text('Continue', style: TextStyle(fontSize: 20)),
//                       ),
//                     ),
//                   // Text(
//                   //     'Barcode Type: ${describeEnum(result.format)}   Data: ${result.code}')
//                   // else
//                   // Text('Scan a code'),
//                   // Row(
//                   //   mainAxisAlignment: MainAxisAlignment.center,
//                   //   crossAxisAlignment: CrossAxisAlignment.center,
//                   //   children: <Widget>[
//                   //     Container(
//                   //       margin: EdgeInsets.all(8),
//                   //       child: RaisedButton(
//                   //           onPressed: () async {
//                   //             await controller?.toggleFlash();
//                   //             setState(() {});
//                   //           },
//                   //           child: FutureBuilder(
//                   //             future: controller?.getFlashStatus(),
//                   //             builder: (context, snapshot) {
//                   //               return Text('Flash: ${snapshot.data}');
//                   //             },
//                   //           )),
//                   //     ),
//                   //     Container(
//                   //       margin: EdgeInsets.all(8),
//                   //       child: RaisedButton(
//                   //           onPressed: () async {
//                   //             await controller?.flipCamera();
//                   //             setState(() {});
//                   //           },
//                   //           child: FutureBuilder(
//                   //             future: controller?.getCameraInfo(),
//                   //             builder: (context, snapshot) {
//                   //               if (snapshot.data != null) {
//                   //                 return Text(
//                   //                     'Camera facing ${describeEnum(snapshot.data)}');
//                   //               } else {
//                   //                 return Text('loading');
//                   //               }
//                   //             },
//                   //           )),
//                   //     )
//                   //   ],
//                   // ),
//                   // Row(
//                   //   mainAxisAlignment: MainAxisAlignment.center,
//                   //   crossAxisAlignment: CrossAxisAlignment.center,
//                   //   children: <Widget>[
//                   //     Container(
//                   //       margin: EdgeInsets.all(8),
//                   //       child: RaisedButton(
//                   //         onPressed: () async {
//                   //           await controller?.pauseCamera();
//                   //         },
//                   //         child: Text('pause', style: TextStyle(fontSize: 20)),
//                   //       ),
//                   //     ),
//                   //     Container(
//                   //       margin: EdgeInsets.all(8),
//                   //       child: RaisedButton(
//                   //         onPressed: () async {
//                   //           await controller?.resumeCamera();
//                   //         },
//                   //         child: Text('resume', style: TextStyle(fontSize: 20)),
//                   //       ),
//                   //     )
//                   //   ],
//                   // ),
//                 ],
//               ),
//             )*/
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildQrView(BuildContext context) {
//     // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
//     var scanArea = (Get.width < 400 || Get.height < 400) ? 150.0 : 300.0;
//     // To ensure the Scanner view is properly sizes after rotation
//     // we need to listen for Flutter SizeChanged notification and update controller
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
//   //           return StatefulBuilder(
//   //             builder: (context, setState) {
//   //               return Container(
//   //                 padding: EdgeInsets.only(top: 5,bottom: 5,left: 10,right: 10),
//   //                 child: SimpleDialog(
//   //                   // contentPadding: EdgeInsets.symmetric(horizontal: 20),
//   //                   // titlePadding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
//   //                   children: <Widget>[
//   //                    Row(
//   //                      mainAxisAlignment: MainAxisAlignment.end,
//   //                      children: [
//   //                        SizedBox(),
//   //                        IconButton(icon:Icon(Icons.clear,color: Colors.red,), onPressed: () {
//   //                          Get.back();
//   //                          Get.back();
//   //                          Get.back();
//   //                        },),
//   //                      ],
//   //                    ),
//   //                     Row(
//   //                       children: [
//   //                         Column(
//   //                           mainAxisAlignment:MainAxisAlignment.center,
//   //                           children: [
//   //                             Icon(Icons.info,color: Colors.lightBlue,size: 55,),
//   //                           ],
//   //                         ),
//   //                         SizedBox(width: 10,),
//   //                         Column(
//   //                           mainAxisAlignment: MainAxisAlignment.start,
//   //                           crossAxisAlignment: CrossAxisAlignment.start,
//   //                           children: [
//   //                            Text(
//   //                           'Thank You',
//   //                               style: GoogleFonts.poppins(
//   //                                   fontSize: 18, fontWeight: FontWeight.w600),
//   //                             ),
//   //                             Text(
//   //                           'Your return as been accepted.',
//   //                               style: GoogleFonts.poppins(
//   //                                   fontSize: 12, color: Colors.black.withOpacity(0.8),fontWeight: FontWeight.w500),
//   //                             ),
//   //                             SizedBox(height: 10,),
//   //                             Text(
//   //                               'Note: You can still this product ',
//   //                               style: GoogleFonts.poppins(
//   //                                   fontSize: 12, color: Colors.black.withOpacity(0.7),fontWeight: FontWeight.w400),
//   //                             ),
//   //                             Text(
//   //                               'to your  customer',
//   //                               style: GoogleFonts.poppins(
//   //                                   fontSize: 12, color: Colors.black.withOpacity(0.7),fontWeight: FontWeight.w400),
//   //                             ),
//   //                           ],
//   //                         ),
//   //                       ],
//   //                     ),
//   //                   ],
//   //                 ),
//   //               );
//   //             } ,
//   //           );
//   //         });
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
//                       onTap: () {
//                         Get.back();
//                         Get.back();
//                         Get.back();
//                       },
//                       child: Icon(
//                         Icons.clear,
//                         color: Colors.red,
//                       )),
//                 ],
//               ),
//               Container(
//                 margin: EdgeInsets.only(top: 5, bottom: 5, left: 10),
//                 child: Row(
//                   children: [
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(Icons.info, color: Colors.lightBlue, size: 55),
//                       ],
//                     ),
//                     SizedBox(width: 10),
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Thank You',
//                           style: GoogleFonts.poppins(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         Text(
//                           'Your return as been accepted.',
//                           style: GoogleFonts.poppins(
//                             fontSize: 12,
//                             color: Colors.black.withOpacity(0.8),
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         SizedBox(height: 10),
//                         Text(
//                           'Note: You can still this product ',
//                           style: GoogleFonts.poppins(
//                             fontSize: 12,
//                             color: Colors.black.withOpacity(0.7),
//                             fontWeight: FontWeight.w400,
//                           ),
//                         ),
//                         Text(
//                           'to your  customer',
//                           style: GoogleFonts.poppins(
//                             fontSize: 12,
//                             color: Colors.black.withOpacity(0.7),
//                             fontWeight: FontWeight.w400,
//                           ),
//                         ),
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
