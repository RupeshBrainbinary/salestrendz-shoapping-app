import 'dart:io';
import 'package:shoppingapp/utils/commons/export_basic_file.dart';
import 'package:flutter/material.dart';

class EditUserInfoPage extends StatefulWidget {
  @override
  _EditUserInfoPageState createState() => _EditUserInfoPageState();
}

class _EditUserInfoPageState extends State<EditUserInfoPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text(
            Strings.userInformation,
            style: GoogleFonts.poppins(color: Colors.black),
          ),
          leading: InkWell(
            onTap: () async {
              await Get.back();
            },
            child: Icon(
              Platform.isAndroid ? Icons.arrow_back : Icons.chevron_left,
              size: 25,
            ),
          ),
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
        ),
        backgroundColor: Color(0xFFFCFCFC),
        body: Container(
          padding: EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    NewAddressInput(
                      labelValue: LoginModelClass.loginModelObj
                              .getValueForKeyFromLoginResponse(key: userName) ??
                          '',
                      labelText: Strings.nameSurname,
                      hintText: Strings.nameSurname,
                      isEmail: true,
                      validator: (String value) {},
                      onSaved: (String value) {},
                    ),
                    SizedBox(height: 16),
                    NewAddressInput(
                      labelValue: LoginModelClass.loginModelObj
                              .getValueForKeyFromLoginResponse(
                                  key: userEmail) ??
                          '',
                      labelText: Strings.emailAddress,
                      hintText: Strings.emailHint,
                      isEmail: true,
                      validator: (String value) {},
                      onSaved: (String value) {
//                        model.email = value;
                      },
                    ),
                    SizedBox(height: 16),
                    NewAddressInput(
                      labelValue: LoginModelClass.loginModelObj
                              .getValueForKeyFromLoginResponse(
                                  key: userMobileNumber) ??
                          '',
                      labelText: Strings.MobileNumber,
                      hintText: Strings.MobileHint,
                      isEmail: true,
                      validator: (String value) {},
                      onSaved: (String value) {
//                        model.email = value;
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
