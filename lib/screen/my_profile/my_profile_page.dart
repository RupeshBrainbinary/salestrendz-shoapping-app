import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:shoppingapp/utils/commons/export_basic_file.dart';

class MyProfilePage extends StatefulWidget {
  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<ThemeNotifier>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            AppBarButtonWidget(
              themeColor: themeColor,
            )
          ],
          iconTheme: IconThemeData(
            color: themeColor.getColor(),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: Text(
            appName,
            style: GoogleFonts.poppins(
              color: themeColor.getColor(),
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        drawer: CustomDrawer(),
        body: Container(
          height: Get.height,
          color: Colors.white,
          padding: EdgeInsets.only(right: 24, left: 24, top: 8, bottom: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  Strings.MyProfile,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: Color(0xFF5D6A78),
                  ),
                ),
                Container(
                  width: 28,
                  child: Divider(
                    color: themeColor.getColor(),
                    height: 3,
                    thickness: 2,
                  ),
                ),
                SizedBox(height: 12),
                ListTile(
                  onTap: () {
                    Nav.route(context, OrdersDetailPage());
                  },
                  leading: Icon(
                    Feather.box,
                    color: Color(0xFF5D6A78),
                  ),
                  title: Text(
                    Strings.MyOrders,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: Color(0xFF5D6A78),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                ListTile(
                  onTap: () {
                    Nav.route(context, MyProfileSettings());
                  },
                  leading: Image.asset(
                    "assets/icons/ic_search.png",
                    width: 22,
                    color: Color(0xFF5D6A78),
                  ),
                  title: Text(
                    Strings.ProfileSettings,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: Color(0xFF5D6A78),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                // ListTile(
                //   onTap: () {
                //     Nav.route(context, LanguageSettingScreen());
                //   },
                //   leading: Image.asset(
                //     "assets/icons/ic_search.png",
                //     width: 22,
                //     color: Color(0xFF5D6A78),
                //   ),
                //   title: Text(
                //     Strings.LanguageSetting,
                //     style: GoogleFonts.poppins(
                //       fontSize: 15,
                //       color: Color(0xFF5D6A78),
                //     ),
                //   ),
                // ),
                // SizedBox(height: 12),
                // ListTile(
                //   onTap: () {
                //     Nav.route(context, NotificationSettingsPage());
                //   },
                //   leading: Image.asset(
                //     "assets/icons/ic_search.png",
                //     width: 22,
                //     color: Color(0xFF5D6A78),
                //   ),
                //   title: Text(
                //     Strings.NotificationSetting,
                //     style: GoogleFonts.poppins(
                //       fontSize: 15,
                //       color: Color(0xFF5D6A78),
                //     ),
                //   ),
                // ),
                ListTile(
                  onTap: () {
                    return showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            Strings.Logout,
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 19,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          content: Text(
                            Strings.logoutdialog,
                            style: GoogleFonts.poppins(),
                          ),
                          actions: [
                            FlatButton(
                              child: Text(
                                Strings.ok,
                                style: GoogleFonts.poppins(
                                  color: mainColor,
                                  fontSize: 19,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              onPressed: () async {
                                ///when millBorn App unComment This 4 line
                                // SharedPreferences prefs = await SharedPreferences.getInstance();
                                // prefs.remove("Theme");
                                // prefs.remove('color');
                                LoginModelClass.loginModelObj
                                    .logOutFromApplication(context);
                                // Phoenix.rebirth(context);
                              },
                            ),
                            FlatButton(
                              child: Text(
                                Strings.cancel,
                                style: GoogleFonts.poppins(
                                  color:mainColor,
                                  fontSize: 19,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              onPressed: () {
                                Get.back();
                              },
                            )
                          ],
                        );
                      },
                    );
                  },
                  leading: Icon(
                    Icons.logout,
                    size: 22,
                    color: Color(0xFF5D6A78),
                  ),
                  title: Text(
                    Strings.Logout,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: Color(0xFF5D6A78),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
