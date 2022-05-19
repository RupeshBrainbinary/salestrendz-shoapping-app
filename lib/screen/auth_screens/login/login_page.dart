import 'package:flutter/material.dart';
import 'package:shoppingapp/utils/commons/export_basic_file.dart';
import 'package:shoppingapp/screen/auth_screens/register/reg_distributor.dart';
import 'package:shoppingapp/screen/auth_screens/register/reg_retailer.dart';

Color consumerBorderColor = mainColor;
Color retailerBorderColor = Colors.black;
Color distributorBorderColor = Colors.black;

Color consumerViewColor = HeaderColor;
Color retailerViewColor = Colors.white;
Color distributorViewColor = Colors.white;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BookOrderModel.orderModelObj.showLoadingIndicator = false;
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<ThemeNotifier>(context);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: mainColor,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              AuthHeader(
                headerTitle: Strings.logIn,
                headerBigTitle: Strings.New,
                isLoginHeader: true,
              ),
              SizedBox(
                height: 36,
              ),
              LoginForm(),
              SizedBox(
                height: 8,
              ),
              routeRegisterWidget(themeColor, context),
            ],
          ),
        ),
      ),
    );
  }

  String registerAs = RegisteredAs.Consumer.toString();

  routeRegisterWidget(ThemeNotifier themeColor, BuildContext context) {
    return Container(
      height: 50.0,
      padding: EdgeInsets.only(right: 48, left: 30, bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(
            flex: 1,
            child: Text(
              Strings.doYouHaveAc,
              style: GoogleFonts.roboto(
                fontSize: 13,
                color: Colors.black54,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Flexible(
            flex: 0,
            child: FlatButton(
              child: Text(
                Strings.register,
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  color: Colors.red[600],
                  fontWeight: FontWeight.w400,
                ),
              ),
              onPressed: () {
                registerAlertDialog(themeColor);
              },
            ),
          )
        ],
      ),
    );
  }

  registerAlertDialog(ThemeNotifier themeColor) {
    LoginModelClass.loginModelObj.resetModel();

    consumerViewColor = HeaderColor;
    retailerViewColor = distributorViewColor = Colors.white;

    consumerBorderColor = themeColor.getColor();
    retailerBorderColor = distributorBorderColor = Colors.black;
    registerAs = RegisteredAs.Consumer.toString();
    print(registerAs);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        LoginModelClass.loginModelObj.resetModel();
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          backgroundColor: Colors.white,
          content: StatefulBuilder(
            // You need this, notice the parameters below:
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                height: Get.height * 0.385,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      child: Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Icon(
                            Icons.close,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(
                        height: 35.0,
                        child: Align(
                          child: Text(
                            Strings.RegisterAs,
                            style: GoogleFonts.roboto(
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          alignment: Alignment.center,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Flexible(
                      flex: 4,
                      child: Row(
                        children: <Widget>[
                          CustomAlertView(
                            viewColor: consumerViewColor,
                            imageWid: 'assets/images/customers.png',
                            labelText: Strings.Consumer,
                            gestureFunc: () {
                              setState(() {
                                consumerViewColor = HeaderColor;
                                retailerViewColor =
                                    distributorViewColor = Colors.white;
                                consumerBorderColor = themeColor.getColor();
                                retailerBorderColor =
                                    distributorBorderColor = Colors.black;
                                registerAs = RegisteredAs.Consumer.toString();
                              });
                            },
                            sidesColor: consumerBorderColor,
                          ),
                          SizedBox(width: 5.0),
                          CustomAlertView(
                            viewColor: retailerViewColor,
                            imageWid: 'assets/images/retailer.png',
                            labelText: Strings.Retailer,
                            gestureFunc: () {
                              setState(() {
                                retailerViewColor = HeaderColor;
                                consumerViewColor =
                                    distributorViewColor = Colors.white;
                                retailerBorderColor = themeColor.getColor();
                                consumerBorderColor =
                                    distributorBorderColor = Colors.black;
                                registerAs = RegisteredAs.Retailer.toString();
                              });
                            },
                            sidesColor: retailerBorderColor,
                          ),
                          SizedBox(width: 5.0),
                          CustomAlertView(
                            viewColor: distributorViewColor,
                            imageWid: 'assets/images/distributor.png',
                            labelText: Strings.Distributor,
                            gestureFunc: () {
                              setState(() {
                                distributorViewColor = HeaderColor;
                                retailerViewColor =
                                    distributorViewColor = Colors.white;
                                distributorBorderColor = themeColor.getColor();
                                consumerBorderColor =
                                    retailerBorderColor = Colors.black;
                                registerAs =
                                    RegisteredAs.Distributor.toString();
                              });
                            },
                            sidesColor: distributorBorderColor,
                          ),
                          SizedBox(width: 5.0),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Flexible(
                      flex: 2,
                      child: GestureDetector(
                        onTap: () {
                          String value = '';
                          switch (registerAs) {
                            case 'RegisteredAs.Consumer':
                              value = 'Consumer';
                              Nav.routeReplacement(
                                context,
                                RegisterAsConsumer(),
                              );
                              break;
                            case 'RegisteredAs.Retailer':
                              value = 'Retailer';
                              Nav.routeReplacement(
                                context,
                                RegisterAsRetailer(),
                              );
                              break;
                            case 'RegisteredAs.Distributor':
                              value = 'Distributor';
                              Nav.routeReplacement(
                                context,
                                RegisterAsDistributor(),
                              );
                              break;
                          }
                        },
                        child: Container(
                          height: 45.0,
                          child: Align(
                            child: Text(
                              Strings.Proceed,
                              style: GoogleFonts.roboto(color: Colors.white),
                            ),
                            alignment: Alignment.center,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red[600],
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
