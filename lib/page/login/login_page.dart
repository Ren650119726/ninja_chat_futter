import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ninja_chat/common/const.dart';
import 'package:ninja_chat/page/chats/chats_page.dart';
import 'package:ninja_chat/page/conversation/conversation_page.dart';
import 'package:ninja_chat/page/conversation/home.dart';
import 'package:ninja_chat/page/login/login_controller.dart';
import 'package:ninja_chat/utils/http.dart';
import 'package:ninja_chat/utils/im.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(LoginController());
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.only(
          left: 24.w,
          right: 24.w,
          top: 24.h,
          bottom: 34.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 24, bottom: 24),
              child: Text(
                'Welcome back',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.all(
                  Radius.circular(12.r),
                ),
                border: Border.all(
                  color: const Color(0x44EEEEEE),
                ),
              ),
              child: TextField(
                controller:
                    TextEditingController(text: 'https://api.githubim.com'),
                textInputAction: TextInputAction.done,
                onChanged: (text) {
                  controller.apiStr.value = text;
                },
                decoration: InputDecoration(
                    prefixIconConstraints: const BoxConstraints(minWidth: 0),
                    suffixIcon: const Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                    ),
                    prefixIcon: SizedBox(width: 18.w),
                    hintText: 'API地址 默认【https://api.githubim.com】'),
              ),
            ),
            10.verticalSpace,
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.all(
                  Radius.circular(12.r),
                ),
                border: Border.all(
                  color: const Color(0x44EEEEEE),
                ),
              ),
              child: TextField(
                textInputAction: TextInputAction.done,
                onChanged: (text) {
                  controller.uidStr.value = text;
                },
                decoration: InputDecoration(
                  prefixIconConstraints: const BoxConstraints(minWidth: 0),
                  suffixIcon: const Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                  ),
                  prefixIcon: SizedBox(width: 18.w),
                  hintText: "uid",
                ),
              ),
            ),
            10.verticalSpace,
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.all(
                  Radius.circular(12.r),
                ),
                border: Border.all(
                  color: const Color(0x44EEEEEE),
                ),
              ),
              child: TextField(
                textInputAction: TextInputAction.done,
                onChanged: (text) {
                  controller.tokenStr.value = text;
                },
                decoration: InputDecoration(
                  prefixIconConstraints: const BoxConstraints(minWidth: 0),
                  suffixIcon: const Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                  ),
                  prefixIcon: SizedBox(width: 18.w),
                  hintText: "token",
                ),
              ),
            ),
            // const Spacer(),
            10.verticalSpace,
            ElevatedButton(
              child: const Text("下一步"),
              onPressed: () async {
                var apiStr = controller.apiStr.value;
                var uidStr = controller.uidStr.value;
                var tokenStr = controller.tokenStr.value;
                // if (apiStr != '') {
                //   HttpUtils.apiURL = apiStr;
                // }
                if (uidStr == '' || tokenStr == '') {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('提示'),
                          content: const Text('uid和token不能为空'),
                          actions: <Widget>[
                            MaterialButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("确定"),
                            ),
                          ],
                        );
                      });
                  return;
                }
                var status = await HttpUtils.login(uidStr, tokenStr);
                if (status == HttpStatus.ok) {
                  UserInfo.token = tokenStr;
                  UserInfo.uid = uidStr;
                  IMUtils.initIM(uidStr, tokenStr).then((result) {
                    if (result) {
                      Get.to(()=> const ConversationPage());
                    }
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
