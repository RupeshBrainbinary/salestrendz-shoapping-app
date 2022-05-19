import 'dart:io';

import 'package:dio/dio.dart';

// import 'package:flutter_file_manager/flutter_file_manager.dart';

import 'package:shoppingapp/models/brochures_model.dart';
import 'package:shoppingapp/screen/activity_pages/brochures/brochures_screen.dart';
import 'package:shoppingapp/utils/commons/export_basic_file.dart';
// import 'package:path_provider_ex/path_provider_ex.dart';
import 'package:path_provider/path_provider.dart'as path;
class BrochuresScreenViewModel{

  BrochuresState state;

  BrochureDataModel brochureDataModel;

  BrochuresScreenViewModel(this.state) {
    getCallBrochures();
  }

  var filename;

  String link;

  getCallBrochures() async {
    var resp = await RestApi.getBrochuresFromServer();
    print(resp);
    brochureDataModel= resp;
    print(brochureDataModel.result.firstPageUrl);


    if (brochureDataModel == null) {
      //print("ABOUT LIST"+data..toString());
      print(brochureDataModel.toString());
      //data2 = Data(attachment: List());
      //print(data2.toString());
      // ignore: deprecated_member_use
    //  contact = HelplineModel(callHelplines: List());
    } else {
      print("ABOUT LIST"+brochureDataModel.toString());
     // data=aboutList;
      //contact = aboutList;
    }

    //getFiles();

    state.setState(() {});
  }

}

/*downloadBook({String downloadLink, String title}) async {

  var dio;
  if (await Permission.storage.request().isGranted) {
    final downloadPath = await path.getExternalStorageDirectory();
    var filePath = downloadPath.path + '/$title';
    print("FILE PATH : "+filePath);
    File file= new File(filePath);
    bool fileExists = await File(filePath).exists();
    if(fileExists){
      print("FILE ALREADY DOWNLOADED");
    }else{
      dio = Dio();
      await dio.download(downloadLink, filePath).then((value) {
        // setState(() {
        //   thisDownloadPath=downloadLink.toString();
        // });
        // print(thisDownloadPath);

        print("DOWNLOAD LINK : "+ downloadLink.toString() +"FilePATH :  " +filePath.toString());

        dio.close();
      }).catchError((Object e) {
        print(e.toString());
        // Fluttertoast.showToast(
        //     msg: "Terjadi kesalahan. Download gagal.", timeInSecForIosWeb: 1);
      });
    }



  } else {

  }
}*/



// var files;
// void getFiles() async { //asyn function to get list of files
//   List<StorageInfo> storageInfo = await PathProviderEx.getStorageInfo();
//   var root = storageInfo[0].rootDir; //storageInfo[1] for SD card, geting the root directory
//   var fm = FileManager(root: Directory(root)); //
//   files = await fm.filesTree(
//     //set fm.dirsTree() for directory/folder tree list
//       excludedPaths: ["/storage/emulated/0/Android"],
//       extensions: ["png", "pdf"] //optional, to filter files, remove to list all,
//     //remove this if your are grabbing folder list
//   );
// print("FILES  "+files.toString());
// //update the UI
// }
