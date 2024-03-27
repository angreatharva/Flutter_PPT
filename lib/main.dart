import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ppt_link/downloadController.dart';
import 'package:ppt_link/permissioncontroller.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PermissionScreen(),
    );
  }
}

class PermissionScreen extends StatelessWidget {
  const PermissionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PermissionController _permissionController =
    Get.put(PermissionController());
    final DownloadController downloadController =
    Get.put(DownloadController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Download PPT'),
      ),
      body: Center(
        child: Obx(
              () {
            final permissionStatus =
                _permissionController.permissionStatus.value;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Storage Permission Status: \n $permissionStatus',
                  style: TextStyle(fontSize: 18),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (permissionStatus == PermissionStatus.granted) {
                      String url = "https://beta-reconnect.colliersasia.com/Documents/Japan/DealReport/Reports/Test Company mobile app_26032024094552.pptx";
                      String savePath = "test_file.pptx";

                      downloadController.downloadFile(url, savePath, context);
                    } else {
                      await _permissionController.requestStoragePermission();
                    }
                  },
                  child: Text('Download'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

}
