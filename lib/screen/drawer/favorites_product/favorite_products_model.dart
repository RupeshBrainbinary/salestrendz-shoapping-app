import 'package:shoppingapp/utils/commons/export_basic_file.dart';

class FavoriteProductViewModel {
  FavoriteProductsPageState state;

  WishlistModel product;

  FavoriteProductViewModel(this.state) {
    favoriteProductApi();
  }

  favoriteProductApi() async {
    var products = await RestApi.getFavoriteProductApi();

    if (products == null) {
      // ignore: deprecated_member_use
      product = WishlistModel(wishlistProducts: List());
    } else {
      product = products;
    }

    // ignore: invalid_use_of_protected_member
    state.setState(() {});
  }
}

// class FavoriteViewModel {
//   FavoriteProductsPageState state;
//
//   WishlistModel productlike;
//
//   FavoriteViewModel(this.state) {
//     // getAboutusApi();
//   }
//
//   getFavoriteApi(
//       {String wishListStatus, String productId, String wishListId}) async {
//     Loader().showLoader(state.context);
//     var wish = await RestApi.getWishListFromServer(
//         wishListStatus: wishListStatus,
//         wishListId: wishListId,
//         productId: productId);
//     Loader().hideLoader(state.context);
//     BookOrderModel.orderModelObj.refreshViewForOrderBooking();
//     // ignore: invalid_use_of_protected_member
//     state.setState(() {});
//     return jsonDecode(wish)['wishlist_details'];
//   }
// }
