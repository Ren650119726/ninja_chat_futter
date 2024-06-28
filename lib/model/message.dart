import 'package:ninja_chat/model/member.dart';
import 'package:wukongimfluttersdk/entity/msg.dart';

class SyncMessage extends WKSyncMsg {}

class Message extends WKMsg {
  String? text;
  static Message fromWKMsg(WKMsg value) {
    Message msg = Message();
    msg.channelID = value.channelID;
    msg.channelType = value.channelType;
    msg.content = value.content;
    msg.contentType = value.contentType;
    msg.messageContent = value.messageContent!;
    msg.timestamp = value.timestamp;
    msg.reactionList = value.reactionList;
    msg.wkMsgExtra = value.wkMsgExtra;
    msg.messageID = value.messageID;
    msg.messageSeq = value.messageSeq;
    msg.fromUID = value.fromUID;
    return msg;
  }
}

extension MessageX on Message {
  Message replaceMentions({bool linkify = true, required Member member}) {
    var messageTextToRender = text;
    final mentionedUsers = getMentionedUsers();
    for (final userId in mentionedUsers.toSet()) {
      final userName = member.name;
      if (linkify) {
        messageTextToRender = messageTextToRender?.replaceAll(
          RegExp('@($userId|$userName)'),
          '[@$userName]($userId)',
        );
      } else {
        messageTextToRender = messageTextToRender?.replaceAll(
          RegExp('@($userId|$userName)'),
          '@$userName',
        );
      }
    }
    return Message()
      ..text = messageTextToRender;
  }

  List<String> getMentionedUsers() {
    if (messageContent?.mentionInfo == null) {
      return [];
    }
    return messageContent?.mentionInfo?.uids ?? [];
  }
}
