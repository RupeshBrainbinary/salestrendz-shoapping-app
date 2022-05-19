import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shoppingapp/app_url_name_companyid.dart';
import 'package:shoppingapp/models/LoginModelClass.dart';
import 'package:shoppingapp/models/allCollectionModel.dart';
import 'package:shoppingapp/models/banklistModel.dart';
import 'package:shoppingapp/models/brochures_model.dart';
import 'package:shoppingapp/models/change_status_model.dart';
import 'package:shoppingapp/models/collectiondetailModel.dart';
import 'package:shoppingapp/models/company_categories_details_model.dart';
import 'package:shoppingapp/models/favorite_product_response_model.dart';
import 'package:shoppingapp/models/helpline_model.dart';
import 'package:shoppingapp/models/home_page_search_model.dart';
import 'package:shoppingapp/models/homepage_model.dart';
import 'package:shoppingapp/models/OdertrasectionModel.dart';
import 'package:shoppingapp/models/payment_method_model.dart';
import 'package:shoppingapp/models/productMayLikeModel.dart';
import 'package:shoppingapp/models/product_stock_model.dart';
import 'package:shoppingapp/models/received_order_model.dart';
import 'package:shoppingapp/models/supplierlist_response_model.dart';
import 'package:shoppingapp/models/suppliermodel.dart';
import 'package:shoppingapp/screen/order_transaction/order_filter.dart';
import 'package:shoppingapp/utils/constants/constants_app_variables.dart';

class RestApi {
  static Future<WishlistModel> favoriteProductApi() async {
    try {
      String loggedInUserId = LoginModelClass.loginModelObj
          .getValueForKeyFromLoginResponse(key: 'user_id');
      String url = Base_URL +
          getAllWishList +
          "?logged_in_userid=$loggedInUserId" +
          "&comp_id=$company_id";
      print(url);
      Response response = await http.get(Uri.parse(url), headers: {
        'Authorization': LoginModelClass.loginModelObj
            .getValueForKeyFromLoginResponse(key: 'token'),
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      });

      print(response?.statusCode);
      print(response?.body);
      print(url);

      if (response?.statusCode == 200) {
        return wishlistModelFromJson(response.body);
      } else {
        return null;
      }
    } catch (e, s) {
      // await FirebaseCrashlytics.instance.recordError(e,s, reason:"Favorite Product List From ApI");
      return null;
    }
  }

  static Future<HomePageModel> getHomePageData(
      int i, String productName) async {
    try {
      String loggedInUserId = LoginModelClass.loginModelObj
          .getValueForKeyFromLoginResponse(key: 'user_id');

      String url = Base_URL +
          getBannerProduct +
          '&logged_in_userid=$loggedInUserId&page=$i&records=15&product_name=$productName';
      print(url);

      Response response = await http.get(Uri.parse(url), headers: {
        'Authorization': LoginModelClass.loginModelObj
            .getValueForKeyFromLoginResponse(key: 'token'),
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      });

      print(response?.statusCode);
      print(response?.body);

      print(response.body);
      if (response?.statusCode == 200) {
        return homePageModelFromJson(response.body);
      } else if (response?.statusCode == 500) {
        return null;
      }
    } catch (e, s) {
      //await FirebaseCrashlytics.instance.recordError(e,s, reason:"Error in Home Page ApI");
      return null;
    }
  }

  static Future<MyOrdersList> getMyOrderApi(int i) async {
    try {
      List<String> list = [];
      if(switch1){
        list.add("Placed");
      } if(switch2){
        list.add("Cancelled");
      } if(switch3){
        list.add("Part Supplied");
      } if(switch4){
        list.add("Supplied");
      } if(switch5){
        list.add("Confirmed");
      } if(switch6){
        list.add("Order Dispatched");
      }if(switch7){
        list.add("Rejected");
      }

      String loggedInUserId = LoginModelClass.loginModelObj
          .getValueForKeyFromLoginResponse(key: 'user_id');
      String url = Base_URL +
          getMyOrdersList +
          "?logged_in_userid=$loggedInUserId" +
          "&comp_id=$company_id" +
          "&page=$i&limit=10&order_id=&status=${list.join(", ")}";
      print(url);
      Response response = await http.get(Uri.parse(url), headers: {
        'Authorization': LoginModelClass.loginModelObj
            .getValueForKeyFromLoginResponse(key: 'token'),
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      });

      print(response?.statusCode);
      print(response?.body);

      if (response?.statusCode == 200) {
        return myOrdersListFromJson(response.body);
      } else {
        return null;
      }
    } catch (e, s) {
      //await FirebaseCrashlytics.instance.recordError(e, s, reason: "Error in My Order List ApI");
      return null;
    }
  }

  static Future<CategoriesModel> getCategoriesFromServer() async {
    try {
      var loggedUserId = LoginModelClass.loginModelObj
          .getValueForKeyFromLoginResponse(key: 'user_id');
      String url =
          Base_URL + getCompanyCategories + '&logged_in_userid=$loggedUserId';
      Response response = await http.get(Uri.parse(url), headers: {
        'Authorization': LoginModelClass.loginModelObj
            .getValueForKeyFromLoginResponse(key: 'token'),
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      });

      print(response?.statusCode);
      print(response?.body);

      if (response?.statusCode == 200) {
        return categoriesModelFromJson(response.body);
      } else {
        return null;
      }
    } catch (e, s) {
      //await FirebaseCrashlytics.instance.recordError(e, s, reason: "Error in Company Catrogies ApI");
      return null;
    }
  }

  static Future<HelplineModel> getCallHelplineListFromServer() async {
    try {
      var loggedUserId = LoginModelClass.loginModelObj
          .getValueForKeyFromLoginResponse(key: 'user_id');
      String url = Base_URL +
          getCallHelplineList +
          '?logged_in_userid=$loggedUserId&comp_id=$company_id';
      Response response = await http.get(Uri.parse(url), headers: {
        'Authorization': LoginModelClass.loginModelObj
            .getValueForKeyFromLoginResponse(key: 'token'),
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      });

      print(response?.statusCode);
      print(response?.body);

      if (response?.statusCode == 200) {
        if (jsonDecode(response.body)['status'] == false)
          return null;
        else
          return helplineModelFromJson(response.body);
      } else {
        return null;
      }
    } catch (e, s) {
      // await FirebaseCrashlytics.instance.recordError(e, s, reason: "Error in Call Helpline ApI");
      return null;
    }
  }

  static Future<ProductLikeModel> getProductLikeData(
      int i, String search, String catId) async {
    try {
      String loggedInUserId = LoginModelClass.loginModelObj
          .getValueForKeyFromLoginResponse(key: 'user_id');

      String url = Base_URL +
          productsList +
          '&logged_in_userid=$loggedInUserId&comp_id=$company_id&category_id=$catId&brand_id&price_min=&price_max=&sort_by&limit=15&page=$i&product_name=$search';
      print(url);

      Response response = await http.get(Uri.parse(url), headers: {
        'Authorization': LoginModelClass.loginModelObj
            .getValueForKeyFromLoginResponse(key: 'token'),
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      });

      print(response?.statusCode);
      print(response?.body);

      print(response.body);
      if (response?.statusCode == 200) {
        return productLikeModelFromJson(response.body);
      } else {
        return null;
      }
    } catch (e, s) {
      // await FirebaseCrashlytics.instance.recordError(e, s, reason: "Error in Porduct Like Data ApI");
      return null;
    }
  }

  static Future<RecivedOrderModel> getReceivedOrderFromServer(int i) async {
    String loggedInUserId = LoginModelClass.loginModelObj
        .getValueForKeyFromLoginResponse(key: 'user_id');
    String url = Base_URL +
        retailersOrders +
        'logged_in_userid=$loggedInUserId&comp_id=$company_id&page=$i&limit=10&comp_ord_id=&cust_name&status=&sup_name&product_count&amount&user_name&date';
    try {
      Response response = await http.get(Uri.parse(url), headers: {
        'Authorization': LoginModelClass.loginModelObj
            .getValueForKeyFromLoginResponse(key: 'token'),
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      });
      print(response?.statusCode);
      print(response?.body);

      if (response.statusCode == 200) {
        return recivedOrderModelFromJson(response.body);
      } else {
        return null;
      }
    } catch (e, s) {
      // await FirebaseCrashlytics.instance.recordError(e, s, reason: "Error in Received Order ApI");
      return null;
    }
  }

  static Future getWishListFromServer(
      {String wishListStatus, String productId, String wishListId}) async {
    try {
      String loggedInUserId = LoginModelClass.loginModelObj
          .getValueForKeyFromLoginResponse(key: 'user_id');
      Map<String, String> requestBody = <String, String>{
        'wishlist_id': wishListId,
        'wishlist_status': wishListStatus,
        'product_id': productId,
        'comp_id': company_id,
        'logged_in_userid': loggedInUserId
      };
      Map<String, String> headers = {
        'Authorization': LoginModelClass.loginModelObj
            .getValueForKeyFromLoginResponse(key: 'token'),
        "Content-Type": "application/x-www-form-urlencoded",
        'Accept': 'application/json',
      };
      var uri = Uri.parse(Base_URL + 'addWishlistProduct');
      var request = http.MultipartRequest('POST', uri);
      request.headers.addAll(headers);
      request.fields.addAll(requestBody);
      var response = await request.send();
      final respStr = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        print('object');
        return respStr;
      }
      return response;
    } catch (e, s) {
      // await FirebaseCrashlytics.instance.recordError(e, s, reason: "Error in Add Wishlist ApI");
      return null;
    }
  }

  static Future<SupllierModel> getSupplierListFromServer() async {
    try {
      var loggedUserId = LoginModelClass.loginModelObj
          .getValueForKeyFromLoginResponse(key: 'user_id');
      String url = Base_URL +
          'getcompanysupplier?comp_id=$company_id&logged_in_userid=$loggedUserId';
      Response response = await http.get(Uri.parse(url), headers: {
        'Authorization': LoginModelClass.loginModelObj
            .getValueForKeyFromLoginResponse(key: 'token'),
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      });

      print(response?.statusCode);
      print(response?.body);

      if (response?.statusCode == 200) {
        return supllierModelFromJson(response.body);
      } else {
        return null;
      }
    } catch (e, s) {
      // await FirebaseCrashlytics.instance.recordError(e, s, reason: "Error in Supplier List ApI");
      return null;
    }
  }

  static Future<PaymentMethodModel> getPaymentMethodListFromServer() async {
    try {
      var loggedUserId = LoginModelClass.loginModelObj
          .getValueForKeyFromLoginResponse(key: 'user_id');
      String url = Base_URL +
          'getpaymentmethod?comp_id=$company_id&logged_in_userid=$loggedUserId';
      Response response = await http.get(Uri.parse(url), headers: {
        'Authorization': LoginModelClass.loginModelObj
            .getValueForKeyFromLoginResponse(key: 'token'),
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      });

      print(response?.statusCode);
      print(response?.body);

      if (response?.statusCode == 200) {
        return paymentMethodModelFromJson(response.body);
      } else {
        return null;
      }
    } catch (e, s) {
      // await FirebaseCrashlytics.instance.recordError(e, s, reason: "Error in payment Method List ApI");
      return null;
    }
  }

  static Future<CollectionDetailModel> getCollectionDetailFromServer(
      int colId) async {
    try {
      String url =
          Base_URL + collectionDetail + 'comp_id=$company_id&collection_id=66';
      Response response = await http.get(Uri.parse(url), headers: {
        'Authorization': LoginModelClass.loginModelObj
            .getValueForKeyFromLoginResponse(key: 'token'),
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      });

      print(response?.statusCode);
      print(response?.body);
      if (response?.statusCode == 200) {
        return collectionDetailModelFromJson(response.body);
      } else {
        return null;
      }
    } catch (e, s) {
      // await FirebaseCrashlytics.instance.recordError(e, s, reason: "Error in Collection Detail ApI");
      return null;
    }
  }

  static Future<AllCollectionsModel> getAllCollectionFromServer() async {
    try {
      var loggedUserId = LoginModelClass.loginModelObj
          .getValueForKeyFromLoginResponse(key: 'user_id');
      String url = Base_URL +
          allcollection +
          'logged_in_userid=$loggedUserId&comp_id=$company_id&search=&page=1';
      Response response = await http.get(Uri.parse(url), headers: {
        'Authorization': LoginModelClass.loginModelObj
            .getValueForKeyFromLoginResponse(key: 'token'),
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      });

      print(response?.statusCode);
      print(response?.body);

      if (response?.statusCode == 200) {
        return allCollectionsModelFromJson(response.body);
      } else {
        return null;
      }
    } catch (e, s) {
      // await FirebaseCrashlytics.instance.recordError(e, s, reason: "Error in All Collection List ApI");
      return null;
    }
  }

  static Future<BankListModel> getBankListFromServer() async {
    try {
      var loggedUserId = LoginModelClass.loginModelObj
          .getValueForKeyFromLoginResponse(key: 'user_id');
      String url = Base_URL +
          banklist +
          'comp_id=$company_id&logged_in_userid=$loggedUserId';
      Response response = await http.get(Uri.parse(url), headers: {
        'Authorization': LoginModelClass.loginModelObj
            .getValueForKeyFromLoginResponse(key: 'token'),
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      });

      print(response?.statusCode);
      print(response?.body);

      if (response?.statusCode == 200) {
        return bankListModelFromJson(response.body);
      } else {
        return null;
      }
    } catch (e, s) {
      // await FirebaseCrashlytics.instance.recordError(e, s, reason: "Error in Bank List ApI");
      return null;
    }
  }

  static Future<ChangeStatusModel> getChangeStatusFromServer() async {
    try {
      var loggedUserId = LoginModelClass.loginModelObj
          .getValueForKeyFromLoginResponse(key: 'user_id');
      String url = Base_URL +
          changeOrderStatus +
          '&logged_in_userid=$loggedUserId&status=Confirmed&order_id=174746';
      Response response = await http.get(Uri.parse(url), headers: {
        'Authorization': LoginModelClass.loginModelObj
            .getValueForKeyFromLoginResponse(key: 'token'),
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      });

      print(response?.statusCode);
      print(response?.body);

      if (response?.statusCode == 200) {
        return changeStatusModelFromJson(response.body);
      } else {
        return null;
      }
    } catch (e, s) {
      // await FirebaseCrashlytics.instance.recordError(e, s, reason: "Error in Change Status ApI");
      return null;
    }
  }

 /* static Future<OrderDetailViewModel> getOrderDetailFromServer() async {
      Response response = await http.get(
          Base_URL + getOrderDetails + '&logged_in_userid=4283&order_id=174746',
          headers: {
            'Authorization': LoginModelClass.loginModelObj
                .getValueForKeyFromLoginResponse(key: 'token'),
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          });

      print(response?.statusCode);
      print(response?.body);

      print(response.statusCode);
      if (response?.statusCode == 200) {
        return orderDetailViewModelFromJson(response.body);
      } else {
        return null;
      }
  }*/

  static Future<SupplierViewModel> getSupplierFromServer(
      int i, String search) async {
    try {
      var loggedUserId = LoginModelClass.loginModelObj
          .getValueForKeyFromLoginResponse(key: 'user_id');
      String url = Base_URL +
          retailerSupplierList +
          '&logged_in_userid=$loggedUserId&state=&pincode=&page=$i&limit=15&sup_name=$search';
      Response response = await http.get(Uri.parse(url), headers: {
        'Authorization': LoginModelClass.loginModelObj
            .getValueForKeyFromLoginResponse(key: 'token'),
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      });

      print(response?.statusCode);
      print(response?.body);

      print(response.statusCode);
      if (response?.statusCode == 200) {
        return supplierViewModelFromJson(response.body);
      } else {
        return null;
      }
    } catch (e, s) {
      // await FirebaseCrashlytics.instance.recordError(e, s, reason: "Error in Supplier List ApI");
      return null;
    }
  }

  static Future<ProductStockViewModel> getProductStockFromServer(
      int productId, int supId, int accountId, String accountType) async {
    try {
      var loggedUserId = LoginModelClass.loginModelObj
          .getValueForKeyFromLoginResponse(key: 'user_id');
      String url = Base_URL +
          productstock +
          '&logged_in_userid=$loggedUserId&sup_id=$supId&product_id=$productId&account_id=$accountId&account_type=$accountType';
      Response response = await http.get(Uri.parse(url), headers: {
        'Authorization': LoginModelClass.loginModelObj
            .getValueForKeyFromLoginResponse(key: 'token'),
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      });

      print(response?.statusCode);
      print(response?.body);

      print(response.statusCode);
      if (response?.statusCode == 200) {
        return productStockViewModelFromJson(response.body);
      } else {
        return null;
      }
    } catch (e, s) {
      // await FirebaseCrashlytics.instance.recordError(e, s, reason: "Error in Stock ApI");
      return null;
    }
  }

  // Search Products Home Page APi

  static Future<HomePageSearch> getSearchProduct(
      String search, int page) async {
    var loggedUserId = LoginModelClass.loginModelObj
        .getValueForKeyFromLoginResponse(key: 'user_id');
    String url = Base_URL +
        homesearch +
        'comp_id=$company_id&logged_in_userid=$loggedUserId&page=$page&records=20&product_name=$search&limit=20';
    Response response = await http.get(Uri.parse(url), headers: {
      'Authorization': LoginModelClass.loginModelObj
          .getValueForKeyFromLoginResponse(key: 'token'),
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });

    print(response?.statusCode);
    print(response?.body);

    print(response.statusCode);
    if (response?.statusCode == 200) {
      return homePageSearchFromJson(response.body);
    } else {
      return null;
    }
  }

// static Future<CollectionSubmitModel> postCollectionToServer(
//     String selectedDate,
//     String sup_id,
//     String onaccount,
//     String collectedamount,
//     String invoice_id,
//     String invoiceamount,
//     String payment_id,
//     String bank_id,
//     String remark,
//     ) async {
//
//   Map<String,dynamic> bodyData = {
//     "collection_id":"new",
//     "comp_id": company_id.toString(),
//     "org_id":"0",
//     "logged_in_userid": loggedInUserId.toString(),
//     "date": selectedDate.toString(),
//     "sup_id": sup_id.toString(),
//     "on_account": onaccount.toString(),
//     "coll_amount": collectedamount.toString(),
//     "invoices": [
//       {
//         "invoice_id": invoice_id.toString(),
//         "collected_amount": invoiceamount.toString()
//       }
//     ],
//     "collection_image_token": [],
//     "payment_mode_type_id": payment_id.toString(),
//     "ref_no": "1",
//     "bank_id": bank_id.toString(),
//     "remark": remark.toString(),
//     "payment_status": "unpaid"
//   };
//   try{
//     Response response = await http.post(
//         Base_URL + insertcollection,
//         headers: {
//           'Authorization': LoginModelClass.loginModelObj
//               .getValueForKeyFromLoginResponse(key: 'token'),
//           'Content-Type': 'application/json',
//           'Accept': 'application/json'},
//         body: jsonEncode(bodyData));
//
//     print(response?.statusCode);
//     print(response?.body);
//
//     if (response?.statusCode == 200) {
//       return collectionSubmitModelFromJson(response.body);
//     } else {
//       print('The error encountered here');
//       return null;
//     }
//   }catch(e,s){
//     await FirebaseCrashlytics.instance.recordError(e,s, reason:"Bank List From ApI");
//     return null;
//   }
// }

  static Future<WishlistModel> getFavoriteProductApi() async {
    try {
      String loggedInUserId = LoginModelClass.loginModelObj
          .getValueForKeyFromLoginResponse(key: 'user_id');
      String url = Base_URL +
          getAllWishList +
          "?logged_in_userid=$loggedInUserId" +
          "&comp_id=$company_id";
      print(url);
      Response response = await http.get(Uri.parse(url), headers: {
        'Authorization': LoginModelClass.loginModelObj
            .getValueForKeyFromLoginResponse(key: 'token'),
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      });

      print(response?.statusCode);
      print(response?.body);
      print(url);

      if (response?.statusCode == 200) {
        return wishlistModelFromJson(response.body);
      } else {
        return null;
      }
    } catch (e, s) {
      // await FirebaseCrashlytics.instance.recordError(e,s, reason:"Favorite Product List From ApI");
      return null;
    }
  }

  static Future<BrochureDataModel> getBrochuresFromServer() async {
    try {
      print(
        "---------->BROCHURES API PASS TOKEN" +
            LoginModelClass.loginModelObj
                .getValueForKeyFromLoginResponse(key: 'token'),
      );
      var loggedUserId = LoginModelClass.loginModelObj
          .getValueForKeyFromLoginResponse(key: 'user_id');
      String url = brochures +
          '?comp_id=$company_id&logged_in_userid=$loggedUserId&limit=5';
      // String url = brochures+
      //     '?comp_id=$company_id&logged_in_userid=$loggedUserId&limit=5';
      //String url = brochures + '?comp_id=290&logged_in_userid=6514&limit=5';
      print("BROCHURES API URL :  " + url);
      Response response = await http.get(Uri.parse(url), headers: {
        'Authorization': LoginModelClass.loginModelObj
            .getValueForKeyFromLoginResponse(key: 'token'),
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      });

      print(response?.statusCode);
      print(response?.body);
      print("RESPONSE OF BROCHURES : " + response.body);
      var jsonResp = jsonDecode(response.body);
      if (response?.statusCode == 200) {
        if (jsonResp['status'] == false)
          return null;
        else {
          print(jsonResp['result']);
          return brochureDataModelFromJson(response.body);
        }
      } else {
        return null;
      }
    } catch (e, s) {
      // await FirebaseCrashlytics.instance.recordError(e, s, reason: "Error in Call Helpline ApI");
      return null;
    }
  }
}
