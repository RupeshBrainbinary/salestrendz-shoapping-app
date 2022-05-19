import 'dart:core';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shoppingapp/models/BookOrderModel.dart';
import 'package:shoppingapp/models/ConnectivityModel.dart';
import 'package:shoppingapp/utils/commons/colors.dart';
import 'package:shoppingapp/utils/theme_notifier.dart';
import 'package:store_redirect/store_redirect.dart';

class GlobalModelClass {
  static GlobalModelClass globalObject = GlobalModelClass();
  int selectedTabBarItem;

  String getDateInString({String fromDate, String inFormat}) {
    // print('----------------Date of order : $fromDate');
    var dateTimeObject = DateTime.parse(fromDate);
    var newFormat = DateFormat('yyyy MMM, dd');
    //print('----------------Date of order after converting : ${newFormat.format(dateTimeObject)}');
    return newFormat.format(dateTimeObject);
    //print('----calling date change');
  }

  String convertDateToLocal({String fromDate}) {
    //print('----------------Date of order : $fromDate');
    var dateTimeObject = DateTime.parse(fromDate + 'Z');
    //print('------utc : ${dateTimeObject.isUtc}');
    var newFormat = DateFormat('yy-MM-dd hh:mm:ss');
    //print('----------------Date of order after converting : ${dateTimeObject.toLocal().toString()}');
    return newFormat.format(dateTimeObject.toLocal());
  }

  static bool internetConnectionAvaiable() {
    return ConnectivityModelClass.getInstance().hasConnection;
  }

  static Alert showAlertForNoInternetConnection(BuildContext context,
      [Function func]) {
    return Alert(
      context: context,
      type: AlertType.warning,
      title: 'Network Unavaiable',
      desc: 'Please connect to a network to serve your request.',
      buttons: [
        DialogButton(
          child: Text(
            'Ok',
            style: GoogleFonts.poppins(color: Colors.white),
          ),
          onPressed: () {
            BookOrderModel.orderModelObj.showLoadingIndicator = false;
            if (func != null) {
              func();
            }
            Get.back();
          },
        ),
        // DialogButton(
        //   child: Text(
        //     'Retry',
        //     style: TextStyle(color: Colors.white),
        //   ),
        //   onPressed: () {
        //     Get.back();
        //   },
        // ),
      ],
    );
  }

  showAlertWith(
      {BuildContext parentContext,
      BuildContext childContext,
      String alertTitle,
      String alertMessage,
      List<Widget> alertButtons,
      Widget cancelButton}) {
    if (alertButtons.length >= 2) {
      return CupertinoActionSheet(
        title: Text(alertTitle),
        actions: alertButtons,
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(childContext);
          },
          child: Text(
            'Cancel',
            style: GoogleFonts.poppins(color: mainColor),
          ),
        ),
      );
    }

    if (Platform.isIOS) {
      if (alertButtons.length < 2) {
        return CupertinoAlertDialog(
          title: Text(alertTitle),
          content: Text(alertMessage),
          actions: alertButtons,
        );
      }
    } else {}
  }

  Widget loadingIndicator(bool visibility,context) {
    final themeColor = Provider.of<ThemeNotifier>(context);
    return Visibility(
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
      visible: visibility,
      child: Center(
        child: Container(
          margin: EdgeInsets.only(top: 50, bottom: 30),
          child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(themeColor.getColor())),
        ),
      ),
    );
  }

  static Alert showAlertForUpdate(BuildContext context, [Function func]) {
    return Alert(
      style: AlertStyle(isOverlayTapDismiss: false),
      context: context,
      onWillPopActive: false,
      type: AlertType.warning,
      //closeIcon:SizedBox(),
      title: 'New Update Available',
      desc: 'Please update new version for continue',
      buttons: [
        DialogButton(
          child: Text(
            'Update',
            style: GoogleFonts.poppins(color: Colors.white),
          ),
          onPressed: () {
            StoreRedirect.redirect(
              androidAppId: "com.softpillar.qone",
              iOSAppId: "585027354",
            );
          },
        ),
      ],
    );
  }
}
