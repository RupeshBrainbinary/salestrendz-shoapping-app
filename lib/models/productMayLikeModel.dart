// To parse this JSON data, do
//
//     final productLikeModel = productLikeModelFromJson(jsonString);

import 'dart:convert';

ProductLikeModel productLikeModelFromJson(String str) => ProductLikeModel.fromJson(json.decode(str));

String productLikeModelToJson(ProductLikeModel data) => json.encode(data.toJson());

class ProductLikeModel {
  ProductLikeModel({
    this.status,
    this.products,
    this.totalPages,
    this.page,
    this.totalProducts,
  });

  bool status;
  List<Product> products;
  int totalPages;
  String page;
  int totalProducts;

  factory ProductLikeModel.fromJson(Map<String, dynamic> json) => ProductLikeModel(
    status: json["status"],
    products: List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
    totalPages: json["total_pages"],
    page: json["page"],
    totalProducts: json["total_products"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "products": List<dynamic>.from(products.map((x) => x.toJson())),
    "total_pages": totalPages,
    "page": page,
    "total_products": totalProducts,
  };
}

class Product {
  Product({
    this.productId,
    this.productName,
    this.sku,
    this.brandName,
    this.ppPrice,
    this.ppMrp,
    this.minQty,
    this.savedPercentage,
    this.ppGst,
    this.wishlist,
    this.isinWishlist,
    this.productVariants,
    this.qtyInCases,
    this.schemeOnProduct,
    this.imagesize512X512,
    this.imagesize700X700,
  });

  int productId;
  String productName;
  String sku;
  BrandName brandName;
  double ppPrice;
  int ppMrp;
  int minQty;
  dynamic savedPercentage;
  int ppGst;
  Wishlist wishlist;
  IsinWishlist isinWishlist;
  List<ProductVariant> productVariants;
  int qtyInCases;
  List<SchemeOnProduct> schemeOnProduct;
  // List<String> imagesize512X512;
  dynamic  imagesize512X512;
  dynamic  imagesize700X700;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    productId: json["product_id"],
    productName: json["product_name"],
    sku: json["sku"],
    brandName: brandNameValues.map[json["brand_name"]],
    ppPrice: json["pp_price"],
    ppMrp: json["pp_mrp"] == null ? null : json["pp_mrp"],
    minQty:json["min_qty"] == null ? null : json["min_qty"],
    savedPercentage: json["saved_percentage"],
    ppGst: json["pp_gst"] == null ? null : json["pp_gst"],
    wishlist: json["wishlist"] == null ? null : Wishlist.fromJson(json["wishlist"]),
    isinWishlist: isinWishlistValues.map[json["isin_wishlist"]],
    productVariants: List<ProductVariant>.from(json["product_variants"].map((x) => ProductVariant.fromJson(x))),
    qtyInCases: json["qty_in_cases"],
    schemeOnProduct: List<SchemeOnProduct>.from(json["scheme_on_product"].map((x) => SchemeOnProduct.fromJson(x))),
    imagesize512X512: json["imagesize512x512"],
    imagesize700X700: json["imagesize700x700"],
  );

  Map<String, dynamic> toJson() => {
    "product_id": productId,
    "product_name": productName,
    "sku": sku,
    "brand_name": brandNameValues.reverse[brandName],
    "pp_price": ppPrice,
    "pp_mrp": ppMrp == null ? null : ppMrp,
    "min_qty":minQty == null?null:minQty,
    "saved_percentage": savedPercentage,
    "pp_gst": ppGst == null ? null : ppGst,
    "wishlist": wishlist == null ? null : wishlist.toJson(),
    "isin_wishlist": isinWishlistValues.reverse[isinWishlist],
    "product_variants": List<dynamic>.from(productVariants.map((x) => x.toJson())),
    "qty_in_cases":qtyInCases,
    "scheme_on_product": List<dynamic>.from(schemeOnProduct.map((x) => x.toJson())),
    "imagesize512x512": imagesize512X512,
    "imagesize700x700": imagesize700X700,
  };
}

enum BrandName { BRAND_TRENDZ }

final brandNameValues = EnumValues({
  "BrandTrendz": BrandName.BRAND_TRENDZ
});

enum IsinWishlist { INACTIVE, ACTIVE }

final isinWishlistValues = EnumValues({
  "active": IsinWishlist.ACTIVE,
  "inactive": IsinWishlist.INACTIVE
});

class ProductVariant {
  ProductVariant({
    this.productVariantId,
  });

  int productVariantId;

  factory ProductVariant.fromJson(Map<String, dynamic> json) => ProductVariant(
    productVariantId: json["product_variant_id"],
  );

  Map<String, dynamic> toJson() => {
    "product_variant_id": productVariantId,
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

  int id;
  int compId;
  String name;
  int schemeType;
  DateTime startDate;
  DateTime endDate;
  int schemeOfferProductQty;
  int schemeOfferOrderAmount;
  int schemePercentageOff;
  IsinWishlist status;
  dynamic description;
  String customersAllowed;
  String suppliersAllowed;
  int addBy;
  dynamic mdfBy;
  DateTime createdAt;
  dynamic updatedAt;
  int schemeId;
  int masterProductVariantId;
  int masterProductVariantQtyMax;
  int masterProductVariantQtyCases;
  int masterProductVariantQtyUnits;
  int masterProductVariantTotalQty;
  int freeProductVaritantId;
  int freeProductVariantQtyCases;
  int freeProductVariantQtyUnits;
  int freeMasterQty;
  int masterProductVariantDiscount;

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
    status: isinWishlistValues.map[json["status"]],
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
    "status": isinWishlistValues.reverse[status],
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
  IsinWishlist favorite;

  factory Wishlist.fromJson(Map<String, dynamic> json) => Wishlist(
    wishlistId: json["wishlist_id"],
    wishlistProductId: json["wishlist_product_id"],
    userId: json["user_id"],
    compId: json["comp_id"],
    favorite: isinWishlistValues.map[json["favorite"]],
  );

  Map<String, dynamic> toJson() => {
    "wishlist_id": wishlistId,
    "wishlist_product_id": wishlistProductId,
    "user_id": userId,
    "comp_id": compId,
    "favorite": isinWishlistValues.reverse[favorite],
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
