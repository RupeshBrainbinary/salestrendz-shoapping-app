import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shoppingapp/screen/drawer/drawer.dart';
import 'package:shoppingapp/utils/theme_notifier.dart';
import 'package:shoppingapp/utils/utils.dart';
import 'package:shoppingapp/widgets/commons/string_res.dart';



class LiveImagePage extends StatefulWidget {
  @override
  _LiveImagePageState createState() => _LiveImagePageState();
}

class _LiveImagePageState extends State<LiveImagePage> {
  List imageList = List();

  void selectImage() async {
    List<Asset> assets =
        await MultiImagePicker.pickImages(maxImages: 10, enableCamera: false);
    if (assets != null && assets.isNotEmpty) {
      assets.forEach((asset) async {
        final image = await Utils.compressAndGetFile(
            await Utils.byteDataToFile(await asset.getByteData()));
        imageList.add(image);
        setState(() {});
      });
    }
  }

  _imgFromCamera() async {
    // ignore: invalid_use_of_visible_for_testing_member
    var image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);

    setState(() {
      imageList.add(image);
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Current page --> $runtimeType");
    final themeColor = Provider.of<ThemeNotifier>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: themeColor.getColor()),
          title: Text(
            Strings.mygallery,
            style: GoogleFonts.poppins(
              fontSize: 18,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: InkWell(
                onTap: () {
                  _showPicker(context);
                },
                child: Icon(
                  Icons.add,
                  color: Colors.black,
                  size: 30,
                ),
              ),
            )
          ],
        ),
        drawer: CustomDrawer(),
        body: Container(
          height: Get.height,
          child: GridView.count(
            crossAxisCount: 4,
            children: List.generate(
              imageList.length,
              (index) {
                File asset = imageList[index];
                setState(() {});
                print(asset);
                return Container(
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: Image.file(
                    asset,
                    height: 120,
                    width: 110,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bc) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            color: Colors.white,
          ),
          height: 160,
          child: Column(
            children: [
              Container(
                height: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Padding(
                        padding: EdgeInsets.only(top: 10, right: 10),
                        child: Icon(
                          Icons.close,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 140,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        selectImage();
                        Get.back();
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.lightBlueAccent,
                            ),
                            child: Icon(
                              Icons.photo_library,
                              color: Colors.white,
                              size: 35,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Phone Gallery",
                            style: GoogleFonts.poppins(
                              color: Colors.grey,
                              fontSize: 15,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: 50),
                    InkWell(
                      onTap: () {
                        _imgFromCamera();
                        Get.back();
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.lightGreen[400],
                            ),
                            child: Icon(
                              Icons.photo_camera,
                              color: Colors.white,
                              size: 35,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Camera",
                            style: GoogleFonts.poppins(
                              color: Colors.grey,
                              fontSize: 15,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
