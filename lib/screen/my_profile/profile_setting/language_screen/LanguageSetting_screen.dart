import 'package:flutter/material.dart';
import 'package:shoppingapp/utils/commons/export_basic_file.dart';

class LanguageSettingScreen extends StatefulWidget {
  @override
  _LanguageSettingScreenState createState() => _LanguageSettingScreenState();
}

class _LanguageSettingScreenState extends State<LanguageSettingScreen> {
  List languageName = [
    'English',
    'Hindi',
    'Arabic',
    'chinese',
    'Tamil',
  ];
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<ThemeNotifier>(context);
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
        body: Container(
          height: Get.height,
          color: Colors.white,
          padding: EdgeInsets.only(left: 0, right: 0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 16, top: 24),
                  child: Text(
                    Strings.LanguageSetting,
                    style: GoogleFonts.poppins(
                      fontSize: 19,
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
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: languageName.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        currentIndex = index;
                        setState(() {});
                      },
                      child: Container(
                        margin: EdgeInsets.all(5),
                        padding: EdgeInsets.only(top: 20, left: 15, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              languageName[index],
                              style: GoogleFonts.poppins(
                                fontSize: 17,
                                color: Color(0xFF5D6A78),
                              ),
                            ),
                            currentIndex == index
                                ? Container(
                                    decoration: BoxDecoration(
                                      color: themeColor.getColor(),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(40)),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.check,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                :SizedBox(),
                          ],
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
