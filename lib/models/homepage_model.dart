// To parse this JSON data, do
//
//     final homePageModel = homePageModelFromJson(jsonString);

import 'dart:convert';

HomePageModel homePageModelFromJson(String str) =>
    HomePageModel.fromJson(json.decode(str));

String homePageModelToJson(HomePageModel data) => json.encode(data.toJson());

class HomePageModel {
  HomePageModel({
    this.status,
    this.bannerDetails,
    this.trendingProducts,
    this.blockbusterProducts,
  });

  bool status;
  BannerDetails bannerDetails;
  Products trendingProducts;
  Products blockbusterProducts;

  factory HomePageModel.fromJson(Map<String, dynamic> json) => HomePageModel(
        status: json["status"],
        bannerDetails: BannerDetails.fromJson(json["banner_details"]),
        trendingProducts: json["trending_products"] is Map
            ? Products.fromJson(json["trending_products"])
            : null,
        blockbusterProducts: json["blockbuster_products"] is Map
            ? Products.fromJson(json["blockbuster_products"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "banner_details": bannerDetails.toJson(),
        "trending_products": trendingProducts.toJson(),
        "blockbuster_products": blockbusterProducts.toJson(),
      };
}

class BannerDetails {
  BannerDetails({
    this.bannerId,
    this.status,
    this.compId,
    this.attachments,
  });

  int bannerId;
  String status;
  int compId;
  List<Attachment> attachments;

  factory BannerDetails.fromJson(Map<String, dynamic> json) => BannerDetails(
        bannerId: json["banner_id"],
        status: json["status"],
        compId: json["comp_id"],
        attachments: List<Attachment>.from(
            json["attachments"].map((x) => Attachment.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "banner_id": bannerId,
        "status": status,
        "comp_id": compId,
        "attachments": List<dynamic>.from(attachments.map((x) => x.toJson())),
      };
}

class Attachment {
  Attachment({
    this.originalName,
    this.uploadPath,
    this.version,
    this.typeid,
    this.token,
  });

  String originalName;
  String uploadPath;
  Version version;
  int typeid;
  String token;

  factory Attachment.fromJson(Map<String, dynamic> json) => Attachment(
        originalName: json["original_name"],
        uploadPath: json["upload_path"],
        version: versionValues.map[json["version"]],
        typeid: json["typeid"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "original_name": originalName,
        "upload_path": uploadPath,
        "version": versionValues.reverse[version],
        "typeid": typeid,
        "token": token,
      };
}

enum Version { ORIGINAL, THE_150_X150 }

final versionValues =
    EnumValues({"original": Version.ORIGINAL, "150x150": Version.THE_150_X150});

class Products {
  Products({
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

  factory Products.fromJson(Map<String, dynamic> json) => Products(
        currentPage: json["current_page"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        nextPageUrl:
            json["next_page_url"] == null ? null : json["next_page_url"],
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
        "next_page_url": nextPageUrl == null ? null : nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
      };
}

class Datum {
  Datum({
    this.ppId,
    this.compId,
    this.ppProductId,
    this.ppProductVariantId,
    this.ppPricelistId,
    this.ppPrice,
    this.ppMrp,
    this.ppGst,
    this.savedAmount,
    this.savedPercentage,
    this.ppStatus,
    this.qtyInCases,
    this.minQty,
    this.wishlist,
    this.isinWishlist,
    this.imageAttached,
    this.productName,
    this.sku,
    this.schemeOnProduct,
  });

  int ppId;
  int compId;
  int ppProductId;
  int ppProductVariantId;
  int ppPricelistId;
  double ppPrice;
  dynamic ppMrp;
  int ppGst;
  dynamic savedAmount;
  dynamic savedPercentage;
  String ppStatus;
  int qtyInCases;
  int minQty;
  Wishlist wishlist;
  String isinWishlist;
  List<Attachment> imageAttached;
  String productName;
  String sku;
  List<dynamic> schemeOnProduct;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        ppId: json["pp_id"],
        compId: json["comp_id"],
        ppProductId: json["pp_product_id"],
        ppProductVariantId: json["pp_product_variant_id"],
        ppPricelistId: json["pp_pricelist_id"],
        ppPrice: double.parse(json["pp_price"].toString()),
        ppMrp: json["pp_mrp"],
        ppGst: json["pp_gst"],
        savedAmount: json["saved_amount"],
        savedPercentage: json["saved_percentage"],
        ppStatus: json["pp_status"],
        qtyInCases: json["qty_in_cases"],
        minQty: json["min_qty"],
        wishlist: json["wishlist"] == null
            ? null
            : Wishlist.fromJson(json["wishlist"]),
        isinWishlist: json["isin_wishlist"],
        imageAttached: List<Attachment>.from(
            json["image_attached"].map((x) => Attachment.fromJson(x))),
        productName: json["product_name"],
        sku: json["sku"],
        schemeOnProduct:
            List<dynamic>.from(json["scheme_on_product"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "pp_id": ppId,
        "comp_id": compId,
        "pp_product_id": ppProductId,
        "pp_product_variant_id": ppProductVariantId,
        "pp_pricelist_id": ppPricelistId,
        "pp_price": ppPrice,
        "pp_mrp": ppMrp,
        "pp_gst": ppGst,
        "saved_amount": savedAmount,
        "saved_percentage": savedPercentage,
        "pp_status": ppStatus,
        "qty_in_cases": qtyInCases,
        "min_qty": minQty,
        "wishlist": wishlist == null ? null : wishlist.toJson(),
        "isin_wishlist": isinWishlist,
        "image_attached":
            List<dynamic>.from(imageAttached.map((x) => x.toJson())),
        "product_name": productName,
        "sku": sku,
        "scheme_on_product": List<dynamic>.from(schemeOnProduct.map((x) => x)),
      };
}

class Wishlist {
  Wishlist({
    this.wishlistId,
    this.wishlistProductId,
    this.userId,
    this.compId,
    this.favorite,
  });

  int wishlistId;
  int wishlistProductId;
  int userId;
  int compId;
  String favorite;

  factory Wishlist.fromJson(Map<String, dynamic> json) => Wishlist(
        wishlistId: json["wishlist_id"],
        wishlistProductId: json["wishlist_product_id"],
        userId: json["user_id"],
        compId: json["comp_id"],
        favorite: json["favorite"],
      );

  Map<String, dynamic> toJson() => {
        "wishlist_id": wishlistId,
        "wishlist_product_id": wishlistProductId,
        "user_id": userId,
        "comp_id": compId,
        "favorite": favorite,
      };
}

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
