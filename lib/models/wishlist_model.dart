// To parse this JSON data, do
//
//     final wishlistModel = wishlistModelFromJson(jsonString);

import 'dart:convert';

WishlistModel wishlistModelFromJson(String str) =>
    WishlistModel.fromJson(json.decode(str));

String wishlistModelToJson(WishlistModel data) => json.encode(data.toJson());

class WishlistModel {
  WishlistModel({
    this.status,
    this.message,
    this.wishlistDetails,
  });

  bool status;
  String message;
  WishlistDetails wishlistDetails;

  factory WishlistModel.fromJson(Map<String, dynamic> json) => WishlistModel(
        status: json["status"],
        message: json["message"],
        wishlistDetails: WishlistDetails.fromJson(json["wishlist_details"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "wishlist_details": wishlistDetails.toJson(),
      };
}

class WishlistDetails {
  WishlistDetails({
    this.wishlistId,
    this.wishlistProductId,
    this.compId,
    this.userId,
    this.createdAt,
    this.addBy,
    this.favorite,
  });

  int wishlistId;
  int wishlistProductId;
  int compId;
  int userId;
  DateTime createdAt;
  int addBy;
  String favorite;

  factory WishlistDetails.fromJson(Map<String, dynamic> json) =>
      WishlistDetails(
        wishlistId: json["wishlist_id"],
        wishlistProductId: json["wishlist_product_id"],
        compId: json["comp_id"],
        userId: json["user_id"],
        createdAt: DateTime.parse(json["created_at"]),
        addBy: json["add_by"],
        favorite: json["favorite"],
      );

  Map<String, dynamic> toJson() => {
        "wishlist_id": wishlistId,
        "wishlist_product_id": wishlistProductId,
        "comp_id": compId,
        "user_id": userId,
        "created_at": createdAt.toIso8601String(),
        "add_by": addBy,
        "favorite": favorite,
      };
}
