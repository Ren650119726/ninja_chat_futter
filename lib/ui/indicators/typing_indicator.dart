import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:ninja_chat/ui/models/channel.dart';

import '../models/user.dart';
import '../rx/better_stream_builder.dart';
import '../stream_chat.dart';

/// {@template streamTypingIndicator}
/// Shows the list of user who are actively typing.
/// {@endtemplate}
class StreamTypingIndicator extends StatelessWidget {
  /// {@macro streamTypingIndicator}
  const StreamTypingIndicator({
    super.key,
    this.conversation,
    this.alternativeWidget,
    this.style,
    this.padding = EdgeInsets.zero,
    this.parentId,
  });

  /// Style of the text widget
  final TextStyle? style;

  /// List of typing users
  final Conversation? conversation;

  /// The widget to build when no typing is happening
  final Widget? alternativeWidget;

  /// The padding of this widget
  final EdgeInsets padding;

  /// Id of the parent message in case of a thread
  final String? parentId;

  @override
  Widget build(BuildContext context) {

    // StreamChat.of(context).

    final altWidget = alternativeWidget ?? const Offstage();
    //todo
    return Padding(
      padding: padding,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset(
            'animations/typing_dots.json',
            package: 'stream_chat_flutter',
            height: 4,
          ),
          Flexible(
            child: Text(
               '',
              maxLines: 1,
              style: style,
            ),
          ),
        ],
      ),
    );
  }
}
