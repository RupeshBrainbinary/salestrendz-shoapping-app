import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shoppingapp/utils/commons/export_basic_file.dart';


class CallHelpline extends StatefulWidget {
  @override
  CallHelplineState createState() => CallHelplineState();
}

class CallHelplineState extends State<CallHelpline> {
  HelpLineViewModel model;

  @override
  Widget build(BuildContext context) {

    // ignore: unnecessary_statements
    model ?? (model = HelpLineViewModel(this));
    final themeColor = Provider.of<ThemeNotifier>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            Strings.callhelpline,
            style: GoogleFonts.poppins(
              color: themeColor.getColor(),
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(
              Platform.isAndroid ? Icons.arrow_back : Icons.chevron_left,
              color: themeColor.getColor(),
              size: 25,
            ),
            onPressed: () {
              Get.back();
            },
          ),
        ),
        body: Column(
          children: [
            Container(
              height: Get.height / 5.5,
              width: Get.width,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: themeColor.getColor(),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.zero,
                  topRight: Radius.zero,
                  bottomLeft: Radius.circular(22.0),
                  bottomRight: Radius.circular(22.0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    Strings.reachout,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
            ),
            Expanded(child: productListData()),
          ],
        ),
      ),
    );
  }

  Widget productListData() {
    final themeColor = Provider.of<ThemeNotifier>(context);
    return model.contact == null
        ? Center(child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(themeColor.getColor())))
        : Container(
            padding: EdgeInsets.only(top: 10),
            margin: EdgeInsets.symmetric(
              horizontal: 5,
            ),
            child: model.contact.callHelplines.isNotEmpty
                ? ListView.builder(
                    itemCount: model.contact.callHelplines.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () async {
                          String url = 'tel:+91' +
                              model.contact.callHelplines[index]
                                  .helplineUserNumber;
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                            left: 10,
                            right: 10,
                            bottom: 10,
                            top: 15,
                          ),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 1.0,
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.all(8),
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: model.contact.callHelplines[index]
                                                .userProfileImage ==
                                            ""
                                        ? AssetImage(
                                            'assets/images/prodcut8.png')
                                        : NetworkImage(model
                                            .contact
                                            .callHelplines[index]
                                            .userProfileImage
                                            .toString()),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(width: 18),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      model.contact.callHelplines[index]
                                          .helplineUsername,
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.call_outlined,
                                          color: Colors.black.withOpacity(0.6),
                                          size: 15,
                                        ),
                                        Text(
                                          model.contact.callHelplines[index]
                                              .helplineUserNumber,
                                          style: GoogleFonts.poppins(
                                            color:
                                                Colors.black.withOpacity(0.6),
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Icon(
                                  Icons.phone_callback_rounded,
                                  color: Colors.grey,
                                  size: 30,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : Container(
                    height: Get.height * 0.8,
                    child: Center(
                      child: Text(
                        Strings.connotfound,
                        style: GoogleFonts.poppins(
                          fontSize: 25,
                          color: Colors.grey[500],
                        ),
                      ),
                    ),
                  ),
          );
  }
}
