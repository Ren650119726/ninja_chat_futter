import 'package:ninja_chat/model/message.dart';
import 'package:wukongimfluttersdk/entity/conversation.dart';

class UIConversation {
  String lastContent = '';
  String channelAvatar = '';
  String channelName = '';
  int isMentionMe = 0;
  WKUIConversationMsg msg;
  UIConversation(this.msg);
  bool? isMuted;
  Message? lastMessage;

  String getUnreadCount() {
    if (msg.unreadCount > 0) {
      return '${msg.unreadCount}';
    }
    return '';
  }


}
