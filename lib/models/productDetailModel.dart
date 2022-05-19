// To parse this JSON data, do
//
//     final productDetailsModel = productDetailsModelFromJson(jsonString);

import 'dart:convert';

ProductDetailsModel productDetailsModelFromJson(String str) =>
    ProductDetailsModel.fromJson(json.decode(str));

String productDetailsModelToJson(ProductDetailsModel data) =>
    json.encode(data.toJson());

class ProductDetailsModel {
  ProductDetailsModel({
    this.status,
    this.products,
  });

  bool status;
  Products products;

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) =>
      ProductDetailsModel(
        status: json["status"],
        products: Products.fromJson(json["products"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "products": products.toJson(),
      };
}

class Products {
  Products({
    this.productId,
    this.productName,
    this.sku,
    this.hsn,
    this.price,
    this.mrp,
    this.gst,
    this.brandName,
    this.productDescription,
    this.minQty,
    this.type,
    this.imagesize512X512,
    this.imagesize700X700,
    this.availableVariants,
  });

  int productId;
  String productName;
  dynamic sku;
  dynamic hsn;
  dynamic price;
  dynamic mrp;
  int gst;
  dynamic brandName;
  dynamic productDescription;
  dynamic minQty;
  String type;
  List<dynamic> imagesize512X512;
  List<dynamic> imagesize700X700;
  List<AvailableVariant> availableVariants;

  factory Products.fromJson(Map<String, dynamic> json) => Products(
        productId: json["product_id"],
        productName: json["product_name"],
        sku: json["sku"],
        hsn: json["hsn"],
        price: json["price"],
        mrp: json["mrp"],
        gst: json["gst"],
        brandName: json["brand_name"],
        productDescription: json["product_description"],
        minQty: json["min_qty"],
        type: json["type"],
        imagesize512X512:
            List<dynamic>.from(json["imagesize512x512"].map((x) => x)),
        imagesize700X700:
            List<dynamic>.from(json["imagesize700x700"].map((x) => x)),
        availableVariants: List<AvailableVariant>.from(
            json["available_variants"]
                .map((x) => AvailableVariant.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "product_name": productName,
        "sku": sku,
        "hsn": hsn,
        "price": price,
        "mrp": mrp,
        "gst": gst,
        "brand_name": brandName,
        "product_description": productDescription,
        "min_qty": minQty,
        "type": type,
        "imagesize512x512": List<dynamic>.from(imagesize512X512.map((x) => x)),
        "imagesize700x700": List<dynamic>.from(imagesize700X700.map((x) => x)),
        "available_variants":
            List<dynamic>.from(availableVariants.map((x) => x.toJson())),
      };
}

class AvailableVariant {
  AvailableVariant({
    this.variantAttriName,
    this.variantId,
    this.variantInPricelist,
    this.sku,
  });

  String variantAttriName;
  int variantId;
  String variantInPricelist;
  String sku;

  factory AvailableVariant.fromJson(Map<String, dynamic> json) =>
      AvailableVariant(
        variantAttriName: json["variant_attri_name"],
        variantId: json["variant_id"],
        variantInPricelist: json["variant_in_pricelist"],
        sku: json["sku"],
      );

  Map<String, dynamic> toJson() => {
        "variant_attri_name": variantAttriName,
        "variant_id": variantId,
        "variant_in_pricelist": variantInPricelist,
        "sku": sku,
      };
}
