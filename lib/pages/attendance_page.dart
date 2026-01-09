import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hadirin/controllers/attendance_controller.dart';
import 'package:hadirin/widgets/theme_toggle.dart';

class AttendancePage extends StatelessWidget {
  AttendancePage({super.key});

  final AttendanceController controller = Get.put(AttendanceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enroll Page'),
        actions: [ThemeToggle()],
        actionsPadding: const EdgeInsets.only(right: 16),
        forceMaterialTransparency: true,
      ),
      body: Obx(() {
        if (!controller.isCameraInitialized.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(controller.feedbackMessage.value),
              ],
            ),
          );
        }

        return Stack(
          children: [
            // Camera Preview
            Align(
              alignment: Alignment.center,
              child: CameraPreview(controller.cameraController),
            ),

            // FeedBack Message
            Positioned(
              top: 20,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(10),
                ),

                child: Text(
                  controller.feedbackMessage.value,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),

            // Border
            Align(
              alignment: Alignment.center,
              child: AspectRatio(
                aspectRatio: 3 / 4,
                child: Container(
                  margin: const EdgeInsets.all(54),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(140),
                    border: Border.all(color: Colors.white, width: 4),
                  ),
                ),
              ),
            ),

            // Capture Button
            Positioned(
              bottom: 60,
              left: 0,
              right: 0,
              child: FloatingActionButton.large(
                // onPressed: controller.captureAndEnrollFace,
                onPressed: () {},
                shape: CircleBorder(),
                child: const Icon(Icons.camera),
              ),
            ),

            // Overlay
            Obx(() {
              if (!controller.isProcessing.value) {
                return const SizedBox.shrink();
              }

              return Container(
                color: Colors.black.withAlpha(180),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text(
                        controller.feedbackMessage.value,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyLarge?.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        );
      }),
    );
  }
}
