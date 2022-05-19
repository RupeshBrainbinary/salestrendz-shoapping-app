import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:shoppingapp/screen/activity_pages/brochures/brochures_screen.dart';
import 'package:shoppingapp/screen/activity_pages/file_complaint/file_complaint_page.dart';
import 'package:shoppingapp/utils/commons/export_basic_file.dart';

class ActivityProfile extends StatefulWidget {
  @override
  _ActivityProfileState createState() => _ActivityProfileState();
}

class _ActivityProfileState extends State<ActivityProfile> {
  List activityName = [
    // 'Place Order',
    // 'Mark Return',
    // 'Stock Update',
    //'Payment Update',
    // 'Live Pic',
    'View Brochure',
    // 'Conduct Survey',
    // 'Comment',
    'Raise Complaint',
    // 'Feed Back',
    'Call Helpline',
  ];
  List activityImage = [
    // 'assets/icons/placeorder.png',
    // 'assets/icons/markreturn.png',
    // 'assets/icons/Strock update.png',
    //'assets/icons/paymentupdate.png',
    // 'assets/icons/livepic.png',
    'assets/icons/livebrochure.png',
    // 'assets/icons/condectsurvey.png',
    // 'assets/icons/comment.png',
    'assets/icons/raisecomplain.png',
    // 'assets/icons/feedback.png',
    'assets/icons/helpline.png',
  ];

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPackageInfo();
  }

  Future<void> initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      version = info.version;
      buildNumber = info.buildNumber;
    });
    versionCode = await LoginModelClass.loginModelObj.getVersionCode();
    forceUpdate = await LoginModelClass.loginModelObj.getForceUpdate();
    if(forceUpdate.toString().toLowerCase() == "true" ){
      if(versionCode.toString() != version.toString()){
        if (alertDialog == null) {
          Future.delayed(Duration.zero, () {
            alertDialog = GlobalModelClass.showAlertForUpdate(
                context, refreshView);
            alertDialog.show();
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<ThemeNotifier>(context);
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              height: Get.height / 20,
              width: Get.width,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: themeColor.getColor(),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.zero,
                  topRight: Radius.zero,
                  bottomLeft: Radius.circular(22.0),
                  bottomRight: Radius.circular(22.0),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [SizedBox(height: 3), SizedBox(height: 25)],
              ),
            ),
            // InkResponse(
            //   onTap: () {
            //     // _selectActionBottomSheet(context, themeColor);
            //   },
            //   child: Container(
            //     margin: EdgeInsets.only(top: 25, bottom: 1),
            //     height: Get.height / 8,
            //     width: Get.width / 1.2,
            //     decoration: BoxDecoration(
            //       shape: BoxShape.rectangle,
            //       color: themeColor.getColor(),
            //       borderRadius: BorderRadius.all(
            //         Radius.circular(15),
            //       ),
            //     ),
            //     child: Row(
            //       children: [
            //         Container(
            //           padding: EdgeInsets.only(
            //             left: 15,
            //             top: 10,
            //             bottom: 10,
            //             right: 20,
            //           ),
            //           child: Image.asset(
            //             'assets/icons/qrcode.png',
            //             color: Colors.white,
            //           ),
            //         ),
            //         Container(
            //           child: Text(
            //             'Scan QR Code',
            //             style: GoogleFonts.poppins(
            //               color: Colors.white,
            //               fontSize: 20,
            //               fontWeight: FontWeight.w600,
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.only(
                  left: 15,
                  bottom: 10,
                  right: 20,
                ),
                width: Get.width,
                child: GridView.builder(
                  itemCount: activityName.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: .85,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        if (index == 0) {
                          Nav.route(context, Brochures());

                          // Nav.route(context, MakePaymentPage());
                        }
                        if (index == 1) {
                          print("INDEX 1 TAPPED");
                          Nav.route(context, FileComplaintPage());
                         // Nav.route(context, CallHelpline());
                         // Nav.route(context, Brochures());
                          // Nav.route(context, AllCollectionPage());
                          // Nav.route(context, ReturnScreen());
                        }
                        if (index == 2) {
                          print("INDEX 2 TAPPED");
                          Nav.route(context, CallHelpline());
                        }
                        if (index == 3) {
                          print("INDEX 3 TAPPED");
                        }
                        if (index == 4) {
                          print("INDEX 4 TAPPED");
                        }
                        if (index == 5) {
                          print("INDEX 5 TAPPED");
                        }
                        if (index == 6) {
                          print("INDEX 6 TAPPED");
                        }
                        if (index == 7) {
                          print("INDEX 7 TAPPED");
                        }
                        if (index == 8) {
                          print("INDEX 8 TAPPED");
                          // Nav.route(context, FileComplaintPage());
                        }
                        if (index == 9) {
                          print("INDEX 9 TAPPED");
                        }
                        if (index == 10) {
                          print("INDEX 10 TAPPED");
                        }
                      },
                      child:   activityName[index] =='Raise Complaint'?SizedBox():Container(
                        margin: EdgeInsets.only(
                          left: 10,
                          right: 10,
                          bottom: 10,
                          top: 5,
                        ),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 1.0,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 50.0,
                              height: 50.0,
                              padding: EdgeInsets.all(8),
                              decoration: new BoxDecoration(
                                color: themeColor.getColor(),
                                shape: BoxShape.circle,
                              ),
                              child: Image.asset(
                                activityImage[index],
                                color: Colors.white,
                              ),
                            ),
                            Flexible(
                              child: Center(
                                child: Text(
                                  activityName[index],
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void selectActionBottomSheet(BuildContext context, ThemeNotifier themeColor) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10),
                    color: themeColor.getColor(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Select Action',
                          style: GoogleFonts.poppins(color: Colors.white),
                        ),
                        InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                  InkResponse(
                    onTap: () {
                      // Nav.route(context, QRViewExample());
                    },
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                            left: 15,
                            top: 12,
                            bottom: 12,
                          ),
                          child: Text(
                            'Stack Update',
                            style: GoogleFonts.poppins(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 2),
                  InkResponse(
                    onTap: () {
                      // Nav.route(context, MarkReturnQRCode());
                    },
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                            left: 15,
                            top: 12,
                            bottom: 12,
                          ),
                          child: Text(
                            'Mark a Return',
                            style: GoogleFonts.poppins(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 2),
                  InkResponse(
                    onTap: () {
                      // Nav.route(context, ClaimExpiryQRCode());
                    },
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                            left: 15,
                            top: 12,
                            bottom: 12,
                          ),
                          child: Text(
                            'Claim Expiry',
                            style: GoogleFonts.poppins(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 2),
                  InkResponse(
                    onTap: () {},
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                            left: 15,
                            top: 12,
                            bottom: 12,
                          ),
                          child: Text(
                            'Claim Scheme',
                            style: GoogleFonts.poppins(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
