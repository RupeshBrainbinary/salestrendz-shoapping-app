import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:shoppingapp/models/brochures_model.dart';
import 'package:shoppingapp/screen/activity_pages/brochures/brochures_screen_model.dart';
import 'package:shoppingapp/screen/activity_pages/brochures/pdf_and_image_view.dart';
import 'package:path_provider/path_provider.dart'as path;
import 'package:shoppingapp/utils/commons/export_basic_file.dart';


class Brochures extends StatefulWidget {
  @override
  BrochuresState createState() => BrochuresState();
}

class BrochuresState extends State<Brochures> {
  BrochuresScreenViewModel model;

  BrochureDataModel data;

  Attachment attachment;

  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_statements
    model ?? (model = BrochuresScreenViewModel(this));
    final themeColor = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          Strings.brochures,
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
            color: Colors.white,
            size: 25,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: model.brochureDataModel==null?
          Center(
            child:CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(themeColor.getColor()))
          ):
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(
              color: Colors.grey.withOpacity(0.2),
              // height: Get.height * 0.85,
              width: Get.width,
              child: GridView.builder(
                  itemCount: model.brochureDataModel.result.data.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: .85,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return Stack(
                      overflow: Overflow.visible,
                      alignment: Alignment.topCenter,
                      fit: StackFit.loose,
                      children: <Widget>[
                        Container(
                          height: Get.height * 0.3,
                          width: Get.width * 0.5,
                          margin: EdgeInsets.only(
                            left: 10,
                            right: 10,
                            bottom: 10,
                            top: 10,
                          ),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            // border: Border.all(
                            //     width: 2, color: themeColor.getColor()),
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 1.0,
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          left: 20,
                          right: 20,
                          top: 15,
                          child: GestureDetector(
                            onTap: () {
                                 /*   downloadBook(
                                        downloadLink:
                                           model.brochureDataModel.result.data[index].attachments[2].uploadPath,
                                        title: model.brochureDataModel.result.data[index].attachments[2].originalName);*/
                                    model.link=model.brochureDataModel.result.data[index].attachments[2].uploadPath.split(".").last;

                                    print("LINK CONTAINS TIME"+model.link);
                             /*       if(model.link=="pdf") {
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>pdfviewer(index,model)));

                                    }else if (model.link=="jpg" || model.link=="jpeg" || model.link == "png"){
                                      print("IMAGE LINK");

                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ImageViewer(index,model)));
                                    }*/

                            // Navigator.push(context, MaterialPageRoute(builder: (context)=>pdfviewer(index,model)));


                                    // model.filename=model.brochureDataModel.result.data[index].attachments[2].newName;
                                    // print("FILENAME   : " +model.filename );
                                    // _launched = _launchInBrowser(model.brochureDataModel.result.data[index].attachments[2].uploadPath).then((value) => {
                                    // Navigator.push(context, MaterialPageRoute(builder: (context)=>pdfviewer(index,model)))
                                    // });
                                  },
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(width: 2),
                                  image: DecorationImage(
                                      image: NetworkImage(model
                                              .brochureDataModel
                                              .result
                                              .data[index]
                                              .attachments[0]
                                              .uploadPath ??
                                          model
                                              .brochureDataModel
                                              .result
                                              .data[index]
                                              .attachments[1]
                                              .uploadPath))),
                              height: Get.height * 0.2,
                              width: Get.width * 0.5 - 20,
                            ),
                          ),
                        ),
                        Positioned(
                            bottom: 30,
                            left: 20,
                            child: Container(
                                padding: EdgeInsets.all(5),
                                height: 45,
                                width: Get.width * 0.5 - 40,
                                // decoration:
                                //     BoxDecoration(border: Border.all(width: 2)),
                                alignment: Alignment.topLeft,
                                color: Colors.white,
                                child: Text(model.brochureDataModel.result
                                    .data[index].brochureName))),
                        Positioned(
                            top: 15,
                            left: 15,
                            child: CircleAvatar(
                              radius: 17,
                              backgroundColor: Colors.yellow,
                              child: Text(
                                "New",
                                style: TextStyle(
                                    color: themeColor.getColor(), fontSize: 14),
                              ),
                            ))
                      ],
                    );
                  }),
            ),
          )
        ],
      ),
    );
  }
}
Future<void> _launched;

Future<void> _launchInBrowser(String url) async {
  if (await canLaunch(url)) {
    await launch(url, forceSafariVC: false, forceWebView: false, );
  } else {
    throw 'Could not launch $url';
  }





}

