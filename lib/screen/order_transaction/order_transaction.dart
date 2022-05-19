import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info/package_info.dart';
import 'package:shoppingapp/screen/order_transaction/order_filter.dart';
import 'package:shoppingapp/utils/commons/export_basic_file.dart';

class OrderTransaction extends StatefulWidget {
  OrderTransaction({this.pageRouteType});

  final dynamic pageRouteType;

  @override
  _OrderTransactionState createState() => _OrderTransactionState();
}

enum OrderTransactionType {
  homePage,
  totalOrder,
  pendingOrder,
  productReturned
}

class _OrderTransactionState extends State<OrderTransaction> {
  PageController pageController = PageController();
  int currentIndex = 0;
  bool valueFirst = false;
  bool valueSecond = false;
  bool filter = false;
  bool _isChecked = true;

  var versionCode;
  var forceUpdate;
  var alertDialog;
  String version;
  String buildNumber;

  void refreshView() {
    if (mounted) {
      setState(() {});
    }
  }

  void onPageChanged(int value) {
    setState(() {
      this.currentIndex = value;
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    initPackageInfo();
    // TODO: implement initState
    super.initState();
    if (GlobalModelClass.internetConnectionAvaiable() != true) {
      if (alertDialog == null) {
        Future.delayed(Duration.zero, () {
          alertDialog = GlobalModelClass.showAlertForNoInternetConnection(
              context, refreshView);
          alertDialog.show();
        });
      }
    }
    setState(() {});
  }

  Future<void> initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      version = info.version;
      buildNumber = info.buildNumber;
    });
    versionCode = await LoginModelClass.loginModelObj.getVersionCode();
    forceUpdate = await LoginModelClass.loginModelObj.getForceUpdate();
    if (forceUpdate.toString().toLowerCase() == "true") {
      if (versionCode.toString() != version.toString()) {
        if (alertDialog == null) {
          Future.delayed(Duration.zero, () {
            alertDialog =
                GlobalModelClass.showAlertForUpdate(context, refreshView);
            alertDialog.show();
          });
        }
      }
    }
  }

  final List _items = [
    'Placed',
    'Placed',
    'cancelled',
    'cancelled',
    'cancelled'
  ];

  String _selection;

  @override
  Widget build(BuildContext context) {
    print("Current page --> $runtimeType");
    final themeColor = Provider.of<ThemeNotifier>(context);
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color.fromARGB(255, 252, 252, 252),
          toolbarHeight:
              widget.pageRouteType == OrderTransactionType.homePage ? 0 : 60,
          actions: <Widget>[AppBarUpdate(themeColor: themeColor)],
          leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Text(
                    appName,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      color: themeColor.getColor(),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    Strings.OrderString,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black.withOpacity(0.5),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Spacer(),
              // Row(
              //   children: [
              //     InkWell(
              //         onTap: () {
              //           setState(() {
              //             if (filter == true) {
              //               filter = false;
              //             } else {
              //               filter = true;
              //             }
              //           });
              //         },
              //         child: Container(
              //             margin: EdgeInsets.all(10),
              //             child: Icon(
              //               Icons.filter_alt_outlined,
              //               color: themeColor.getColor(),
              //               size: 30,
              //             ))),
              //   ],
              // )
            ],
          ),
        ),
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.only(top: 5),
            child: Column(
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                pageController.jumpToPage(0);
                              });
                            },
                            child: Container(
                              child: Text(
                                widget.pageRouteType ==
                                        OrderTransactionType.productReturned
                                    ? Strings.Placed
                                    : Strings.PurchaseOrder,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: currentIndex == 0
                                      ? themeColor.getColor()
                                      : Colors.black54,
                                ),
                                maxLines: 1,
                              ),
                            ),
                          ),
                          SizedBox(height: 7),
                          Container(
                            height: 2.5,
                            width: Get.width * 0.5,
                            color: currentIndex == 0
                                ? themeColor.getColor()
                                : Colors.grey[200],
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                pageController.jumpToPage(1);
                              });
                            },
                            child: Container(
                              child: Text(
                                widget.pageRouteType ==
                                        OrderTransactionType.productReturned
                                    ? Strings.Received
                                    : Strings.SalesOrder,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: currentIndex == 1
                                      ? themeColor.getColor()
                                      : Colors.black54,
                                ),
                                maxLines: 1,
                              ),
                            ),
                          ),
                          SizedBox(height: 7),
                          Container(
                            width: Get.width * 0.5,
                            height: 2.5,
                            color: currentIndex == 1
                                ? themeColor.getColor()
                                : Colors.grey[200],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // SizedBox(
                //   height: 15,
                // ),
                // Container(
                //   height: 45,
                //   margin: EdgeInsets.symmetric(horizontal: 30),
                //   padding: EdgeInsets.symmetric(horizontal: 15),
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(25),
                //     color: Colors.white,
                //     boxShadow: [
                //       BoxShadow(
                //         color: Colors.grey.withOpacity(0.3),
                //         blurRadius: 5,
                //         offset: Offset(0, 0), // changes position of shadow
                //       ),
                //     ],
                //   ),
                //   child: Row(
                //     children: [
                //       Expanded(
                //         child: InkWell(
                //           onTap: () {},
                //           child: Row(
                //             mainAxisAlignment: MainAxisAlignment.start,
                //             children: [
                //               Image.asset(
                //                 "assets/images/sort.png",
                //                 height: 25,
                //                 color: Colors.grey,
                //               ),
                //               //SizedBox(width: 10),
                //               Text(
                //                 "Sort by",
                //                 style: TextStyle(
                //                   fontSize: 13,
                //                   color: Colors.black87,
                //                 ),
                //               ),
                //             ],
                //           ),
                //         ),
                //       ),
                //       Expanded(
                //         child: InkWell(
                //           onTap: () {
                //             Get.to(() => OrderFilterScreen()).then((value){
                //               setState((){
                //
                //               });
                //             });
                //           },
                //           child: Row(
                //             mainAxisAlignment: MainAxisAlignment.end,
                //             children: [
                //               Image.asset(
                //                 "assets/images/filter.png",
                //                 height: 20,
                //                 color: Colors.grey,
                //               ),
                //               SizedBox(width: 5),
                //               Text(
                //                 "Filter",
                //                 style: TextStyle(
                //                   fontSize: 13,
                //                   color: Colors.black87,
                //                 ),
                //               ),
                //             ],
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),

                Expanded(
                  child: Container(
                    child: PageView(
                      physics: NeverScrollableScrollPhysics(),
                      onPageChanged: onPageChanged,
                      controller: pageController,
                      children: [
                        PurchaseTransaction(
                            pageRouteType: widget.pageRouteType),
                        SalesTransaction(pageRouteType: widget.pageRouteType),
                      ],
                    ),
                  ),
                ),

              ],
            ),
          ),
        ));
  }
}
//    filter == true? InkWell(
//      onTap:(){
//       setState(() {
//         filter == false;
//       });
//
// },
//      child: Container(margin: EdgeInsets.only(top: 150),
//        height: Get.height,
//        width: Get.width,
//        child: Column(
//          children: [
//            BackdropFilter(
//              filter:  ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
//              child: Container(padding: EdgeInsets.all(5),
//                alignment: Alignment.center,
//                height: 180,width:125,
//                // decoration: BoxDecoration(color:Colors.white,
//                //   borderRadius: BorderRadius.circular(10),),
//                decoration: BoxDecoration(
//                  color: Colors.white,
//                  boxShadow: [
//                    BoxShadow(
//                      color: Colors.grey.withOpacity(0.8),
//                      spreadRadius: 1,
//                      blurRadius: 5,
//                      offset: Offset(0, 0), // changes position of shadow
//                    ),
//                  ],
//                ),
//                 child: ListView.builder(itemCount: _items.length,itemBuilder: (context, index) {
//                   return  Container(margin: EdgeInsets.only(top: 10),
//
//                     child: Row(children: [
//                       SizedBox(height: 30,
//                         child: Checkbox(
//                           checkColor: Colors.white,
//                           // fillColor: MaterialStateProperty.resolveWith(getColor),
//                           value: _isChecked,
//                           // shape: (),
//                           onChanged: (bool value) {
//                             setState(() {
//                               _isChecked = value;
//                             });
//                           },
//                         ),
//                       ),Text(_items[index])
//
//                     ],),
//                   )   ;
//
//                   //   ListTile(
//                   //   leading: Checkbox(
//                   //   checkColor: Colors.white,
//                   //   // fillColor: MaterialStateProperty.resolveWith(getColor),
//                   //   value: _isChecked,
//                   //   // shape: (),
//                   //   onChanged: (bool value) {
//                   //     setState(() {
//                   //       _isChecked = value;
//                   //     });
//                   //   },
//                   // ), trailing:Text(_items[index]),
//                   //
//                   // );
//                 },),
//
//               ),
//            ),
//          ],
//        ),
//      ),
//    ):SizedBox(),
