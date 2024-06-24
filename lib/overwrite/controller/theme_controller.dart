import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  // 默认明亮模式
  Rx<ThemeMode> themeMode = ThemeMode.light.obs;

  @override
  void onInit() {
    super.onInit();
    loadThemeMode();
  }

  // 切换主题模式
  void changeThemeMode() {
     themeMode.value == ThemeMode.light
        ? themeMode.value = ThemeMode.dark
        : themeMode.value = ThemeMode.light;
     update();
     saveThemeMode(themeMode.value); // 保存主题模式到 SharedPreferences
  }

  Future<void> saveThemeMode(ThemeMode mode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', mode.index);
  }

  Future<void> loadThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? modeIndex = prefs.getInt('themeMode');
    if (modeIndex != null) {
      themeMode.value = ThemeMode.values[modeIndex];
      update(); // 更新状态
    }
  }
}
