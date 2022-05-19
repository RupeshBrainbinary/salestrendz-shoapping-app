// To parse this JSON data, do
//
//     final helplineModel = helplineModelFromJson(jsonString);

import 'dart:convert';

HelplineModel helplineModelFromJson(String str) =>
    HelplineModel.fromJson(json.decode(str));

String helplineModelToJson(HelplineModel data) => json.encode(data.toJson());

class HelplineModel {
  HelplineModel({
    this.status,
    this.callHelplines,
  });

  bool status;
  List<CallHelpline> callHelplines;

  factory HelplineModel.fromJson(Map<String, dynamic> json) => HelplineModel(
        status: json["status"],
        callHelplines: List<CallHelpline>.from(
            json["Call_helplines"].map((x) => CallHelpline.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "Call_helplines":
            List<dynamic>.from(callHelplines.map((x) => x.toJson())),
      };
}

class CallHelpline {
  CallHelpline({
    this.helplineUsername,
    this.helplineUserNumber,
    this.helplineId,
    this.userProfileImage,
  });

  String helplineUsername;
  String helplineUserNumber;
  int helplineId;
  String userProfileImage;

  factory CallHelpline.fromJson(Map<String, dynamic> json) => CallHelpline(
        helplineUsername: json["helpline_username"],
        helplineUserNumber: json["helpline_user_number"],
        helplineId: json["helpline_id"],
        userProfileImage: json["user_profile_image"],
      );

  Map<String, dynamic> toJson() => {
        "helpline_username": helplineUsername,
        "helpline_user_number": helplineUserNumber,
        "helpline_id": helplineId,
        "user_profile_image": userProfileImage,
      };
}
