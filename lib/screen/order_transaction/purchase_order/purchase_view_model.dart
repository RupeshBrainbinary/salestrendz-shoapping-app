import 'package:shoppingapp/utils/commons/export_basic_file.dart';

class PurchaseViewModel {
  PurchaseTransactionState state;
  int orderPageLength = 0;
  bool canPaging = true;

  MyOrdersList purchaseOrder;

  PurchaseViewModel(this.state) {
    getPurchaseOrderApiInitial();
  }

  getPurchaseOrderApiInitial() async {
    var purchaseOrderList = await RestApi.getMyOrderApi(1);

    if (purchaseOrderList == null) {
      // ignore: deprecated_member_use
      purchaseOrder = MyOrdersList(orderList: List());
    } else {
      purchaseOrder = purchaseOrderList;
    }

    if (purchaseOrderList != null) {
      if(purchaseOrderList.orderList != null || purchaseOrderList.orderList.isNotEmpty){
        if (purchaseOrderList.orderList.length < 10) {
          canPaging = false;
        }
      }
    }

    orderPageLength++;

    if (this.state.mounted) {
      // ignore: invalid_use_of_protected_member
      state.setState(() {});
    }
  }

  getPurchaseOrderApi(int i) async {
    Loader().showLoader(state.context);
    var purchaseOrderList = await RestApi.getMyOrderApi(i);
    Loader().hideLoader(state.context);
    purchaseOrder.orderList = [];
    purchaseOrder.orderList.addAll(purchaseOrderList.orderList);
    state.isPaging = false;

    if (purchaseOrderList != null) {
      if(purchaseOrderList.orderList != null){
        if (purchaseOrderList.orderList.length < 10) {
          canPaging = false;
        }
      }
    }

    orderPageLength++;

    if (orderPageLength == purchaseOrder.totalPages) {
      canPaging = false;
    }
    // ignore: invalid_use_of_protected_member
    state.setState(() {});
  }
}
