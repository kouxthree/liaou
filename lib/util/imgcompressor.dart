import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import '../consts.dart';

class ImgCompressor {
  late String srcFullFileName;
  late Directory _docDir;
  late Directory _tmpDir;
  late String _dstFileName;

  ImgCompressor(String srcFullFileName) {
    this.srcFullFileName = srcFullFileName;
  }

  Future<void> _init() async {
    _docDir = await path_provider.getApplicationDocumentsDirectory();
    _tmpDir = await path_provider.getTemporaryDirectory();
    String tmp1 = _docDir.absolute.path;
    String tmp2 = Consts.MY_IMG_FILE;
    _dstFileName = '$tmp1/$tmp2';
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<String> compress() async {
    _init();
    //final srcFile = File(srcFullFileName);
    //final srcData = await srcFile.readAsBytes();
    // final dstData = await FlutterImageCompress.compressWithList(
    //   srcData,
    final dstData = await FlutterImageCompress.compressWithFile(
      srcFullFileName,
      minHeight: 480,
      minWidth: 640,
      quality: 50,
      format: CompressFormat.jpeg,
    );
    if(dstData != null) {
      File dstFile = File(_dstFileName);
      // File dstFile = createFile(_dstFileName);
      //dstFile.createSync(recursive: true);
      // dstFile.writeAsBytesSync(dstData.buffer.asUint8List(),flush: true, mode: FileMode.write);
      dstFile.writeAsBytesSync(
          dstData.buffer.asUint8List(), flush: true, mode: FileMode.write);
      }
    return _dstFileName;

    // ImageProvider provider = FileImage(imageFile);
    // _myimg = Image(image:provider, fit:BoxFit.cover);
  }
  // File createFile(String path) {
  //   final file = File(path);
  //   if (!file.existsSync()) {
  //     file.createSync(recursive: true);
  //   }
  //   return file;
  // }
}