import 'package:shoppingapp/models/supplierlist_response_model.dart';
import 'package:shoppingapp/screen/cart_screen/confirm_order_screen/confirmOrderVC.dart';
import 'package:shoppingapp/utils/api/api.dart';
import 'package:shoppingapp/widgets/commons/full_screen_loader.dart';

class ConfirmOrderViewModel {
  ConfirmOrderWidgetClass state;
  int supplierPageLength = 0;
  bool canPaging = true;

  SupplierViewModel supplierModel;

  ConfirmOrderViewModel(this.state) {
    getSupplierListInitial();
  }

  getSupplierListInitial() async {
    var supplier = await RestApi.getSupplierFromServer(1,state.searchController.text.trim());

    if (supplier == null) {
      supplierModel = SupplierViewModel(supplierLists: List());
    } else {
      supplierModel = supplier;
    }

    if (supplier != null) {
      if(supplier.supplierLists != null){
        if (supplier.supplierLists.length < 15) {
          canPaging = false;
        }
      }
    }

    supplierPageLength++;

    // ignore: invalid_use_of_protected_member
    state.setState(() {});
  }

  getSupplierListApi(int i) async {
    Loader().showLoader(state.context);
    var supList = await RestApi.getSupplierFromServer(state.page,state.searchController.text.trim());
    Loader().hideLoader(state.context);
    supplierModel.supplierLists.addAll(supList.supplierLists);
    state.isPaging = false;

    supplierPageLength++;

    if (supList != null) {
      if(supList.supplierLists != null){
        if (supList.supplierLists.length < 15) {
          canPaging = false;
        }
      }
    }

    if (supplierPageLength == supplierModel.totalPages) {
      canPaging = false;
    }

    // ignore: invalid_use_of_protected_member
    state.setState(() {});
  }
}
