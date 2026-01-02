import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hadirin/controllers/req_camera_controller.dart';
import 'package:hadirin/services/permission_service.dart';
import 'package:hadirin/widgets/theme_toggle.dart';

class RequestCameraPage extends StatelessWidget {
  final String nextRoute;
  RequestCameraPage({super.key, required this.nextRoute});

  final ReqCameraController controller = Get.put(ReqCameraController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [ThemeToggle()],
        actionsPadding: const EdgeInsets.only(right: 16),
        forceMaterialTransparency: true,
      ),
      body: Center(
        child: Obx(
          () => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.camera_outlined,
                size: 76,
                color:
                    controller.cameraPermissionStatus.value ==
                        PermissionState.granted
                    ? Colors.green
                    : Colors.red,
              ),
              Text(
                controller.feedbackMessage.value,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () => controller.next(nextRoute),
                child: Text(
                  controller.cameraPermissionStatus.value ==
                          PermissionState.granted
                      ? 'Continue'
                      : 'Request Camera Access',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
