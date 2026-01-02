import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hadirin/services/permission_service.dart';

class ReqCameraController extends GetxController with WidgetsBindingObserver {
  final PermissionService _permissionService = Get.find();

  Rx<PermissionState> cameraPermissionStatus = PermissionState.unkwon.obs;
  RxString feedbackMessage = ''.obs;

  @override
  void onInit() async {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    await checkCameraPermission();
  }

  void onclose() {
    super.onClose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      checkCameraPermission();
    }
  }

  Future<void> checkCameraPermission() async {
    final status = await _permissionService.cameraPermissionStatus;
    _changeStatus(status);
  }

  Future<void> requestCameraPermission() async {
    final status = await _permissionService.requestCameraPermission();
    _changeStatus(status);
  }

  void _changeStatus(PermissionState status) {
    cameraPermissionStatus(status);

    if (status == PermissionState.granted) {
      feedbackMessage('Camera access granted');
    } else {
      feedbackMessage('You need camera access to continue.');
    }
  }

  void next(String nextRoute) async {
    if (cameraPermissionStatus.value == PermissionState.granted) {
      Get.offAllNamed(nextRoute);
    } else if (cameraPermissionStatus.value ==
        PermissionState.permanentlyDenied) {
      await _permissionService.openSetting();
    } else {
      await requestCameraPermission();
    }
  }
}
