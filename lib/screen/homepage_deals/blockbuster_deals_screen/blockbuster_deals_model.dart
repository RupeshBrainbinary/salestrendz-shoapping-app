import 'dart:convert';

import 'package:shoppingapp/models/BookOrderModel.dart';
import 'package:shoppingapp/models/homepage_model.dart';
import 'package:shoppingapp/models/wishlist_model.dart';
import 'package:shoppingapp/screen/homepage_deals/blockbuster_deals_screen/blockbuster_deals_page.dart';
import 'package:shoppingapp/utils/api/api.dart';
import 'package:shoppingapp/widgets/commons/full_screen_loader.dart';

class BlockBasterPageViewModel {
  BlockBusterDealsPageState state;
  int orderPageLength = 0;
  bool canPaging = true;

  HomePageModel homepage;

  BlockBasterPageViewModel(this.state) {
    getHomePageApiInitial();
  }

  getHomePageApiInitial() async {
    var homepageList =
        await RestApi.getHomePageData(1, state.searchController.text.trim());

    if (homepageList == null) {
      homepage = HomePageModel(blockbusterProducts: null);
    } else {
      homepage = homepageList;
    }

    if (homepageList != null) {
      if (homepageList.blockbusterProducts.data != null ||
          homepageList.blockbusterProducts.data.isNotEmpty) {
        if (homepageList.blockbusterProducts.data.length < 15) {
          canPaging = false;
        }
      }
    }

    orderPageLength++;
    // ignore: invalid_use_of_protected_member
    state.setState(() {});
  }

  getHomePageApi(int i) async {
    Loader().showLoader(state.context);
    HomePageModel homepageList =
        await RestApi.getHomePageData(i, state.searchController.text.trim());
    Loader().hideLoader(state.context);
    homepage.blockbusterProducts.data
        .addAll(homepageList.blockbusterProducts?.data ?? null);
    state.isPaging = false;

    orderPageLength++;

    if (homepageList != null) {
      if (homepageList.blockbusterProducts.data != null ||
          homepageList.blockbusterProducts.data.isNotEmpty) {
        if (homepageList.blockbusterProducts.data.length < 15) {
          canPaging = false;
        }
      }
    }

    if (orderPageLength == homepage.blockbusterProducts.lastPage) {
      canPaging = false;
    }
    // ignore: invalid_use_of_protected_member
    state.setState(() {});
  }
}

class BlockbusterDealsFavoriteViewModel {
  BlockBusterDealsPageState state;

  WishlistModel productlike;

  BlockbusterDealsFavoriteViewModel(this.state) {
    //
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
