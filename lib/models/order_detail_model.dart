// To parse this JSON data, do
//
//     final orderDetailViewModel = orderDetailViewModelFromJson(jsonString);

import 'dart:convert';

OrderDetailViewModel orderDetailViewModelFromJson(String str) =>
    OrderDetailViewModel.fromJson(json.decode(str));

String orderDetailViewModelToJson(OrderDetailViewModel data) =>
    json.encode(data.toJson());

class OrderDetailViewModel {
  OrderDetailViewModel({
    this.status,
    this.orderDetails,
  });

  bool status;
  OrderDetails orderDetails;

  factory OrderDetailViewModel.fromJson(Map<String, dynamic> json) =>
      OrderDetailViewModel(
        status: json["status"],
        orderDetails: OrderDetails.fromJson(json["order_details"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "order_details": orderDetails.toJson(),
      };
}

class OrderDetails {
  OrderDetails({
    this.ordId,
    this.compId,
    this.custId,
    this.supId,
    this.supAssigned,
    this.userId,
    this.amount,
    this.totalgstAmount,
    this.shippingCharge,
    this.handlingCharge,
    this.totalHandlingCharge,
    this.handlingChargeType,
    this.beforeDiscountAmount,
    this.beforeGstAdditionAmount,
    this.totalAmountSaved,
    this.comments,
    this.deliveryAddress,
    this.status,
    this.orderStatus,
    this.createdAt,
    this.compOrdId,
    this.retailerType,
    this.discountType,
    this.discountPecentage,
    this.discountValue,
    this.generalDiscountAmount,
    this.schemeDiscountType,
    this.schemeDiscountValue,
    this.schemeDiscountPercentage,
    this.schemeDiscountAmount,
    this.custSupDiscountType,
    this.custSupDiscountPercentage,
    this.custSupDiscountValue,
    this.custSupDiscountAmount,
    this.retailerAddress,
    this.orderProducts,
    this.orderedCustomerName,
    this.orderedCustomerEmail,
    this.orderedCustomerPhoneNumber,
    this.retailerName,
    this.retailerEmail,
    this.retailerPhoneNumber,
  });

  int ordId;
  int compId;
  int custId;
  int supId;
  int supAssigned;
  int userId;
  int amount;
  int totalgstAmount;
  dynamic shippingCharge;
  dynamic handlingCharge;
  dynamic totalHandlingCharge;
  dynamic handlingChargeType;
  int beforeDiscountAmount;
  int beforeGstAdditionAmount;
  dynamic totalAmountSaved;
  dynamic comments;
  String deliveryAddress;
  String status;
  String orderStatus;
  String createdAt;
  int compOrdId;
  String retailerType;
  dynamic discountType;
  int discountPecentage;
  int discountValue;
  dynamic generalDiscountAmount;
  dynamic schemeDiscountType;
  int schemeDiscountValue;
  int schemeDiscountPercentage;
  dynamic schemeDiscountAmount;
  dynamic custSupDiscountType;
  int custSupDiscountPercentage;
  int custSupDiscountValue;
  dynamic custSupDiscountAmount;
  String retailerAddress;
  List<OrderProduct> orderProducts;
  String orderedCustomerName;
  String orderedCustomerEmail;
  String orderedCustomerPhoneNumber;
  String retailerName;
  String retailerEmail;
  String retailerPhoneNumber;

  factory OrderDetails.fromJson(Map<String, dynamic> json) => OrderDetails(
        ordId: json["ord_id"],
        compId: json["comp_id"],
        custId: json["cust_id"],
        supId: json["sup_id"],
        supAssigned: json["sup_assigned"],
        userId: json["user_id"],
        amount: json["amount"],
        totalgstAmount: json["totalgst_amount"],
        shippingCharge: json["shipping_charge"],
        handlingCharge: json["handling_charge"],
        totalHandlingCharge: json["total_handling_charge"],
        handlingChargeType: json["handling_charge_type"],
        beforeDiscountAmount: json["before_discount_amount"],
        beforeGstAdditionAmount: json["before_gst_addition_amount"],
        totalAmountSaved: json["total_amount_saved"],
        comments: json["comments"],
        deliveryAddress: json["delivery_address"],
        status: json["status"],
        orderStatus: json["order_status"],
        createdAt: json["created_at"],
        compOrdId: json["comp_ord_id"],
        retailerType: json["retailer_type"],
        discountType: json["discount_type"],
        discountPecentage: json["discount_pecentage"],
        discountValue: json["discount_value"],
        generalDiscountAmount: json["general_discount_amount"],
        schemeDiscountType: json["scheme_discount_type"],
        schemeDiscountValue: json["scheme_discount_value"],
        schemeDiscountPercentage: json["scheme_discount_percentage"],
        schemeDiscountAmount: json["scheme_discount_amount"],
        custSupDiscountType: json["cust_sup_discount_type"],
        custSupDiscountPercentage: json["cust_sup_discount_percentage"],
        custSupDiscountValue: json["cust_sup_discount_value"],
        custSupDiscountAmount: json["cust_sup_discount_amount"],
        retailerAddress: json["retailer_address"],
        orderProducts: List<OrderProduct>.from(
            json["order_products"].map((x) => OrderProduct.fromJson(x))),
        orderedCustomerName: json["ordered_customer_name"],
        orderedCustomerEmail: json["ordered_customer_email"],
        orderedCustomerPhoneNumber: json["ordered_customer_phoneNumber"],
        retailerName: json["retailer_name"],
        retailerEmail: json["retailer_email"],
        retailerPhoneNumber: json["retailer_phoneNumber"],
      );

  Map<String, dynamic> toJson() => {
        "ord_id": ordId,
        "comp_id": compId,
        "cust_id": custId,
        "sup_id": supId,
        "sup_assigned": supAssigned,
        "user_id": userId,
        "amount": amount,
        "totalgst_amount": totalgstAmount,
        "shipping_charge": shippingCharge,
        "handling_charge": handlingCharge,
        "total_handling_charge": totalHandlingCharge,
        "handling_charge_type": handlingChargeType,
        "before_discount_amount": beforeDiscountAmount,
        "before_gst_addition_amount": beforeGstAdditionAmount,
        "total_amount_saved": totalAmountSaved,
        "comments": comments,
        "delivery_address": deliveryAddress,
        "status": status,
        "order_status": orderStatus,
        "created_at": createdAt,
        "comp_ord_id": compOrdId,
        "retailer_type": retailerType,
        "discount_type": discountType,
        "discount_pecentage": discountPecentage,
        "discount_value": discountValue,
        "general_discount_amount": generalDiscountAmount,
        "scheme_discount_type": schemeDiscountType,
        "scheme_discount_value": schemeDiscountValue,
        "scheme_discount_percentage": schemeDiscountPercentage,
        "scheme_discount_amount": schemeDiscountAmount,
        "cust_sup_discount_type": custSupDiscountType,
        "cust_sup_discount_percentage": custSupDiscountPercentage,
        "cust_sup_discount_value": custSupDiscountValue,
        "cust_sup_discount_amount": custSupDiscountAmount,
        "retailer_address": retailerAddress,
        "order_products":
            List<dynamic>.from(orderProducts.map((x) => x.toJson())),
        "ordered_customer_name": orderedCustomerName,
        "ordered_customer_email": orderedCustomerEmail,
        "ordered_customer_phoneNumber": orderedCustomerPhoneNumber,
        "retailer_name": retailerName,
        "retailer_email": retailerEmail,
        "retailer_phoneNumber": retailerPhoneNumber,
      };
}

class OrderProduct {
  OrderProduct({
    this.ordMetadataId,
    this.ordId,
    this.productVariantId,
    this.qty,
    this.prodPrice,
    this.productTotal,
    this.discountedAmount,
    this.prodMrp,
    this.savedInPercentage,
    this.savedInAmount,
    this.casesQty,
    this.unit,
    this.prodGst,
    this.cgst,
    this.sgst,
    this.prodDiscountType,
    this.prodDiscountValue,
    this.prodDiscountPercentage,
    this.prodDiscountAmount,
    this.productIgstprice,
    this.productCgstprice,
    this.productSgstprice,
    this.hsn,
    this.productVariantName,
  });

  int ordMetadataId;
  int ordId;
  int productVariantId;
  int qty;
  int prodPrice;
  int productTotal;
  int discountedAmount;
  int prodMrp;
  int savedInPercentage;
  int savedInAmount;
  int casesQty;
  int unit;
  int prodGst;
  double cgst;
  double sgst;
  dynamic prodDiscountType;
  dynamic prodDiscountValue;
  dynamic prodDiscountPercentage;
  dynamic prodDiscountAmount;
  int productIgstprice;
  double productCgstprice;
  double productSgstprice;
  String hsn;
  String productVariantName;

  factory OrderProduct.fromJson(Map<String, dynamic> json) => OrderProduct(
        ordMetadataId: json["ord_metadata_id"],
        ordId: json["ord_id"],
        productVariantId: json["product_variant_id"],
        qty: json["qty"],
        prodPrice: json["prod_price"],
        productTotal: json["product_total"],
        discountedAmount: json["discounted_amount"],
        prodMrp: json["prod_mrp"],
        savedInPercentage: json["saved_in_percentage"],
        savedInAmount: json["saved_in_amount"],
        casesQty: json["cases_qty"],
        unit: json["unit"],
        prodGst: json["prod_gst"],
        cgst: json["cgst"].toDouble(),
        sgst: json["sgst"].toDouble(),
        prodDiscountType: json["prod_discount_type"],
        prodDiscountValue: json["prod_discount_value"],
        prodDiscountPercentage: json["prod_discount_percentage"],
        prodDiscountAmount: json["prod_discount_amount"],
        productIgstprice: json["product_igstprice"],
        productCgstprice: json["product_cgstprice"].toDouble(),
        productSgstprice: json["product_sgstprice"].toDouble(),
        hsn: json["hsn"],
        productVariantName: json["product_variant_name"],
      );

  Map<String, dynamic> toJson() => {
        "ord_metadata_id": ordMetadataId,
        "ord_id": ordId,
        "product_variant_id": productVariantId,
        "qty": qty,
        "prod_price": prodPrice,
        "product_total": productTotal,
        "discounted_amount": discountedAmount,
        "prod_mrp": prodMrp,
        "saved_in_percentage": savedInPercentage,
        "saved_in_amount": savedInAmount,
        "cases_qty": casesQty,
        "unit": unit,
        "prod_gst": prodGst,
        "cgst": cgst,
        "sgst": sgst,
        "prod_discount_type": prodDiscountType,
        "prod_discount_value": prodDiscountValue,
        "prod_discount_percentage": prodDiscountPercentage,
        "prod_discount_amount": prodDiscountAmount,
        "product_igstprice": productIgstprice,
        "product_cgstprice": productCgstprice,
        "product_sgstprice": productSgstprice,
        "hsn": hsn,
        "product_variant_name": productVariantName,
      };
}
