import 'package:flutter/material.dart';

class UnreadMessagesBadge extends StatelessWidget {
  final int unreadCount;
  final double? width;
  final double? height;

  const UnreadMessagesBadge({super.key,
    required this.unreadCount,
    this.width = 22.0,
    this.height = 22.0,
  });

  String generateUnreadText() =>
      unreadCount > 99 ? '99+' : unreadCount.toString();

  double generateFontSize(String text) => text.length * -2 + 13;

  @override
  Widget build(BuildContext context) {
    final unreadText = generateUnreadText();
    final fontSize = generateFontSize(unreadText);
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        // shape: BoxShape.circle,
        color: Colors.red,
        borderRadius: BorderRadius.circular(10),
      ),
      child: unreadText != "0"
          ? Center(
              child: Text(
                unreadText,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: fontSize,
                ),
              ),
            )
          : const SizedBox(),
    );
  }
}