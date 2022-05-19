// To parse this JSON data, do
//
//     final supllierModel = supllierModelFromJson(jsonString);

import 'dart:convert';

SupllierModel supllierModelFromJson(String str) =>
    SupllierModel.fromJson(json.decode(str));

String supllierModelToJson(SupllierModel data) => json.encode(data.toJson());

class SupllierModel {
  SupllierModel({
    this.status,
    this.companySupplier,
  });

  bool status;
  List<CompanySupplier> companySupplier;

  factory SupllierModel.fromJson(Map<String, dynamic> json) => SupllierModel(
        status: json["status"],
        companySupplier: List<CompanySupplier>.from(
            json["company_supplier"].map((x) => CompanySupplier.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "company_supplier":
            List<dynamic>.from(companySupplier.map((x) => x.toJson())),
      };
}

class CompanySupplier {
  CompanySupplier({
    this.supId,
    this.supName,
    this.supTypeId,
    this.supStatus,
    this.compId,
    this.supTypeName,
    this.invoiceDetail,
    this.totalUnpaidAmount,
    this.unpaidInvoicesCount,
  });

  int supId;
  String supName;
  int supTypeId;
  String supStatus;
  int compId;
  String supTypeName;
  List<dynamic> invoiceDetail;
  int totalUnpaidAmount;
  int unpaidInvoicesCount;

  factory CompanySupplier.fromJson(Map<String, dynamic> json) =>
      CompanySupplier(
        supId: json["sup_id"],
        supName: json["sup_name"],
        supTypeId: json["sup_type_id"],
        supStatus: json["sup_status"],
        compId: json["comp_id"],
        supTypeName: json["sup_type_name"],
        invoiceDetail: List<dynamic>.from(json["invoice_detail"].map((x) => x)),
        totalUnpaidAmount: json["total_unpaid_amount"],
        unpaidInvoicesCount: json["unpaid_invoices_count"],
      );

  Map<String, dynamic> toJson() => {
        "sup_id": supId,
        "sup_name": supName,
        "sup_type_id": supTypeId,
        "sup_status": supStatus,
        "comp_id": compId,
        "sup_type_name": supTypeName,
        "invoice_detail": List<dynamic>.from(invoiceDetail.map((x) => x)),
        "total_unpaid_amount": totalUnpaidAmount,
        "unpaid_invoices_count": unpaidInvoicesCount,
      };
}
