// To parse this JSON data, do
//
//     final collectionSubmitModel = collectionSubmitModelFromJson(jsonString);

import 'dart:convert';

CollectionSubmitModel collectionSubmitModelFromJson(String str) =>
    CollectionSubmitModel.fromJson(json.decode(str));

String collectionSubmitModelToJson(CollectionSubmitModel data) =>
    json.encode(data.toJson());

class CollectionSubmitModel {
  CollectionSubmitModel({
    this.status,
    this.message,
  });

  bool status;
  String message;

  factory CollectionSubmitModel.fromJson(Map<String, dynamic> json) =>
      CollectionSubmitModel(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
