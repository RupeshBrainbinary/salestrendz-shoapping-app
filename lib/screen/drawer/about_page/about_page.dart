import 'package:flutter/material.dart';
import 'package:shoppingapp/utils/commons/export_basic_file.dart';

class FAQSPages extends StatefulWidget {
  @override
  _FAQSPagesState createState() => _FAQSPagesState();
}

class _FAQSPagesState extends State<FAQSPages> {
  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: themeColor.getColor()),
        title: Text(
          "FAQs",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      drawer: CustomDrawer(),
      backgroundColor: greyBackground,
      body: Container(
        padding: EdgeInsets.only(left: 16, right: 16, top: 4),
        child: ListView(
          children: <Widget>[
            aboutItem(
                "Ubi est azureus mortem?",
                "Valebat, racana, et hippotoxota. Valebat, racana, et hippotoxota. Valebat, racana, et hippotoxota.",
                "rosen@gmail.com"),
            aboutItem(
                "Ubi est azureus mortem?",
                "Valebat, racana, et hippotoxota. Valebat, racana, et hippotoxota. Valebat, racana, et hippotoxota.",
                "rosen@gmail.com"),
            aboutItem(
                "Ubi est azureus mortem?",
                "Valebat, racana, et hippotoxota. Valebat, racana, et hippotoxota. Valebat, racana, et hippotoxota.",
                "rosen@gmail.com"),
            aboutItem(
                "Ubi est azureus mortem?",
                "Valebat, racana, et hippotoxota. Valebat, racana, et hippotoxota. Valebat, racana, et hippotoxota.",
                "rosen@gmail.com"),
            aboutItem(
                "Ubi est azureus mortem?",
                "Valebat, racana, et hippotoxota. Valebat, racana, et hippotoxota. Valebat, racana, et hippotoxota.",
                "rosen@gmail.com"),
            aboutItem(
                "Ubi est azureus mortem?",
                "Valebat, racana, et hippotoxota. Valebat, racana, et hippotoxota. Valebat, racana, et hippotoxota.",
                "rosen@gmail.com"),
            aboutItem(
                "Ubi est azureus mortem?",
                "Valebat, racana, et hippotoxota. Valebat, racana, et hippotoxota. Valebat, racana, et hippotoxota.",
                "rosen@gmail.com"),
            aboutItem(
                "Ubi est azureus mortem?",
                "Valebat, racana, et hippotoxota. Valebat, racana, et hippotoxota. Valebat, racana, et hippotoxota.",
                "rosen@gmail.com"),
          ],
        ),
      ),
    );
  }

  Widget aboutItem(String title, String description, String secondDescription) {
    return Container(
      margin: EdgeInsets.only(bottom: 16, left: 8, right: 8, top: 8),
      height: 96,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.2),
            blurRadius: 9.0,
            spreadRadius: 0.0,
            offset: Offset(0.0, 1.0),
          )
        ],
      ),
      child: Container(
        padding: EdgeInsets.only(left: 12, top: 6, bottom: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                color: subTextColor,
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
            RichText(
              text: TextSpan(
                text: description,
                style: GoogleFonts.poppins(
                  color: textColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
