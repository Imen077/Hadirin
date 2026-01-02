import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hadirin/core/routes.dart';
import 'package:hadirin/pages/request_location_page.dart';
import 'package:hadirin/services/permission_service.dart';
import 'package:hadirin/services/user_service.dart';

class MainCard extends StatelessWidget {
  MainCard({super.key, required this.userService});

  final UserService userService;
  final PermissionService _permissionService = Get.find<PermissionService>();

  void attendanceButton() async {
    final bool isLocstionGranted =
        await _permissionService.locationPermissionStatus ==
        PermissionState.granted;

    final bool isCameraGranted =
        await _permissionService.cameraPermissionStatus ==
        PermissionState.granted;

    if (!isLocstionGranted) {
      Get.toNamed(
        AppRouter.requestLocation,
        arguments: ReqLocationProps(
          nextRoute: AppRouter.requestCamera,
          targetRoute: AppRouter.attendance,
        ),
      );
      return;
    }
    if (!isCameraGranted) {
      Get.toNamed(AppRouter.requestCamera, arguments: AppRouter.attendance);
      return;
    }

    if (isLocstionGranted && isCameraGranted) {
      Get.toNamed(AppRouter.attendance);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withAlpha(100),
            blurRadius: 6,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome, ${userService.firestroreUser.value!.displayName}',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            'You are logged in as ${userService.firestroreUser.value!.email}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: attendanceButton,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
            ),
            icon: Icon(Icons.schedule),
            label: Text('Take Attendance'),
          ),
        ],
      ),
    );
  }
}
