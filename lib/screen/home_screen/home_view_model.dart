import 'package:flutter/material.dart';
import 'package:shoppingapp/models/homepage_model.dart';
import 'package:shoppingapp/screen/home_screen/home_screen.dart';
import 'package:shoppingapp/utils/api/api.dart';

class HomeViewModel {
  HomeScreenState state;

  HomePageModel homepage;

  HomeViewModel(this.state) {
    getHomePageApi();
  }

  getHomePageApi() async {
    var homePageList = await RestApi.getHomePageData(1, state.searchController.text.trim());

    if(homePageList == null){
      homepage = HomePageModel();
    }else{
      homepage = homePageList;
    }


    state.imageSliders = homepage?.bannerDetails?.attachments == null
        // ignore: deprecated_member_use
        ? List()
        : homepage.bannerDetails.attachments
            .map((item) => Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[200],
                        blurRadius: 5.0,
                        spreadRadius: 1,
                        offset: Offset(0.0, 1),
                      ),
                    ],
                  ),
                  margin:
                      EdgeInsets.only(left: 10, right: 10, top: 16, bottom: 16),
                  child: item?.uploadPath != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          child: Container(
                            color: Colors.red,
                            child: Image.network(
                              item.uploadPath,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      :SizedBox(),
                ))
            .toList();
    // ignore: invalid_use_of_protected_member
    state.setState(() {});
  }
}