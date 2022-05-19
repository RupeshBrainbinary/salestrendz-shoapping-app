import 'package:shoppingapp/utils/commons/export_basic_file.dart';
import 'package:shoppingapp/models/supplierlist_response_model.dart';

class ProductDetailWishlistViewModel {
  ProductDetailPageState state;

  WishlistModel detailProductLike;

  ProductDetailWishlistViewModel(this.state) {
    //
  }

  getFavoriteApi(
      {String wishListStatus, String productId, String wishListId}) async {
    Loader().showLoader(state.context);
    var wish = await RestApi.getWishListFromServer(
        wishListStatus: wishListStatus,
        wishListId: wishListId,
        productId: productId);
    Loader().hideLoader(state.context);
    BookOrderModel.orderModelObj.refreshViewForOrderBooking();
    // ignore: invalid_use_of_protected_member
    state.setState(() {});
    return jsonDecode(wish)['wishlist_details'];
  }
}

class SuppliersListViewModel {
  ProductDetailPageState state;
  int supplierPageLength = 0;
  bool canPaging = true;

  SupplierViewModel supplierModel;

  SuppliersListViewModel(this.state) {
    getSupplierListInitial();
  }

  getSupplierListInitial() async {
    var supplier = await RestApi.getSupplierFromServer(1, '');

    if (supplier == null) {
      // ignore: deprecated_member_use
      supplierModel = SupplierViewModel(supplierLists: List());
    } else {
      supplierModel = supplier;
    }

    if (supplier != null) {
      if (supplier.supplierLists != null) {
        if (supplier.supplierLists.length < 15) {
          canPaging = false;
        }
      }
    }

    supplierPageLength++;

    if (state.mounted) {
      // ignore: invalid_use_of_protected_member
      state.setState(() {});
    }
  }

  getSupplierListApi(int i) async {
    Loader().showLoader(state.context);
    var supList = await RestApi.getSupplierFromServer(state.page, '');
    Loader().hideLoader(state.context);
    supplierModel.supplierLists.addAll(supList.supplierLists);
    state.isPaging = false;

    supplierPageLength++;

    if (supList != null) {
      if (supList.supplierLists != null) {
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

class StockViewModel {
  ProductDetailPageState state;

  ProductStockViewModel qtystock;

  StockViewModel(this.state) {
    getProductStockApi();
  }

  getProductStockApi() async {
    var qtyStockNumber = await RestApi.getProductStockFromServer(
        state.productId,
        state.selectSupplierId,
        state.selectAccountId,
        state.selectAccountType);

    if (qtyStockNumber == null) {
      // ignore: deprecated_member_use
      qtystock = ProductStockViewModel(inventoryProduct: List());
    } else {
      qtystock = qtyStockNumber;
    }

    if (this.state.mounted) {
      // ignore: invalid_use_of_protected_member
      state.setState(() {});
    }
  }
}
