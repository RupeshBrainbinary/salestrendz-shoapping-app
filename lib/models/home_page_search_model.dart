// To parse this JSON data, do
//
//     final homePageSearch = homePageSearchFromJson(jsonString);

import 'dart:convert';

HomePageSearch homePageSearchFromJson(String str) =>
    HomePageSearch.fromJson(json.decode(str));

String homePageSearchToJson(HomePageSearch data) => json.encode(data.toJson());

class HomePageSearch {
  HomePageSearch({
    this.status,
    this.products,
    this.totalPages,
    this.page,
    this.totalProducts,
  });

  final bool status;
  final List<Product> products;
  final int totalPages;
  final String page;
  final int totalProducts;

  factory HomePageSearch.fromJson(Map<String, dynamic> json) => HomePageSearch(
        status: json["status"] == null ? null : json["status"],
        products: json["products"] == null
            ? null
            : List<Product>.from(
                json["products"].map((x) => Product.fromJson(x))),
        totalPages: json["total_pages"] == null ? null : json["total_pages"],
        page: json["page"] == null ? null : json["page"],
        totalProducts:
            json["total_products"] == null ? null : json["total_products"],
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "products": products == null
            ? null
            : List<dynamic>.from(products.map((x) => x.toJson())),
        "total_pages": totalPages == null ? null : totalPages,
        "page": page == null ? null : page,
        "total_products": totalProducts == null ? null : totalProducts,
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
    this.savedPercentage,
    this.ppGst,
    this.wishlist,
    this.isinWishlist,
    this.productVariants,
    this.schemeOnProduct,
    this.imagesize512X512,
    this.imagesize700X700,
  });

  final int productId;
  final String productName;
  final String sku;
  final String brandName;
  final double ppPrice;
  final double ppMrp;
  final dynamic savedPercentage;
  final int ppGst;
  final dynamic wishlist;
  final IsinWishlist isinWishlist;
  final List<ProductVariant> productVariants;
  final List<dynamic> schemeOnProduct;
  final List<dynamic> imagesize512X512;
  final List<dynamic> imagesize700X700;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        productId: json["product_id"] == null ? null : json["product_id"],
        productName: json["product_name"] == null ? null : json["product_name"],
        sku: json["sku"] == null ? null : json["sku"],
        brandName: json["brand_name"] == null ? null : json["brand_name"],
        ppPrice: json["pp_price"] == null ? null : json["pp_price"].toDouble(),
        ppMrp: json["pp_mrp"] == null ? null : json["pp_mrp"].toDouble(),
        savedPercentage:
            json["saved_percentage"] == null ? null : json["saved_percentage"],
        ppGst: json["pp_gst"] == null ? null : json["pp_gst"],
        wishlist: json["wishlist"],
        isinWishlist: json["isin_wishlist"] == null
            ? null
            : isinWishlistValues.map[json["isin_wishlist"]],
        productVariants: json["product_variants"] == null
            ? null
            : List<ProductVariant>.from(json["product_variants"]
                .map((x) => ProductVariant.fromJson(x))),
        schemeOnProduct: json["scheme_on_product"] == null
            ? null
            : List<dynamic>.from(json["scheme_on_product"].map((x) => x)),
        imagesize512X512: json["imagesize512x512"]
            == null
            ? null
            : json["imagesize512x512"] is String ? [json["imagesize512x512"]] : List<dynamic>.from(json["imagesize512x512"]),
        imagesize700X700: json["imagesize700x700"]
            == null
            ? null
            : json["imagesize512x512"] is String ? [json["imagesize512x512"]] :List<dynamic>.from(json["imagesize700x700"]),
      );

  Map<String, dynamic> toJson() => {
        "product_id": productId == null ? null : productId,
        "product_name": productName == null ? null : productName,
        "sku": sku == null ? null : sku,
        "brand_name": brandName == null ? null : brandName,
        "pp_price": ppPrice == null ? null : ppPrice,
        "pp_mrp": ppMrp == null ? null : ppMrp,
        "saved_percentage": savedPercentage == null ? null : savedPercentage,
        "pp_gst": ppGst == null ? null : ppGst,
        "wishlist": wishlist,
        "isin_wishlist": isinWishlist == null
            ? null
            : isinWishlistValues.reverse[isinWishlist],
        "product_variants": productVariants == null
            ? null
            : List<dynamic>.from(productVariants.map((x) => x.toJson())),
        "scheme_on_product": schemeOnProduct == null
            ? null
            : List<dynamic>.from(schemeOnProduct.map((x) => x)),
        "imagesize512x512": imagesize512X512 == null
            ? null
            : List<dynamic>.from(imagesize512X512.map((x) => x)),
        "imagesize700x700": imagesize700X700 == null
            ? null
            : List<dynamic>.from(imagesize700X700.map((x) => x)),
      };
}

enum IsinWishlist { INACTIVE }

final isinWishlistValues = EnumValues({"inactive": IsinWishlist.INACTIVE});

class ProductVariant {
  ProductVariant({
    this.productVariantId,
  });

  final int productVariantId;

  factory ProductVariant.fromJson(Map<String, dynamic> json) => ProductVariant(
        productVariantId: json["product_variant_id"] == null
            ? null
            : json["product_variant_id"],
      );

  Map<String, dynamic> toJson() => {
        "product_variant_id":
            productVariantId == null ? null : productVariantId,
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
