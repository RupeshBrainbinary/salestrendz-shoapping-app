import 'dart:convert';

import 'package:shoppingapp/models/BookOrderModel.dart';
import 'package:shoppingapp/models/wishlist_model.dart';
import 'package:shoppingapp/screen/category/category_level1/category_level1.dart';
import 'package:shoppingapp/utils/api/api.dart';
import 'package:shoppingapp/widgets/commons/full_screen_loader.dart';

class Category1FavoriteViewModel {
  CategoryLevel1State state;

  WishlistModel productLike;

  Category1FavoriteViewModel(this.state) {
    // getAboutusApi();
  }

  getFavoriteApi(
      {String wishListStatus, String productId, String wishListId}) async {
    Loader().showLoader(state.context);
    var wish = await RestApi.getWishListFromServer(
      wishListStatus: wishListStatus,
      wishListId: wishListId,
      productId: productId,
    );
    Loader().hideLoader(state.context);
    BookOrderModel.orderModelObj.refreshViewForOrderBooking();
    // ignore: invalid_use_of_protected_member
    state.setState(() {});
    return jsonDecode(wish)['wishlist_details'];
  }
}


