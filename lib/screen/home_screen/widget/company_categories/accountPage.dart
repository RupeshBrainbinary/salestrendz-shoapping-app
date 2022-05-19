import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shoppingapp/screen/drawer/drawer.dart';
import 'package:shoppingapp/utils/theme_notifier.dart';
import 'package:shoppingapp/widgets/commons/string_res.dart';

import 'company_categories_model.dart';

class AccountScreen extends StatefulWidget {
  @override
  AccountScreenState createState() => AccountScreenState();
}

class AccountScreenState extends State<AccountScreen> {
  CompanyCategoriesViewModel model;
  bool brands = false;

  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_statements
    model ?? (model = CompanyCategoriesViewModel(this));
    final themeColor = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        toolbarHeight: 80,
        centerTitle: true,
        actions: [
          Container(width: Get.width / 4.5),
        ],
        title: Column(
          children: [
            Text(
              Strings.selectacc,
              style: GoogleFonts.roboto(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            InkWell(
              onTap: () {
                if (brands == false) {
                  brands = true;
                } else {
                  brands = false;
                }
                setState(() {});
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    brands == true ? Strings.OtherBrands : Strings.ownbrands,
                    style: GoogleFonts.roboto(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down_sharp,
                    color: Colors.white.withOpacity(0.9),
                  )
                ],
              ),
            ),
          ],
        ),
        elevation: 0.0,
        // backgroundColor: themeColor.getColor(),
        //   leading: IconButton(
        //     icon: Icon(Icons.arrow_back, color: Colors.white),
        //     onPressed: () {
        //       Get.back();
        //     }
        // ),
      ),
      body: model.companyCategories == null
          ? Center(child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(themeColor.getColor())))
          : SingleChildScrollView(
              child: Stack(
                children: [
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: themeColor.getColor(),
                      // borderRadius: BorderRadius.only(
                      //   topLeft: Radius.zero,
                      //   topRight: Radius.zero,
                      //   bottomLeft: Radius.circular(22.0),
                      //   bottomRight: Radius.circular(22.0),
                      // ),
                    ),
                    // padding: EdgeInsets.only(top: 10),
                    // margin: EdgeInsets.symmetric(horizontal: 5,),
                  ),
                  if (brands == true)
                    Container(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: model.companyCategories.brands.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {},
                            child: Container(
                              margin: EdgeInsets.only(
                                left: 10,
                                right: 10,
                                bottom: 10,
                                top: 10,
                              ),
                              padding: EdgeInsets.only(
                                top: 10,
                                left: 10,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 1.0,
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.all(8),
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.6),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                      // image: DecorationImage(
                                      //     image: AssetImage('assets/images/bigflex.jpg')
                                      // ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Mo',
                                        style: GoogleFonts.roboto(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Container(
                                  //   child: Image.asset(
                                  //     "assets/images/
                                  //     prodcut8.png",
                                  //     height: 70,
                                  //     width: 70,
                                  //   ),
                                  // ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          model.companyCategories.brands[index]
                                              .brandName,
                                          style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.call_outlined,
                                              color:
                                                  Colors.black.withOpacity(0.6),
                                              size: 15,
                                            ),
                                            Text(
                                              '+91-9820098520',
                                              style: GoogleFonts.roboto(
                                                color: Colors.black
                                                    .withOpacity(0.6),
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: Container(
                                            padding: EdgeInsets.all(3),
                                            height: 20,
                                            width: Get.width / 2.9,
                                            decoration: BoxDecoration(
                                              color: themeColor.getColor(),
                                              borderRadius: BorderRadius.only(
                                                bottomRight:
                                                    Radius.circular(10),
                                              ),
                                            ),
                                            child: Row(
                                              // crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  Strings.requestsingup,
                                                  maxLines: 1,
                                                  style: GoogleFonts.roboto(
                                                    color: Colors.white,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.arrow_forward,
                                                  color: Colors.white,
                                                  size: 15,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  else
                    Container(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: model.companyCategories.categories.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {},
                            child: Container(
                              margin: EdgeInsets.only(
                                left: 10,
                                right: 10,
                                bottom: 10,
                                top: 10,
                              ),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 1.0,
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.all(8),
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.6),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/bigflex.jpg'),
                                      ),
                                    ),
                                  ),
                                  // Container(
                                  //   child: Image.asset(
                                  //     "assets/images/prodcut8.png",
                                  //     height: 70,
                                  //     width: 70,
                                  //   ),
                                  // ),
                                  SizedBox(width: 18),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          model.companyCategories
                                              .categories[index].productCatName,
                                          style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.call_outlined,
                                              color:
                                                  Colors.black.withOpacity(0.6),
                                              size: 15,
                                            ),
                                            Text(
                                              '+91-9988776655',
                                              style: GoogleFonts.roboto(
                                                color: Colors.black
                                                    .withOpacity(0.6),
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 25,
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.8),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                    child: Center(
                                      child: Text(
                                        model.companyCategories
                                            .categories[index].totalProducts
                                            .toString(),
                                        style: GoogleFonts.roboto(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
