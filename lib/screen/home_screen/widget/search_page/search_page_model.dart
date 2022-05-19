import 'package:flutter/material.dart';
import 'package:shoppingapp/models/BookOrderModel.dart';
import 'package:shoppingapp/models/home_page_search_model.dart';
import 'package:shoppingapp/screen/home_screen/widget/search_page/search_page.dart';
import 'package:shoppingapp/utils/api/api.dart';
import 'package:shoppingapp/utils/theme_notifier.dart';
import 'package:shoppingapp/widgets/commons/full_screen_loader.dart';

class HomeSearchViewModel {
  SearchPageState state;
  int productPageLength = 0;
  bool canPaging = true;

  HomePageSearch product;

  HomeSearchViewModel(this.state) {
    getSearchProductInitial();
  }

  getSearchProductInitial() async {
    var searchProduct =
        await RestApi.getSearchProduct(state.searchController.text.trim(), 1);

    if (searchProduct == null) {
      // ignore: deprecated_member_use
      product = HomePageSearch(products: List());
    } else {
      product = searchProduct;
    }

    productPageLength++;

    if (searchProduct != null) {
      if(searchProduct.products != null){
        if (searchProduct.products.length < 20) {
          canPaging = false;
        }
      }
    }

    // ignore: invalid_use_of_protected_member
    state.setState(() {});
  }

  getSearchProductApi(int i) async {
    Loader().showLoader(state.context,);
    var productList =
        await RestApi.getSearchProduct(state.searchController.text.trim(), i);
    Loader().hideLoader(state.context);
    product.products.addAll(productList.products);
    state.isPaging = false;

    productPageLength++;

    if (productList != null) {
      if(productList.products != null){
        if (productList.products.length < 20) {
          canPaging = false;
        }
      }
    }

    if (productPageLength == product.totalPages) {
      canPaging = false;
    }

    // ignore: invalid_use_of_protected_member
    state.setState(() {});
  }
/*  Widget addToCartBtnWidget(
      int index, ThemeNotifier themeColor, BuildContext context) {
    return InkWell(
      onTap: () {
        Loader().showLoader(context);
        BookOrderModel.orderModelObj.refreshViewForOrderBooking();
        getProductDetailsAndAddToCart(
          context,
          catProduct[index]['product_id'].toString(),
          index,
          catProduct[index]['min_qty'] ?? 1,
        );
        BookOrderModel.orderModelObj.refreshViewForOrderBooking();
        setState(() {});
      },
      child: Container(
        margin: EdgeInsets.only(right: 15),
        padding: EdgeInsets.fromLTRB(10, 5, 8, 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: themeColor.getColor())),
        child: Row(
          children: [
            Image.asset(
              "assets/icons/shopping-cart.png",
              height: 18,
              width: 20,
              color: themeColor.getColor(),
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              Strings.addToCart,
              style: GoogleFonts.poppins(color: themeColor.getColor()),
            ),
          ],
        ),
      ),
    );
  }*/

}
