import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionController extends GetxController {
  var permissionStatus = PermissionStatus.denied.obs;

  @override
  void onInit() {
    super.onInit();
    // Fetch initial permission status
    checkPermissionStatus();
  }

  Future<void> checkPermissionStatus() async {
    final status = await Permission.storage.status;
    permissionStatus.value = status;
  }

  Future<void> requestStoragePermission() async {
    final status = await Permission.storage.request();
    permissionStatus.value = status;
  }
}
