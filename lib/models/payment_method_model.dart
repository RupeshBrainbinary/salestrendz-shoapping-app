// To parse this JSON data, do
//
//     final paymentMethodModel = paymentMethodModelFromJson(jsonString);

import 'dart:convert';

PaymentMethodModel paymentMethodModelFromJson(String str) =>
    PaymentMethodModel.fromJson(json.decode(str));

String paymentMethodModelToJson(PaymentMethodModel data) =>
    json.encode(data.toJson());

class PaymentMethodModel {
  PaymentMethodModel({
    this.stauts,
    this.inwardPaymentMethod,
    this.outwardPaymentMethod,
  });

  bool stauts;
  List<dynamic> inwardPaymentMethod;
  List<OutwardPaymentMethod> outwardPaymentMethod;

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) =>
      PaymentMethodModel(
        stauts: json["stauts"],
        inwardPaymentMethod:
            List<dynamic>.from(json["inward_payment_method"].map((x) => x)),
        outwardPaymentMethod: List<OutwardPaymentMethod>.from(
            json["outward_payment_method"]
                .map((x) => OutwardPaymentMethod.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "stauts": stauts,
        "inward_payment_method":
            List<dynamic>.from(inwardPaymentMethod.map((x) => x)),
        "outward_payment_method":
            List<dynamic>.from(outwardPaymentMethod.map((x) => x.toJson())),
      };
}

class OutwardPaymentMethod {
  OutwardPaymentMethod({
    this.paymentModeTypeId,
    this.paymentModeTypeName,
    this.loggedInUserid,
    this.orgId,
    this.compId,
  });

  int paymentModeTypeId;
  String paymentModeTypeName;
  int loggedInUserid;
  int orgId;
  int compId;

  factory OutwardPaymentMethod.fromJson(Map<String, dynamic> json) =>
      OutwardPaymentMethod(
        paymentModeTypeId: json["payment_mode_type_id"],
        paymentModeTypeName: json["payment_mode_type_name"],
        loggedInUserid: json["logged_in_userid"],
        orgId: json["org_id"],
        compId: json["comp_id"],
      );

  Map<String, dynamic> toJson() => {
        "payment_mode_type_id": paymentModeTypeId,
        "payment_mode_type_name": paymentModeTypeName,
        "logged_in_userid": loggedInUserid,
        "org_id": orgId,
        "comp_id": compId,
      };
}
