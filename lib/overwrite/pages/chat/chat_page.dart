import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'chat_controller.dart';

class ChatPage extends GetView<ChatController> {
  late String channelID;
  late int channelType;

  ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    channelID = Get.parameters['channelID']!;
    channelType = int.parse(Get.parameters['channelType']!);
    Get.put(ChatController(channelID: channelID, channelType: channelType));
    return Scaffold(
        appBar: AppBar(
          title: Obx(() => Text(controller.title.value.tr)),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Stack(
                children: <Widget>[
                  Obx(() => Text(controller.title.value.tr)),
                ],
              ),
            )
          ],
        ));
  }
}
