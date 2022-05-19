import 'package:flutter/material.dart';
import 'package:shoppingapp/utils/commons/export_basic_file.dart';

var switch1 = false;
var switch2 = false;
var switch3 = false;
var switch4 = false;
var switch5 = false;
var switch6 = false;
var switch7 = false;

class OrderFilterScreen extends StatefulWidget {
  @override
  _OrderFilterScreenState createState() => _OrderFilterScreenState();
}

class _OrderFilterScreenState extends State<OrderFilterScreen> {
  // var switch1 = false;
  // var switch2 = false;
  // var switch3 = false;
  // var switch4 = false;
  // var switch5 = false;
  // var switch6 = false;
  // var switch7 = false;



  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<ThemeNotifier>(context);

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark),
    );
    print("Current page --> $runtimeType");

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            Strings.SelectFilter,
            style: GoogleFonts.poppins(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          actions: <Widget>[
            FlatButton(
              textColor: Colors.white,
              onPressed: () {
                setState(() {
                  switch1 = false;
                  switch2 = false;
                  switch3 = false;
                  switch4 = false;
                  switch5 = false;
                  switch6 = false;
                  switch7 = false;
                });
              },
              child: Text(Strings.ResetDefault,style: GoogleFonts.poppins(color: themeColor.getColor(),fontSize: 11),),
              shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
            ),
          ],
        ),
        body: Column(
          children: [

            //Placed Switch
            SizedBox(height: 10),
            Container(
              margin: EdgeInsets.fromLTRB(20, 5, 5, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    Strings.Placed,
                    style: GoogleFonts.poppins(
                        fontSize: 17, color: Colors.grey[500]),
                  ),
                  Transform.scale(
                    scale: 0.6,
                    child: CupertinoSwitch(
                      activeColor: themeColor.getColor(),
                      value: switch1,
                      onChanged: (bool value) {
                        setState(() {
                          switch1 = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 2,
            ),

            //Cancelled Switch

            Container(
              margin: EdgeInsets.fromLTRB(20, 5, 5, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    Strings.Cancelled,
                    style: GoogleFonts.poppins(
                        fontSize: 17, color: Colors.grey[500]),
                  ),
                  Transform.scale(
                    scale: 0.6,
                    child: CupertinoSwitch(
                      activeColor: themeColor.getColor(),
                      value: switch2,
                      onChanged: (bool value) {
                        setState(() {
                          switch2 = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 2,
            ),

            //PartSupplied Switch

            Container(
              margin: EdgeInsets.fromLTRB(20, 5, 5, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    Strings.PartSupplied,
                    style: GoogleFonts.poppins(
                        fontSize: 17, color: Colors.grey[500]),
                  ),
                  Transform.scale(
                    scale: 0.6,
                    child: CupertinoSwitch(
                      activeColor: themeColor.getColor(),
                      value: switch3,
                      onChanged: (bool value) {
                        setState(() {
                          switch3 = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 2,
            ),

            //Supplied Switch

            Container(
              margin: EdgeInsets.fromLTRB(20, 5, 5, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    Strings.Supplied,
                    style: GoogleFonts.poppins(
                        fontSize: 17, color: Colors.grey[500]),
                  ),
                  Transform.scale(
                    scale: 0.6,
                    child: CupertinoSwitch(
                      activeColor: themeColor.getColor(),
                      value: switch4,
                      onChanged: (bool value) {
                        setState(() {
                          switch4 = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 2,
            ),
            // Confirmed Switch
            Container(
              margin: EdgeInsets.fromLTRB(20, 5, 5, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    Strings.Confirmed,
                    style: GoogleFonts.poppins(
                        fontSize: 17, color: Colors.grey[500]),
                  ),
                  Transform.scale(
                    scale: 0.6,
                    child: CupertinoSwitch(
                      activeColor: themeColor.getColor(),
                      value: switch5,
                      onChanged: (bool value) {
                        setState(() {
                          switch5 = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 2,
            ),
            // Order Dispatched  Switch
            Container(
              margin: EdgeInsets.fromLTRB(20, 5, 5, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    Strings.OrderDispatched,
                    style: GoogleFonts.poppins(
                        fontSize: 17, color: Colors.grey[500]),
                  ),
                  Transform.scale(
                    scale: 0.6,
                    child: CupertinoSwitch(
                      activeColor: themeColor.getColor(),
                      value: switch6,
                      onChanged: (bool value) {
                        setState(() {
                          switch6 = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 2,
            ),
            //Rejected Switch
            Container(
              margin: EdgeInsets.fromLTRB(20, 5, 5, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    Strings.Rejected,
                    style: GoogleFonts.poppins(
                        fontSize: 17, color: Colors.grey[500]),
                  ),
                  Transform.scale(
                    scale: 0.6,
                    child: CupertinoSwitch(
                      activeColor: themeColor.getColor(),
                      value: switch7,
                      onChanged: (bool value) {
                        setState(() {
                          switch7 = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 2,
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: (){
                  //RestApi.getMyOrderApi();
                  Get.back();
                },
                child: Container(
                  height: 50,
                  width: Get.width,
                  decoration: BoxDecoration(
                    color: themeColor.getColor(),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text("Apply Filter",style: TextStyle(color: Colors.white),),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
