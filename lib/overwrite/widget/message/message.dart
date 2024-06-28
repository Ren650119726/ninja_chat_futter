import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:ninja_chat/model/message.dart';
import 'package:ninja_chat/overwrite/widget/message/text.dart';

import 'image.dart';

const int MessageLeftAlign = 1;
const int MessageRightAlign = 2;

//压缩图片，图片对flutter内存的影响很大，压缩防止崩溃
const String ImageSize = '?imageView2/2/w/200/h/200';

AudioPlayer audioPlayer = AudioPlayer();

/*
 * 单条消息
 */
class ImMessageItemView extends StatefulWidget {
  final String avatarUrl;
  final Color color;
  final Message message;
  final int messageAlign;

  ImMessageItemView(
      {Key? key,
        required this.avatarUrl,
        this.color = const Color(0xfffdd82c),
        required this.message,
        this.messageAlign = MessageLeftAlign})
      : super(key: key);

  @override
  _ImMessageItemViewState createState() => _ImMessageItemViewState();
}

class _ImMessageItemViewState extends State<ImMessageItemView> {
  @override
  Widget build(BuildContext context) {
    return _messageView(context);
  }

  Widget _messageView(BuildContext context) {
    if (widget.message.contentType == '1') {
      return TextMessage(
        message: widget.message,
        messageAlign: widget.messageAlign,
        color: widget.color,
        avatarUrl: widget.avatarUrl,
      );
    } else if (widget.message.contentType == '2') {
      return ImageMessage(
        message: widget.message,
        messageAlign: widget.messageAlign,
        color: widget.color,
        avatarUrl: widget.avatarUrl,
      );
    } else if (widget.message.contentType == '3') {
      return SizedBox();
    } else if (widget.message.contentType == '4') {
      return SizedBox();
    }
    return SizedBox();
  }
}