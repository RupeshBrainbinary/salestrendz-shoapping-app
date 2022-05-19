import 'package:flutter/material.dart';
import 'package:shoppingapp/utils/commons/export_basic_file.dart';
import 'package:http/http.dart' as http;
import 'package:shoppingapp/widgets/commons/toast_utils.dart';
import 'package:validators/validators.dart' as validator;

final LoginModelClass loginModelObject = LoginModelClass.loginModelObj;

class RegisterAsConsumer extends StatefulWidget {
  @override
  _RegisterAsConsumerState createState() => _RegisterAsConsumerState();
}

class _RegisterAsConsumerState extends State<RegisterAsConsumer> {
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController rePasswordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    print("Current page --> $runtimeType");
    return Container(
      child: SafeArea(
        child: WillPopScope(
          // ignore: missing_return
          onWillPop: () {
            Get.back();
            loginModelObject.resetModel();
          },
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              setState(() {});
            },
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: Colors.white,
              body: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        AuthHeader(
                          headerTitle: Strings.RegisterAsAConsumer,
                          headerBigTitle: Strings.New,
                          isLoginHeader: false,
                        ),
                        Form(
                          //autovalidate: true,
                          autovalidateMode: AutovalidateMode.always,
                          key: _formKey,
                          child: Container(
                            padding: EdgeInsets.only(
                              left: 40.0,
                              right: 40.0,
                              top: 20,
                            ),
                            child: Column(
                              children: [
                                SizedBox(height: 10),
                                TextFormField(

                              cursorColor: Theme.of(context).primaryColor,
                                  controller: nameController,
                                  validator: (String value) {
                                    if (value.isEmpty == true) {
                                      return Strings.enterFullName;
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    filled: true,
                                    hintText: Strings.fullName,
                                    hintStyle:
                                        GoogleFonts.poppins(fontSize: 15),
                                    errorStyle:
                                        GoogleFonts.poppins(fontSize: 12),
                                    fillColor: HeaderColor,
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 15.0, horizontal: 15.0),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                TextFormField(
                                  controller: mobileController,
                                  keyboardType: TextInputType.number,
                                  validator: (String value) {
                                    if (value.isEmpty == true) {
                                      return Strings.enterMobileNumber;
                                    } else if (value.length < 10) {
                                      return Strings.enterAValidMobileNumber;
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    filled: true,
                                    hintText: Strings.mobileNumber,
                                    hintStyle:
                                        GoogleFonts.poppins(fontSize: 15),
                                    errorStyle:
                                        GoogleFonts.poppins(fontSize: 12),
                                    fillColor: HeaderColor,
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 15.0, horizontal: 15.0),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  cursorColor: Theme.of(context).primaryColor,
                                ),
                                SizedBox(height: 10),
                                TextFormField(
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
                                    filled: true,
                                    hintText: Strings.email,
                                    hintStyle:
                                        GoogleFonts.poppins(fontSize: 15),
                                    errorStyle:
                                        GoogleFonts.poppins(fontSize: 12),
                                    fillColor: HeaderColor,
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 15.0, horizontal: 15.0),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  cursorColor: Theme.of(context).primaryColor,
                                ),
                                SizedBox(height: 10),
                                TextFormField(
                                  controller: passwordController,
                                  validator: (String value) {
                                    if (value.isEmpty == true) {
                                      return Strings.EnterPassword;
                                    } else if (value.length < 6) {
                                      return Strings
                                          .PasswordShouldBeMinimum6Characters;
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    filled: true,
                                    hintText: Strings.Password,
                                    hintStyle:
                                        GoogleFonts.poppins(fontSize: 15),
                                    errorStyle:
                                        GoogleFonts.poppins(fontSize: 12),
                                    fillColor: HeaderColor,
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 15.0, horizontal: 15.0),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  cursorColor: Theme.of(context).primaryColor,
                                ),
                                SizedBox(height: 10),
                                TextFormField(
                                  controller: rePasswordController,
                                  validator: (String value) {
                                    if (value.isEmpty == true) {
                                      return Strings.EnterPassword;
                                    } else if (value !=
                                        passwordController.text) {
                                      return Strings.PasswordDoesntSame;
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    filled: true,
                                    hintText: Strings.RetypePassword,
                                    hintStyle:
                                        GoogleFonts.poppins(fontSize: 15),
                                    errorStyle:
                                        GoogleFonts.poppins(fontSize: 12),
                                    fillColor: HeaderColor,
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 15.0, horizontal: 15.0),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  cursorColor: Theme.of(context).primaryColor,
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          loginModelObject.loginDictionary[
                                                  'termsAndConditions'] =
                                              !((loginModelObject
                                                              .loginDictionary[
                                                          'termsAndConditions'] ??
                                                      false) ??
                                                  true);
                                        });
                                      },
                                      child: Icon(
                                        ((loginModelObject.loginDictionary[
                                                            'termsAndConditions'] !=
                                                        null &&
                                                    loginModelObject
                                                            .loginDictionary[
                                                        'termsAndConditions']) ==
                                                true
                                            ? Icons.check_box
                                            : Icons
                                                .check_box_outline_blank_rounded),
                                        size: 35.0,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    SizedBox(width: 15),
                                    Text(
                                      Strings.termsandConditions,
                                      style: GoogleFonts.poppins(
                                        color: Colors.grey,
                                        fontSize: 17.0,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          if (_formKey.currentState
                                              .validate()) {
                                            if ((loginModelObject
                                                                .loginDictionary[
                                                            'termsAndConditions'] !=
                                                        null &&
                                                    loginModelObject
                                                            .loginDictionary[
                                                        'termsAndConditions']) ==
                                                true) {
                                              serveRegisterRequestWith();
                                            } else {
                                              ToastUtils.showError(
                                                  message: Strings
                                                      .AcceptTermsAndConditions);
                                            }
                                          }
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            color: Colors.red[600],
                                          ),
                                          width: Get.width * 0.77,
                                          child: Center(
                                            child: Text(
                                              Strings.register,
                                              style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.w600),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          height: 45.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void serveRegisterRequestWith() async {

    Loader().showLoader(context);

    if (GlobalModelClass.internetConnectionAvaiable() == true) {
      http.Response response = await http.post(
        Uri.parse(Base_URL + register_URL),
        headers: {
          'Accept': 'application/json',
        },
        body: {
          'user_email': emailController.text,
          'name': nameController.text,
          'user_number': mobileController.text,
          'password': passwordController.text,
          'comp_id': company_id,
          'retype_password': rePasswordController.text,
          'terms_conditions': '1',
        },
      );
      print('The error encountered here1 ${response.statusCode}');
      print(response.body);
      if (response.statusCode == 200) {
        var responseDict = jsonDecode(response.body);
        Loader().hideLoader(context);
        var jsonSuccessKey;
        if (responseDict.containsKey('success')) {
          jsonSuccessKey = responseDict['success'];
        } else {
          jsonSuccessKey = responseDict['status'];
        }
        if (jsonSuccessKey.toString() == 'true') {
          ToastUtils.showSuccess(message: responseDict['message']);
          Get.back();
        } else {
          print('The error encountered here');
          print(responseDict);
          ToastUtils.showError(
              message: responseDict['response']['message'] ??
                  Strings.somethingWentWrong);
        }
      } else {
        Loader().hideLoader(context);
        Map responseDict = jsonDecode(response.body);
        String message = responseDict.values.toString().replaceAll('[', "");
        message = message.replaceAll(']', "");
        message = message.replaceAll('(', "");
        message = message.replaceAll(')', "");
        message = message.replaceAll('.,', ".\n");
        ToastUtils.showError(
          message: message != null && message.length > 0
              ? message
              : Strings.somethingWentWrong,
        );
      }
    } else {
      Loader().hideLoader(context);
      Future.delayed(Duration.zero, () {
        GlobalModelClass.showAlertForNoInternetConnection(context).show();
      });
    }

  }
}
