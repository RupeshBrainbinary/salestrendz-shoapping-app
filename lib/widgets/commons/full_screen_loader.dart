import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shoppingapp/utils/theme_notifier.dart';

class Loader {
  void showLoader(BuildContext context ) {
    final themeColor = Provider.of<ThemeNotifier>(context,listen: false);
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Stack(
            children: <Widget>[
              Container(
                height: Get.height,
                width: Get.width,
                color: Colors.transparent,
              ),
              Center(
                child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(themeColor.getColor())),
              )
            ],
          ),
        );
      },
    );
  }

  void hideLoader(BuildContext context) {
    Navigator.of(context, rootNavigator: false).pop();
  }
}
