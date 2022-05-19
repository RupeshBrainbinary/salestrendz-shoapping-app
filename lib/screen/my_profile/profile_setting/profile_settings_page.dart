import 'dart:io';
import 'package:shoppingapp/screen/my_profile/profile_setting/address_pages/address_page.dart';
import 'package:shoppingapp/screen/my_profile/profile_setting/change_password/change_password_page.dart';
import 'package:shoppingapp/utils/commons/export_basic_file.dart';

import 'package:flutter/material.dart';

class MyProfileSettings extends StatefulWidget {
  @override
  _MyProfileSettingsState createState() => _MyProfileSettingsState();
}

class _MyProfileSettingsState extends State<MyProfileSettings> {
  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<ThemeNotifier>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: Icon(
              Platform.isAndroid ? Icons.arrow_back : Icons.chevron_left,
            ),
          ),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          title: Text(
            Strings.profile,
            style: GoogleFonts.poppins(color: Colors.black),
          ),
          centerTitle: true,
        ),
        backgroundColor: Color(0xFFFCFCFC),
        body: Container(
          padding: EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    Column(
                      children: [
                        Text(
                          Strings.ProfileSettings,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: Color(0xFF5D6A78),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  width: 28,
                  child: Divider(
                    color: themeColor.getColor(),
                    height: 3,
                    thickness: 2,
                  ),
                ),
                SizedBox(height: 16),
                ListTile(
                  onTap: () {
                    Nav.route(context, AddressPage());
                  },
                  leading: Image.asset(
                    "assets/icons/ic_location.png",
                    width: 22,
                  ),
                  title: Text(
                    Strings.Address,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: Color(0xFF5D6A78),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                ListTile(
                  onTap: () {
                    Nav.route(context, ChangePasswordPage());
                  },
                  leading: Image.asset(
                    "assets/icons/ic_lock.png",
                    width: 22,
                  ),
                  title: Text(
                    Strings.ChangePassword,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: Color(0xFF5D6A78),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                ListTile(
                  onTap: () {
                    Nav.route(context, EditUserInfoPage());
                  },
                  leading: Image.asset(
                    "assets/icons/ic_user.png",
                    width: 22,
                  ),
                  title: Text(
                    Strings.MyUserInfo,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: Color(0xFF5D6A78),
                    ),
                  ),
                ),
                // SizedBox(
                //   height: 16,
                // ),
                // ListTile(
                //   onTap: () {
                //     Nav.route(context, NotificationSettingsPage());
                //   },
                //   leading: Image.asset(
                //     "assets/icons/ic_notification.png",
                //     width: 22,
                //   ),
                //   title: Text(Strings.notificationSetting,
                //       style: GoogleFonts.poppins(
                //           fontSize: 15, color: Color(0xFF5D6A78))),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
