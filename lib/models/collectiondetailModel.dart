// To parse this JSON data, do
//
//     final collectionDetailModel = collectionDetailModelFromJson(jsonString);

import 'dart:convert';

CollectionDetailModel collectionDetailModelFromJson(String str) =>
    CollectionDetailModel.fromJson(json.decode(str));

String collectionDetailModelToJson(CollectionDetailModel data) =>
    json.encode(data.toJson());

class CollectionDetailModel {
  CollectionDetailModel({
    this.status,
    this.collectionDetails,
    this.invoiceDetails,
    this.uploads,
    this.createdHistory,
    this.updatedHistory,
  });

  bool status;
  List<CollectionDetail> collectionDetails;
  List<InvoiceDetail> invoiceDetails;
  List<dynamic> uploads;
  List<CreatedHistory> createdHistory;
  List<dynamic> updatedHistory;

  factory CollectionDetailModel.fromJson(Map<String, dynamic> json) =>
      CollectionDetailModel(
        status: json["status"],
        collectionDetails: List<CollectionDetail>.from(
            json["Collection_Details"]
                .map((x) => CollectionDetail.fromJson(x))),
        invoiceDetails: List<InvoiceDetail>.from(
            json["invoice_details"].map((x) => InvoiceDetail.fromJson(x))),
        uploads: List<dynamic>.from(json["Uploads"].map((x) => x)),
        createdHistory: List<CreatedHistory>.from(
            json["created_History"].map((x) => CreatedHistory.fromJson(x))),
        updatedHistory:
            List<dynamic>.from(json["updated_history"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "Collection_Details":
            List<dynamic>.from(collectionDetails.map((x) => x.toJson())),
        "invoice_details":
            List<dynamic>.from(invoiceDetails.map((x) => x.toJson())),
        "Uploads": List<dynamic>.from(uploads.map((x) => x)),
        "created_History":
            List<dynamic>.from(createdHistory.map((x) => x.toJson())),
        "updated_history": List<dynamic>.from(updatedHistory.map((x) => x)),
      };
}

class CollectionDetail {
  CollectionDetail({
    this.collectionId,
    this.compInvoiceId,
    this.date,
    this.collDate,
    this.custSupId,
    this.custSupType,
    this.accountName,
    this.supId,
    this.supName,
    this.onAccount,
    this.paymentModeTypeId,
    this.paymentModeTypeName,
    this.collPaymentText,
    this.collRecieptNo,
    this.collAmount,
    this.thirdPartyId,
    this.thirdParty,
    this.bankId,
    this.bankName,
  });

  int collectionId;
  dynamic compInvoiceId;
  DateTime date;
  DateTime collDate;
  int custSupId;
  String custSupType;
  String accountName;
  int supId;
  String supName;
  int onAccount;
  int paymentModeTypeId;
  String paymentModeTypeName;
  String collPaymentText;
  dynamic collRecieptNo;
  int collAmount;
  dynamic thirdPartyId;
  dynamic thirdParty;
  int bankId;
  String bankName;

  factory CollectionDetail.fromJson(Map<String, dynamic> json) =>
      CollectionDetail(
        collectionId: json["collection_id"],
        compInvoiceId: json["comp_invoice_id"],
        date: DateTime.parse(json["date"]),
        collDate: DateTime.parse(json["coll_date"]),
        custSupId: json["cust_sup_id"],
        custSupType: json["cust_sup_type"],
        accountName: json["Account_name"],
        supId: json["sup_id"],
        supName: json["sup_name"],
        onAccount: json["on_account"],
        paymentModeTypeId: json["payment_mode_type_id"],
        paymentModeTypeName: json["payment_mode_type_name"],
        collPaymentText: json["coll_payment_text"],
        collRecieptNo: json["coll_reciept_no"],
        collAmount: json["coll_amount"],
        thirdPartyId: json["third_party_id"],
        thirdParty: json["third_party"],
        bankId: json["bank_id"],
        bankName: json["bank_name"],
      );

  Map<String, dynamic> toJson() => {
        "collection_id": collectionId,
        "comp_invoice_id": compInvoiceId,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "coll_date": collDate.toIso8601String(),
        "cust_sup_id": custSupId,
        "cust_sup_type": custSupType,
        "Account_name": accountName,
        "sup_id": supId,
        "sup_name": supName,
        "on_account": onAccount,
        "payment_mode_type_id": paymentModeTypeId,
        "payment_mode_type_name": paymentModeTypeName,
        "coll_payment_text": collPaymentText,
        "coll_reciept_no": collRecieptNo,
        "coll_amount": collAmount,
        "third_party_id": thirdPartyId,
        "third_party": thirdParty,
        "bank_id": bankId,
        "bank_name": bankName,
      };
}

class CreatedHistory {
  CreatedHistory({
    this.userId,
    this.userName,
    this.createdAt,
  });

  int userId;
  String userName;
  DateTime createdAt;

  factory CreatedHistory.fromJson(Map<String, dynamic> json) => CreatedHistory(
        userId: json["user_id"],
        userName: json["user_name"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "user_name": userName,
        "created_at": createdAt.toIso8601String(),
      };
}

class InvoiceDetail {
  InvoiceDetail({
    this.collectionId,
    this.invoiceId,
    this.compCollId,
    this.compInvoiceId,
    this.collectedAmount,
    this.pendingAmount,
    this.totalAmount,
    this.createdAt,
    this.updatedAt,
  });

  int collectionId;
  int invoiceId;
  int compCollId;
  dynamic compInvoiceId;
  int collectedAmount;
  int pendingAmount;
  int totalAmount;
  DateTime createdAt;
  dynamic updatedAt;

  factory InvoiceDetail.fromJson(Map<String, dynamic> json) => InvoiceDetail(
        collectionId: json["collection_id"],
        invoiceId: json["invoice_id"],
        compCollId: json["comp_coll_id"],
        compInvoiceId: json["comp_invoice_id"],
        collectedAmount: json["collected_amount"],
        pendingAmount: json["pending_amount"],
        totalAmount: json["total_amount"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "collection_id": collectionId,
        "invoice_id": invoiceId,
        "comp_coll_id": compCollId,
        "comp_invoice_id": compInvoiceId,
        "collected_amount": collectedAmount,
        "pending_amount": pendingAmount,
        "total_amount": totalAmount,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt,
      };
}
