import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class DownloadController extends GetxController {
  Dio _dio = Dio();

  String getUniqueFileName(String baseFileName, String extension) {
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    String uniqueFileName = '$baseFileName' + '_$timestamp.$extension';
    return uniqueFileName;
  }

  Future<void> downloadFile(
      String url,
      String fileName,
      BuildContext context,
      ) async {
    try {
      //Default path -> /storage/emulated/0/Android/data/com.example.json_to_excel/files/
      Directory? downloadsDir = Platform.isAndroid
          ? await getExternalStorageDirectory()
          : await getApplicationDocumentsDirectory();

      // //Custom path -> /storage/emulated/0/ReConnect/
      // String downloadsPath = '/storage/emulated/0/';
      // String subDirectory = 'ReConnect';
      // Directory downloadsDir = Directory('$downloadsPath$subDirectory');

      String pptFileName = getUniqueFileName('ReConnect_PPT', 'pptx');
      String savePath = '${downloadsDir!.path}/$pptFileName';

      await _dio.download(
        url,
        savePath,
        options: Options(responseType: ResponseType.bytes),
        onReceiveProgress: (received, total) {
          if (total != -1) {
            print((received / total * 100).toStringAsFixed(0) + "%");
          }
        },
      );


      print('Download complete: $savePath');

      // Show success snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('File saved to: $savePath'),
          duration: Duration(seconds: 5),
          backgroundColor: Colors.green,
          action: SnackBarAction(
            label: 'Open',
            textColor: Colors.blue,
            onPressed: () {
              OpenFile.open(savePath);
            },
          ),
        ),
      );
    } catch (e) {
      print('Download error: $e');
      // Show error snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          duration: Duration(seconds: 5),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
