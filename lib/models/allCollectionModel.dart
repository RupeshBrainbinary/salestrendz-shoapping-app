// To parse this JSON data, do
//
//     final allCollectionsModel = allCollectionsModelFromJson(jsonString);

import 'dart:convert';

AllCollectionsModel allCollectionsModelFromJson(String str) =>
    AllCollectionsModel.fromJson(json.decode(str));

String allCollectionsModelToJson(AllCollectionsModel data) =>
    json.encode(data.toJson());

class AllCollectionsModel {
  AllCollectionsModel({
    this.status,
    this.collection,
    this.totalPendingAmount,
  });

  bool status;
  Collection collection;
  int totalPendingAmount;

  factory AllCollectionsModel.fromJson(Map<String, dynamic> json) =>
      AllCollectionsModel(
        status: json["status"],
        collection: Collection.fromJson(json["Collection"]),
        totalPendingAmount: json["Total_pending_amount"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "Collection": collection.toJson(),
        "Total_pending_amount": totalPendingAmount,
      };
}

class Collection {
  Collection({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  int currentPage;
  List<Datum> data;
  String firstPageUrl;
  int from;
  int lastPage;
  String lastPageUrl;
  dynamic nextPageUrl;
  String path;
  int perPage;
  dynamic prevPageUrl;
  int to;
  int total;

  factory Collection.fromJson(Map<String, dynamic> json) => Collection(
        currentPage: json["current_page"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
      };
}

class Datum {
  Datum({
    this.compCollId,
    this.collectionId,
    this.date,
    this.time,
    this.collectionStatus,
    this.custSupId,
    this.custSupName,
    this.typeName,
    this.collectionPaidToSupid,
    this.collectionPaidTo,
    this.userId,
    this.collectionBy,
    this.imageUrl,
    this.paymentModeTypeId,
    this.paymentModeTypeName,
    this.collAmount,
    this.thirdParty,
    this.deleted,
    this.invoiceIds,
    this.compInvoiceIds,
    this.amount,
  });

  int compCollId;
  int collectionId;
  String date;
  String time;
  String collectionStatus;
  int custSupId;
  String custSupName;
  String typeName;
  int collectionPaidToSupid;
  String collectionPaidTo;
  int userId;
  String collectionBy;
  dynamic imageUrl;
  int paymentModeTypeId;
  String paymentModeTypeName;
  int collAmount;
  dynamic thirdParty;
  String deleted;
  String invoiceIds;
  String compInvoiceIds;
  int amount;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        compCollId: json["comp_coll_id"],
        collectionId: json["collection_id"],
        date: json["date"],
        time: json["time"],
        collectionStatus: json["collection_status"],
        custSupId: json["cust_sup_id"],
        custSupName: json["cust_sup_name"],
        typeName: json["type_name"],
        collectionPaidToSupid: json["collection_paid_to_supid"],
        collectionPaidTo: json["collection_paid_to"],
        userId: json["user_id"],
        collectionBy: json["collection_by"],
        imageUrl: json["image_url"],
        paymentModeTypeId: json["payment_mode_type_id"],
        paymentModeTypeName: json["payment_mode_type_name"],
        collAmount: json["coll_amount"],
        thirdParty: json["third_party"],
        deleted: json["deleted"],
        invoiceIds: json["invoice_ids"],
        compInvoiceIds: json["comp_invoice_ids"],
        amount: json["amount"],
      );

  Map<String, dynamic> toJson() => {
        "comp_coll_id": compCollId,
        "collection_id": collectionId,
        "date": date,
        "time": time,
        "collection_status": collectionStatus,
        "cust_sup_id": custSupId,
        "cust_sup_name": custSupName,
        "type_name": typeName,
        "collection_paid_to_supid": collectionPaidToSupid,
        "collection_paid_to": collectionPaidTo,
        "user_id": userId,
        "collection_by": collectionBy,
        "image_url": imageUrl,
        "payment_mode_type_id": paymentModeTypeId,
        "payment_mode_type_name": paymentModeTypeName,
        "coll_amount": collAmount,
        "third_party": thirdParty,
        "deleted": deleted,
        "invoice_ids": invoiceIds,
        "comp_invoice_ids": compInvoiceIds,
        "amount": amount,
      };
}
