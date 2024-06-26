import 'package:flutter/material.dart';
import 'package:ninja_chat/core/wkim.dart';
import 'package:ninja_chat/model/message.dart';
import 'package:wukongimfluttersdk/wkim.dart';

/// A widget that renders a preview of the message text.
class MessagePreviewText extends StatelessWidget {
  /// Creates a new instance of [MessagePreviewText].
  const MessagePreviewText({
    super.key,
    required this.message,
    this.language,
    this.textStyle,
  });

  /// The message to display.
  final Message message;

  /// The language to use for translations.
  final String? language;

  /// The style to use for the text.
  final TextStyle? textStyle;


  Regx() async {
    final messageMentionedUsers = message.messageContent?.mentionInfo?.uids ?? [];
    List<Future<String>> futures = [];
    for (var it in messageMentionedUsers) {
      futures.add(WKIMUtils.getMemberName(message.channelID, message.channelType, it));
    }
    List<String> names = await Future.wait(futures);
    names.map((name) => '@${name}').toList().join('|');

    final mentionedUsersRegex = RegExp(
      names.map((name) => '@${name}').toList().join('|'),
      caseSensitive: false,
    );
    return mentionedUsersRegex;
  }


  @override
  Widget build(BuildContext context) {
    //todo 消息正文
    final messageText = message.messageContent?.displayText();
    //附件消息
    final messageAttachments = [];
    final messageMentionedUsers = message.messageContent?.mentionInfo?.uids ??
        [];


    final mentionedUsersRegex = Regx();

    final messageTextParts = [
      // ...messageAttachments.map((it) {
      //   if (it.type == AttachmentType.image) {
      //     return '📷';
      //   } else if (it.type == AttachmentType.video) {
      //     return '🎬';
      //   } else if (it.type == AttachmentType.giphy) {
      //     return '[GIF]';
      //   }
      //   return it == message.attachments.last
      //       ? (it.title ?? 'File')
      //       : '${it.title ?? 'File'} , ';
      // }),
      if (messageText != null)
        // if (messageMentionedUsers.isNotEmpty)
        //   ...mentionedUsersRegex.allMatchesWithSep(messageText)
        // else
          messageText,
    ];

    final fontStyle = FontStyle.italic;

    final regularTextStyle = textStyle?.copyWith(fontStyle: fontStyle);

    final mentionsTextStyle = textStyle?.copyWith(
      fontStyle: fontStyle,
      fontWeight: FontWeight.bold,
    );

    final spans = [
      for (final part in messageTextParts)
        if (messageMentionedUsers.isNotEmpty)
          TextSpan(
            text: part,
            style: mentionsTextStyle,
          )
        else
          if (messageAttachments.isNotEmpty &&
              messageAttachments
                  .where((it) => it.title != null)
                  .any((it) => it.title == part))
            TextSpan(
              text: part,
              style: regularTextStyle?.copyWith(
                fontStyle: FontStyle.italic,
              ),
            )
          else
            TextSpan(
              text: part,
              style: regularTextStyle,
            ),
    ];

    return Text.rich(
      TextSpan(children: spans),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.start,
    );
  }
}


extension _RegExpX on RegExp {
  List<String> allMatchesWithSep(String input, [int start = 0]) {
    final result = <String>[];
    for (final match in allMatches(input, start)) {
      result.add(input.substring(start, match.start));
      // ignore: cascade_invocations
      result.add(match[0]!);
      // ignore: parameter_assignments
      start = match.end;
    }
    result.add(input.substring(start));
    return result;
  }
}
