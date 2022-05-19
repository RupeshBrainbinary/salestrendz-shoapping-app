import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:shoppingapp/utils/commons/export_basic_file.dart';
import 'package:flutter/material.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

Widget getHomeScreen(SharedPreferences prefs) {
  if (prefs.getString(loginResponse) != null) {
    return InitPage();
  } else {
    print('The User is not logged in');
    return OnBoardingPage();
  }
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      Timer(
        Duration(seconds: 3),
        () => Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (BuildContext context) => getHomeScreen(prefs)),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<ThemeNotifier>(context);
    FlutterStatusbarcolor.setStatusBarColor(
        themeColor.getColor());
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: mainColor,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          color: Colors.white,
          height: 240,
          width: Get.width / 2,
          child: Image.asset(logoImage),
        ),
      ),
    );
  }
}
