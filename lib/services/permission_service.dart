import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

enum PermissionState { granted, denied, permanentlyDenied, unkwon }

class PermissionService extends GetxService {
  // Camera
  Future<PermissionState> get cameraPermissionStatus async {
    final status = await Permission.camera.status;
    return _converStatus(status);
  }

  Future<PermissionState> requestCameraPermission() async {
    final status = await Permission.camera.request();
    return _converStatus(status);
  }

  //   location
  Future<PermissionState> get locationPermissionStatus async {
    final status = await Permission.location.status;
    return _converStatus(status);
  }

  Future<PermissionState> requestLocationPermission() async {
    final status = await Permission.location.request();
    return _converStatus(status);
  }

  //   Helper
  Future<void> openSetting() async {
    await openAppSettings();
  }

  PermissionState _converStatus(PermissionStatus status) {
    switch (status) {
      case PermissionStatus.granted:
        return PermissionState.granted;
      case PermissionStatus.permanentlyDenied:
        return PermissionState.permanentlyDenied;
      case PermissionStatus.denied:
        return PermissionState.denied;
      default:
        return PermissionState.unkwon;
    }
  }
}
