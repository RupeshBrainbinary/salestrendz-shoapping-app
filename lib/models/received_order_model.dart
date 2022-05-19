// To parse this JSON data, do
//
//     final recivedOrderModel = recivedOrderModelFromJson(jsonString);

import 'dart:convert';

RecivedOrderModel recivedOrderModelFromJson(String str) =>
    RecivedOrderModel.fromJson(json.decode(str));

String recivedOrderModelToJson(RecivedOrderModel data) =>
    json.encode(data.toJson());

class RecivedOrderModel {
  RecivedOrderModel({
    this.staus,
    this.orders,
    this.totalPages,
    this.orderCount,
  });

  bool staus;
  List<Order> orders;
  int totalPages;
  int orderCount;

  factory RecivedOrderModel.fromJson(Map<String, dynamic> json) {
    print(json);
    return RecivedOrderModel(
      staus: json["staus"],
      orders: json["orders"] == null
          ? null
          : List<Order>.from(json["orders"].map((x) => Order.fromJson(x))),
      totalPages: json["total_pages"],
      orderCount: json["order_count"],
    );
  }

  Map<String, dynamic> toJson() => {
        "staus": staus,
        "orders": List<dynamic>.from(orders.map((x) => x.toJson())),
        "total_pages": totalPages,
        "order_count": orderCount,
      };
}

class Order {
  Order({
    this.ordId,
    this.compId,
    this.createdAt,
    this.status,
    this.custId,
    this.supId,
    this.compOrdId,
    this.orderStatus,
    this.custName,
    this.supAssigned,
    this.supName,
    this.amount,
    this.userId,
    this.updatedAt,
    this.userName,
    this.productCount,
    this.assignSupplierName,
    this.orderedCustId,
    this.orderedCustName,
  });

  int ordId;
  String compId;
  DateTime createdAt;
  String status;
  int custId;
  int supId;
  int compOrdId;
  OrderStatus orderStatus;
  String custName;
  int supAssigned;
  dynamic supName;
  double amount;
  int userId;
  DateTime updatedAt;
  Name userName;
  String productCount;
  dynamic assignSupplierName;
  int orderedCustId;
  Name orderedCustName;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        ordId: json["ord_id"],
        compId: json["comp_id"],
        createdAt: DateTime.parse(json["created_at"]),
        status: json["status"],
        custId: json["cust_id"],
        supId: json["sup_id"],
        compOrdId: json["comp_ord_id"],
        orderStatus: orderStatusValues.map[json["order_status"]],
        custName: json["cust_name"] ?? "",
        supAssigned: json["sup_assigned"],
        supName: json["sup_name"],
        amount: json["amount"].toDouble(),
        userId: json["user_id"],
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        userName: nameValues.map[json["user_name"]],
        productCount:
            json["product_count"] == null ? null : json["product_count"],
        assignSupplierName: json["assign_supplier_name"],
        orderedCustId: json["ordered_cust_id"],
        orderedCustName: nameValues.map[json["ordered_cust_name"]],
      );

  Map<String, dynamic> toJson() => {
        "ord_id": ordId,
        "comp_id": compId,
        "created_at": createdAt.toIso8601String(),
        "status": status,
        "cust_id": custId,
        "sup_id": supId,
        "comp_ord_id": compOrdId,
        "order_status": orderStatusValues.reverse[orderStatus],
        "cust_name": custName == null ? null : nameValues.reverse[custName],
        "sup_assigned": supAssigned,
        "sup_name": supName,
        "amount": amount,
        "user_id": userId,
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
        "user_name": nameValues.reverse[userName],
        "product_count": productCount == null ? null : productCount,
        "assign_supplier_name": assignSupplierName,
        "ordered_cust_id": orderedCustId,
        "ordered_cust_name": nameValues.reverse[orderedCustName],
      };
}

enum Name { HARITA_TRADERS, SACHIN_MEHTA }

final nameValues = EnumValues(
    {"Harita Traders": Name.HARITA_TRADERS, "Sachin Mehta": Name.SACHIN_MEHTA});

enum OrderStatus { ORDERED }

final orderStatusValues = EnumValues({"Ordered": OrderStatus.ORDERED});

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
