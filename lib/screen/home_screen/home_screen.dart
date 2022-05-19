import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shoppingapp/app_url_name_companyid.dart';
import 'package:shoppingapp/models/BookOrderModel.dart';
import 'package:shoppingapp/models/GlobalModelClass.dart';
import 'package:shoppingapp/models/LoginModelClass.dart';
import 'package:shoppingapp/screen/home_screen/home_view_model.dart';
import 'package:shoppingapp/screen/home_screen/widget/blockbuster_deals/blockbuster_deals.dart';
import 'package:shoppingapp/screen/home_screen/widget/product_list.dart';
import 'package:shoppingapp/screen/home_screen/widget/product_list_titlebar.dart';
import 'package:shoppingapp/screen/home_screen/widget/search_box.dart';
import 'package:shoppingapp/screen/home_screen/widget/slider_dot.dart';
import 'package:shoppingapp/screen/home_screen/widget/trending_deals/trending_deals.dart';
import 'package:shoppingapp/screen/homepage_deals/blockbuster_deals_screen/blockbuster_deals_page.dart';
import 'package:shoppingapp/screen/homepage_deals/trending_deals_screen/trending_deals_page.dart';
import 'package:shoppingapp/screen/product_may_like_page/products_may_like_page.dart';
import 'package:shoppingapp/utils/constants/constants_app_variables.dart';
import 'package:shoppingapp/utils/theme_notifier.dart';
import 'package:shoppingapp/widgets/commons/string_res.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  HomeViewModel model;

  var alertDialog;

  List productListArray = [];

  bool isProductApiCall = false;

  List<Widget> imageSliders;

  int carouselCurrentPage = 0;

  final searchController = TextEditingController();

  var scrollController = ScrollController();

  String version;
  String buildNumber;

  var versionCode;
  var forceUpdate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPackageInfo();
    BookOrderModel.orderModelObj.homePageRefresh = refreshView;
    if (GlobalModelClass.internetConnectionAvaiable() == true) {
      getProductsFromServer();
    } else {
      if (alertDialog == null) {
        Future.delayed(Duration.zero, () {
          alertDialog = GlobalModelClass.showAlertForNoInternetConnection(
              context, refreshView);
          alertDialog.show();
        });
      }
    }
  }

  Future<void> initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      version = info.version;
      buildNumber = info.buildNumber;
    });
    versionCode = await LoginModelClass.loginModelObj.getVersionCode();
    forceUpdate = await LoginModelClass.loginModelObj.getForceUpdate();
    if (forceUpdate.toString().toLowerCase() == "true") {
      if (versionCode.toString() != version.toString()) {
        if (alertDialog == null) {
          Future.delayed(Duration.zero, () {
            alertDialog =
                GlobalModelClass.showAlertForUpdate(context, refreshView);
            alertDialog.show();
          });
        }
      }
    }
  }

  void refreshView() {
    if (this.mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_statements
    model ?? (model = HomeViewModel(this));
    final themeColor = Provider.of<ThemeNotifier>(context);
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 252, 252, 252),
        body: Stack(
          children: [
            ListView(
              controller: scrollController,
              children: <Widget>[
              //  SearchBox(),
                NewSearchBox(),
                model.homepage == null
                    ? imageShimmer()
                    : InkWell(
                        onTap: () {},
                        child: imageSliders.isNotEmpty
                            ? CarouselSlider(
                                items: imageSliders,
                                options: CarouselOptions(
                                  autoPlay: false,
                                  height: 175,
                                  viewportFraction: 1.0,
                                  enlargeCenterPage: false,
                                  onPageChanged: (index, reason) {
                                    carouselCurrentPage = index;
                                    setState(() {});
                                  },
                                ),
                              )
                            : Container(
                                height: 175,
                                child: Center(
                                  child: Text(
                                    Strings.imagenotfound,
                                    style: GoogleFonts.roboto(
                                      fontSize: 25,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ),
                              ),
                      ),
                model.homepage == null
                    ? sliderDotShimmer()
                    : imageSliders.isNotEmpty
                        ? SliderDot(current: carouselCurrentPage)
                        :SizedBox(),
                isProductApiCall
                    ? productMayLikeShimmer()
                    : productListArray.isEmpty
                        ? Container(
                            height: 175,
                            child: Center(
                              child: Text(
                                Strings.productnotfound,
                                style: GoogleFonts.roboto(
                                  fontSize: 25,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ),
                          )
                        : ProductList(
                            refreshApi: getProductsFromServer,
                            productData: productListArray,
                            themeColor: themeColor,
                            productListTitleBar: ProductListTitleBar(
                              themeColor: themeColor,
                              title: Strings.productYouLike,
                              isCountShow: false,
                              refreshApi: getProductsFromServer,

                            ),
                          ),
                model.homepage == null
                    ? blockBusterDealsShimmer()
                    : model.homepage.blockbusterProducts != null
                        ? BlockBasterDeals(model.homepage.blockbusterProducts)
                        : SizedBox(),
                model.homepage == null
                    ? trendingDealsShimmer()
                    : model.homepage.trendingProducts != null
                        ? TrendingDeals(model.homepage.trendingProducts)
                        : SizedBox(),
              ],
            )
          ],
        ),
      ),
    );
  }

  openAlertBox(context, themeColor) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          contentPadding: EdgeInsets.only(top: 10.0),
          content: Container(
            width: 300.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 32),
                Container(
                  width: 180,
                  child: Text(
                    Strings.yourOrderHasBeenSuccessfullyCompleted,
                    style: GoogleFonts.poppins(
                      color: Color(0xFF5D6A78),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  width: 220,
                  child: RaisedButton(
                    onPressed: () {
                      Get.to(() => HomeScreen());
                    },
                    color: themeColor.getColor(),
                    child: Text(
                      Strings.okey,
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }

  getProductsFromServer() async {
    isProductApiCall = true;
    setState(() {});
    productListArray.clear();
    print("getProductsFromServer"+LoginModelClass.loginModelObj.getValueForKeyFromLoginResponse(key: 'token'));

    String loggedInUserId = LoginModelClass.loginModelObj
        .getValueForKeyFromLoginResponse(key: 'user_id');
print("EXAMPLE IN OTHER API TOKEN"+LoginModelClass.loginModelObj
    .getValueForKeyFromLoginResponse(key: 'token'));
print("listing");
print(Base_URL + productsList + '&logged_in_userid=$loggedInUserId&category_id=&brand_id&price_min&price_max&sort_by&limit=10&page=1');
    http.Response resp = await http.get(
        Uri.parse(Base_URL + productsList + '&logged_in_userid=$loggedInUserId&category_id=&brand_id&price_min&price_max&sort_by&limit=10&page=1'),
        headers: {
          'Authorization': LoginModelClass.loginModelObj
              .getValueForKeyFromLoginResponse(key: 'token'),
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        });
    if (resp.statusCode == 200) {
      productListArray = [];
      print(resp.statusCode);
      var jsonBodyResp = jsonDecode(resp.body);

      if (jsonBodyResp['status'] == true) {
        productListArray = (productListArray ?? []) + jsonBodyResp['products'];
      } else {
        productListArray = [];
      }
    } else {
      print('Error occurred while serving request');
    }
    isProductApiCall = false;
    setState(() {});
  }

  imageShimmer() {
    return Shimmer.fromColors(
        baseColor: Colors.grey[600],
        highlightColor: Colors.grey[200],
        child: Container(
          width: Get.width,
          height: 175,
          margin: EdgeInsets.only(bottom: 10, left: 15, right: 15, top: 15),
          padding: EdgeInsets.only(right: 10, left: 10),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
            borderRadius: BorderRadius.circular(5),
          ),
        ));
  }

  sliderDotShimmer() {
    return Shimmer.fromColors(
        baseColor: Colors.grey[600],
        highlightColor: Colors.grey[200],
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            width: 8.0,
            height: 8.0,
            margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF0055FF),
            ),
          ),
          Container(
            width: 8.0,
            height: 8.0,
            margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF0055FF),
            ),
          ),
          Container(
            width: 8.0,
            height: 8.0,
            margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF0055FF),
            ),
          )
        ]));
  }

  productMayLikeShimmer() {
    return Column(
      children: [
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                Strings.productYouLike,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
            InkWell(
              onTap: () async{
                Get.to(() => ProductLikeDetailPage());

              },
              child: Padding(
                padding: EdgeInsets.only(right: 20),
                child: Text(
                  Strings.viewall,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 5),
        Divider(height: 3),
        SizedBox(height: 8),
        Shimmer.fromColors(
          baseColor: Colors.grey[600],
          highlightColor: Colors.grey[200],
          child: Container(
            height: 250,
            width: Get.width,
            child: ListView.builder(
              itemCount: 10,
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  width: 170,
                  margin: EdgeInsets.only(bottom: 10, left: 10),
                  padding: EdgeInsets.only(right: 10, left: 10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(5),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  blockBusterDealsShimmer() {
    return Column(
      children: [
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                Strings.blockbusterDeals,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Get.to(() => BlockBusterDealsPage());
              },
              child: Padding(
                padding: EdgeInsets.only(right: 20),
                child: Text(
                  Strings.viewall,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 5),
        Divider(height: 3),
        SizedBox(height: 8),
        Shimmer.fromColors(
          baseColor: Colors.grey[600],
          highlightColor: Colors.grey[200],
          child: Container(
            height: 250,
            width: Get.width,
            child: ListView.builder(
              itemCount: 10,
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  width: 170,
                  margin: EdgeInsets.only(bottom: 10, left: 10),
                  padding: EdgeInsets.only(right: 10, left: 10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(5),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  trendingDealsShimmer() {
    return Column(
      children: [
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                Strings.trendingDeals,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Get.to(() => TrendingDealPage());
              },
              child: Padding(
                padding: EdgeInsets.only(right: 20),
                child: Text(
                  Strings.viewall,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 5),
        Divider(height: 3),
        SizedBox(height: 8),
        Shimmer.fromColors(
          baseColor: Colors.grey[600],
          highlightColor: Colors.grey[200],
          child: Container(
            height: 250,
            width: Get.width,
            child: ListView.builder(
              itemCount: 10,
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  width: 170,
                  margin: EdgeInsets.only(bottom: 10, left: 10),
                  padding: EdgeInsets.only(right: 10, left: 10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(5),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
