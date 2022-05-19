// To parse this JSON data, do
//
//     final checkUpdateModel = checkUpdateModelFromJson(jsonString);

import 'dart:convert';

CheckUpdateModel checkUpdateModelFromJson(String str) => CheckUpdateModel.fromJson(json.decode(str));

String checkUpdateModelToJson(CheckUpdateModel data) => json.encode(data.toJson());

class CheckUpdateModel {
  CheckUpdateModel({
    this.status,
    this.versionData,
  });

  final bool status;
  final VersionData versionData;

  factory CheckUpdateModel.fromJson(Map<String, dynamic> json) => CheckUpdateModel(
    status: json["status"] == null ? null : json["status"],
    versionData: json["version_data"] == null ? null : VersionData.fromJson(json["version_data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "version_data": versionData == null ? null : versionData.toJson(),
  };
}

class VersionData {
  VersionData({
    this.currentVersion,
    this.forceUpdate,
  });

  final double currentVersion;
  final String forceUpdate;

  factory VersionData.fromJson(Map<String, dynamic> json) => VersionData(
    currentVersion: json["current_version"] == null ? null : json["current_version"].toDouble(),
    forceUpdate: json["force_update"] == null ? null : json["force_update"],
  );

  Map<String, dynamic> toJson() => {
    "current_version": currentVersion == null ? null : currentVersion,
    "force_update": forceUpdate == null ? null : forceUpdate,
  };
}
