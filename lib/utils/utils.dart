import 'dart:io';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path_provider/path_provider.dart' as path_provider;


class Utils {

  static Future<File> getImageFileFromAssets(String path) async {
    Random random = new Random();
    int randomNumber = random.nextInt(10000000);
    final byteData = await rootBundle.load(path);

    final file = File(
        '${(await getTemporaryDirectory()).path}/${randomNumber.toString()}');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  static Future<File> compressAndGetFile(File file) async {
    Random random = new Random();
    int randomNumber = random.nextInt(10000000);
    final dir = await path_provider.getTemporaryDirectory();
    final targetPath =
        dir.absolute.path + "/" + randomNumber.toString() + ".jpg";

    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 50,
      rotate: 0,
    );

    return result;
  }


  static Future<File> byteDataToFile(ByteData data) async {
    Random random = new Random();
    int randomNumber = random.nextInt(10000000);
    final buffer = data.buffer;

    final dir = await path_provider.getTemporaryDirectory();
    final targetPath =
        dir.absolute.path + "/" + randomNumber.toString() + ".jpg";

    return new File(targetPath).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }
}