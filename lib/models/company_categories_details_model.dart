// To parse this JSON data, do
//
//     final categoriesModel = categoriesModelFromJson(jsonString);

import 'dart:convert';

CategoriesModel categoriesModelFromJson(String str) => CategoriesModel.fromJson(json.decode(str));

String categoriesModelToJson(CategoriesModel data) => json.encode(data.toJson());

class CategoriesModel {
  CategoriesModel({
    this.status,
    this.categories,
    this.pirceRange,
    this.brands,
    this.categoryTree,
    this.pricelistInfo,
  });

  final bool status;
  final List<Category> categories;
  final List<PirceRange> pirceRange;
  final List<Brand> brands;
  final List<Category> categoryTree;
  final String pricelistInfo;

  factory CategoriesModel.fromJson(Map<String, dynamic> json) => CategoriesModel(
    status: json["status"] == null ? null : json["status"],
    categories: json["categories"] == null ? null : List<Category>.from(json["categories"].map((x) => Category.fromJson(x))),
    pirceRange: json["pirce_range"] == null ? null : List<PirceRange>.from(json["pirce_range"].map((x) => PirceRange.fromJson(x))),
    brands: json["brands"] == null ? null : List<Brand>.from(json["brands"].map((x) => Brand.fromJson(x))),
    categoryTree: json["category_tree"] == null ? null : List<Category>.from(json["category_tree"].map((x) => Category.fromJson(x))),
    pricelistInfo: json["pricelist_info"] == null ? null : json["pricelist_info"],
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "categories": categories == null ? null : List<dynamic>.from(categories.map((x) => x.toJson())),
    "pirce_range": pirceRange == null ? null : List<dynamic>.from(pirceRange.map((x) => x.toJson())),
    "brands": brands == null ? null : List<dynamic>.from(brands.map((x) => x.toJson())),
    "category_tree": categoryTree == null ? null : List<dynamic>.from(categoryTree.map((x) => x.toJson())),
    "pricelist_info": pricelistInfo == null ? null : pricelistInfo,
  };
}

class Brand {
  Brand({
    this.id,
    this.brandName,
  });

  final int id;
  final String brandName;

  factory Brand.fromJson(Map<String, dynamic> json) => Brand(
    id: json["id"] == null ? null : json["id"],
    brandName: json["brand_name"] == null ? null : json["brand_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "brand_name": brandName == null ? null : brandName,
  };
}

class Category {
  Category({
    this.productCatId,
    this.productCatName,
    this.categoryParent,
    this.totalProducts,
    this.isChildren,
    this.children,
  });

  final int productCatId;
  final String productCatName;
  final int categoryParent;
  final int totalProducts;
  final String isChildren;
  final List<Category> children;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    productCatId: json["product_cat_id"] == null ? null : json["product_cat_id"],
    productCatName: json["product_cat_name"] == null ? null : json["product_cat_name"],
    categoryParent: json["category_parent"] == null ? null : json["category_parent"],
    totalProducts: json["total_products"] == null ? null : json["total_products"],
    isChildren: json["is_children"] == null ? null : json["is_children"],
    children: json["children"] == null ? null : List<Category>.from(json["children"].map((x) => Category.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "product_cat_id": productCatId == null ? null : productCatId,
    "product_cat_name": productCatName == null ? null : productCatName,
    "category_parent": categoryParent == null ? null : categoryParent,
    "total_products": totalProducts == null ? null : totalProducts,
    "is_children": isChildren == null ? null : isChildren,
    "children": children == null ? null : List<dynamic>.from(children.map((x) => x.toJson())),
  };
}

class PirceRange {
  PirceRange({
    this.minPrice,
    this.maxPrice,
  });

  final int minPrice;
  final int maxPrice;

  factory PirceRange.fromJson(Map<String, dynamic> json) => PirceRange(
    minPrice: json["min_price"] == null ? null : json["min_price"],
    maxPrice: json["max_price"] == null ? null : json["max_price"],
  );

  Map<String, dynamic> toJson() => {
    "min_price": minPrice == null ? null : minPrice,
    "max_price": maxPrice == null ? null : maxPrice,
  };
}
