import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shoppingapp/utils/commons/export_basic_file.dart';
import 'package:http/http.dart' as http;

BookOrderModel bookOrderObj = BookOrderModel.orderModelObj;

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController passController = TextEditingController();
  TextEditingController newPassController = TextEditingController();
  TextEditingController cNewPassController = TextEditingController();
  bool passwordVisible = true;
  bool passwordVisible1 = true;

  @override
  Widget build(BuildContext context) {
    print("Current page --> $runtimeType");
    ChangePassword model = ChangePassword();
    final themeColor = Provider.of<ThemeNotifier>(context);

    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: InkWell(
          onTap: () async {
            setState(() {
              bookOrderObj.showLoadingIndicator = true;
            });
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
              if (GlobalModelClass.internetConnectionAvaiable() == true) {
                Loader().showLoader(context);
                http.Response response = await http.post(
                    Uri.parse(Base_URL + change_password),
                  headers: {
                    HttpHeaders.authorizationHeader: LoginModelClass
                        .loginModelObj
                        .getValueForKeyFromLoginResponse(key: 'token')
                  },
                  body: {
                    'password': model.password.toString(),
                    'new_password': model.newPassword.toString(),
                    'retype_password': model.retypePassword.toString(),
                    'user_id': LoginModelClass.loginModelObj
                        .getValueForKeyFromLoginResponse(key: 'user_id'),
                    'logged_in_userid': LoginModelClass.loginModelObj
                        .getValueForKeyFromLoginResponse(key: 'user_id'),
                    'comp_id': LoginModelClass.loginModelObj
                        .getValueForKeyFromLoginResponse(key: 'comp_id'),
                    'format': 'json',
                  },
                );

                if (response.statusCode == 200) {
                  var jsonResp = jsonDecode(response.body);
                  print(jsonResp);
                  Loader().hideLoader(context);
                  if (jsonResp['status'] == true) {
                    var titleString = '';
                    if (jsonResp['status'] == true) {
                      titleString = (jsonResp['message']);
                    } else {
                      titleString = (jsonResp['status'])['message'].toString();
                    }
                    ToastUtils.showSuccess(message: titleString);
                    Nav.routeReplacement(context, InitPage());
                  } else {
                    var titleString = '';
                    if (jsonResp['response'] == null) {
                      titleString = (jsonResp['message']);
                    } else {
                      titleString =
                          (jsonResp['response'])['message'].toString();
                    }
                    ToastUtils.showError(message: titleString);
                  }
                } else {
                  print('URL Calling Failed' + response.statusCode.toString());
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => LoginPage()),
                      ModalRoute.withName('/'));
                }
              } else {
                Future.delayed(Duration.zero, () {
                  GlobalModelClass.showAlertForNoInternetConnection(context)
                      .show();
                });
              }
            }
            //}
          },
          child: Container(
            margin: EdgeInsets.only(left: 14, right: 14, bottom: 5),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                Strings.savePassword,
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            ),
            height: 45,
            decoration: BoxDecoration(
              color: themeColor.getColor(),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              ),
            ),
          ),
        ),
        backgroundColor: Color(0xFFFCFCFC),
        appBar: AppBar(
          elevation: 0.0,
          leading: InkWell(
            onTap: () async {
              await Get.back();
            },
            child: Icon(
              Platform.isAndroid ? Icons.arrow_back : Icons.chevron_left,
              size: 25,
            ),
          ),
          title: Text(
            Strings.resetPassword,
            style: GoogleFonts.poppins(color: Colors.black),
          ),
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Colors.white,
        ),
        body: Container(
          padding: EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 16),
                Container(
                  child: Form(
                    //autovalidate: true,
                    autovalidateMode: AutovalidateMode.always,
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        MyTextFormFieldLine(
                          controller: passController,
                          hintText: Strings.Password,
                          validator: (String value) {
                            if (value.isEmpty) {
                              return Strings.EnterPassword;
                            } else {
                              return null;
                            }
                          },
                          onSaved: (String value) {
                            model.password = value;
                          },
                        ),
                        SizedBox(height: 16),
                        MyTextFormFieldLine(
                          controller: newPassController,
                          hintText: Strings.newPassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              passwordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: themeColor.getColor(),
                            ),
                            onPressed: () {
                              setState(() {
                                passwordVisible = !passwordVisible;
                              });
                            },
                          ),
                          isPassword: passwordVisible,
                          validator: (String value) {
                            if (value.isEmpty) {
                              return Strings.EnterPassword;
                            }
                            if (value.length < 6) {
                              return Strings.PasswordShouldBeMinimum6Characters;
                            }
                            model.newPassword = value;
                            _formKey.currentState.save();

                            return null;
                          },
                          onSaved: (String value) {},
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        MyTextFormFieldLine(
                          controller: cNewPassController,
                          hintText: Strings.confirmPassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              passwordVisible1
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: themeColor.getColor(),
                            ),
                            onPressed: () {
                              setState(() {
                                passwordVisible1 = !passwordVisible1;
                              });
                            },
                          ),
                          isPassword: passwordVisible1,
                          validator: (String value) {
                            if (value.isEmpty) {
                              return Strings.EnterPassword;
                            }
                            if (value != newPassController.text) {
                              return Strings.PasswordDoesntSame;
                            }
                            model.retypePassword = value;
                            _formKey.currentState.save();
                            return null;
                          },
                          onSaved: (String value) {},
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
