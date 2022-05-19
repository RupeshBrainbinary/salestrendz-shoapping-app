// To parse this JSON data, do
//
//     final wishlistModel = wishlistModelFromJson(jsonString);

import 'dart:convert';

WishlistModel wishlistModelFromJson(String str) => WishlistModel.fromJson(json.decode(str));

String wishlistModelToJson(WishlistModel data) => json.encode(data.toJson());

class WishlistModel {
  WishlistModel({
    this.status,
    this.wishlistProducts,
  });

  final bool status;
  final List<WishlistProduct> wishlistProducts;

  factory WishlistModel.fromJson(Map<String, dynamic> json) => WishlistModel(
    status: json["status"] == null ? null : json["status"],
    wishlistProducts: json["wishlist_products"] == null ? null : List<WishlistProduct>.from(json["wishlist_products"].map((x) => WishlistProduct.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "wishlist_products": wishlistProducts == null ? null : List<dynamic>.from(wishlistProducts.map((x) => x.toJson())),
  };
}

class WishlistProduct {
  WishlistProduct({
    this.wishlistProductId,
    this.userId,
    this.wishlistId,
    this.favorite,
    this.productId,
    this.productName,
    this.hsn,
    this.sku,
    this.brandName,
    this.price,
    this.mrp,
    this.unitPerCases,
    this.minQty,
    this.type,
    this.productVariants,
    this.schemeOnProduct,
    this.imagesize512X512,
    this.imagesize700X700,
  });

  final int wishlistProductId;
  final int userId;
  final int wishlistId;
  final String favorite;
  final int productId;
  final String productName;
  final dynamic hsn;
  final String sku;
  final dynamic brandName;
  final double price;
  final double mrp;
  final dynamic unitPerCases;
  final dynamic minQty;
  final String type;
  final List<ProductVariant> productVariants;
  final List<SchemeOnProduct> schemeOnProduct;
  final List<dynamic> imagesize512X512;
  final List<dynamic> imagesize700X700;

  factory WishlistProduct.fromJson(Map<String, dynamic> json) => WishlistProduct(
    wishlistProductId: json["wishlist_product_id"] == null ? null : json["wishlist_product_id"],
    userId: json["user_id"] == null ? null : json["user_id"],
    wishlistId: json["wishlist_id"] == null ? null : json["wishlist_id"],
    favorite: json["favorite"] == null ? null : json["favorite"],
    productId: json["product_id"] == null ? null : json["product_id"],
    productName: json["product_name"] == null ? null : json["product_name"],
    hsn: json["hsn"],
    sku: json["sku"] == null ? null : json["sku"],
    brandName: json["brand_name"],
    price: json["price"] == null ? null : json["price"].toDouble(),
    mrp: json["mrp"] == null ? null : json["mrp"].toDouble(),
    unitPerCases: json["unit_per_cases"],
    minQty: json["min_qty"],
    type: json["type"] == null ? null : json["type"],
    productVariants: json["product_variants"] == null ? null : List<ProductVariant>.from(json["product_variants"].map((x) => ProductVariant.fromJson(x))),
    schemeOnProduct: json["scheme_on_product"] == null ? null : List<SchemeOnProduct>.from(json["scheme_on_product"].map((x) => SchemeOnProduct.fromJson(x))),
    imagesize512X512: json["imagesize512x512"] == null ? null : List<dynamic>.from(json["imagesize512x512"].map((x) => x)),
    imagesize700X700: json["imagesize700x700"] == null ? null : List<dynamic>.from(json["imagesize700x700"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "wishlist_product_id": wishlistProductId == null ? null : wishlistProductId,
    "user_id": userId == null ? null : userId,
    "wishlist_id": wishlistId == null ? null : wishlistId,
    "favorite": favorite == null ? null : favorite,
    "product_id": productId == null ? null : productId,
    "product_name": productName == null ? null : productName,
    "hsn": hsn,
    "sku": sku == null ? null : sku,
    "brand_name": brandName,
    "price": price == null ? null : price,
    "mrp": mrp == null ? null : mrp,
    "unit_per_cases": unitPerCases,
    "min_qty": minQty,
    "type": type == null ? null : type,
    "product_variants": productVariants == null ? null : List<dynamic>.from(productVariants.map((x) => x.toJson())),
    "scheme_on_product": schemeOnProduct == null ? null : List<dynamic>.from(schemeOnProduct.map((x) => x.toJson())),
    "imagesize512x512": imagesize512X512 == null ? null : List<dynamic>.from(imagesize512X512.map((x) => x)),
    "imagesize700x700": imagesize700X700 == null ? null : List<dynamic>.from(imagesize700X700.map((x) => x)),
  };
}

class ProductVariant {
  ProductVariant({
    this.productVariantId,
  });

  final int productVariantId;

  factory ProductVariant.fromJson(Map<String, dynamic> json) => ProductVariant(
    productVariantId: json["product_variant_id"] == null ? null : json["product_variant_id"],
  );

  Map<String, dynamic> toJson() => {
    "product_variant_id": productVariantId == null ? null : productVariantId,
  };
}
class SchemeOnProduct {
  SchemeOnProduct({
    this.id,
    this.compId,
    this.name,
    this.schemeType,
    this.startDate,
    this.endDate,
    this.schemeOfferProductQty,
    this.schemeOfferOrderAmount,
    this.schemePercentageOff,
    this.status,
    this.description,
    this.customersAllowed,
    this.suppliersAllowed,
    this.addBy,
    this.mdfBy,
    this.createdAt,
    this.updatedAt,
    this.schemeId,
    this.masterProductVariantId,
    this.masterProductVariantQtyMax,
    this.masterProductVariantQtyCases,
    this.masterProductVariantQtyUnits,
    this.masterProductVariantTotalQty,
    this.freeProductVaritantId,
    this.freeProductVariantQtyCases,
    this.freeProductVariantQtyUnits,
    this.freeMasterQty,
    this.masterProductVariantDiscount,
  });

  final int id;
  final int compId;
  final String name;
  final int schemeType;
  final DateTime startDate;
  final DateTime endDate;
  final int schemeOfferProductQty;
  final int schemeOfferOrderAmount;
  final int schemePercentageOff;
  final String status;
  final dynamic description;
  final String customersAllowed;
  final String suppliersAllowed;
  final int addBy;
  final dynamic mdfBy;
  final DateTime createdAt;
  final dynamic updatedAt;
  final int schemeId;
  final int masterProductVariantId;
  final int masterProductVariantQtyMax;
  final int masterProductVariantQtyCases;
  final int masterProductVariantQtyUnits;
  final int masterProductVariantTotalQty;
  final int freeProductVaritantId;
  final int freeProductVariantQtyCases;
  final int freeProductVariantQtyUnits;
  final int freeMasterQty;
  final int masterProductVariantDiscount;

  factory SchemeOnProduct.fromJson(Map<String, dynamic> json) => SchemeOnProduct(
    id: json["id"],
    compId: json["comp_id"],
    name: json["name"],
    schemeType: json["scheme_type"],
    startDate: DateTime.parse(json["start_date"]),
    endDate: DateTime.parse(json["end_date"]),
    schemeOfferProductQty: json["scheme_offer_productQty"],
    schemeOfferOrderAmount: json["scheme_offer_orderAmount"],
    schemePercentageOff: json["scheme_percentage_off"],
    status: json["status"],
    description: json["description"],
    customersAllowed: json["customers_allowed"],
    suppliersAllowed: json["suppliers_allowed"],
    addBy: json["add_by"],
    mdfBy: json["mdf_by"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"],
    schemeId: json["scheme_id"],
    masterProductVariantId: json["master_product_variant_id"],
    masterProductVariantQtyMax: json["master_product_variant_qty_max"],
    masterProductVariantQtyCases: json["master_product_variant_qty_cases"],
    masterProductVariantQtyUnits: json["master_product_variant_qty_units"],
    masterProductVariantTotalQty: json["master_product_variant_total_qty"],
    freeProductVaritantId: json["free_product_varitant_id"],
    freeProductVariantQtyCases: json["free_product_variant_qty_cases"],
    freeProductVariantQtyUnits: json["free_product_variant_qty_units"],
    freeMasterQty: json["free_master_qty"],
    masterProductVariantDiscount: json["master_product_variant_discount"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "comp_id": compId,
    "name": name,
    "scheme_type": schemeType,
    "start_date": startDate.toIso8601String(),
    "end_date": endDate.toIso8601String(),
    "scheme_offer_productQty": schemeOfferProductQty,
    "scheme_offer_orderAmount": schemeOfferOrderAmount,
    "scheme_percentage_off": schemePercentageOff,
    "status": status,
    "description": description,
    "customers_allowed": customersAllowed,
    "suppliers_allowed": suppliersAllowed,
    "add_by": addBy,
    "mdf_by": mdfBy,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt,
    "scheme_id": schemeId,
    "master_product_variant_id": masterProductVariantId,
    "master_product_variant_qty_max": masterProductVariantQtyMax,
    "master_product_variant_qty_cases": masterProductVariantQtyCases,
    "master_product_variant_qty_units": masterProductVariantQtyUnits,
    "master_product_variant_total_qty": masterProductVariantTotalQty,
    "free_product_varitant_id": freeProductVaritantId,
    "free_product_variant_qty_cases": freeProductVariantQtyCases,
    "free_product_variant_qty_units": freeProductVariantQtyUnits,
    "free_master_qty": freeMasterQty,
    "master_product_variant_discount": masterProductVariantDiscount,
  };
}
