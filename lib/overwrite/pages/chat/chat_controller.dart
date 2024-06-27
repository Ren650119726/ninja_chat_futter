import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ninja_chat/model/message.dart';
import 'package:wukongimfluttersdk/type/const.dart';
import 'package:wukongimfluttersdk/wkim.dart';

class ChatController extends GetxController {
  late ScrollController scrollController;

  final String channelID;
  final int channelType;
  var title = ''.obs;
  var msgList = RxList<Message>.empty();

  ChatController({required this.channelID, required this.channelType}) {
    getChannelName();
  }

  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController();
    initListener();
    getMsgList(0, 0, true);
  }

  void initListener() {
    WKIM.shared.messageManager.addOnMsgInsertedListener((wkMsg) {
      if (wkMsg.channelID == channelID && wkMsg.channelType == channelType) {
        msgList.add(Message.fromWKMsg(wkMsg));
        Future.delayed(const Duration(milliseconds: 500), () {});
        update();
      }
    });
    WKIM.shared.messageManager.addOnNewMsgListener('chat', (msgs) {
      if (msgs.isEmpty) {
        return;
      }
      for (var i = 0; i < msgs.length; i++) {
        if (msgs[i].setting.receipt == 1) {
          //todo 消息需要回执
        }
        if (msgs[i].isDeleted == 0) {
          msgList.add(Message.fromWKMsg(msgs[i]));
        }
      }
      Future.delayed(const Duration(milliseconds: 500), () {});
      update();
    });

    WKIM.shared.messageManager.addOnRefreshMsgListener('chat', (wkMsg) {
      for (var i = 0; i < msgList.length; i++) {
        if (msgList[i].clientMsgNO == wkMsg.clientMsgNO) {
          msgList[i].messageID = wkMsg.messageID;
          msgList[i].messageSeq = wkMsg.messageSeq;
          msgList[i].status = wkMsg.status;
          msgList[i].wkMsgExtra = wkMsg.wkMsgExtra;
          break;
        }
      }
    });
    // 清除聊天记录
    WKIM.shared.messageManager.addOnClearChannelMsgListener("chat",
        (channelId, channelType) {
      if (channelID == channelId) {
        msgList.clear();
      }
    });
  }

  void getChannelName() {
    WKIM.shared.channelManager
        .getChannel(channelID, channelType)
        .then((channel) {
      WKIM.shared.channelManager.fetchChannelInfo(channelID, channelType);
      if (channelType == WKChannelType.group) {
        title.value = '${channel?.channelName}';
      } else {
        title.value = '${channel?.channelName}';
      }
    });
  }

  getMsgList(int oldestOrderSeq, int pullMode, bool isReset) {
    WKIM.shared.messageManager.getOrSyncHistoryMessages(channelID, channelType,
        oldestOrderSeq, oldestOrderSeq == 0, pullMode, 10, 0, (list) {
      List<Message> uiList = [];
      for (int i = 0; i < list.length; i++) {
        if (pullMode == 0 && !isReset) {
          uiList.add(Message.fromWKMsg(list[i]));
        } else {
          msgList.add(Message.fromWKMsg(list[i]));
        }
      }
      if (uiList.isNotEmpty) {
        msgList.insertAll(0, uiList);
      }
      update();
      if (isReset) {
        Future.delayed(const Duration(milliseconds: 300), () {});
      }
    }, () {
      print('消息同步中');
    });
  }
}
