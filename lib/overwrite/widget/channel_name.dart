import 'package:flutter/material.dart';

import '../../model/member.dart';
import '../../model/user.dart';

class ChannelName extends StatelessWidget {
  const ChannelName({
    super.key,
    required this.currentUser,
    required this.members,
    required this.channelName,
    this.textStyle,
    this.textOverflow = TextOverflow.ellipsis,
  });

  final String channelName;

  /// The style of the text displayed
  final TextStyle? textStyle;

  /// How visual overflow should be handled.
  final TextOverflow textOverflow;

  final User currentUser;
  final List<Member> members;

  @override
  Widget build(BuildContext context) {
    return _NameGenerator(
      channelName: channelName,
      currentUser: currentUser,
      members: members,
      textStyle: textStyle,
      textOverflow: textOverflow,
    );
  }
}

class _NameGenerator extends StatelessWidget {
  const _NameGenerator({
    required this.channelName,
    required this.currentUser,
    required this.members,
    this.textStyle,
    this.textOverflow,
  });

  final String channelName;
  final User currentUser;
  final List<Member> members;
  final TextStyle? textStyle;
  final TextOverflow? textOverflow;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var channelName = this.channelName;
        final otherMembers = members.where(
          (member) => member.uid != currentUser.uid,
        );

        if (otherMembers.isNotEmpty) {
          if (otherMembers.length == 1) {
            channelName = otherMembers.first.name;
          } else {
            final maxWidth = constraints.maxWidth;
            final maxChars = maxWidth / (textStyle?.fontSize ?? 1);
            var currentChars = 0;
            final currentMembers = <Member>[];
            otherMembers.forEach((element) {
              final newLength = currentChars + (element.name.length ?? 0);
              if (newLength < maxChars) {
                currentChars = newLength;
                currentMembers.add(element);
              }
            });

            final exceedingMembers =
                otherMembers.length - currentMembers.length;
            channelName = '${currentMembers.map((e) => e.name).join(', ')} '
                '${exceedingMembers > 0 ? '+ $exceedingMembers' : ''}';
          }
        }

        return Text(
          channelName,
          style: textStyle,
          overflow: textOverflow,
        );
      },
    );
  }
}
