import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:ninja_chat/model/chat.dart';
import 'package:wukongimfluttersdk/entity/conversation.dart';
import 'package:wukongimfluttersdk/type/const.dart';
import 'package:wukongimfluttersdk/wkim.dart';

class ConversationController extends GetxController {
  final _conversationList = <Chat>[].obs;

  List<Chat> get conversationList => _conversationList.value;

  get connectionStatusStr => ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initListener();
    _getDataList();
  }

  void _getDataList() {
    WKIM.shared.conversationManager.getAll().then((result) async {
      print(result.length);
      for (var i = 0; i < result.length; i++) {
        _conversationList.add(await Chat.fromConversation(result[i]));
      }
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
            conversationList[i].msg = '';
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
    });
  }
}
