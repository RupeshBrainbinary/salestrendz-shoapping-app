import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:shoppingapp/utils/commons/export_basic_file.dart';
import 'package:flutter/material.dart';
import 'package:validators/validators.dart' as validator;
import 'package:http/http.dart' as http;

//mill born primary color
bool showMBPrimaryColor;
String tempName;
class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Model model = Model();
  bool passwordVisible = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<ThemeNotifier>(context);
    FlutterStatusbarcolor.setStatusBarColor(
        themeColor.getColor());
    print("Current page --> $runtimeType");
    return Container(
      padding: EdgeInsets.only(right: 42, left: 42),
      child: Stack(
        children: [
          Form(
            //utovalidate: true,
            autovalidateMode: AutovalidateMode.always,
            key: _formKey,
            child: Column(
              children: <Widget>[
                MyTextFormField(
                  hintText:"Mobile no / Email",
                  // hintText: Strings.emailOrPhone ,
                  isEmail: true,
                  // validator: (String value) {
                  //   if (value.isEmpty == true) {
                  //     return Strings.enterEmail;
                  //   } else if (!validator.isEmail(value)) {
                  //     return Strings.enterAValidEmail;
                  //   }
                  //   return null;
                  // },
                  controller: emailController,
                  onSaved: (String value) {
                    model.email = value.toString().trim();
                  },
                ),
                MyTextFormField(
                  hintText: Strings.Password,
                  suffixIcon: IconButton(
                    icon: Icon(
                      passwordVisible ? Icons.visibility_off : Icons.visibility,
                      color: Colors.red[600],
                    ),
                    onPressed: () {
                      setState(() {
                        passwordVisible = !passwordVisible;
                      });
                    },
                  ),
                  isPassword: passwordVisible,
                  validator: (String value) {
                    if (value.isEmpty == true) {
                      return Strings.EnterPassword;
                    }
                    _formKey.currentState.save();
                    return null;
                  },
                  controller: passwordController,
                  onSaved: (String value) {
                    model.password = value;
                  },
                ),
                Container(
                  height: 42,
                  width: Get.width,
                  margin: EdgeInsets.only(top: 20, bottom: 12),
                  child: ShadowButton(
                    borderRadius: 0,
                    height: 40,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                     color : appName == "MILLBORN-Jaipur" ? millBornPrimaryThemeColor : mainColor ,
                      onPressed: () async {
                        SharedPreferences prefs =await SharedPreferences.getInstance();
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          if (GlobalModelClass.internetConnectionAvaiable() ==
                              true) {
                            showDialog<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return Center(
                                  child: Stack(
                                    children: <Widget>[
                                      Container(
                                        height: Get.height,
                                        width: Get.width,
                                        color: Colors.transparent,
                                      ),
                                      Center(
                                        child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(themeColor.getColor())),
                                      )
                                    ],
                                  ),
                                );
                              },
                            );
                            ///when  in login api body map key change email or phone below is uncommented and assign in related conditions
                           //  // var bodyData;
                           //  bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(emailController.text.toString());
                           //  String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                           //  RegExp regExp = new RegExp(pattern);
                           //  bool validPhone = regExp.hasMatch(emailController.text.trim());
                           //  print(validPhone);
                           //
                           //  if(emailValid == true){
                           //   print("You enter email for sign in");
                           //   //pass email in body of api
                           // }else if(validPhone == true){
                           //    print("You enter mobile for sign in");
                           //    //pass phone in body of api if need to parameter key change
                           // }
                            http.Response response = await http.post(
                                Uri.parse(Base_URL + Login_URL),
                              body: {
                                'email': model.email,
                                'password': model.password,
                                'comp_id': '$company_id',
                                'format': 'json'
                              },
                            );
                            Loader().hideLoader(context);
                            if (response.statusCode == 200) {

                              if(appName == "MILLBORN-Jaipur"){
                                setState(() {
                                  showMBPrimaryColor = true;
                                  prefs.remove("showMBPrimaryColor");
                                  prefs.setBool("showMBPrimaryColor", showMBPrimaryColor);
                                });
                              }else{
                                setState(() {
                                  prefs.remove("showMBPrimaryColor");
                                  // prefs.setString("Theme", "MILLBORN-Jaipur");
                                  showMBPrimaryColor = false;
                                  tempName="NotMillBornApp";
                                  prefs.setBool("showMBPrimaryColor", showMBPrimaryColor);

                                });
                              }

                              var jsonResp = jsonDecode(response.body);
                              print(jsonResp);
                              var jsonSuccessKey;
                              if (jsonResp.containsKey('success')) {
                                jsonSuccessKey = jsonResp['success'];
                              } else {
                                jsonSuccessKey = jsonResp['status'];
                              }
                              if (jsonSuccessKey == true) {
                                getAppVersion();
                                LoginModelClass.loginModelObj
                                    .setValueForKeyInPreferences(
                                        key: loginResponse,
                                        value: jsonEncode(
                                            jsonResp['response']['result']));
                                loggedInUserId = LoginModelClass.loginModelObj.getValueForKeyFromLoginResponse(
                                        key: 'user_id');
                                print(
                                    '-----------> user id------$loggedInUserId');
                                Nav.routeReplacement(context, InitPage());
                              } else {
                                var titleString = '';
                                if (jsonResp['response'] == null) {
                                  titleString = (jsonResp['message']);
                                } else {
                                  titleString =
                                      (jsonResp['response'])['message']
                                          .toString();
                                }
                                ToastUtils.showError(message: titleString);
                              }
                            } else {
                              Map responseDict = jsonDecode(response.body);
                              String message = responseDict.values
                                  .toString()
                                  .replaceAll('[', "");
                              message = message.replaceAll(']', "");
                              message = message.replaceAll('(', "");
                              message = message.replaceAll(')', "");
                              message = message.replaceAll('.,', ".\n");
                              ToastUtils.showError(
                                message: (message != null && message.length > 0)
                                    ? message
                                    : Strings.somethingWentWrong,
                              );
                            }
                          } else {
                            GlobalModelClass.showAlertForNoInternetConnection(
                                    context)
                                .show();
                          }
                        }
                      },
                      child: Text(
                        Strings.signIn,
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Nav.route(context, ForgetPassword());
                  },
                  child: Container(
                    width: double.infinity,
                    height: 30.0,
                    child: Center(
                      child: Text(
                        Strings.forgotPassword + '?',
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w500,
                          color: Colors.red[600],
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          GlobalModelClass.globalObject.loadingIndicator(
              BookOrderModel.orderModelObj.showLoadingIndicator ?? false,context),
        ],
      ),
    );
  }

   getAppVersion() async {
    http.Response response = await http.get(
      Uri.parse(Base_URL + appVersion + 'comp_id=$company_id&version_for=retailer_app'),
      headers: {
        'Accept': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['status'].toString() == 'true') {
        LoginModelClass.loginModelObj.setVersionCode(jsonDecode(response.body)['version_data']['current_version'].toString());
        LoginModelClass.loginModelObj.setForceUpdate(jsonDecode(response.body)['version_data']['force_update'].toString());

      } else {
      }
    } else {
    }
  }

}

class Model {
  String email;
  String password;

  Model({this.email, this.password});
}
