import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class UnreadIndicator extends StatelessWidget {
  const UnreadIndicator({
    super.key,
    this.cid,
  });

  final String? cid;

  @override
  Widget build(BuildContext context) {
    //todo 所有会话总未读数
    final data = 1;
    return IgnorePointer(
        child: Material(
      borderRadius: BorderRadius.circular(8),
      color: StreamChatTheme.of(context).channelPreviewTheme.unreadCounterColor,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 5,
          right: 5,
          top: 2,
          bottom: 1,
        ),
        child: Center(
          child: Text(
            '${data > 99 ? '99+' : data}',
            style: const TextStyle(
              fontSize: 11,
              color: Colors.white,
            ),
          ),
        ),
      ),
    ));
  }
}
