import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:getflutter/components/button/gf_button.dart';
import 'package:getflutter/types/gf_button_type.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shoppingapp/screen/home_screen/home_screen.dart';
import 'package:shoppingapp/utils/credit_cart/credit_card_form.dart';
import 'package:shoppingapp/utils/credit_cart/credit_card_model.dart';
import 'package:shoppingapp/utils/credit_cart/credit_card_widget.dart';
import 'package:shoppingapp/utils/theme_notifier.dart';
import 'package:shoppingapp/widgets/commons/string_res.dart';

class CreditCartPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CreditCartPageState();
  }
}

class CreditCartPageState extends State<CreditCartPage> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;

  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<ThemeNotifier>(context);

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
      ),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text(
          Strings.MyAddress,
          style: GoogleFonts.poppins(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white12,
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            CreditCardWidget(
              cardBgColor: themeColor.getColor(),
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
              showBackView: isCvvFocused,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    CreditCardForm(
                      themeColor: Color(0xFFFF2933),
                      cursorColor: Color(0xFFFF2933),
                      textColor: Color(0xFFFF2933),
                      onCreditCardModelChange: onCreditCardModelChange,
                    ),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        height: 64,
                        padding: const EdgeInsets.only(
                          left: 16.0,
                          right: 16,
                          top: 24,
                        ),
                        child: GFButton(
                          borderShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(Strings.OrderComplete),
                          color: themeColor.getColor(),
                          onPressed: () {
                            openAlertBox(context, themeColor);
                          },
                          type: GFButtonType.solid,
                          fullWidthButton: true,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  openAlertBox(context, themeColor) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          contentPadding: EdgeInsets.only(top: 10.0),
          content: Container(
            width: 300.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 32,
                ),
                Container(
                  width: 180,
                  child: Text(
                    Strings.yourOrderHasBeenSuccessfullyCompleted,
                    style: GoogleFonts.poppins(
                      color: Color(0xFF5D6A78),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  width: 220,
                  child: RaisedButton(
                    onPressed: () {
                      Get.to(() => HomeScreen());
                    },
                    color: themeColor.getColor(),
                    child: Text(
                      Strings.okey,
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}
