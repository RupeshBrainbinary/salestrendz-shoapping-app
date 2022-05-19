// To parse this JSON data, do
//
//     final bankListModel = bankListModelFromJson(jsonString);

import 'dart:convert';

BankListModel bankListModelFromJson(String str) =>
    BankListModel.fromJson(json.decode(str));

String bankListModelToJson(BankListModel data) => json.encode(data.toJson());

class BankListModel {
  BankListModel({
    this.stauts,
    this.inwardBanklist,
    this.outwardBanklist,
  });

  bool stauts;
  List<dynamic> inwardBanklist;
  List<OutwardBanklist> outwardBanklist;

  factory BankListModel.fromJson(Map<String, dynamic> json) => BankListModel(
        stauts: json["stauts"],
        inwardBanklist:
            List<dynamic>.from(json["inward_banklist"].map((x) => x)),
        outwardBanklist: List<OutwardBanklist>.from(
            json["outward_banklist"].map((x) => OutwardBanklist.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "stauts": stauts,
        "inward_banklist": List<dynamic>.from(inwardBanklist.map((x) => x)),
        "outward_banklist":
            List<dynamic>.from(outwardBanklist.map((x) => x.toJson())),
      };
}

class OutwardBanklist {
  OutwardBanklist({
    this.bankId,
    this.compId,
    this.orgId,
    this.bankName,
    this.accountNumber,
    this.loggedInUserid,
  });

  int bankId;
  int compId;
  int orgId;
  String bankName;
  int accountNumber;
  int loggedInUserid;

  factory OutwardBanklist.fromJson(Map<String, dynamic> json) =>
      OutwardBanklist(
        bankId: json["bank_id"],
        compId: json["comp_id"],
        orgId: json["org_id"],
        bankName: json["bank_name"],
        accountNumber: json["account_number"],
        loggedInUserid: json["logged_in_userid"],
      );

  Map<String, dynamic> toJson() => {
        "bank_id": bankId,
        "comp_id": compId,
        "org_id": orgId,
        "bank_name": bankName,
        "account_number": accountNumber,
        "logged_in_userid": loggedInUserid,
      };
}
