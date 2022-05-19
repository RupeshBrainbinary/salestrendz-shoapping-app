// To parse this JSON data, do
//
//     final supplierViewModel = supplierViewModelFromJson(jsonString);

import 'dart:convert';

SupplierViewModel supplierViewModelFromJson(String str) =>
    SupplierViewModel.fromJson(json.decode(str));

String supplierViewModelToJson(SupplierViewModel data) =>
    json.encode(data.toJson());

class SupplierViewModel {
  SupplierViewModel({
    this.status,
    this.supplierLists,
    this.totalrow,
    this.totalPages,
  });

  final bool status;
  final List<SupplierList> supplierLists;
  final int totalrow;
  final int totalPages;

  factory SupplierViewModel.fromJson(Map<String, dynamic> json) =>
      SupplierViewModel(
        status: json["status"] == null ? null : json["status"],
        supplierLists: json["supplier_lists"] == null
            ? null
            : List<SupplierList>.from(
                json["supplier_lists"].map((x) => SupplierList.fromJson(x))),
        totalrow: json["totalrow"] == null ? null : json["totalrow"],
        totalPages: json["total_pages"] == null ? null : json["total_pages"],
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "supplier_lists": supplierLists == null
            ? null
            : List<dynamic>.from(supplierLists.map((x) => x.toJson())),
        "totalrow": totalrow == null ? null : totalrow,
        "total_pages": totalPages == null ? null : totalPages,
      };
}

class SupplierList {
  SupplierList({
    this.supId,
    this.supName,
    this.gstApply,
    this.accountType,
    this.supplierAddress,
    this.contactPerson,
    this.phoneNumber,
    this.emailAddress,
    this.website,
  });

  final int supId;
  final String supName;
  final GstApply gstApply;
  final AccountType accountType;
  final String supplierAddress;
  final String contactPerson;
  final String phoneNumber;
  final String emailAddress;
  final String website;

  factory SupplierList.fromJson(Map<String, dynamic> json) => SupplierList(
        supId: json["sup_id"] == null ? null : json["sup_id"],
        supName: json["sup_name"] == null ? null : json["sup_name"],
        gstApply: json["gst_apply"] == null
            ? null
            : gstApplyValues.map[json["gst_apply"]],
        accountType: json["account_type"] == null
            ? null
            : accountTypeValues.map[json["account_type"]],
        supplierAddress:
            json["supplier_address"] == null ? null : json["supplier_address"],
        contactPerson:
            json["contact_person"] == null ? null : json["contact_person"],
        phoneNumber: json["phone_number"] == null ? null : json["phone_number"],
        emailAddress:
            json["email_address"] == null ? null : json["email_address"],
        website: json["website"] == null ? null : json["website"],
      );

  Map<String, dynamic> toJson() => {
        "sup_id": supId == null ? null : supId,
        "sup_name": supName == null ? null : supName,
        "gst_apply": gstApply == null ? null : gstApplyValues.reverse[gstApply],
        "account_type":
            accountType == null ? null : accountTypeValues.reverse[accountType],
        "supplier_address": supplierAddress == null ? null : supplierAddress,
        "contact_person": contactPerson == null ? null : contactPerson,
        "phone_number": phoneNumber == null ? null : phoneNumber,
        "email_address": emailAddress == null ? null : emailAddress,
        "website": website == null ? null : website,
      };
}

enum AccountType { ACCOUNT }

final accountTypeValues = EnumValues({"account": AccountType.ACCOUNT});

enum GstApply { IGST, GST }

final gstApplyValues = EnumValues({"GST": GstApply.GST, "IGST": GstApply.IGST});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
