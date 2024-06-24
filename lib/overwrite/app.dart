import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:ninja_chat/overwrite/controller/theme_controller.dart';
import 'package:ninja_chat/overwrite/pages/login/login/login_page.dart';

class ChatApp extends GetView<ThemeController> {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ThemeController());
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      splitScreenMode: false,
      builder: (BuildContext context, Widget? child) {
        return Obx(() => GetMaterialApp(
              title: 'Almaren',
              theme: FlexThemeData.light(
                  colors: const FlexSchemeColor(
                primary: Color(0xFF00296B),
                primaryContainer: Color(0xFFA0C2ED),
                secondary: Color(0xFFD26900),
                secondaryContainer: Color(0xFFFFD270),
                tertiary: Color(0xFF5C5C95),
                tertiaryContainer: Color(0xFFC8DBF8),
                appBarColor: Color(0xffcfdbf2),
              )),
              // The Mandy red, dark theme.
              darkTheme: FlexThemeData.dark(
                  colors: const FlexSchemeColor(
                      primary: Color(0xFFB1CFF5),
                      primaryContainer: Color(0xFF3873BA),
                      secondary: Color(0xFFFFD270),
                      secondaryContainer: Color(0xFFD26900),
                      tertiary: Color(0xFFC9CBFC),
                      tertiaryContainer: Color(0xFF535393))),
              themeMode: controller.themeMode.value,
              debugShowCheckedModeBanner: false,
              home: const LoginPage(),
              defaultTransition: Transition.rightToLeft,
              builder: EasyLoading.init(
                builder: (context, child) => MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    textScaleFactor: 1.0,
                  ),
                  child: child!,
                ),
              ),
            ));
      },
    );
  }
}
