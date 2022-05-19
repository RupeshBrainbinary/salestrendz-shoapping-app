import 'package:flutter/material.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import 'package:shoppingapp/screen/activity_pages/brochures/brochures_screen_model.dart';
import 'package:shoppingapp/utils/commons/export_basic_file.dart';

import 'package:photo_view/photo_view.dart';

//
// // class pdfview extends StatefulWidget {
// //   @override
// //   _pdfviewState createState() => _pdfviewState();
// // }
// //
// // class _pdfviewState extends State<pdfview> {
// //   String urlPDFPath = "";
// //   bool exists = true;
// //   int _totalPages = 0;
// //   int _currentPage = 0;
// //   bool pdfReady = false;
// //   PDFViewController _pdfViewController;
// //   bool loaded = false;
// //
// //   Future<File> getFileFromUrl(String url, {name}) async {
// //     var fileName = 'testonline';
// //     if (name != null) {
// //       fileName = name;
// //     }
// //     try {
// //       // data = await http.get(url);
// //       var data = await http.get(Uri.parse(url));
// //       var bytes = data.bodyBytes;
// //       var dir = await getApplicationDocumentsDirectory();
// //       File file = File("${dir.path}/" + fileName + ".pdf");
// //       print(dir.path);
// //       File urlFile = await file.writeAsBytes(bytes);
// //       return urlFile;
// //     } catch (e) {
// //       throw Exception("Error opening url file");
// //     }
// //   }
// //
// //   void requestPersmission() async {
// //     //  await PermissionHandler().requestPermissions([PermissionGroup.storage]);
// //     await Permission.storage.request();
// //   }
// //
// //   @override
// //   void initState() {
// //     requestPersmission();
// //     getFileFromUrl(
// //             "https://s3.ap-south-1.amazonaws.com/ow-brochures/files/290/llGVs4RG9wn6bbDKYSscm6Pk2oaYmmK1.pdf")
// //         .then(
// //       (value) => {
// //         setState(() {
// //           if (value != null) {
// //             urlPDFPath = value.path;
// //             loaded = true;
// //             exists = true;
// //           } else {
// //             exists = false;
// //           }
// //         })
// //       },
// //     );
// //     super.initState();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     print(urlPDFPath);
// //     if (loaded) {
// //       return Scaffold(
// //         body: PDFView(
// //           filePath: urlPDFPath,
// //           autoSpacing: true,
// //           enableSwipe: true,
// //           pageSnap: true,
// //           swipeHorizontal: true,
// //           nightMode: false,
// //           onError: (e) {
// //             //Show some error message or UI
// //           },
// //           onRender: (_pages) {
// //             setState(() {
// //               _totalPages = _pages;
// //               pdfReady = true;
// //             });
// //           },
// //           onViewCreated: (PDFViewController vc) {
// //             setState(() {
// //               _pdfViewController = vc;
// //             });
// //           },
// //           // onPageChanged: (int page, int total) {
// //           //   setState(() {
// //           //     _currentPage = page;
// //           //   });
// //           // },
// //           onPageError: (page, e) {},
// //         ),
// //         floatingActionButton: Row(
// //           mainAxisAlignment: MainAxisAlignment.end,
// //           children: <Widget>[
// //             IconButton(
// //               icon: Icon(Icons.chevron_left),
// //               iconSize: 50,
// //               color: Colors.black,
// //               onPressed: () {
// //                 setState(() {
// //                   if (_currentPage > 0) {
// //                     _currentPage--;
// //                     _pdfViewController.setPage(_currentPage);
// //                   }
// //                 });
// //               },
// //             ),
// //             Text(
// //               "${_currentPage + 1}/$_totalPages",
// //               style: TextStyle(color: Colors.black, fontSize: 20),
// //             ),
// //             IconButton(
// //               icon: Icon(Icons.chevron_right),
// //               iconSize: 50,
// //               color: Colors.black,
// //               onPressed: () {
// //                 setState(() {
// //                   if (_currentPage < _totalPages - 1) {
// //                     _currentPage++;
// //                     _pdfViewController.setPage(_currentPage);
// //                   }
// //                 });
// //               },
// //             ),
// //           ],
// //         ),
// //       );
// //     } else {
// //       if (exists) {
// //         //Replace with your loading UI
// //         return Scaffold(
// //           body: Center(
// //             child: CircularProgressIndicator(),
// //           )
// //         );
// //       } else {
// //         //Replace Error UI
// //         return Scaffold(
// //           body: Text(
// //             "PDF Not Available",
// //             style: TextStyle(fontSize: 20),
// //           ),
// //         );
// //       }
// //     }
// //   }
// // }
//
//
// class pdfviewer extends StatefulWidget {
//   const pdfviewer({Key key}) : super(key: key);
//
//   @override
//   _pdfviewerState createState() => _pdfviewerState();
// }
//
// class _pdfviewerState extends State<pdfviewer> {
//   final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: SfPdfViewer.network(
//         'https://s3.ap-south-1.amazonaws.com/ow-brochures/files/290/16GrMANdzVfCOciN9TnIBQQWS1O9xawQ.pdf',
//
//         key: _pdfViewerKey,
//       ),
//     );
//   }
// }
//
//


//Comment 31-03-22
// class pdfviewer extends StatefulWidget {
//   pdfviewer(@required this.index, @required this.model);
//
//   final BrochuresScreenViewModel model;
//   final int index;
//
//   @override
//   State<pdfviewer> createState() => _pdfviewerState();
// }
//
// class _pdfviewerState extends State<pdfviewer> {
//   //final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
//   bool isBool=true;
// @override
//   void initState() {
// /*  Future.delayed(Duration(seconds: 20),(){
//     isBool=false;
//     setState(() {
//
//     });
//   });*/
//
//     super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {
//     final themeColor = Provider.of<ThemeNotifier>(context);
//     return  Stack(
//       children: [
//         Container(
//           child: widget.model.brochureDataModel == null
//               ? Center(child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(themeColor.getColor())))
//               :Container() /*SfPdfViewer.network(
//                   widget.model.brochureDataModel.result.data[widget.index].attachments[2]
//                       .uploadPath,
//                   enableDocumentLinkAnnotation: true,
//                 //  searchTextHighlightColor: themeColor.getColor(),
//                   canShowScrollHead: false,
//                   canShowScrollStatus: false,
//                   canShowPaginationDialog: false,
//                   enableDoubleTapZooming: false,
//                   onDocumentLoadFailed: (detail) {
//                     return CircularProgressIndicator();
//                   },
//                     onDocumentLoaded: (data){
//                       setState(() {
//                         Future.delayed(Duration(seconds: 10),(){
//                           setState(() {
//                             isBool=false;
//                           });
//
//                         });
//
//                       });
//                     //return CircularProgressIndicator();
//                     },
//                   key: _pdfViewerKey,
//                 )*/,
//         ),
//         isBool==true?Center(child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(themeColor.getColor())),):Container()
//       ],
//     );
//   }
//
//   showloader() {
//     final themeColor = Provider.of<ThemeNotifier>(context);
//     return Center(
//       child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(themeColor.getColor())),
//     );
//   }
// }
//
// class ImageViewer extends StatelessWidget {
//   final BrochuresScreenViewModel model;
//   final int index;
//
//   ImageViewer(@required this.index, @required this.model);
//
//   @override
//   Widget build(BuildContext context) {
//     final themeColor = Provider.of<ThemeNotifier>(context);
//     return Container(
//       height: Get.height,
//       width: Get.width,
//       decoration: BoxDecoration(color: Colors.white),
//       child: Center(
//           child: model.brochureDataModel == null
//               ? Center(child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(themeColor.getColor())))
//               : PhotoView(
//                   backgroundDecoration: BoxDecoration(color: Colors.white),
//                   imageProvider: NetworkImage(
//                     model.brochureDataModel.result.data[index].attachments[2]
//                         .uploadPath,
//                   ),
//                 )),
//     );
//   }
// }
