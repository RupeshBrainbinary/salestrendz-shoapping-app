import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shoppingapp/app_url_name_companyid.dart';
import 'package:shoppingapp/models/LoginModelClass.dart';
import 'package:shoppingapp/models/supplierlist_response_model.dart';
import 'package:shoppingapp/utils/constants/constants_app_variables.dart';

class BookOrderModel {
  static BookOrderModel orderModelObj = BookOrderModel();

  Map selectedAddressForOrderBooking;
  SupplierList selectedRetailerSupplier;

  bool showLoadingIndicator;

  Function initPageRefresh;
  Function homeNavigatorRefresh;
  Function appBarButtonCountrRefresh;
  Function homePageRefresh;

  List footerList;

  void resetModel() {
    orderModelObj.selectedAddressForOrderBooking = null;
    orderModelObj.footerList = null;
    orderModelObj.productsInCart = [];
  }

  void refreshViewForOrderBooking() {
    initPageRefresh();
    homeNavigatorRefresh();
    // appBarButtonCountrRefresh();
    homePageRefresh();
  }

  List<OrderedProduct> productsInCart = [];

  List currentProductVariants;
  List<AvailableVariants> availableVariantsList = [];
  Map schemeInfo;
  Map selectedProduct;
  Map selectedVariant;

  String selectedProductType;

  OrderedProduct getProductDetailsObject({
    @optionalTypeArgs Map variantSelectedAs,
    @required String productID,
    Map selectedVarientId,
    int callType,
    int variantIndex,
    double productQty,
    bool isVariantAvailable,
    int minQty,

  }) {
    isVariantAvailable = isVariantAvailable ?? false;
    variantIndex = variantIndex ?? 0;
    print('The value for product ID is');
    print(productID);

    OrderedProduct product = OrderedProduct();
    // if (selectedProduct['type'].toString().toLowerCase() == 'variant') {
    if (variantSelectedAs == null) {
      variantSelectedAs = selectedProduct['available_variants'].first;
    }
    print(variantSelectedAs['gst']);
    return OrderedProduct(
      productID: productID,
      productVariantID: callType == 1
          ? (selectedVarientId['available_variants'][variantIndex]
                      ['variant_id'])
                  .toString() ??
              ''
          : variantSelectedAs != null
              ? (variantSelectedAs['variant_id']).toString()
              : '',
      productName: selectedProduct['product_name'] ?? '',
      brandName: isVariantAvailable
          ? selectedVarientId['brand_name']
                  .toString() ??
              ''
          : variantSelectedAs != null
              ? variantSelectedAs['brand_name']
              : (selectedProduct['brand_name'] ?? ''),
      productDescription: variantSelectedAs['product_description'] ?? '',
      //productDescription: selectedVarientId['product_description'] ?? '',
      hsn: variantSelectedAs['hsn'] ?? '',
      sku: variantSelectedAs['sku'] ?? '',
      qtyIncases: variantSelectedAs['qty_in_cases'] ?? '',
      variantQty: double.parse((isVariantAvailable
              ? selectedVarientId['available_variants'][variantIndex]
                      ['qty_in_cases'] ??
                  0
              : variantSelectedAs['qty_in_cases'] ?? 0)
          .toString()),
      productPrice: double.parse((isVariantAvailable
              ? selectedVarientId['price'] ?? 0
              : variantSelectedAs['price'] ?? 0)
          .toString()),
      productQuantity: productQty ?? 1.0,
      minQuantity: minQty != null ? minQty.toDouble() : double.parse((variantSelectedAs['min_qty'] ?? 0).toString()),
      mrp: double.parse((variantSelectedAs['mrp']==null?(selectedVarientId != null && selectedVarientId['price']!=null?selectedVarientId['price']:0):  0).toString()),
      gst: double.parse((selectedVarientId == null ? 0 : selectedVarientId['gst'] ?? 0).toString()),
      productImages: callType == 1
          ? selectedProduct['imagesize512x512'] == null || selectedProduct['imagesize512x512'] is String ? [] : selectedProduct['imagesize512x512'] is bool ? [] : selectedProduct['imagesize512x512']
          : variantSelectedAs['imagesize512x512'] ?? [],
      freeProductVaritantId:
          variantSelectedAs['scheme_on_product'].length == 0 ||
                  variantSelectedAs['scheme_on_product'][0] == null
              ? 0
              : variantSelectedAs['scheme_on_product'][0]
                  ['free_product_varitant_id'],
      unitsOfMeasurement: variantSelectedAs['unit_of_measurement']
    );
    // } else {
    //   return OrderedProduct(
    //     productID: productID,
    //     productVariantID: '0',
    //     productName: selectedProduct['product_name'] ?? '',
    //     brandName: selectedProduct['brand_name'] ?? '',
    //     productDescription: selectedProduct['product_description'] ?? '',
    //     hsn: selectedProduct['hsn'] ?? '',
    //     sku: selectedProduct['sku'] ?? '',
    //     productPrice: double.parse((selectedProduct['price'] ?? 0).toString()),
    //     productQuantity: 1.0,
    //     minQuantity: double.parse((selectedProduct['min_qty'] ?? 0).toString()),
    //     mrp: double.parse((selectedProduct['mrp'] ?? 0).toString()),
    //     gst: double.parse((selectedProduct['gst'] ?? 0).toString()),
    //     productImages: selectedProduct['imagesize512x512'] ?? [],
    //   );
    // }
    return product;
  }

  List setOrderBookingFooterViewFromOrderDetails(Map orderDetails) {
    if (orderDetails == null || (orderDetails?.keys?.length ?? 0) <= 0) {
      return [];
    }

    double totalTaxApplied = 0.0;

    List productsOrdered = orderDetails['order_products'];

    List taxValues = Set.from(productsOrdered
        ?.map((e) => double.parse((e['cgst'] ?? '0').toString()))).toList();

    double totalTaxValue = 0.0;

    double totalTaxCalculatedOnProduct = (productsOrdered
            .map((e) => double.parse(e['product_total'].toString())))
        .fold(0.0, (previousValue, element) => previousValue + element);

    footerList = [
      {
        'Subtotal':
            '$currencySymbol ${double.parse(orderDetails['before_gst_addition_amount'].toString()).toStringAsFixed(2)}'
      },
    ];

    String taxType = '';
    if (double.parse(productsOrdered.first['prod_gst'].toString()) == 0.0) {
      taxType = 'gst';
    }

    for (double taxValue in taxValues) {
      if (taxValue != 0.0) {
        var objectsEqualToTax = orderDetails['order_products'].where(
            (element) =>
                double.parse(element['cgst'].toString() ?? '') == taxValue);

        double totalValueForCaluculatingTax = ((objectsEqualToTax
                .map((e) => double.parse(e['product_total'].toString())))
            .fold(
                0.0,
                (previousValue, element) =>
                    double.parse(previousValue.toString()) +
                    double.parse(element.toString())));

        if (taxType?.toLowerCase() == 'gst') {
          footerList.add({
            'CGST @$taxValue on $currencySymbol ${totalValueForCaluculatingTax.toStringAsFixed(2)}':
                '$currencySymbol ${(totalValueForCaluculatingTax * ((taxValue) / 100.0)).toStringAsFixed(2)}'
          });
          footerList.add({
            'SGST @$taxValue on $currencySymbol ${totalValueForCaluculatingTax.toStringAsFixed(2)}':
                '$currencySymbol ${(totalValueForCaluculatingTax * ((taxValue) / 100.0)).toStringAsFixed(2)}'
          });
        } else {
          footerList.add({
            '${taxType != null && taxType.length > 0 ? taxType : 'GST'} @$taxValue on ₹ ${totalValueForCaluculatingTax.toStringAsFixed(2)}':
                '$currencySymbol ${(totalValueForCaluculatingTax * ((taxValue) / 100)).toStringAsFixed(2)}'
          });
        }

        totalTaxValue = double.parse(
            (totalValueForCaluculatingTax * ((taxValue) / 100))
                .toStringAsFixed(2));

        totalTaxCalculatedOnProduct =
            double.parse(totalTaxCalculatedOnProduct.toStringAsFixed(2)) +
                double.parse(((totalValueForCaluculatingTax * (taxValue / 100))
                    .toStringAsFixed(2)));
      }
    }

    footerList.add({
      'Total':
          '$currencySymbol ${double.parse(orderDetails['amount'].toString()).toStringAsFixed(2)}'
    });

    return footerList;
  }

  List setOrderBookingFooterView([String taxType, bool getTotalTax = true]) {
    double totalTaxApplied = 0.0;

    List taxValues =
        Set.from(orderModelObj.productsInCart.map((e) => e.gst)).toList();

    double totalTaxValue = 0.0;

    double totalTaxCalculatedOnProduct = (orderModelObj.productsInCart
            .map((e) => e.productPrice * e.productQuantity))
        .fold(0.0, (previousValue, element) => previousValue + element);
    footerList = [
      {'Subtotal': '${totalTaxCalculatedOnProduct.toStringAsFixed(2)}'},
    ];

    for (double taxValue in taxValues) {
      if (taxValue != 0.0) {
        var objectsEqualToTax = orderModelObj.productsInCart
            .where((element) => element.gst == taxValue);

        double totalValueForCaluculatingTax =
            ((objectsEqualToTax.map((e) => e.productPrice * e.productQuantity))
                .fold(
                    0.0,
                    (previousValue, element) =>
                        double.parse(previousValue.toString()) +
                        double.parse(element.toString())));

        // if (taxType?.toLowerCase() == 'gst') {
        //   footerList.add({
        //     'CGST @${taxValue / 2.0} on $currencySymbol ${totalValueForCaluculatingTax.toStringAsFixed(2)}':
        //         '$currencySymbol ${(totalValueForCaluculatingTax * ((taxValue / 2.0) / 100)).toStringAsFixed(2)}'
        //   });
        //   footerList.add({
        //     'SGST @${taxValue / 2.0} on $currencySymbol ${totalValueForCaluculatingTax.toStringAsFixed(2)}':
        //         '$currencySymbol ${(totalValueForCaluculatingTax * ((taxValue / 2.0) / 100)).toStringAsFixed(2)}'
        //   });
        // } else {
        //   footerList.add({
        //     '${taxType != null && taxType?.length > 0 ? taxType : 'GST'} @$taxValue on ₹ ${totalValueForCaluculatingTax.toStringAsFixed(2)}':
        //         '${(totalValueForCaluculatingTax * ((taxValue) / 100)).toStringAsFixed(2)}'
        //   });
        // }

        totalTaxValue = double.parse(
            (totalValueForCaluculatingTax * ((taxValue) / 100))
                .toStringAsFixed(2));

        totalTaxCalculatedOnProduct =
            double.parse(totalTaxCalculatedOnProduct.toStringAsFixed(2)) +
                double.parse(((totalValueForCaluculatingTax * (taxValue / 100))
                    .toStringAsFixed(2)));
      }
    }
    if (getTotalTax == true && totalTaxValue != 0.0) {
      footerList.add({
        'TotalTax': '${totalTaxValue.toString()}',
      });
    }

    footerList
        .add({'Total': '${totalTaxCalculatedOnProduct.toStringAsFixed(2)} '});

    return footerList;
  }

  void addSelectedProductInCart(OrderedProduct prod) {
    if (prod != null) {
      if (orderModelObj.productsInCart == null) {
        orderModelObj.productsInCart = [];
      }

      // if (orderModelObj.productsInCart.contains(prod)) {
      //   orderModelObj.productsInCart.remove(prod);
      // }
      prod.addQty = prod.productQuantity;
      orderModelObj.productsInCart.add(prod);
    }

    LoginModelClass.loginModelObj.prefs
        .setString('productsInCart', OrderedProduct.encodeObjectsToJson());
  }

  void removeSelectedProductFromCart(OrderedProduct prod) {
    orderModelObj.productsInCart.remove(prod);
    LoginModelClass.loginModelObj.prefs
        .setString('productsInCart', OrderedProduct.encodeObjectsToJson());
  }

  void loadProductsFromSharedPreferences() {
    String productsCartString = LoginModelClass.loginModelObj
        .getValueForKeyInPreferences(key: 'productsInCart');

    OrderedProduct.decodeObjectsFromJson(jsonDecode(productsCartString));
  }

  Map getBookOrderRequestRawDataForSubmittingTheOrder(String paymentMethod) {
    String taxType = orderModelObj.selectedRetailerSupplier.gstApply.toString();

    List footerListFor = orderModelObj.setOrderBookingFooterView(taxType, true);

    Map bookOrderReqData = Map();
    bookOrderReqData['retailer_type'] =
        orderModelObj.selectedRetailerSupplier.accountType.toString();
    bookOrderReqData['order_id'] = 'new';
    bookOrderReqData['sub_total'] =
        '${footerListFor.where((element) => element.keys?.first == 'Subtotal').first['Subtotal'].toString().replaceAll('₹ ', '')}';
    bookOrderReqData['total_tax'] = footerListFor
                .where((element) => element.keys?.first == 'TotalTax')
                .length >
            0
        ? '${footerListFor.where((element) => element.keys?.first == 'TotalTax').first['TotalTax'].toString()}'
        : '0';
    bookOrderReqData['order_total'] =
        '${footerListFor.where((element) => element.keys?.first == 'Total').first['Total'].toString().replaceAll('₹ ', '')}';
    bookOrderReqData['delivery_address'] = orderModelObj
            .selectedAddressForOrderBooking['name'] +
        ', ${orderModelObj.selectedAddressForOrderBooking['street_address']}' +
        ', ${orderModelObj.selectedAddressForOrderBooking['town']}' +
        ', ${orderModelObj.selectedAddressForOrderBooking['state']}' +
        ', ${orderModelObj.selectedAddressForOrderBooking['contry']}' +
        ' - ${orderModelObj.selectedAddressForOrderBooking['pincode']}' +
        '\n${orderModelObj.selectedAddressForOrderBooking['address_label']}';
    bookOrderReqData['retailer'] =
        orderModelObj.selectedRetailerSupplier.supId.toString();
    bookOrderReqData['logged_in_userid'] =
        '${LoginModelClass.loginModelObj.getValueForKeyFromLoginResponse(key: 'user_id')}';
    bookOrderReqData['comp_id'] = company_id.toString();
    bookOrderReqData['source'] = 'E-commerce retailer-app';
    bookOrderReqData['payment_method'] = paymentMethod;

    /// new changes ///

    bookOrderReqData['orderamount_schemeId'] =
        schemeInfo['order_totalAmount_SchemeId'];
    bookOrderReqData['Orderamount_scheme_discount_percentage'] =
        schemeInfo['orderAmount_SchemePercentage'];
    bookOrderReqData['Orderamount_scheme_discount_amount'] =
        schemeInfo['scheme_Discount_Amount'];

    List<Map> productsArray = [];
    int i = 0;
    for (OrderedProduct prod in orderModelObj.productsInCart) {
      Map productData = {};
      productData['product_id'] = prod.productID.toString();
      productData['product_variant_id'] = prod.productVariantID.toString();
      productData['price'] = prod.productPrice.toString();
      productData['mrp'] = prod.mrp.toString();
      productData['qty'] = prod.productQuantity.toString();
      productData['prod_total'] =
          (prod.productPrice * prod.productQuantity).toStringAsFixed(2);
      productData['tax_percentage'] = prod.gst.toString();
      productData['tax_type'] =
          orderModelObj.selectedRetailerSupplier.gstApply == GstApply.GST
              ? "GST"
              : "IGST";
      productData['hsn'] = prod.hsn.toString();

      /// new changes ///

      productData['free_product_variant_rel'] =
          prod.freeProductVaritantId == 0 ? "primary" : "free";
      productData['free_product_variant_id'] = prod.freeProductVaritantId;
      productData['free_cases'] =
          schemeInfo['products'][i]['free_product_cases'];
      productData['free_units'] =
          schemeInfo['products'][i]['free_product_units'];
      productData['scheme_id'] =
          schemeInfo['products'][i]['productQty_schemeId'];
      productData['productQty_schemeId'] =
          schemeInfo['products'][i]['productQty_schemeId'];
      productData['product_scheme_discount_percentage'] =
          schemeInfo['products'][i]['product_scheme_discount_percentage'];
      productData['product_scheme_discount_amount'] =
          schemeInfo['products'][i]['product_scheme_discount_amount'];
      productsArray.add(productData);
      i++;
    }

    bookOrderReqData['products'] = productsArray;
    return bookOrderReqData;
  }

  Map<String, dynamic> getSchemeInfoBody() {
    Map<String, dynamic> body = {};

    //String taxType = orderModelObj.selectedRetailerSupplier.gstApply.toString();

    List footerListFor = orderModelObj.setOrderBookingFooterView('', true);

    body['comp_id'] = company_id.toString();
    body['order_totalAmount'] =
        '${footerListFor.where((element) => element.keys?.first == 'Subtotal').first['Subtotal'].toString().replaceAll('₹ ', '')}';
    body['logged_in_userid'] =
        '${LoginModelClass.loginModelObj.getValueForKeyFromLoginResponse(key: 'user_id')}';
    body['request_source'] = "retailer_app";
    body['account_id'] = "0";

    List<Map> productsArray = [];
    int i = 0;
    for (OrderedProduct prod in orderModelObj.productsInCart) {
      Map productData = {};

      productData['product_variant_id'] = prod.productVariantID.toString();
      productData['product_variant_name'] = prod.productName.toString();
      productData['product_price'] = prod.productPrice.toString();
      productData['product_gst_percentage'] = prod.gst.toString();
      productData['product_amount'] =
          ((prod.productQuantity ?? 0) * prod.productPrice).toString();
      productData['qty'] = prod.productQuantity.toString();
      productsArray.add(productData);
      i++;
    }
    body['products'] = productsArray;
    return body;
  }
}

class OrderedProduct {
  final String productName;
  final String isinwishlist;
  final String brandName;
  final String hsn, sku;
  final  int qtyIncases;
  final String productDescription;
  final double productPrice;
  final double variantQty;
  double productQuantity;
  double addQty;
  double minQuantity;
  final double mrp;
  final double gst;
  final String productVariantID;
  final String productID;
  final int freeProductVaritantId;
  String variantName;
  final List productImages;
  final String unitsOfMeasurement;

  OrderedProduct({
    this.productID,
    this.isinwishlist,
    this.variantQty,
    this.variantName,
    this.productVariantID,
    this.productName,
    this.brandName,
    this.productDescription,
    this.hsn,
    this.sku,
    this.qtyIncases,
    this.productPrice,
    this.productQuantity,
    this.addQty,
    this.minQuantity,
    this.mrp,
    this.gst,
    this.productImages,
    this.freeProductVaritantId,
    this.unitsOfMeasurement

  });

  static String encodeObjectsToJson() {
    List<Map> productListJsonFormat = [];
    for (OrderedProduct prod in BookOrderModel.orderModelObj.productsInCart) {
      Map productDict = {
        'productID': prod.productID,
        'isinwishlist': prod.isinwishlist,
        'productVariantID': prod.productVariantID,
        'productName': prod.productName,
        'variantQty': prod.variantQty,
        'brandName': prod.brandName,
        'productDescription': prod.productDescription,
        'hsn': prod.hsn,
        'sku': prod.sku,
        'qty_in_cases':prod.qtyIncases,
        'productPrice': prod.productPrice,
        'productQuantity': prod.productQuantity,
        'addQty': prod.addQty,
        'minQuantity': prod.minQuantity,
        'mrp': prod.mrp,
        'gst': prod.gst,
        'productImages': prod.productImages,
        'variantName': prod.variantName,
        'free_product_varitant_id': prod.freeProductVaritantId,
        'unit_of_measurement':prod.unitsOfMeasurement
      };
      productListJsonFormat.add(productDict);
    }

    return jsonEncode(productListJsonFormat);
  }

  static void decodeObjectsFromJson(List productObjs) {
    BookOrderModel.orderModelObj.productsInCart = [];
    if (productObjs != null) {
      for (Map variantSelectedAs in productObjs) {
        BookOrderModel.orderModelObj.productsInCart.add(
          OrderedProduct(
            productID: (variantSelectedAs['productID']).toString(),
            isinwishlist: (variantSelectedAs['isinwishlist'].toString()),
            productVariantID:
                (variantSelectedAs['productVariantID']).toString(),
            productName: variantSelectedAs['productName'] ?? '',
            brandName: variantSelectedAs['brandName'],
            productDescription: variantSelectedAs['productDescription'] ?? '',
            hsn: variantSelectedAs['hsn'] ?? '',
            sku: variantSelectedAs['sku'] ?? '',
            qtyIncases: variantSelectedAs['qty_in_cases'] ?? '',
            productPrice: double.parse(
                (variantSelectedAs['productPrice'] ?? 0).toString()),
            productQuantity: double.parse(
                (variantSelectedAs['productQuantity'] ?? 0).toString()),
            minQuantity: double.parse(
                (variantSelectedAs['minQuantity'] ?? 0).toString()),
            mrp: double.parse((variantSelectedAs['mrp'] ?? 0).toString()),
            gst: double.parse((variantSelectedAs['gst'] ?? 0).toString()),
            productImages: variantSelectedAs['productImages'] ?? [],
            variantName: variantSelectedAs['variantName'] ?? "",
            freeProductVaritantId:
                variantSelectedAs['free_product_varitant_id'] ?? 0,
            unitsOfMeasurement: variantSelectedAs['unit_of_measurement']
          ),
        );
      }
    }
  }
}

List<AvailableVariants> availableVariantsFromJson(String str) =>
    List<AvailableVariants>.from(
        json.decode(str).map((x) => AvailableVariants.fromJson(x)));

String availableVariantsToJson(List<AvailableVariants> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AvailableVariants {
  AvailableVariants({
    this.variantAttriName,
    this.variantId,
    this.variantInPricelist,
    this.sku,
    this.schemeOnProduct,
  });

  String variantAttriName;
  int variantId;
  String variantInPricelist;
  String sku;
  SchemesOnProducts schemeOnProduct;

  factory AvailableVariants.fromJson(Map<String, dynamic> json) =>
      AvailableVariants(
        variantAttriName: json["variant_attri_name"]==""?"":json["variant_attri_name"],
        variantId: json["variant_id"],
        variantInPricelist: json["variant_in_pricelist"],
        sku: json["sku"],
        schemeOnProduct: json["scheme_on_product"] is Map
            ? SchemesOnProducts.fromJson(json["scheme_on_product"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "variant_attri_name": variantAttriName,
        "variant_id": variantId,
        "variant_in_pricelist": variantInPricelist,
        "sku": sku,
        "scheme_on_product": schemeOnProduct.toJson(),
      };
}

class SchemesOnProducts {
  SchemesOnProducts({
    this.schemeId,
    this.masterProductVariantId,
    this.masterProductVariantQtyCases,
    this.masterProductVariantQtyUnits,
    this.masterProductVariantTotalQty,
    this.freeProductVaritantId,
    this.freeProductVariantQtyCases,
    this.freeProductVariantQtyUnits,
    this.freeMasterQty,
    this.masterProductVariantDiscount,
    this.masterVariantName,
    this.freeVariantName,
    this.freeVariantId,
    this.freeProductVarianttype,
    this.freeProductId,
    this.images,
    this.schemeDetails,
  });

  int schemeId;
  int masterProductVariantId;
  int masterProductVariantQtyCases;
  int masterProductVariantQtyUnits;
  int masterProductVariantTotalQty;
  int freeProductVaritantId;
  int freeProductVariantQtyCases;
  int freeProductVariantQtyUnits;
  int freeMasterQty;
  int masterProductVariantDiscount;
  String masterVariantName;
  dynamic freeVariantName;
  dynamic freeVariantId;
  dynamic freeProductVarianttype;
  dynamic freeProductId;
  List<dynamic> images;
  List<SchemeDetail> schemeDetails;

  factory SchemesOnProducts.fromJson(Map<String, dynamic> json) =>
      SchemesOnProducts(
        schemeId: json["scheme_id"],
        masterProductVariantId: json["master_product_variant_id"],
        masterProductVariantQtyCases: json["master_product_variant_qty_cases"],
        masterProductVariantQtyUnits: json["master_product_variant_qty_units"],
        masterProductVariantTotalQty: json["master_product_variant_total_qty"],
        freeProductVaritantId: json["free_product_varitant_id"],
        freeProductVariantQtyCases: json["free_product_variant_qty_cases"],
        freeProductVariantQtyUnits: json["free_product_variant_qty_units"],
        freeMasterQty: json["free_master_qty"],
        masterProductVariantDiscount: json["master_product_variant_discount"],
        masterVariantName: json["master_variant_name"],
        freeVariantName: json["free_variant_name"]==null?"":json["free_variant_name"],
        freeVariantId: json["free_variant_id"]==null?"":json["free_variant_id"],
        freeProductVarianttype: json["freeProduct_varianttype"]==null?"":json["freeProduct_varianttype"],
        freeProductId: json["free_product_id"],
        images:json["images"]==null?[]: List<dynamic>.from(json["images"].map((x) => x)),
        schemeDetails: List<SchemeDetail>.from(
            json["scheme_details"].map((x) => SchemeDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "scheme_id": schemeId,
        "master_product_variant_id": masterProductVariantId,
        "master_product_variant_qty_cases": masterProductVariantQtyCases,
        "master_product_variant_qty_units": masterProductVariantQtyUnits,
        "master_product_variant_total_qty": masterProductVariantTotalQty,
        "free_product_varitant_id": freeProductVaritantId,
        "free_product_variant_qty_cases": freeProductVariantQtyCases,
        "free_product_variant_qty_units": freeProductVariantQtyUnits,
        "free_master_qty": freeMasterQty,
        "master_product_variant_discount": masterProductVariantDiscount,
        "master_variant_name": masterVariantName,
        "free_variant_name": freeVariantName,
        "free_variant_id": freeVariantId,
        "freeProduct_varianttype": freeProductVarianttype,
        "free_product_id": freeProductId,
        "images": List<dynamic>.from(images.map((x) => x)),
        "scheme_details":
            List<dynamic>.from(schemeDetails.map((x) => x.toJson())),
      };
}

class SchemeDetail {
  SchemeDetail({
    this.id,
    this.compId,
    this.name,
    this.schemeType,
    this.startDate,
    this.endDate,
    this.schemeOfferProductQty,
    this.schemeOfferOrderAmount,
    this.schemePercentageOff,
    this.status,
    this.description,
    this.customersAllowed,
    this.suppliersAllowed,
    this.addBy,
    this.mdfBy,
    this.createdAt,
    this.updatedAt,
    this.schemeId,
    this.masterProductVariantId,
    this.masterProductVariantQtyMax,
    this.masterProductVariantQtyCases,
    this.masterProductVariantQtyUnits,
    this.masterProductVariantTotalQty,
    this.freeProductVaritantId,
    this.freeProductVariantQtyCases,
    this.freeProductVariantQtyUnits,
    this.freeMasterQty,
    this.masterProductVariantDiscount,
    this.masterProductVariantName,
    this.freeProductVaritantName,
  });

  int id;
  int compId;
  String name;
  int schemeType;
  DateTime startDate;
  DateTime endDate;
  int schemeOfferProductQty;
  int schemeOfferOrderAmount;
  int schemePercentageOff;
  String status;
  dynamic description;
  String customersAllowed;
  String suppliersAllowed;
  int addBy;
  dynamic mdfBy;
  DateTime createdAt;
  dynamic updatedAt;
  int schemeId;
  int masterProductVariantId;
  int masterProductVariantQtyMax;
  int masterProductVariantQtyCases;
  int masterProductVariantQtyUnits;
  int masterProductVariantTotalQty;
  int freeProductVaritantId;
  int freeProductVariantQtyCases;
  int freeProductVariantQtyUnits;
  int freeMasterQty;
  int masterProductVariantDiscount;
  String masterProductVariantName;
  dynamic freeProductVaritantName;

  factory SchemeDetail.fromJson(Map<String, dynamic> json) => SchemeDetail(
        id: json["id"],
        compId: json["comp_id"],
        name: json["name"],
        schemeType: json["scheme_type"],
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
        schemeOfferProductQty: json["scheme_offer_productQty"],
        schemeOfferOrderAmount: json["scheme_offer_orderAmount"],
        schemePercentageOff: json["scheme_percentage_off"],
        status: json["status"],
        description: json["description"],
        customersAllowed: json["customers_allowed"],
        suppliersAllowed: json["suppliers_allowed"],
        addBy: json["add_by"],
        mdfBy: json["mdf_by"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"],
        schemeId: json["scheme_id"],
        masterProductVariantId: json["master_product_variant_id"],
        masterProductVariantQtyMax: json["master_product_variant_qty_max"],
        masterProductVariantQtyCases: json["master_product_variant_qty_cases"],
        masterProductVariantQtyUnits: json["master_product_variant_qty_units"],
        masterProductVariantTotalQty: json["master_product_variant_total_qty"],
        freeProductVaritantId: json["free_product_varitant_id"],
        freeProductVariantQtyCases: json["free_product_variant_qty_cases"],
        freeProductVariantQtyUnits: json["free_product_variant_qty_units"],
        freeMasterQty: json["free_master_qty"],
        masterProductVariantDiscount: json["master_product_variant_discount"],
        masterProductVariantName: json["master_product_variant_name"],
        freeProductVaritantName: json["free_product_varitant_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "comp_id": compId,
        "name": name,
        "scheme_type": schemeType,
        "start_date": startDate.toIso8601String(),
        "end_date": endDate.toIso8601String(),
        "scheme_offer_productQty": schemeOfferProductQty,
        "scheme_offer_orderAmount": schemeOfferOrderAmount,
        "scheme_percentage_off": schemePercentageOff,
        "status": status,
        "description": description,
        "customers_allowed": customersAllowed,
        "suppliers_allowed": suppliersAllowed,
        "add_by": addBy,
        "mdf_by": mdfBy,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt,
        "scheme_id": schemeId,
        "master_product_variant_id": masterProductVariantId,
        "master_product_variant_qty_max": masterProductVariantQtyMax,
        "master_product_variant_qty_cases": masterProductVariantQtyCases,
        "master_product_variant_qty_units": masterProductVariantQtyUnits,
        "master_product_variant_total_qty": masterProductVariantTotalQty,
        "free_product_varitant_id": freeProductVaritantId,
        "free_product_variant_qty_cases": freeProductVariantQtyCases,
        "free_product_variant_qty_units": freeProductVariantQtyUnits,
        "free_master_qty": freeMasterQty,
        "master_product_variant_discount": masterProductVariantDiscount,
        "master_product_variant_name": masterProductVariantName,
        "free_product_varitant_name": freeProductVaritantName,
      };
}
