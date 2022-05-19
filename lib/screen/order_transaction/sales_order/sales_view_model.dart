import 'package:shoppingapp/utils/commons/export_basic_file.dart';

class SalesOrderViewModel {
  SalesTransactionState state;
  int orderPageLength = 0;
  bool canPaging = true;

  RecivedOrderModel salesOrder;

  SalesOrderViewModel(this.state) {
    getSalesOrderApiInitial();
  }

  getSalesOrderApiInitial() async {
    var salesOrderList = await RestApi.getReceivedOrderFromServer(1);

    if (salesOrderList == null) {
      // ignore: deprecated_member_use
      salesOrder = RecivedOrderModel(orders: List());
    } else {
      salesOrder = salesOrderList;
    }

    if (salesOrderList != null) {
      if(salesOrderList.orders != null){
        if (salesOrderList.orders.length < 10) {
          canPaging = false;
        }
      }
    }

    orderPageLength++;
    if (state.mounted) {
      // ignore: invalid_use_of_protected_member
      state.setState(() {});
    }
  }

  getSalesOrderApi(int i) async {
    Loader().showLoader(state.context);
    var salesOrderList = await RestApi.getReceivedOrderFromServer(i);
    Loader().hideLoader(state.context);
    salesOrder.orders.addAll(salesOrderList.orders);
    state.isPaging = false;

    orderPageLength++;

    if (salesOrderList != null) {
      if(salesOrderList.orders != null){
        if (salesOrderList.orders.length < 10) {
          canPaging = false;
        }
      }
    }

    if (orderPageLength == salesOrder.totalPages) {
      canPaging = false;
    }
    // ignore: invalid_use_of_protected_member
    state.setState(() {});
  }
}
