import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:shoppingapp/utils/commons/export_basic_file.dart';

class CustomDrawer extends StatefulWidget {
  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<ThemeNotifier>(context);
    ThemeChanger _themeChanger = ThemeChanger(context);
    return SafeArea(
      child: Drawer(
        child: Container(
          color: themeColor.getColor(),
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(left: 15),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage("assets/images/man.png"),
                      ),
                      SizedBox(width: 14),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Nav.route(context, MyProfilePage());
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                LoginModelClass.loginModelObj
                                    .getValueForKeyFromLoginResponse(
                                        key: userName),
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    appName,
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Container(
                                    height: 10,
                                    child: Image.asset(
                                      'assets/icons/drop-down.png',
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 30),
                  Container(
                    padding: EdgeInsets.only(left: 10),
                    child: Column(
                      children: [
                        DrawerItem(
                          name: Strings.home,
                          icon: Icon(
                            Feather.home,
                            size: 19,
                            color: Colors.white,
                          ),
                          baseStyle: GoogleFonts.poppins(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 19.0,
                          ),
                          onTap: () {
                            GlobalModelClass.globalObject.selectedTabBarItem =
                                0;
                            Nav.route(context, HomeNavigator());
                          },

                        ),
                        DrawerItem(
                          name: Strings.receivedord,
                          icon: Image.asset("assets/icons/check-list.png",color: Colors.white,height: 19,width: 19,),
                          baseStyle: GoogleFonts.poppins(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 19.0,
                          ),
                          onTap: () {
                            GlobalModelClass.globalObject.selectedTabBarItem = 3;
                            Nav.route(context, HomeNavigator());
                          },
                        ),
                        DrawerItem(
                          name: Strings.Favourites,
                          baseStyle: GoogleFonts.poppins(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 19.0,
                          ),
                          icon: Icon(
                            Feather.heart,
                            size: 19,
                            color: Colors.white,
                          ),
                          onTap: () {
                            Nav.route(context, FavoriteProductsPage());
                          },
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors.white.withOpacity(0.6),
                        ),
                        SizedBox(height: 17),
                        // DrawerItem(
                        //   icon: Icon(
                        //     Feather.check_square,
                        //     size: 19,
                        //     color: Colors.white,
                        //   ),
                        //   name: Strings.themes,
                        //   baseStyle: GoogleFonts.poppins(
                        //     color: Colors.white.withOpacity(0.6),
                        //     fontSize: 19.0,
                        //   ),
                        //   onTap: () async {
                        //     SharedPreferences prefs =await SharedPreferences.getInstance();
                        //     setState(() {
                        //       showMBPrimaryColor = false;
                        //       prefs.remove("showMBPrimaryColor");
                        //       prefs.setBool("showMBPrimaryColor", showMBPrimaryColor);
                        //       tempName =  "MILLBORN-Jaipur-changeDueToTheme";
                        //       prefs.setString("Theme", tempName);
                        //     });
                        //     _themeChanger
                        //         .openFullMaterialColorPicker(themeColor);
                        //   },
                        // ),
                        DrawerItem(
                          onTap: () {
                            Nav.route(context, ContactPage());
                          },
                          icon: Icon(
                            Icons.call,
                            size: 19,
                            color: Colors.white,
                          ),
                          name: Strings.contact,
                          baseStyle: GoogleFonts.poppins(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 19.0,
                            fontWeight: FontWeight.w200,
                          ),
                          colorLineSelected: Colors.orange,
                        ),
                        DrawerItem(
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
                                          color:mainColor,
                                          fontSize: 19,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      onPressed: () async{
                                        ///when millBorn App unComment This 4 line
                                       // SharedPreferences prefs = await SharedPreferences.getInstance();
                                       //  prefs.remove("Theme");
                                       //  prefs.remove('color');
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
                          icon: Icon(
                            Icons.directions_walk_outlined,
                            size: 19,
                            color: Colors.white,
                          ),
                          name: 'Logout',
                          baseStyle: GoogleFonts.poppins(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 19.0,
                              fontWeight: FontWeight.w200),
                          colorLineSelected: Colors.orange,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
