import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shoppingapp/utils/commons/export_basic_file.dart';

class ContactPage extends StatefulWidget {
  @override
  ContactPageState createState() => ContactPageState();
}

class ContactPageState extends State<ContactPage> {
  ContactViewModel model;

  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<ThemeNotifier>(context);
    // ignore: unnecessary_statements
    model ?? (model = ContactViewModel(this));
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.redAccent,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          child: Icon(
            Platform.isAndroid ? Icons.arrow_back : Icons.chevron_left,
            color: Colors.black,
          ),
          onTap: () {
            Get.back();
          },
        ),
        title: Text(
          appName,
          style: GoogleFonts.roboto(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      backgroundColor: greyBackground,
      body: model.contact == null
          ? Center(child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(themeColor.getColor())))
          : Container(
              padding: EdgeInsets.only(left: 16, right: 16, top: 4),
              child: model.contact.callHelplines.isNotEmpty
                  ? ListView.builder(
                      itemCount: model.contact.callHelplines.length,
                      itemBuilder: (BuildContext context, int index) {
                        return contactItem(
                          model.contact.callHelplines[index].helplineUsername,
                          model.contact.callHelplines[index].helplineUserNumber,
                        );
                      },
                    )
                  : Container(
                      height: Get.height * 0.8,
                      child: Center(
                        child: Text(
                          Strings.connotfound,
                          style: GoogleFonts.roboto(
                            fontSize: 25,
                            color: Colors.grey[500],
                          ),
                        ),
                      ),
                    ),
            ),
    );
  }

  AppBar buildAppBar(themeColor) {
    return AppBar(
      brightness: Brightness.light,
      elevation: 0,
      centerTitle: true,
      title: Text(
        Strings.Contact,
        style: GoogleFonts.roboto(
          color: themeColor.getColor(),
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.white,
      leading: Icon(
        Icons.chevron_left,
        color: themeColor.getColor(),
      ),
    );
  }

  Container contactItem(String title, String description) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 16,
        left: 8,
        right: 8,
        top: 8,
      ),
      height: 84,
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
              style: GoogleFonts.roboto(
                color: Color(0xFF707070),
              ),
            ),
            InkWell(
              onTap: () async {
                String url = 'tel:+91' + description;
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
              child: Container(
                child: Row(
                  children: [
                    Icon(
                      Icons.call,
                      size: 15,
                      color: Colors.black.withOpacity(0.8),
                    ),
                    RichText(
                      text: TextSpan(
                        text: description,
                        style: GoogleFonts.roboto(
                          color: textColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
