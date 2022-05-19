import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:shoppingapp/screen/consumer_ui_pages/filter_screen/filter_detail_inner_page.dart';
import 'package:shoppingapp/utils/commons/colors.dart';
import 'package:shoppingapp/utils/theme_notifier.dart';
import 'package:shoppingapp/widgets/commons/string_res.dart';

class FilterPage extends StatefulWidget {
  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  var switch1 = true;
  var switch2 = false;

  @override
  Widget build(BuildContext context) {
    print("Current page --> $runtimeType");
    final themeColor = Provider.of<ThemeNotifier>(context);

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            Strings.SelectFilter,
            style: GoogleFonts.poppins(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          centerTitle: true,
        ),
        bottomNavigationBar: InkWell(
          onTap: () {
            Get.back();
            // Nav.routeReplacement(context, SearchPage());
          },
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
                color: Color(0xFF5D6A78)),
            height: 42,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                Strings.Apply,
                style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: Container(
          margin: EdgeInsets.only(bottom: 12),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                buildItem("Category", "All"),
                buildItem("Price", "All"),
                Container(
                  height: 54,
                  child: ListTile(
                    title: Text(
                      Strings.Daily,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: textColor,
                      ),
                    ),
                    trailing: Transform.scale(
                      scale: 0.7,
                      child: CupertinoSwitch(
                        activeColor: themeColor.getColor(),
                        value: switch1,
                        onChanged: (bool value) {
                          setState(() {
                            switch1 = value;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 54,
                  child: ListTile(
                    title: Text(
                      Strings.FreeCargo,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: textColor,
                      ),
                    ),
                    trailing: Transform.scale(
                      scale: 0.7,
                      child: CupertinoSwitch(
                        activeColor: themeColor.getColor(),
                        value: switch2,
                        onChanged: (bool value) {
                          setState(() {
                            switch2 = value;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 16.0,
                    right: Get.width / 2.2,
                  ),
                  child: Divider(),
                ),
                ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    buildItem("Brand", "All"),
                    buildItem("Color", "All"),
                    buildItem("Size", "All"),
                    buildItem("Dress size", "All"),
                    buildItem("Collar Type", "All"),
                    buildItem("Arm Type", "All"),
                    buildItem("Decolletage", "All"),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildItem(String title, String subTitle) {
    return Container(
      height: 54,
      child: Align(
        alignment: Alignment.center,
        child: ListTile(
          onTap: () {
            // Nav.route(context, FilterDetalInnerPage());
            Get.to(() => FilterDetalInnerPage());
          },
          title: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Color(0xFFA1B1C2),
            ),
          ),
          subtitle: Text(
            subTitle,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: textColor,
            ),
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.chevron_right,
              color: textColor,
            ),
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}
