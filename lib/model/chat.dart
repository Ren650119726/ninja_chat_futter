import 'package:ninja_chat/model/member.dart';
import 'package:ninja_chat/model/message.dart';
import 'package:wukongimfluttersdk/entity/channel.dart';
import 'package:wukongimfluttersdk/entity/conversation.dart';
import 'package:wukongimfluttersdk/entity/msg.dart';
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

  //是否静音
  bool isMuted = false;

  int type = 1;

  //群成员，此处群成员不是全部群成员
  List<Member> members = [];

  Message? wkMsg;

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
    chat.isMuted = await getIsMuted(conversation);
    chat.members = await getMembers(conversation);
    chat.type = conversation.channelType;
    chat.wkMsg = await getMessage(conversation);
    chat.lastMsgTimestamp = conversation.lastMsgTimestamp;
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

  static Future<bool> getIsMuted(WKUIConversationMsg conversation) async {
    bool isMuted = false;
    var channel = await conversation.getWkChannel();
    if (channel != null) {
      isMuted = channel.mute == 1;
    }
    return isMuted;
  }

  static Future<List<Member>> getMembers(WKUIConversationMsg conversation) {
    if (conversation.channelType == 1) {
      return Future.value([]);
    }
    return Future.value([
      Member(
        uid: "1",
        groupNo: conversation.channelID,
        name: "张三",
        remark: "",
        role: 0,
        version: 0,
        isDeleted: 0,
        status: 0,
        vercode: "",
        inviteUid: "",
        robot: 0,
        forbiddenExpirTime: 0,
        avatar:
            'https://img2.baidu.com/it/u=2559320899,1546883787&fm=253&fmt=auto&app=138&f=JPEG?w=441&h=499',
      ),
      Member(
        uid: "2",
        groupNo: conversation.channelID,
        name: "李四",
        remark: "",
        role: 0,
        version: 0,
        isDeleted: 0,
        status: 0,
        vercode: "",
        inviteUid: "",
        robot: 0,
        forbiddenExpirTime: 0,
        avatar: 'https://q6.itc.cn/q_70/images03/20240527/b7a98963946e4162938b868807b5ac21.jpeg',
      ),
      Member(
        uid: "3",
        groupNo: conversation.channelID,
        name: "test",
        remark: "",
        role: 0,
        version: 0,
        isDeleted: 0,
        status: 0,
        vercode: "",
        inviteUid: "",
        robot: 0,
        forbiddenExpirTime: 0,
        avatar:
            'https://img2.baidu.com/it/u=2559320899,1546883787&fm=253&fmt=auto&app=138&f=JPEG?w=441&h=499',
      ),
      Member(
        uid: "4",
        groupNo: conversation.channelID,
        name: "test",
        remark: "",
        role: 0,
        version: 0,
        isDeleted: 0,
        status: 0,
        vercode: "",
        inviteUid: "",
        robot: 0,
        forbiddenExpirTime: 0,
        avatar:
            'https://q9.itc.cn/q_70/images03/20240423/cd1a8cb841594416a20f21b49c784647.jpeg',
      )
    ]);
  }

  static Future<Message> getMessage(conversation) async {
    Message msg = Message();
    final value = await conversation.getWkMsg(); // 使用await等待异步操作完成
    if (value != null) {
      msg = Message.fromWKMsg(value);
    }
    return msg;
  }
}
