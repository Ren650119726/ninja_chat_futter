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

  static Future<Chat> fromConversation(WKUIConversationMsg conversation) async {
    Chat chat = Chat();
    chat.channelID = conversation.channelID;
    chat.name = await getChannelName(conversation);
    chat.msg = await getShowContent(conversation);
    chat.unread = conversation.unreadCount;
    chat.portrait = await getChannelAvatarURL(conversation);
    chat.localPortrait = await getChannelAvatarURL(conversation);
    chat.lastMsgTimestamp = conversation.lastMsgTimestamp;
    chat.online = await getOnlineStatus(conversation);
    return chat;
  }

  static Future<String> getChannelName(WKUIConversationMsg conversation) async {
    String channelName = "";
    var channel = await conversation.getWkChannel();
    if (channel != null) {
      if (channel.channelRemark == '') {
        channelName = channel.channelName;
      } else {
        channelName = channel.channelRemark;
      }
    } else {
      var fetchChannelInfo = WKIM.shared.channelManager
          .fetchChannelInfo(conversation.channelID, conversation.channelType);
    }
    return channelName;
  }

  static Future<String> getShowContent(WKUIConversationMsg conversation) async {
    String lastContent = "";
    var value = await conversation.getWkMsg();
    if (value != null && value.messageContent != null) {
      lastContent = value.messageContent!.displayText();
    }
    return lastContent;
  }

  static Future<String> getChannelAvatarURL(
      WKUIConversationMsg conversation) async {
    String channelAvatar = "";
    var channel = await conversation.getWkChannel();
    if (channel != null) {
      channelAvatar = channel.avatar;
    }
    return channelAvatar;
  }

  static Future<bool> getOnlineStatus(WKUIConversationMsg conversation) async {
    bool onlineStatus = false;
    var channel = await conversation.getWkChannel();
    if (channel != null) {
      onlineStatus = channel.online == 1;
    }
    return onlineStatus;
  }
}
