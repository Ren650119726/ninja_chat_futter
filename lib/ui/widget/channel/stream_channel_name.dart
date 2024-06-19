import 'package:flutter/material.dart';
import 'package:ninja_chat/ui/models/member.dart';
import 'package:ninja_chat/ui/models/user.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart' hide Member, User;





/// It shows the current [Channel] name using a [Text] widget.
///
/// This widget directly generates the channel name and does not rely on
/// StreamBuilder for name updates.
class StreamChannelName extends StatelessWidget {
  /// Instantiate a new StreamChannelName
  StreamChannelName({
    Key? key,
    this.textStyle,
    this.textOverflow = TextOverflow.ellipsis,
    this.members,
    this.currentUser,
  }) : super(key: key);

  /// The style of the text displayed
  final TextStyle? textStyle;

  /// How visual overflow should be handled.
  final TextOverflow textOverflow;

  final List<Member>? members;

  final User? currentUser;

  @override
  Widget build(BuildContext context) {
    var channelName = context.translations.noTitleText;
    final otherMembers = members!.where(
      (member) => member.userId != currentUser?.id,
    );

    if (otherMembers.isNotEmpty) {
      if (otherMembers.length == 1) {
        final user = otherMembers.first.user;
        if (user != null) {
          channelName = user.name;
        }
      } else {
        final maxWidth = double.infinity; // No constraints for max width
        final maxChars = maxWidth / (textStyle?.fontSize ?? 1);
        var currentChars = 0;
        final currentMembers = <Member>[];
        otherMembers.forEach((element) {
          final newLength = currentChars + (element.user?.name.length ?? 0);
          if (newLength < maxChars) {
            currentChars = newLength;
            currentMembers.add(element);
          }
        });

        final exceedingMembers = otherMembers.length - currentMembers.length;
        channelName = '${currentMembers.map((e) => e.user?.name).join(', ')} '
            '${exceedingMembers > 0 ? '+ $exceedingMembers' : ''}';
      }
    }

    return Text(
      channelName,
      style: textStyle,
      overflow: textOverflow,
    );
  }
}
