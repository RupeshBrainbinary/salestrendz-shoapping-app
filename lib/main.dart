import 'dart:io';

import 'package:badges/badges.dart';
import 'package:bot_toast/bot_toast.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppingapp/models/BookOrderModel.dart';
import 'package:shoppingapp/models/ConnectivityModel.dart';
import 'package:shoppingapp/models/LoginModelClass.dart';
import 'package:shoppingapp/screen/auth_screens/landing_screen/splash_screen.dart';
import 'package:shoppingapp/screen/auth_screens/login/login_form.dart';
import 'package:shoppingapp/screen/home_navigator/home_navigator.dart';
import 'package:shoppingapp/utils/commons/colors.dart';
import 'app_url_name_companyid.dart';
import 'screen/cart_screen/shopping_cart_page.dart';
import 'utils/navigator.dart';
import 'utils/theme_notifier.dart';
class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

void main() async {
  HttpOverrides.global = new MyHttpOverrides();
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  //
  // await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  // FirebaseCrashlytics.instance.crash();
  var delegate = await LocalizationDelegate.create(
      fallbackLocale: 'en_US', supportedLocales: ['en_US', 'es', 'fa', 'ar']);

  SharedPreferences.getInstance().then(
    (prefs) {
      LoginModelClass.loginModelObj.prefs = prefs;
      Color color = mainColor;


      ///when millBorn App unComment This
      //  tempName = prefs.getString("Theme") ??"MILLBORN-Jaipur";
      //   color = tempName == "MILLBORN-Jaipur" ?  millBornPrimaryThemeColor : Color(prefs.getInt('color'));
      ///when millBorn App Comment This
      tempName = appName;
      if (prefs.getInt('color') != null) {
      color = tempName == "MILLBORN-Jaipur" ?  millBornPrimaryThemeColor : Color(prefs.getInt('color'));
      }


      BookOrderModel.orderModelObj.loadProductsFromSharedPreferences();

      ConnectivityModelClass.getInstance().initialize();

      runApp(
        ChangeNotifierProvider<ThemeNotifier>(
          create: (_) => ThemeNotifier(color),
          child: Phoenix(
            child: LocalizedApp(
              delegate,
              MyApp(
                prefs: prefs,
              ),
            ),
          ),
        ),
      );
    },
  );
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;

  MyApp({this.prefs});

  @override
  Widget build(BuildContext context) {
    final botToastBuilder = BotToastInit();

    final themeColor = Provider.of<ThemeNotifier>(context);
    var localizationDelegate = LocalizedApp.of(context).delegate;
    FlutterStatusbarcolor.setStatusBarColor(
        themeColor.getColor()); //this change the status bar color to white
    FlutterStatusbarcolor.setNavigationBarColor(Colors.black54);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return LocalizationProvider(
      state: LocalizationProvider.of(context).state,
      child: Container(
        color: themeColor.getColor(),
        child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorObservers: [BotToastNavigatorObserver()],
          builder: (context, child) {
            child = botToastBuilder(context, child);
            return child;
          },
          title: 'Shopping App',
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            localizationDelegate
          ],
          supportedLocales: localizationDelegate.supportedLocales,
          locale: localizationDelegate.currentLocale,
          theme: ThemeData(
            fontFamily: "roboto",
            pageTransitionsTheme: PageTransitionsTheme(builders: {
              TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            }),
            primaryColor: themeColor.getColor(),
          ),
          routes: {
            '/': (BuildContext context) => SplashScreen(),
            'homeScreen': (BuildContext context) => InitPage(),
          },
          initialRoute: '/',
        ),
      ),
    );
  }
}

class InitPage extends StatefulWidget {
  @override
  _InitPageState createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  void updateViewForTabBarAndAppBar() {
    setState(() {});
  }

  @override
  void initState() {
    BookOrderModel.orderModelObj.initPageRefresh = updateViewForTabBarAndAppBar;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HomeNavigator(),
    );
  }
}

class AppBarUpdate extends StatefulWidget {
  AppBarUpdate({this.themeColor});

  final themeColor;

  @override
  _AppBarUpdateState createState() =>
      _AppBarUpdateState(themeColor: themeColor);
}

class _AppBarUpdateState extends State<AppBarUpdate> {
  _AppBarUpdateState({this.themeColor});

  final themeColor;

  void refreshBadgeValue() {
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BookOrderModel.orderModelObj.appBarButtonCountrRefresh = refreshBadgeValue;
  }

  @override
  Widget build(BuildContext context) {
    return AppBarButtonWidget(
      themeColor: themeColor,
    );
  }
}

class AppBarButtonWidget extends StatelessWidget {
  const AppBarButtonWidget({
    Key key,
    @required this.themeColor,
  }) : super(key: key);
  final ThemeNotifier themeColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 16, top: 8),
      child: InkWell(
        onTap: () {
          Nav.route(
            context,
            ShoppingCartPage(
              showBackArrow: true,
            ),
          );
        },
        child: Badge(
          badgeColor: Color(0xFF5D6A78),
          alignment: Alignment(-0.5, -1.0),
          padding: EdgeInsets.all(4),
          badgeContent: Text(
            '${BookOrderModel.orderModelObj.productsInCart?.length ?? 0}',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 10,
            ),
          ),
          child: SvgPicture.asset(
            "assets/icons/ic_shopping_cart.svg",
            color: themeColor.getColor(),
            height: 26,
          ),
        ),
      ),
    );
  }
}
