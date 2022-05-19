import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:shoppingapp/app_url_name_companyid.dart';
import 'package:shoppingapp/models/GlobalModelClass.dart';
import 'package:shoppingapp/models/LoginModelClass.dart';
import 'package:shoppingapp/screen/drawer/drawer.dart';
import 'package:shoppingapp/screen/ledgers_pages/Ledgers_page.dart';
import 'package:shoppingapp/screen/ledgers_pages/ledger_report_page.dart';
import 'package:shoppingapp/utils/commons/export_basic_file.dart';
import 'package:shoppingapp/utils/constants/constants_app_variables.dart';
import 'package:shoppingapp/utils/theme_notifier.dart';
import 'package:shoppingapp/widgets/commons/string_res.dart';
import 'package:http/http.dart' as http;

class LedgersMainPage extends StatefulWidget {
  @override
  _LedgersMainPageState createState() => _LedgersMainPageState();
}

class _LedgersMainPageState extends State<LedgersMainPage> {
  int _value = 1;
  bool showReport = false;

  var versionCode;
  var forceUpdate;
  var alertDialog;
  String version;
  String buildNumber;
  String image;
  bool show = true;

  void refreshView() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPackageInfo();
    initialApi();
  }

  initialApi() async {
    String url = Base_URL + QRcode + '&logged_in_userid=$loggedInUserId';
    print("QRCOde url====>$url");
    print("token");
    print(LoginModelClass.loginModelObj
        .getValueForKeyFromLoginResponse(key: 'token'));
    try {
      http.Response response = await http.get(Uri.parse(url), headers: {
        'Authorization': LoginModelClass.loginModelObj
            .getValueForKeyFromLoginResponse(key: 'token'),
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      });
      if (response.statusCode == 200) {
        print(jsonDecode(response.body));
        var res = jsonDecode(response.body);
        image = res['qr_code'];
        setState(() {
          show = false;
        });
      }
      else{
        setState(() {
          show = false;
        });
      }
    } catch (e) {
      setState(() {
        show = false;
      });

      print(e.toString());
    }
  }

  Future<void> initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      version = info.version;
      buildNumber = info.buildNumber;
    });
    versionCode = await LoginModelClass.loginModelObj.getVersionCode();
    forceUpdate = await LoginModelClass.loginModelObj.getForceUpdate();
    if (forceUpdate.toString().toLowerCase() == "true") {
      if (versionCode.toString() != version.toString()) {
        if (alertDialog == null) {
          Future.delayed(Duration.zero, () {
            alertDialog =
                GlobalModelClass.showAlertForUpdate(context, refreshView);
            alertDialog.show();
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<ThemeNotifier>(context);
    print("Current page --> $runtimeType");
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: themeColor.getColor()),
          title: InkWell(
            onTap: () {
              setState(() {
                if (showReport == false) {
                  showReport = true;
                } else if (showReport == true) {
                  showReport = false;
                }
                return null;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  appName,
                  style: GoogleFonts.poppins(color: Colors.black),
                ),
                /*  Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.black54,
                )*/
              ],
            ),
          ),
    /*      actions: [
            InkWell(
              onTap: () {
                _sortingBottomSheet();
                setState(() {});
              },
              child: Icon(
                Icons.more_horiz,
                color: Colors.grey,
                size: 30,
              ),
            ),
            SizedBox(width: 10)
          ],*/
        ),
        drawer: CustomDrawer(),
        body: show == true
            ? Center(child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(themeColor.getColor())))
            : Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        Strings.ScanQr + " " + appName,
                        style: GoogleFonts.poppins(color: Colors.black),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: CachedNetworkImage(
                        imageUrl: image,
                        placeholder: (context, url) =>SizedBox(),
                        errorWidget: (context, url, error) => Center(
                          child: Container(
                            child: Text("QR code not found for this payment"),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ) /*Container(
          height: Get.height,
          child: Column(
            children: [!showReport ? LedgersPage() : LedgerReportPage()],
          ),
        )*/
        ,
      ),
    );
  }

  void _sortingBottomSheet() {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              final themeColor = Provider.of<ThemeNotifier>(context);
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10),
                      color: themeColor.getColor(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            Strings.SelectAction,
                            style: GoogleFonts.poppins(color: Colors.white),
                          ),
                          InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Icon(Icons.close, color: Colors.white),
                          )
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.all(10),
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                color: themeColor.getColor(),
                              ),
                              child: Icon(
                                Icons.ios_share,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                            Text(
                              Strings.Export,
                              style: GoogleFonts.poppins(color: Colors.black54),
                            ),
                          ],
                        )
                      ],
                    ),
                    Divider(height: 2),
                    Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.all(10),
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                color: themeColor.getColor(),
                              ),
                              child: Icon(
                                Icons.filter_alt_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                            Text(
                              Strings.Filter,
                              style: GoogleFonts.poppins(color: Colors.black54),
                            ),
                          ],
                        )
                      ],
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

  Widget dropdown() {
    return DropdownButton(
        value: _value,
        items: [
          DropdownMenuItem(
            child: Text("First Item"),
            value: 1,
          ),
          DropdownMenuItem(
            child: Text("Second Item"),
            value: 2,
          ),
          DropdownMenuItem(child: Text("Third Item"), value: 3),
          DropdownMenuItem(child: Text("Fourth Item"), value: 4)
        ],
        onChanged: (value) {
          setState(() {
            _value = value;
          });
        });
  }
}
