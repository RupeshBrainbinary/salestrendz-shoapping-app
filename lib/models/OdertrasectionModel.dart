import 'dart:convert';

MyOrdersList myOrdersListFromJson(String str) =>
    MyOrdersList.fromJson(json.decode(str));

String myOrdersListToJson(MyOrdersList data) => json.encode(data.toJson());

class MyOrdersList {
  MyOrdersList({
    this.status,
    this.orderList,
    this.page,
    this.totalPages,
  });

  bool status;
  List<OrderList> orderList;
  String page;
  int totalPages;

  factory MyOrdersList.fromJson(Map<String, dynamic> json) => MyOrdersList(
        status: json["status"],
        orderList: json["order_list"] == null
            // ignore: deprecated_member_use
            ? List()
            : List<OrderList>.from(
                json["order_list"].map((x) => OrderList.fromJson(x))),
        page: json["page"],
        totalPages: json["total_pages"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "order_list": List<dynamic>.from(orderList.map((x) => x.toJson())),
        "page": page,
        "total_pages": totalPages,
      };
}

class OrderList {
  OrderList({
    this.ordId,
    this.amount,
    this.createdAt,
    this.orderId,
    this.status,
    this.totalQty,
  });

  int ordId;
  double amount;
  String createdAt;
  int orderId;
  String status;
  String totalQty;

  factory OrderList.fromJson(Map<String, dynamic> json) => OrderList(
        ordId: json["ord_id"],
        amount: double.parse(json["amount"].toString()),
        createdAt: json["created_at"],
        orderId: json["order_id"],
        status: json["status"],
        totalQty: json["total_qty"] == null ? null : json["total_qty"],
      );

  Map<String, dynamic> toJson() => {
        "ord_id": ordId,
        "amount": amount,
        "created_at": createdAt,
        "order_id": orderId,
        "status": status,
        "total_qty": totalQty == null ? null : totalQty,
      };
}
