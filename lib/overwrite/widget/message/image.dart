import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ninja_chat/model/message.dart';
import 'package:ninja_chat/overwrite/widget/gallery/photo.dart';

import 'avatar.dart';
import 'message.dart';

class ImageMessage extends StatefulWidget {
  final Message message;
  final int messageAlign;
  final String avatarUrl;
  final Color? color;

  ImageMessage(
      {Key? key,
      required this.message,
      required this.messageAlign,
      required this.avatarUrl,
      this.color})
      : super(key: key);

  @override
  _ImageMessageState createState() => _ImageMessageState();
}

class _ImageMessageState extends State<ImageMessage> {
  @override
  Widget build(BuildContext context) {
    return _buildImageMessage(context);
  }

  Widget _buildImageMessage(BuildContext context) {
    if (widget.messageAlign == MessageLeftAlign) {
      return Container(
        margin: const EdgeInsets.only(left: 10, top: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: ImAvatar(
                avatarUrl: widget.avatarUrl,
              ),
            ),
            GestureDetector(
              onTap: () => _pushToFullImage(context, widget.message.messageContent!.content),
              child: Container(
                height: 200,
                width: 200,
                margin: const EdgeInsets.only(bottom: 10, left: 4),
                child: Image(
                  image: NetworkImage(widget.message.messageContent!.content + ImageSize),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return GestureDetector(
        onTap: () => _pushToFullImage(context, widget.message.messageContent!.content),
        child: Container(
          margin: const EdgeInsets.only(right: 10, top: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                height: 200,
                width: 200,
                margin: const EdgeInsets.only(bottom: 10, right: 4),
                child: Image(
                  image: NetworkImage(widget.message.messageContent!.content + ImageSize),
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                child: ImAvatar(avatarUrl: widget.avatarUrl),
              ),
            ],
          ),
        ),
      );
    }
  }

  void _pushToFullImage(BuildContext context, String url) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MessageGalleryView(
                backgroundDecoration:
                    const BoxDecoration(color: Colors.black87),
                url: url)));
  }
}
