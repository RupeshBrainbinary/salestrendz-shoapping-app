import 'dart:io';
import 'package:shoppingapp/utils/commons/export_basic_file.dart';
import 'package:flutter/material.dart';


class ShowImage extends StatefulWidget {
  final String image;

  const ShowImage({Key key, this.image}) : super(key: key);

  @override
  _ShowImageState createState() => _ShowImageState();
}

class _ShowImageState extends State<ShowImage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        await Get.back();
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: InkWell(
                onTap: (){
                  Get.back();
                },
                child: Icon(Platform.isAndroid ? Icons.arrow_back :Icons.chevron_left,size: 30,)),
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black),
          ),
          body:InteractiveViewer(
            panEnabled: true,
            maxScale: 5,
            minScale: 0.1,
            child: Container(
                width: Get.width,
                height: Get.height,
                color: Colors.white,
                child: Image.network(widget.image)
            ),
          ),
        ),
      ),
    );
  }
}
