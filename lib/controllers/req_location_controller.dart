import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hadirin/pages/request_location_page.dart';
import 'package:hadirin/services/permission_service.dart';

class ReqLocationController extends GetxController with WidgetsBindingObserver {
  final PermissionService _permissionService = Get.find();

  Rx<PermissionState> locationPermissionStatus = PermissionState.unkwon.obs;
  RxString feedbackMessage = ''.obs;

  @override
  void onInit() async {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    await checkLocationPermission();
  }

  void onclose() {
    super.onClose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      checkLocationPermission();
    }
  }

  Future<void> checkLocationPermission() async {
    final status = await _permissionService.locationPermissionStatus;
    _changeStatus(status);
  }

  Future<void> requestLocationPermission() async {
    final status = await _permissionService.requestLocationPermission();
    _changeStatus(status);
  }

  void _changeStatus(PermissionState status) {
    locationPermissionStatus(status);

    if (status == PermissionState.granted) {
      feedbackMessage('Location access granted');
    } else {
      feedbackMessage('You need location access to continue.');
    }
  }

  void next(ReqLocationProps data) async {
    if (locationPermissionStatus.value == PermissionState.granted) {
      if (await _permissionService.cameraPermissionStatus ==
          PermissionState.granted) {
        Get.offNamed(data.targetRoute!);
        return;
      }
      Get.offAllNamed(data.nextRoute, arguments: data.targetRoute);
    } else if (locationPermissionStatus.value ==
        PermissionState.permanentlyDenied) {
      await _permissionService.openSetting();
    } else {
      await requestLocationPermission();
    }
  }
}
