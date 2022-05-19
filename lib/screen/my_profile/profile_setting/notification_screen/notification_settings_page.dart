import 'package:shoppingapp/utils/commons/export_basic_file.dart';
import 'package:flutter/material.dart';

class NotificationSettingsPage extends StatefulWidget {
  @override
  _NotificationSettingsPageState createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool isAllNotifications = false;
  bool isOrderNotifications = true;
  bool isFaqNotifications = true;
  bool isReminderNotifications = true;
  bool isShoppingCartReminderNotifications = true;
  bool isDiscountReminderNotifications = true;
  bool isCustomizeUserDiscountReminderNotifications = true;
  bool isUpdateReminderNotifications = true;

  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<ThemeNotifier>(context);

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Color(0xFFFCFCFC),
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: Icon(
              Icons.arrow_back,
            ),
          ),
          backgroundColor: Colors.white,
          // elevation: 0.0,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          title: Text(
            Strings.profile,
            style: GoogleFonts.poppins(color: Colors.black),
          ),
          centerTitle: true,
          // centerTitle: true,
        ),
        // appBar: AppBar(
        //   backgroundColor: Colors.white,
        //   // elevation: 0.0,
        //   iconTheme: IconThemeData(
        //     color: Colors.black,
        //   ),
        //
        //
        //   title: Text(Strings.profile,style:GoogleFonts.poppins(color: Colors.black)),
        //
        //   centerTitle: true,
        //   // centerTitle: true,
        // ),

        body: Container(
          padding: EdgeInsets.only(left: 0, right: 0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 16, top: 24),
                  child: Text(
                    Strings.notificationSetting,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Color(0xFF5D6A78),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 16),
                  width: 28,
                  child: Divider(
                    color: themeColor.getColor(),
                    height: 3,
                    thickness: 2,
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(6),
                  child: ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: <Widget>[
                      SwitchListTile(
                        onChanged: (bool value) {
                          setState(() {
                            isAllNotifications = !isAllNotifications;
                          });
                        },
                        value: isAllNotifications,
                        title: Text(
                          Strings.allowNotifications,
                          style: GoogleFonts.poppins(
                            color: Color(0xFF5D6A78),
                          ),
                        ),
                        activeColor: themeColor.getColor(),
                      ),
                      SwitchListTile(
                        onChanged: (bool value) {
                          setState(() {
                            isOrderNotifications = !isOrderNotifications;
                          });
                        },
                        value: isOrderNotifications,
                        title: Text(
                          Strings.Order,
                          style: GoogleFonts.poppins(
                            color: Color(0xFF5D6A78),
                          ),
                        ),
                        subtitle: Text(
                          Strings.keepTrackOfYourTimeOrder,
                          style: GoogleFonts.poppins(
                              color: Color(0xFF5D6A78),
                              fontSize: 12,
                              fontWeight: FontWeight.w300),
                        ),
                        activeColor: themeColor.getColor(),
                      ),
                      SwitchListTile(
                        onChanged: (bool value) {
                          setState(() {
                            isFaqNotifications = !isOrderNotifications;
                          });
                        },
                        value: isFaqNotifications,
                        title: Text(
                          Strings.storeQA,
                          style: GoogleFonts.poppins(
                            color: Color(0xFF5D6A78),
                          ),
                        ),
                        subtitle: Text(
                          Strings.easyCommunicationWithDryStore,
                          style: GoogleFonts.poppins(
                            color: Color(0xFF5D6A78),
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        activeColor: themeColor.getColor(),
                      ),
                      SwitchListTile(
                        onChanged: (bool value) {
                          setState(() {
                            isReminderNotifications = !isReminderNotifications;
                          });
                        },
                        value: isReminderNotifications,
                        title: Text(
                          Strings.reminderCart,
                          style: GoogleFonts.poppins(
                            color: Color(0xFF5D6A78),
                          ),
                        ),
                        subtitle: Text(
                          Strings.shoppingCartReminder,
                          style: GoogleFonts.poppins(
                            color: Color(0xFF5D6A78),
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        activeColor: themeColor.getColor(),
                      ),
                      SwitchListTile(
                        onChanged: (bool value) {
                          setState(() {
                            isShoppingCartReminderNotifications =
                                !isShoppingCartReminderNotifications;
                          });
                        },
                        value: isShoppingCartReminderNotifications,
                        title: Text(
                          Strings.opportunitiesAndCampaigns,
                          style: GoogleFonts.poppins(
                            color: Color(0xFF5D6A78),
                          ),
                        ),
                        subtitle: Text(
                          Strings.benefitFromMobileSpecialOffer,
                          style: GoogleFonts.poppins(
                            color: Color(0xFF5D6A78),
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        activeColor: themeColor.getColor(),
                      ),
                      SwitchListTile(
                        onChanged: (bool value) {
                          setState(() {
                            isDiscountReminderNotifications =
                                !isDiscountReminderNotifications;
                          });
                        },
                        value: isDiscountReminderNotifications,
                        title: Text(
                          Strings.specialBenefitsForPersons,
                          style: GoogleFonts.poppins(
                            color: Color(0xFF5D6A78),
                          ),
                        ),
                        subtitle: Text(
                          Strings.youSpecialDiscounts,
                          style: GoogleFonts.poppins(
                            color: Color(0xFF5D6A78),
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        activeColor: themeColor.getColor(),
                      ),
                      SwitchListTile(
                        onChanged: (bool value) {
                          setState(() {
                            isCustomizeUserDiscountReminderNotifications =
                                !isCustomizeUserDiscountReminderNotifications;
                          });
                        },
                        value: isCustomizeUserDiscountReminderNotifications,
                        title: Text(
                          Strings.Updates,
                          style: GoogleFonts.poppins(
                            color: Color(0xFF5D6A78),
                          ),
                        ),
                        subtitle: Text(
                          Strings.notifyMeOfNewFeatures,
                          style: GoogleFonts.poppins(
                            color: Color(0xFF5D6A78),
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        activeColor: themeColor.getColor(),
                      ),
                    ],
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
