import 'dart:convert';
import 'dart:ui';

import 'package:get/get.dart';
import 'package:ninja_chat/theme/color.dart';
import 'package:ninja_chat/theme/tui_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  // 将 TUITheme 转换为 Rx<TUITheme>
  final Rx<TUITheme> theme = Rx<TUITheme>(TUITheme());

  @override
  void onInit() {
    super.onInit();
    ThemeType themeType = DefTheme.themeTypeFromString(ThemeType.solemn.toString());
    currentThemeType(themeType);
  }

  // 初始化主题
  void initTheme() {
    try {
      Map<String, Color?> jsonMap = Map.from(CommonColor.defaultTheme.toJson());
      theme.value = TUITheme.fromJson(jsonMap);
    } catch (e) {
      // 如果解析失败，使用默认主题
      theme.value = const TUITheme();
    }
  }

  // 更新主题并触发UI更新
  void setTheme(TUITheme newTheme) {
    theme.value = newTheme;
  }

  setDarkTheme() {
    theme.value = TUITheme.dark; //Dark
  }

  setLightTheme() {
    theme.value = TUITheme.light; //Light
  }

  currentThemeType(ThemeType type) {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    _prefs.then((prefs) {
      prefs.setString("themeType", type.toString());
    });
    setTheme(DefTheme.defaultTheme[type]!);
  }
}
