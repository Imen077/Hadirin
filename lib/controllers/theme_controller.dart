import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  final _box = GetStorage();
  final _themeBoxName = "isDarkMode";

  final Rx<ThemeMode> _themeMode = ThemeMode.system.obs;

  ThemeMode get themeMode => _themeMode.value;

  void toggleTheme() {
    _themeMode.value = _themeMode.value == 
    ThemeMode.light 
    ? ThemeMode.dark 
    : ThemeMode.light;
    _box.write(_themeBoxName, _themeMode.value == ThemeMode.dark);
  }

    @override
    void onInit() {
      super.onInit();
      final isDarkMode = _box.read(_themeBoxName) ?? false;
      _themeMode.value = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    }
}