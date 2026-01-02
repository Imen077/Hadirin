import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hadirin/controllers/req_location_controller.dart';
import 'package:hadirin/services/permission_service.dart';
import 'package:hadirin/widgets/theme_toggle.dart';

class ReqLocationProps {
  final String nextRoute;
  final String? targetRoute;

  ReqLocationProps({required this.nextRoute, this.targetRoute});
}

class RequestLocationPage extends StatelessWidget {
  final ReqLocationProps props;
  RequestLocationPage({super.key, required this.props});

  final ReqLocationController controller = Get.put(ReqLocationController());

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
                Icons.location_on_outlined,
                size: 76,
                color:
                    controller.locationPermissionStatus.value ==
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
                onPressed: () => controller.next(props),
                child: Text(
                  controller.locationPermissionStatus.value ==
                          PermissionState.granted
                      ? 'Continue'
                      : 'Request Location Access',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
