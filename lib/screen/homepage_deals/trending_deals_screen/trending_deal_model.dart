import 'dart:convert';

import 'package:shoppingapp/models/BookOrderModel.dart';
import 'package:shoppingapp/models/homepage_model.dart';
import 'package:shoppingapp/models/wishlist_model.dart';
import 'package:shoppingapp/screen/homepage_deals/trending_deals_screen/trending_deals_page.dart';
import 'package:shoppingapp/utils/api/api.dart';
import 'package:shoppingapp/widgets/commons/full_screen_loader.dart';

class TrendingDealPageViewModel {
  TrendingDealPageState state;

  int orderPageLength = 0;
  bool canPaging = true;

  HomePageModel homepage;

  TrendingDealPageViewModel(this.state) {
    getHomePageApiInitial();
  }

  getHomePageApiInitial() async {
    var homepageList =
        await RestApi.getHomePageData(1, state.searchController.text.trim());

    if (homepageList == null) {
      homepage = HomePageModel(trendingProducts: null);

    } else {
      homepage = homepageList;
    }

    if (homepageList != null) {
      if (homepageList.trendingProducts.data != null) {
        if (homepageList.trendingProducts.data.length < 15) {
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
    var homepageList =
        await RestApi.getHomePageData(i, state.searchController.text.trim());
    Loader().hideLoader(state.context);
    homepage.trendingProducts.data.addAll(homepageList.trendingProducts.data);
    state.isPaging = false;

    orderPageLength++;

    if (homepageList != null) {
      if (homepageList.trendingProducts.data != null) {
        if (homepageList.trendingProducts.data.length < 15) {
          canPaging = false;
        }
      }
    }

    if (orderPageLength == homepage.trendingProducts.lastPage) {
      canPaging = false;
    }
    // ignore: invalid_use_of_protected_member
    state.setState(() {});
  }
}

class TrendingDealFavoriteViewModel {
  TrendingDealPageState state;

  WishlistModel productLike;

  TrendingDealFavoriteViewModel(this.state) {
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
