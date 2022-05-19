import 'package:shoppingapp/utils/commons/export_basic_file.dart';

class ReceiveOrderViewModel {
  ReceiveOrderState state;
  int orderPageLength = 0;
  bool canPaging = true;

  RecivedOrderModel receiveOrder;

  ReceiveOrderViewModel(this.state) {
    getReceiveOrderApiInitial();
  }

  getReceiveOrderApiInitial() async {
    var retailerOrderList = await RestApi.getReceivedOrderFromServer(1);

    if (retailerOrderList == null) {
      // ignore: deprecated_member_use
      receiveOrder = RecivedOrderModel(orders: List());
    } else {
      receiveOrder = retailerOrderList;
    }


    if (retailerOrderList != null) {
      if (retailerOrderList.orders != null) {
        if (retailerOrderList.orders.length < 10) {
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

  getReceiveOrderApi(int i) async {
    Loader().showLoader(state.context);
    var retailerOrderList = await RestApi.getReceivedOrderFromServer(i);
    Loader().hideLoader(state.context);
    receiveOrder.orders.addAll(retailerOrderList.orders);
    state.isPaging = false;

    if (retailerOrderList != null) {
      if (retailerOrderList.orders != null) {
        if (retailerOrderList.orders.length < 10) {
          canPaging = false;
        }
      }
    }

    orderPageLength++;

    if (orderPageLength == receiveOrder.totalPages) {
      canPaging = false;
    }

    if (state.mounted) {
      // ignore: invalid_use_of_protected_member
      state.setState(() {});
    }
  }
}
