import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ninja_chat/model/chat.dart';
import 'package:ninja_chat/model/message.dart';
import 'package:wukongimfluttersdk/entity/conversation.dart';
import 'package:wukongimfluttersdk/type/const.dart';
import 'package:wukongimfluttersdk/wkim.dart';

class ConversationController extends GetxController
    with StateMixin, GetSingleTickerProviderStateMixin {
  late EasyRefreshController refreshController;
  late ScrollController scrollController;

  var connectionStatusStr = ''.obs;
  var conversationList = RxList<Chat>.empty();

  var titleOpacity = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    refreshController = EasyRefreshController();
    scrollController = ScrollController()..addListener(() {});
    _getDataList();
    _initListener();
  }

  Future loadData() async {
    // await Future.delayed(const Duration(seconds: 1));
    _getDataList();
  }

  void _getDataList() {
    conversationList.clear();
    WKIM.shared.conversationManager.getAll().then((result) async {
      for (var i = 0; i < result.length; i++) {
        conversationList.add(await Chat.fromConversation(result[i]));
      }
      Future.delayed(const Duration(milliseconds: 500), () {});
      update();
    });
  }

  _initListener() {
    // 监听连接状态事件
    WKIM.shared.connectionManager.addOnConnectionStatus('home',
        (status, reason) {
      if (status == WKConnectStatus.connecting) {
        connectionStatusStr.value = '连接中...';
      } else if (status == WKConnectStatus.success) {
        connectionStatusStr.value = '最近会话【连接成功】';
      } else if (status == WKConnectStatus.noNetwork) {
        connectionStatusStr.value = '网络异常';
      } else if (status == WKConnectStatus.syncMsg) {
        connectionStatusStr.value = '同步消息中...';
      } else if (status == WKConnectStatus.kicked) {
        connectionStatusStr.value = '未连接，在其他设备登录';
      } else if (status == WKConnectStatus.fail) {
        connectionStatusStr.value = '未连接';
      }
    });
    WKIM.shared.conversationManager
        .addOnClearAllRedDotListener("chat_conversation", () {
      for (var i = 0; i < conversationList.length; i++) {
        conversationList[i].unread = 0;
      }
      update();
    });
    WKIM.shared.conversationManager
        .addOnRefreshMsgListListener('chat_conversation', (msgs) async {
      if (msgs.isEmpty) {
        return;
      }
      List<Chat> list = [];
      for (WKUIConversationMsg msg in msgs) {
        bool isAdd = true;
        for (var i = 0; i < conversationList.length; i++) {
          if (conversationList[i].channelID == msg.channelID) {
            var wkmsg = await Chat.getMessage(msg);
            conversationList[i].wkMsg = wkmsg;
            isAdd = false;
            break;
          }
        }
        if (isAdd) {
          var chat = await Chat.fromConversation(msg);
          list.add(chat);
        }
      }
      if (list.isNotEmpty) {
        conversationList.addAll(list);
      }
      update();
    });
  }
}
