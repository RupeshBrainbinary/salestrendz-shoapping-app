import 'package:flutter/material.dart';
import 'package:shoppingapp/screen/home_screen/widget/product_card.dart';
import 'package:shoppingapp/screen/home_screen/widget/product_list_titlebar.dart';
import 'package:shoppingapp/utils/commons/export_basic_file.dart';
import 'package:shoppingapp/utils/constants/constants_app_variables.dart';
import 'package:shoppingapp/utils/theme_notifier.dart';
import 'package:shoppingapp/widgets/commons/string_res.dart';

class ProductList extends StatelessWidget {
  const ProductList(
      {Key key,
      @required this.themeColor,
      this.productListTitleBar,
      this.productData,
      this.onCallback,
      this.refreshApi})
      : super(key: key);

  final Function onCallback;
  final List productData;
  final ThemeNotifier themeColor;
  final ProductListTitleBar productListTitleBar;
  final Function refreshApi;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: getListViewForProducts(),
      ),
    );
  }

  List<Widget> getListViewForProducts() {
    List<Widget> productScrollUI = [productListTitleBar];

    if (productData.isEmpty) {
      productScrollUI.add(Center(
        child: Text(Strings.nodata),
      ));
    } else {
      for (int counter = 0;
          counter < (this.productData ?? []).length / 5;
          counter++) {
        productScrollUI.add(
          Container(
            height: 285.0,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: getWidgetsForDisplayingProduct(5 * counter),
            ),
          ),
        );
      }
      return productScrollUI;
    }
  }

  List<Widget> getWidgetsForDisplayingProduct(int offsetValue) {
    List<Widget> productsWidgets = [];

    for (int prodCounter = offsetValue;
        prodCounter < offsetValue + 5;
        prodCounter++) {
      if ((this.productData?.length ?? 0) > prodCounter) {
        Map prodDetails = this.productData[prodCounter];
        var productImageUrl = '';

        if (prodDetails['imagesize512x512'] != null &&
            !(prodDetails['imagesize512x512'] is bool) &&
            (prodDetails['imagesize512x512'] /* as List*/).length > 0) {
          productImageUrl = prodDetails['imagesize512x512'] is String
              ? prodDetails['imagesize512x512']
              : prodDetails['imagesize512x512'] is List
                  ? prodDetails['imagesize512x512'].first
                  : null;
          //for neelam package
          // (prodDetails['imagesize512x512']/* as List*/).first.toString();
          // For Q-one package
          //(prodDetails['imagesize512x512'] /* as List*/);
        }
        List<TextEditingController> qtyController = [];
        List.generate(this.productData.length,
            (index) => qtyController.add(TextEditingController()));

        productsWidgets.add(ProductCard(
          selectedProduct: prodDetails,
          themeColor: this.themeColor,
          index: prodCounter,
          imageUrl: productImageUrl,
          productPrice: prodDetails['pp_price'].toString(),
          productTitle: prodDetails['product_name'].toString(),
          brandName: (prodDetails['brand_name'].toString() == "null"
              ? prodDetails['sku'].toString() == "null"
                  ? prodDetails['product_name']
                  : prodDetails['brand_name']
              : prodDetails['brand_name']),
          refreshPage: refreshApi,
          qtyController: qtyController,
          minQty: prodDetails['min_qty'],
          ppMrp: prodDetails['pp_mrp'],
          qtyInCases: prodDetails['qty_in_cases'],
          offerList: prodDetails['scheme_on_product'].map<Map>((e) {
            if (e is Map) {
              return e;
            }
            return {};
          }).toList(),
        ));
      } else {
        break;
      }
    }
    return productsWidgets;
  }
}
