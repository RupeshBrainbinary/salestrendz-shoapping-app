// To parse this JSON data, do
//
//     final productStockViewModel = productStockViewModelFromJson(jsonString);

import 'dart:convert';

ProductStockViewModel productStockViewModelFromJson(String str) => ProductStockViewModel.fromJson(json.decode(str));

String productStockViewModelToJson(ProductStockViewModel data) => json.encode(data.toJson());

class ProductStockViewModel {
  ProductStockViewModel({
    this.status,
    this.inventoryProduct,
  });

  final bool status;
  final List<Map<String, int>> inventoryProduct;

  factory ProductStockViewModel.fromJson(Map<String, dynamic> json) => ProductStockViewModel(
    status: json["status"] == null ? null : json["status"],
    inventoryProduct: json["inventory_product"] == null ? null : List<Map<String, int>>.from(json["inventory_product"].map((x) => Map.from(x).map((k, v) => MapEntry<String, int>(k, v == null ? null : v)))),
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "inventory_product": inventoryProduct == null ? null : List<dynamic>.from(inventoryProduct.map((x) => Map.from(x).map((k, v) => MapEntry<String, dynamic>(k, v == null ? null : v)))),
  };
}
