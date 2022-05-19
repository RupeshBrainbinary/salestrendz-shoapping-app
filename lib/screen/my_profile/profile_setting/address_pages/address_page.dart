import 'dart:convert';
import 'dart:io';
import 'package:shoppingapp/utils/commons/export_basic_file.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

final BookOrderModel bookOrderObj = BookOrderModel.orderModelObj;
List addressListForBookOrder = [];

class AddressPage extends StatefulWidget {
  @override
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  int index1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAddressListFromServer();
  }

  void getAddressListFromServer() async {
    if (GlobalModelClass.internetConnectionAvaiable() == true) {
      String loggedInUserId = LoginModelClass.loginModelObj
          .getValueForKeyFromLoginResponse(key: 'user_id');

      http.Response resp = await http.get(
          Uri.parse(
              Base_URL + addressList + '&logged_in_userid=$loggedInUserId'),
          headers: {
            'Authorization': LoginModelClass.loginModelObj
                .getValueForKeyFromLoginResponse(key: 'token'),
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          });

      bookOrderObj.showLoadingIndicator = true;
      setState(() {});
      if (resp.statusCode == 200) {
        var jsonBodyResp = jsonDecode(resp.body);

        if (jsonBodyResp['status'] == true) {
          setState(() {
            addressListForBookOrder = jsonBodyResp['result'] ?? [];
            print("Hello $addressListForBookOrder");
            bookOrderObj.showLoadingIndicator = false;
            if (addressListForBookOrder.length != 0) {
              bookOrderObj.selectedAddressForOrderBooking =
                  addressListForBookOrder
                          .where((element) =>
                              element['is_default_address'].toString() == '1')
                          ?.first ??
                      {};
            }
          });
        } else {
          //handle false conditions
        }
      } else {
        bookOrderObj.showLoadingIndicator = false;
        setState(() {});

        print('Error occurred while serving request');
      }
    } else {
      Future.delayed(Duration.zero, () {
        GlobalModelClass.showAlertForNoInternetConnection(
                context, getAddressListFromServer)
            .show();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<ThemeNotifier>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          leading: InkWell(
            onTap: () async {
              Get.back();
            },
            child: Icon(
              Platform.isAndroid ? Icons.arrow_back : Icons.chevron_left,
              size: 25,
            ),
          ),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          title: Text(
            Strings.MyAddress,
            style: GoogleFonts.poppins(color: Colors.black),
          ),
          centerTitle: true,
        ),
        bottomNavigationBar: InkWell(
          onTap: () async {
            await Nav.route(context, NewAddressPage());
          },
          child: Container(
            margin: EdgeInsets.only(
              left: 14,
              right: 14,
              bottom: 5,
            ),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                Strings.addnewaddre,
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            ),
            height: 42,
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
        body: Container(
          padding: EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 16),
                addressListForBookOrder == null
                    ? Container(
                        child: Center(child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(themeColor.getColor()))),
                      )
                    : Container(
                        margin: EdgeInsets.all(8),
                        child: addressListForBookOrder.isNotEmpty
                            ? ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: addressListForBookOrder.length ?? 0,
                                itemBuilder: (context, index) =>
                                    buildAddressItem(context, index),
                              )
                            : Container(
                                height: Get.height * 0.6,
                                child: Center(
                                  child: Text(
                                    Strings.addnotfound,
                                    style: GoogleFonts.poppins(
                                      fontSize: 25,
                                      color: Colors.grey[500],
                                    ),
                                  ),
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

  Container buildAddressItem(BuildContext context, int index) {
    final themeColor = Provider.of<ThemeNotifier>(context);
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            child: Text(
              addressListForBookOrder[index]['address_label'].toString(),
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            alignment: Alignment.topLeft,
          ),
          Container(
            height: 2,
            width: 25,
            color: themeColor.getColor(),
          ),
          SizedBox(height: 15),
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(.2),
                    blurRadius: 6.0, // soften the shadow
                    offset: Offset(0.0, 1.0),
                  )
                ]),
            child: InkWell(
              onTap: () {
                index1 = 0;

                final first = addressListForBookOrder.removeAt(index);
                addressListForBookOrder.insert(0, first);
                setState(() {});
              },
              child: Column(
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(width: 27),
                          AutoSizeText(
                            addressListForBookOrder[index]['name'].toString(),
                            minFontSize: 12.0,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.home_outlined, color: Colors.grey),
                          SizedBox(width: 3),
                          Expanded(
                            child: AutoSizeText(
                              '${addressListForBookOrder[index]['street_address'].toString()}' +
                                  ', ${addressListForBookOrder[index]['town'].toString()}' +
                                  ', ${addressListForBookOrder[index]['state'].toString()}' +
                                  ', ${addressListForBookOrder[index]['contry'].toString()}' +
                                  '  - ${addressListForBookOrder[index]['pincode'].toString()}',
                              minFontSize: 12.0,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(Icons.call, color: Colors.grey),
                          Expanded(
                            child: AutoSizeText(
                              ' ${addressListForBookOrder[index]['email'].toString()}' +
                                  '\n ${addressListForBookOrder[index]['phone'].toString()}',
                              minFontSize: 12.0,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  index1 == index
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Align(
                              child: Text(
                                Strings.makeasdefault,
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              alignment: Alignment.topLeft,
                            ),
                            IconButton(
                              icon: Icon(Icons.check_box),
                              onPressed: () {},
                              iconSize: 30.0,
                            ),
                          ],
                        )
                      :SizedBox(),
                  (addressListForBookOrder[0]['is_default_address']
                                  ?.toString() ??
                              '') !=
                          '1'
                      ? Align(
                          child: IconButton(
                              icon: Icon(Icons.check_box), onPressed: () {}),
                          alignment: Alignment.topRight,
                        )
                      :SizedBox(),
                ],
              ),
            ),
            margin: EdgeInsets.only(bottom: 18),
            padding: EdgeInsets.only(top: 10, left: 24, right: 10, bottom: 15),
          ),
        ],
      ),
    );
  }
}
