import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:ninja_chat/common/const.dart';
import 'package:ninja_chat/model/chat.dart';
import 'package:ninja_chat/page/chats/chats_item.dart';
import 'package:ninja_chat/page/conversation/conversation_controller.dart';
import 'package:wukongimfluttersdk/wkim.dart';

class ConversationPage extends GetView<ConversationController> {
  const ConversationPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ConversationController());
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.connectionStatusStr.toString())),
      ),
      body: ListView.builder(
          shrinkWrap: true,
          itemCount: controller.conversationList.length,
          itemBuilder: (context, pos) {
            return GestureDetector(
              onTap: () {},
              child: _buildRow(controller.conversationList[pos]),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      persistentFooterButtons: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 240, 117, 2),
          ),
          onPressed: () {
            WKIM.shared.conversationManager.clearAllRedDot();
          },
          child: const Text(
            '清除未读',
            style: TextStyle(color: Colors.white),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 240, 2, 133),
          ),
          onPressed: () {},
          child: const Text(
            '提醒项',
            style: TextStyle(color: Colors.white),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          onPressed: () {
            WKIM.shared.connectionManager.disconnect(false);
          },
          child: const Text(
            '断开',
            style: TextStyle(color: Colors.white),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 31, 27, 239),
          ),
          onPressed: () {
            WKIM.shared.connectionManager.connect();
          },
          child: const Text(
            '重连',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildRow(Chat uiMsg) {
    return Container(
        margin: const EdgeInsets.all(10),
        child: Row(
          children: [
            Container(
              decoration: const BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Colors.blue),
              width: 50,
              alignment: Alignment.center,
              height: 50,
              margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: Image.network(
                uiMsg.portrait ?? "",
                height: 200,
                width: 200,
                fit: BoxFit.cover,
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return Image.asset('assets/ic_default_avatar.png');
                },
              ),
            ),
            Expanded(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        uiMsg.name ?? '',
                        style:
                            const TextStyle(color: Colors.black, fontSize: 18),
                        maxLines: 1,
                      ),
                      Expanded(
                        child: Text(
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 16),
                          CommonUtils.formatDateTime(
                              uiMsg.lastMsgTimestamp!),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "",
                        style: const TextStyle(
                            color: Color.fromARGB(255, 247, 2, 2),
                            fontSize: 14),
                        maxLines: 1,
                      ),
                      Text(
                        uiMsg.msg ?? '',
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 14),
                        maxLines: 1,
                      ),
                      Expanded(
                        child: Text(
                          style: const TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                          uiMsg.unread.toString(),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  )
                ]))
          ],
        ));
  }
}
