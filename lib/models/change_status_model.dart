// To parse this JSON data, do
//
//     final changeStatusModel = changeStatusModelFromJson(jsonString);
import 'dart:convert';

ChangeStatusModel changeStatusModelFromJson(String str) =>
    ChangeStatusModel.fromJson(json.decode(str));

String changeStatusModelToJson(ChangeStatusModel data) =>
    json.encode(data.toJson());

class ChangeStatusModel {
  ChangeStatusModel({
    this.status,
    this.message,
  });

  bool status;
  String message;

  factory ChangeStatusModel.fromJson(Map<String, dynamic> json) =>
      ChangeStatusModel(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
