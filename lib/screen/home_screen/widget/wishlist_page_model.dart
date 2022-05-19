import 'dart:convert';

import 'package:shoppingapp/models/BookOrderModel.dart';
import 'package:shoppingapp/models/wishlist_model.dart';
import 'package:shoppingapp/screen/drawer/favorites_product/favorite_products_page.dart';
import 'package:shoppingapp/screen/home_screen/widget/product_card.dart';
import 'package:shoppingapp/utils/api/api.dart';
import 'package:shoppingapp/widgets/commons/full_screen_loader.dart';

class WishListViewModel {
  ProductCardState state;

  WishlistModel wishlist;

  WishListViewModel(this.state) {
    // getAboutusApi();
  }

  getAboutusApi(
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
  }
}

class FavoriteViewModel {
  FavoriteProductsPageState state;

  WishlistModel wishlist;

  FavoriteViewModel(this.state) {
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
