import 'package:flutter/material.dart';
import 'package:shoppingapp/utils/commons/export_basic_file.dart';
import 'package:http/http.dart' as http;
import 'package:validators/validators.dart' as validator;

BuildContext alertContext;

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  String enteredEmail;
  String enterMobileNumber;
  bool showLoadingIndicator;
  bool showSendEmailButton;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    enteredEmail = '';
    enterMobileNumber = "";
    showLoadingIndicator = false;
    showSendEmailButton = true;
  }

  void methodToUpdateUI() {
    setState(() {});
  }

  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    alertContext = context;
    final themeColor = Provider.of<ThemeNotifier>(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: themeColor.getColor(),
      ),
      child: SafeArea(
        child: WillPopScope(
          onWillPop: () {
            Get.back();
          },
          child: GestureDetector(
            onTap: () {
              showSendEmailButton = true;
              setState(() {});
              FocusScope.of(context).unfocus();
            },
            child: Scaffold(
              bottomNavigationBar: Container(
                height: 45,
                margin: EdgeInsets.only(top: 20, bottom: 12),
                padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                child: ShadowButton(
                  borderRadius: 0,
                  height: 40,
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    color:  appName == "MILLBORN-Jaipur" ? millBornPrimaryThemeColor : mainColor,
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        Loader().showLoader(context);
                        sendPasswordViaEmail(methodToUpdateUI);
                      }
                    },
                    child: Text(
                      Strings.Submit,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
              resizeToAvoidBottomInset: true,
              backgroundColor: Colors.white,
              body: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        AuthHeader(
                          headerTitle: Strings.forgotPassword,
                          headerBigTitle: "New",
                          isLoginHeader: false,
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0.0),
                          child: Text(
                            Strings
                                .pleaseEnterYourRegisteredEmailToGetNewPassword,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(),
                          ),
                        ),
                        Form(
                          //autovalidate: true,
                          autovalidateMode: AutovalidateMode.always,
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                height: Get.height * 0.10,
                                margin: EdgeInsets.only(
                                    top: 30, left: 30, right: 30),
                                child:TextFormField(
                                  controller: mobileController,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(15.0),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        width: 0,
                                        style: BorderStyle.none,
                                      ),
                                    ),
                                    hintText: Strings.enterMobileNumber,
                                    filled: true,
                                    hintStyle: GoogleFonts.poppins(),
                                    errorStyle: GoogleFonts.poppins(),
                                    suffixIcon: Icon(Icons.phone),
                                  ),
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    enterMobileNumber = value;
                                    setState(() {});
                                  },
                                ),
                              ),
                              Text(
                                Strings.or,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(),
                              ),
                              Container(
                                height: Get.height * 0.10,
                                margin: EdgeInsets.only(
                                    top: 10, left: 30, right: 30),
                                child:  TextFormField(
                                  controller: emailController,
                                  // validator: (String value) {
                                  //   if (value.isEmpty == true) {
                                  //     return Strings.enterEmail;
                                  //   } else if (!validator.isEmail(value)) {
                                  //     return Strings.enterAValidEmail;
                                  //   }
                                  //   return null;
                                  // },
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(15.0),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        width: 0,
                                        style: BorderStyle.none,
                                      ),
                                    ),
                                    hintText: Strings.enterRegisteredEmail,
                                    filled: true,
                                    hintStyle: GoogleFonts.poppins(),
                                    errorStyle: GoogleFonts.poppins(),
                                    suffixIcon: Icon(Icons.email),
                                  ),
                                  onChanged: (value) {
                                    enteredEmail = value;
                                    setState(() {});
                                  },
                                ),
                              ),


                              SizedBox(height: Get.height * 0.07),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  GlobalModelClass.globalObject.loadingIndicator(
                      BookOrderModel.orderModelObj.showLoadingIndicator ??
                          false,context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void sendPasswordViaEmail(Function onCallBack) async {
    if (GlobalModelClass.internetConnectionAvaiable() == true) {
      showLoadingIndicator = true;
      onCallBack();
      var bodyData;
   if(mobileController.text.trim() != ""){
        bodyData={
          'user_number': enterMobileNumber.toString(),
        };
      }else if(emailController.text.trim() != ""){
     bodyData={
       'user_email': enteredEmail.toString(),
     };
   }
      var resp = await http.post(
        Uri.parse(Base_URL + forgotPassword),
        body:bodyData
      );
      showLoadingIndicator = false;
      onCallBack();
      Map respDict = jsonDecode(resp.body);

      if (resp.statusCode == 200) {
        var jsonResp = jsonDecode(resp.body);
        Loader().hideLoader(context);

        if (respDict['status'] == true) {
          var titleString = '';
          if (jsonResp['status'] == true) {
            titleString = (jsonResp['message']);
            Get.back();
          } else {
            titleString = (jsonResp['status'])['message'].toString();
          }
          ToastUtils.showSuccess(message: titleString);
        } else {
          var titleString = '';
          if (jsonResp['response'] == null) {
            titleString = (jsonResp['message']);
          } else {
            titleString = (jsonResp['response'])['message'].toString();
          }
          ToastUtils.showError(message: titleString);
        }
      } else {
        showAlertWith(alertContext,
            title: Strings.somethingWentWrong, popView: false);
      }
      print(resp.body);
    } else {
      Loader().hideLoader(context);
      Future.delayed(Duration.zero, () {
        GlobalModelClass.showAlertForNoInternetConnection(context).show();
      });
    }
  }
}

void showAlertWith(alertContext, {String title, String message, bool popView}) {
  Alert(
    context: alertContext,
    title: title,
    buttons: [
      DialogButton(
        child: Text(
          Strings.ok,
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        onPressed: () {
          if (popView == true) {
            Nav.routeReplacement(alertContext, LoginPage());
          } else {
            Get.back();
          }
        },
      ),
    ],
  ).show();
}
