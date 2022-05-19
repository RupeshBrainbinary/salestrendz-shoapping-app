import 'dart:convert';
import 'package:shoppingapp/utils/commons/export_basic_file.dart';
import 'package:shoppingapp/models/productMayLikeModel.dart';

class ProductLikeDetailPageViewModel {
  ProductLikeDetailPageState state;
  int productPageLength = 0;
  bool canPaging = true;

  ProductLikeModel productLike;

  ProductLikeDetailPageViewModel(this.state) {
    getProductLikeApiInitial();
  }

  getProductLikeApiInitial() async {
    var product = await RestApi.getProductLikeData(
        1, state.searchController.text.trim(), "");

    print(product);

    if (product == null) {
      // ignore: deprecated_member_use
      productLike = ProductLikeModel(products: List());
    } else {
      productLike = product;
    }

    if (product != null) {
      if(product.products != null){
        if (product.products.length < 15) {
          canPaging = false;
        }
      }
    }

    productPageLength++;

    if(state.mounted){
      // ignore: invalid_use_of_protected_member
      state.setState(() {});
    }
  }

  getProductLikeApi(int i) async {
    Loader().showLoader(state.context);
    var productList = await RestApi.getProductLikeData(
        i, state.searchController.text.trim(), "");
    Loader().hideLoader(state.context);
    productLike.products.addAll(productList.products);
    state.isPaging = false;

    productPageLength++;

    if (productList != null) {
      if(productList.products != null){
        if (productList.products.length < 15) {
          canPaging = false;
        }
      }
    }

    if (productPageLength == productLike.totalPages) {
      canPaging = false;
    }

    // ignore: invalid_use_of_protected_member
    state.setState(() {});
  }
}

class FavoriteViewModel1 {
  ProductLikeDetailPageState state;

  WishlistModel productLike;

  FavoriteViewModel1(this.state) {
    // getAboutusApi();
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
