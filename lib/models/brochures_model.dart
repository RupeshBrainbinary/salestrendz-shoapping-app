// To parse this JSON data, do
//
//     final brochureDataModel = brochureDataModelFromJson(jsonString);

import 'dart:convert';

BrochureDataModel brochureDataModelFromJson(String str) => BrochureDataModel.fromJson(json.decode(str));

String brochureDataModelToJson(BrochureDataModel data) => json.encode(data.toJson());

class BrochureDataModel {
  BrochureDataModel({
    this.status,
    this.message,
    this.result,
  });

  bool status;
  String message;
  Result result;

  factory BrochureDataModel.fromJson(Map<String, dynamic> json) => BrochureDataModel(
    status: json["status"],
    message: json["message"],
    result: Result.fromJson(json["result"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "result": result.toJson(),
  };
}

class Result {
  Result({
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
  String nextPageUrl;
  String path;
  String perPage;
  dynamic prevPageUrl;
  int to;
  int total;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
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
    this.brochureId,
    this.compId,
    this.callLogId,
    this.brochureName,
    this.tags,
    this.newFlag,
    this.createdBy,
    this.updatedBy,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.attachments,
  });

  int brochureId;
  int compId;
  int callLogId;
  String brochureName;
  String tags;
  String newFlag;
  String createdBy;
  String updatedBy;
  Status status;
  DateTime createdAt;
  DateTime updatedAt;
  List<Attachment> attachments;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    brochureId: json["brochure_id"],
    compId: json["comp_id"],
    callLogId: json["call_log_id"],
    brochureName: json["brochure_name"],
    tags: json["tags"],
    newFlag: json["new_flag"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    status: statusValues.map[json["status"]],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    attachments: List<Attachment>.from(json["attachments"].map((x) => Attachment.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "brochure_id": brochureId,
    "comp_id": compId,
    "call_log_id": callLogId,
    "brochure_name": brochureName,
    "tags": tags,
    "new_flag": newFlag,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "status": statusValues.reverse[status],
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
    "attachments": List<dynamic>.from(attachments.map((x) => x.toJson())),
  };
}

class Attachment {
  Attachment({
    this.id,
    this.rel,
    this.originalName,
    this.newName,
    this.uploadPath,
    this.version,
    this.type,
    this.typeid,
    this.token,
    this.regdate,
    this.author,
    this.status,
  });

  int id;
  Rel rel;
  String originalName;
  String newName;
  String uploadPath;
  Version version;
  String type;
  int typeid;
  String token;
  DateTime regdate;
  int author;
  Status status;

  factory Attachment.fromJson(Map<String, dynamic> json) => Attachment(
    id: json["id"],
    rel: relValues.map[json["rel"]],
    originalName: json["original_name"],
    newName: json["new_name"],
    uploadPath: json["upload_path"],
    version: versionValues.map[json["version"]],
    type: json["type"],
    typeid: json["typeid"],
    token: json["token"],
    regdate: DateTime.parse(json["regdate"]),
    author: json["author"],
    status: statusValues.map[json["status"]],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "rel": relValues.reverse[rel],
    "original_name": originalName,
    "new_name": newName,
    "upload_path": uploadPath,
    "version": versionValues.reverse[version],
    "type": type,
    "typeid": typeid,
    "token": token,
    "regdate": regdate.toIso8601String(),
    "author": author,
    "status": statusValues.reverse[status],
  };
}

enum Rel { BROCHURE_IMAGE, BROCHURE_PDF }

final relValues = EnumValues({
  "brochure_image": Rel.BROCHURE_IMAGE,
  "brochure_pdf": Rel.BROCHURE_PDF
});

enum Status { ACTIVE }

final statusValues = EnumValues({
  "active": Status.ACTIVE
});

enum Version { ORIGINAL, THE_150_X150 }

final versionValues = EnumValues({
  "original": Version.ORIGINAL,
  "150x150": Version.THE_150_X150
});

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
