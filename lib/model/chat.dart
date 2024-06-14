import 'package:wukongimfluttersdk/entity/channel.dart';
import 'package:wukongimfluttersdk/entity/conversation.dart';
import 'package:wukongimfluttersdk/wkim.dart';

class Chat {
  String? channelID;

  //显示名
  String? name;

  //显示标题
  String? title;

  //显示内容缩略
  String? msg;

  //未读数量
  int unread = 0;

  //显示头像
  String? portrait;

  //显示头像 - 本地
  String? localPortrait;

  //时间戳
  String? timestamp = "";
  int? lastMsgTimestamp;

  //是否在线
  bool online = false;

  static Chat fromConversation(WKUIConversationMsg conversation) {
    Chat chat = Chat();
    chat.channelID = conversation.channelID;
    chat.name = getChannelName(conversation);
    chat.msg = getShowContent(conversation);
    chat.unread = conversation.unreadCount;
    chat.portrait = getChannelAvatarURL(conversation);
    chat.localPortrait = getChannelAvatarURL(conversation);
    chat.lastMsgTimestamp = conversation.lastMsgTimestamp;
    chat.online = getOnlineStatus(conversation);
    return chat;
  }

  static String getChannelName(WKUIConversationMsg conversation) {
    String channelName = "";
    conversation.getWkChannel().then((channel) {
      if (channel != null) {
        if (channel.channelRemark == '') {
          channelName = channel.channelName;
        } else {
          channelName = channel.channelRemark;
        }
      } else {
        WKIM.shared.channelManager
            .fetchChannelInfo(conversation.channelID, conversation.channelType);
      }
    });
    return channelName;
  }

  static String getShowContent(WKUIConversationMsg conversation) {
    String lastContent = "";
    conversation.getWkMsg().then((value) {
      if (value != null && value.messageContent != null) {
        lastContent = value.messageContent!.displayText();
      }
    });
    return lastContent;
  }

  static String getChannelAvatarURL(WKUIConversationMsg conversation) {
    String channelAvatar = "";
    conversation.getWkChannel().then((channel) {
      if (channel != null) {
        channelAvatar = channel.avatar;
      }
      return channelAvatar;
    });
    return channelAvatar;
  }

  static bool getOnlineStatus(WKUIConversationMsg conversation) {
    bool onlineStatus = false;
    conversation.getWkChannel().then((channel) {
      if (channel != null) {
        onlineStatus = channel.online == 1;
      }
    });
    return onlineStatus;
  }
}
