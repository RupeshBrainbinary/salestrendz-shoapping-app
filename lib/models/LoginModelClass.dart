import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppingapp/models/BookOrderModel.dart';
import 'package:shoppingapp/models/GlobalModelClass.dart';
import 'package:shoppingapp/screen/auth_screens/forgot_password/forgetpassword.dart';
import 'package:shoppingapp/screen/auth_screens/login/login_page.dart';
import 'package:shoppingapp/screen/my_profile/profile_setting/address_pages/address_page.dart'
    as Add;
import 'package:shoppingapp/screen/cart_screen/shopping_cart_page.dart' as Ded;
import 'package:shoppingapp/screen/cart_screen/confirm_order_screen/confirmOrderVC.dart';
import 'package:shoppingapp/screen/product_detail/product_detail_page.dart';
import 'package:shoppingapp/utils/constants/constants_app_variables.dart';
import 'package:shoppingapp/utils/dummy_data/category.dart';
import 'package:shoppingapp/utils/navigator.dart';

class LoginModelClass {
  static LoginModelClass loginModelObj = LoginModelClass();

  Future<void> _deleteCacheDir() async {
    final cacheDir = await getTemporaryDirectory();

    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
    }
  }

  Future<void> _deleteAppDir() async {
    final appDir = await getApplicationSupportDirectory();

    if (appDir.existsSync()) {
      appDir.deleteSync(recursive: true);
    }
  }

  Future<void> _deleteStorage() async {
    final appDir = await getExternalStorageDirectory();

    if (appDir.existsSync()) {
      appDir.deleteSync(recursive: true);
    }
  }

  SharedPreferences prefs;

  Map loginDictionary;

  RegisteredAs registeredAs;

  void resetModel() {
    registeredAs = RegisteredAs.Consumer;
    loginDictionary = Map();
    prefs.remove(loginResponse);
  }

  logOutFromApplication(BuildContext context) async {
    GlobalModelClass.globalObject.selectedTabBarItem = 0;
    await prefs.remove(loginResponse);
    // model = null;
    alertContext = null;
    razorPayObject = null;
    Add.addressListForBookOrder = [];
    categories = [];
    subCategoriesImages = [];
    orderedProduct = null;
    loggedInUserId = null;

    selectedVariant = {};
    Ded.addressListForBookOrder = [];

    retailerSupplierListForBookOrder = [];

    if (Platform.isAndroid) {
      await _deleteCacheDir();
      await _deleteAppDir();
      await _deleteStorage();
    }

    BookOrderModel.orderModelObj.resetModel();
    Nav.routeRemoveUntil(context, LoginPage());
  }

  Future<bool> setVersionCode(String versionCode) async {
    final SharedPreferences prefs = await this.prefs;
    return await prefs.setString("current_version", versionCode);
  }

  Future<String> getVersionCode() async {
    final SharedPreferences prefs = await this.prefs;
    return prefs.getString("current_version");
  }

  Future<bool> setForceUpdate(String forceUpdate) async {
    final SharedPreferences prefs = await this.prefs;
    return await prefs.setString("force_update", forceUpdate);
  }

  Future<String> getForceUpdate() async {
    final SharedPreferences prefs = await this.prefs;
    return prefs.getString("force_update");
  }

  //Setting values in prefs root
  void setValueForKeyInPreferences({String key, String value}) {
    this.prefs.setString(key, value);
  }

  //getting values from prefs root
  String getValueForKeyInPreferences({String key}) {
    return prefs.getString(key) ?? 'null';
  }

  // Getting values from login response
  String getValueForKeyFromLoginResponse({String key}) {
    var loginResponseString = prefs.getString(loginResponse);
    var loginResponseDict = jsonDecode(loginResponseString);

    if (key == 'token') {
      return 'Bearer ' + loginResponseDict[key].toString() ?? '';
    }
    return loginResponseDict[key].toString() ?? '';
  }
}