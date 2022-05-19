import 'package:shoppingapp/models/OdertrasectionModel.dart';
import 'package:shoppingapp/screen/my_profile/my_orders/orders_detail_page.dart';
import 'package:shoppingapp/utils/api/api.dart';
import 'package:shoppingapp/widgets/commons/full_screen_loader.dart';

class OrderViewModel {
  OrdersDetailPageState state;
  int orderPageLength = 0;
  bool canPaging = true;

  MyOrdersList myOrdersList;

  OrderViewModel(this.state) {
    getOrderApiInitial();
  }

  getOrderApiInitial() async {
    var orderList = await RestApi.getMyOrderApi(1);

    if (orderList == null) {
      // ignore: deprecated_member_use
      myOrdersList = MyOrdersList(orderList: List());
    } else {
      myOrdersList = orderList;
    }

    if (orderList != null) {
      if (orderList.orderList != null) {
        if (orderList.orderList.length < 10) {
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

  getOrderApi(int i) async {
    Loader().showLoader(state.context);
    var purchaseOrderList = await RestApi.getMyOrderApi(i);
    Loader().hideLoader(state.context);
    myOrdersList.orderList.addAll(purchaseOrderList.orderList);
    state.isPaging = false;
    // state.page++;
    orderPageLength++;

    if (purchaseOrderList != null) {
      if (purchaseOrderList.orderList != null) {
        if (purchaseOrderList.orderList.length < 10) {
          canPaging = false;
        }
      }
    }

    if (orderPageLength == myOrdersList.totalPages) {
      canPaging = false;
    }
    // ignore: invalid_use_of_protected_member
    state.setState(() {});
  }
}
