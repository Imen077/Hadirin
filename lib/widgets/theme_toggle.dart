import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hadirin/controllers/theme_controller.dart';

class ThemeToggle extends StatelessWidget {
  ThemeToggle({super.key});

  final ThemeController themeController = Get.find<ThemeController>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => IconButton(
        onPressed: themeController.toggleTheme,
        icon: themeController.themeMode == ThemeMode.light
            ? const Icon(Icons.dark_mode_outlined)
            : const Icon(Icons.light_mode_outlined),
      ),
    );
  }
}
