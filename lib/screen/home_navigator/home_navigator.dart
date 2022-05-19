import 'package:auto_size_text/auto_size_text.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppingapp/app_url_name_companyid.dart';
import 'package:shoppingapp/main.dart';
import 'package:shoppingapp/models/BookOrderModel.dart';
import 'package:shoppingapp/models/GlobalModelClass.dart';
import 'package:shoppingapp/models/LoginModelClass.dart';
import 'package:shoppingapp/screen/activity_pages/activity_perform_screen.dart';
import 'package:shoppingapp/screen/auth_screens/login/login_form.dart';
import 'package:shoppingapp/screen/category/category_level1/category_level1.dart';
import 'package:shoppingapp/screen/drawer/drawer.dart';
import 'package:shoppingapp/screen/home_screen/home_screen.dart';
import 'package:shoppingapp/screen/ledgers_pages/ledgers_main_page.dart';
import 'package:shoppingapp/screen/order_transaction/order_transaction.dart';
import 'package:shoppingapp/utils/theme_notifier.dart';

class HomeNavigator extends StatefulWidget {
  @override
  _HomeNavigatorState createState() => _HomeNavigatorState();
}

class _HomeNavigatorState extends State<HomeNavigator> {
  int currentTabId = 0;
  List<Widget> _pages = [
    HomeScreen(),
    CategoryLevel1(),
    ActivityProfile(),
    OrderTransaction(
      pageRouteType: OrderTransactionType.homePage,
    ),
    LedgersMainPage()
  ];

  var versionCode;
  var forceUpdate;
  var alertDialog;
  String version;
  String buildNumber;

  void refreshView() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BookOrderModel.orderModelObj.homeNavigatorRefresh = refreshView;
    getMillBornColor();
  }

  getMillBornColor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      showMBPrimaryColor = prefs.getBool("showMBPrimaryColor");
    });
  }

  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

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

  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<ThemeNotifier>(context);
    FlutterStatusbarcolor.setStatusBarColor(themeColor.getColor());
    print("Current page --> $runtimeType");
    return Scaffold(
      key: _drawerKey,
      appBar: currentTabId == 1
      // currentTabId == 3 ? null :
          ? AppBar(
              toolbarHeight: 0,
              elevation: 0.0,
            )
          : currentTabId == 4
              ? null
              : currentTabId != 2
                  ? AppBar(
                      elevation: 0,
                      toolbarHeight: currentTabId != 3 ? 50 : 60,
                      iconTheme: IconThemeData(color: themeColor.getColor()),
                      backgroundColor: Colors.white,
                      title: InkWell(
                        child: currentTabId != 3
                            ? Row(
                                children: [
                                  Expanded(
                                    child: AutoSizeText(
                                      appName,
                                      style: GoogleFonts.roboto(
                                        color: themeColor.getColor(),
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 1,
                                      maxFontSize: 18,
                                      minFontSize: 10,
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Center(
                                          child: AutoSizeText(
                                            appName,
                                            style: GoogleFonts.roboto(
                                              color: themeColor.getColor(),
                                              fontWeight: FontWeight.w600,
                                            ),
                                            maxLines: 1,
                                            maxFontSize: 20,
                                            minFontSize: 10,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Center(
                                    child: Text(
                                      "Orders",
                                      style: GoogleFonts.roboto(
                                        fontSize: 15,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                      ),
                      actions: [
                        // InkWell(
                        //     onTap: () {
                        //
                        //       },
                        //     child: Icon(
                        //       Icons.filter_alt_outlined,
                        //       color: Colors.red,
                        //       size: 30,
                        //     )),
                        // SizedBox(
                        //   width: 20,
                        // ),
                        AppBarButtonWidget(
                          themeColor: themeColor,
                        ),
                      ],
                    )
                  : AppBar(
                      toolbarHeight: 170,
                      backgroundColor: themeColor.getColor(),
                      elevation: 0,
                      centerTitle: true,
                      title: Text(
                        "Select New",
                        style: GoogleFonts.roboto(fontWeight: FontWeight.w600),
                      ),
                      bottom: PreferredSize(
                        preferredSize: Size.fromHeight(30),
                        child: Text(
                          'Activity you want to perform',
                          style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
      drawer: CustomDrawer(),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey,
              blurRadius: 10,
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.only(bottom: 0),
          child: ConvexAppBar(
            height: 60,
            color: Color(0xFF5D6A78),
            backgroundColor: Colors.white,
            activeColor: themeColor.getColor(),
            elevation: 0.5,
            top: -28,
            onTap: (int val) {
              print(val);
              currentTabId = val;
              if (val ==
                  (GlobalModelClass.globalObject.selectedTabBarItem ?? 0))
                return;
              setState(() {
                GlobalModelClass.globalObject.selectedTabBarItem = val;
              });
            },
            curveSize: 10,
            initialActiveIndex:
                GlobalModelClass.globalObject.selectedTabBarItem,
            style: TabStyle.fixedCircle,
            items: <TabItem>[
              TabItem(icon: Feather.home, title: ''),
              TabItem(icon: Feather.box, title: ''),
              TabItem(icon: bottomCenterItem(themeColor), title: ''),
              TabItem(icon: Feather.shopping_bag, title: ''),
              TabItem(icon: Icons.qr_code_scanner, title: ''),
            ],
          ),
        ),
      ),
      body: _pages[GlobalModelClass.globalObject.selectedTabBarItem ?? 0],
    );
  }

  bottomCenterItem(ThemeNotifier themeColor) {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.8),
                  blurRadius: 10,
                  offset: Offset(0, 0),
                  spreadRadius: 1,
                ),
              ],
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Align(
              child: Icon(
                Icons.add,
                color: themeColor.getColor(),
                size: 45,
              ),
              alignment: Alignment.center,
            ),
          ),
        ],
      ),
    );
  }
}
