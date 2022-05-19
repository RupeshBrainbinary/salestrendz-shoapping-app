import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shoppingapp/utils/commons/export_basic_file.dart';

class FileComplaintPage extends StatefulWidget {
  @override
  _FileComplaintPageState createState() => _FileComplaintPageState();
}

class _FileComplaintPageState extends State<FileComplaintPage> {
  final TextEditingController descriptionController = TextEditingController();
  bool userNameValidate = false;
  bool isUserNameValidate = false;
  // ignore: deprecated_member_use
  List<Asset> images = List<Asset>();

  File asset;

  // ignore: deprecated_member_use
  List imageList = List();

  bool validateTextField(String userInput) {
    if (userInput.isEmpty) {
      setState(() {
        isUserNameValidate = true;
      });
      return false;
    }
    setState(() {
      isUserNameValidate = false;
    });
    return true;
  }

  @override
  void initState() {
    super.initState();
  }

  void selectImage() async {
   //  Color yw = Colors.yellow;
   // String _storeColorValue = yw.value.toString();
    List<Asset> assets =
        await MultiImagePicker.pickImages(
            maxImages: 10,
            enableCamera: false,
            // materialOptions:MaterialOptions(
            //     actionBarColor:_storeColorValue,
            //     statusBarColor: _storeColorValue,
            // )
        );
    if (assets != null && assets.isNotEmpty) {
      assets.forEach(
        (asset) async {
          final image = await Utils.compressAndGetFile(
            await Utils.byteDataToFile(await asset.getByteData()),
          );

          imageList.add(image);
          setState(() {});
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Current page --> $runtimeType");
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            "File a Complaint",
            style: GoogleFonts.poppins(color: Colors.black),
          ),
        ),
        bottomNavigationBar: InkWell(
          onTap: () {
            validateTextField(descriptionController.text) == true
                ? Get.back()
                : SizedBox();
          },
          child: Container(
            margin: EdgeInsets.only(left: 30, right: 30),
            alignment: Alignment.bottomCenter,
            height: Get.height / 18,
            width: Get.width * 0.5,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.red,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(22.0),
                topRight: Radius.circular(22.0),
                bottomLeft: Radius.zero,
                bottomRight: Radius.zero,
              ),
            ),
            child: Text(
              'Submit',
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            height: Get.height,
            margin: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                order(),
                SizedBox(height: 8),
                Divider(thickness: 2),
                SizedBox(height: 5),
                product(),
                SizedBox(height: 8),
                Divider(thickness: 2),
                SizedBox(height: 5),
                complaintDescription(),
                SizedBox(height: 8),
                Divider(thickness: 2),
                SizedBox(height: 5),
                attachPhoto(),
                SizedBox(height: 8),
                Divider(thickness: 2),
                SizedBox(height: 5),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 3,
                    children: List.generate(
                      imageList.length,
                      (index) {
                        File asset = imageList[index];
                        return Container(
                          padding: EdgeInsets.only(left: 10, bottom: 10),
                          child: Image.file(
                            asset,
                            height: 350,
                            width: 300,
                          ),
                        );
                      },
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

  Widget order() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Order",
          style: GoogleFonts.poppins(
            color: Colors.grey,
            fontWeight: FontWeight.w500,
            fontSize: 17,
          ),
        ),
        Row(
          children: [
            Text(
              "#854263",
              style: GoogleFonts.poppins(
                color: Colors.grey,
                fontWeight: FontWeight.w500,
                fontSize: 17,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
              size: 18,
            )
          ],
        ),
      ],
    );
  }

  Widget product() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: Get.width * 0.8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Product",
                  style: GoogleFonts.poppins(
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
                Text(
                  "Raw Pressery Dairy Protein Milkshak with choclate",
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey,
            size: 18,
          ),
        ],
      ),
    );
  }

  Widget complaintDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Complaint Description",
          style: GoogleFonts.poppins(
            color: Colors.grey,
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
        ),
        TextFormField(
          cursorColor: Theme.of(context).primaryColor,
          minLines: 1,
          maxLines: 10,
          controller: descriptionController,
          decoration: InputDecoration(
            errorText: isUserNameValidate ? 'Please enter a Username' : null,
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color:  Theme.of(context).primaryColor,),
            ),
          ),
          keyboardType: TextInputType.multiline,
          style: GoogleFonts.poppins(
            color: Colors.black54,
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
        ),
      ],
    );
  }

  Widget attachPhoto() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Attach Photo(s)",
          style: GoogleFonts.poppins(
            color: Colors.grey,
            fontWeight: FontWeight.w500,
            fontSize: 17,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.red,
          ),
          child: Container(
            margin: EdgeInsets.only(
              top: 5,
              bottom: 5,
              left: 15,
              right: 15,
            ),
            child: InkWell(
              onTap: () {
                selectImage();
                setState(() {});
              },
              child: Row(
                children: [
                  Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.grey,
                    size: 18,
                  ),
                  SizedBox(width: 5),
                  Text(
                    "Add",
                    style: GoogleFonts.poppins(color: Colors.white),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
