import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat/model/chat.dart';
import 'package:chat/theme/color.dart';
import 'package:chat/theme/theme_controller.dart';
import 'package:chat/utils/screen_utils.dart';
import 'package:chat/widget/avatar.dart';
import 'package:chat/widget/unread_message.dart';

class ChatsItem extends StatelessWidget {
  final Chat chat;

  const ChatsItem({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    bool isDisturb = true;
    final theme = Get.find<ThemeController>().theme.value;
    final isDesktopScreen =
        TUIKitScreenUtils.getFormFactor(context) == DeviceType.Desktop;
    return Container(
      padding: const EdgeInsets.only(top: 6, bottom: 6, left: 16, right: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.conversationItemBorderColor ??
                CommonColor.weakDividerColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 0, bottom: 2, right: 0),
            child: SizedBox(
              width: isDesktopScreen ? 40 : 44,
              height: isDesktopScreen ? 40 : 44,
              child: Stack(
                fit: StackFit.expand,
                clipBehavior: Clip.none,
                children: [
                  Avatar(
                      isOnline: chat.online,
                      faceUrl: chat.portrait!,
                      localPortrait: chat.localPortrait??''),
                  if (chat.unread != 0)
                    Positioned(
                      top: isDisturb ? -2.5 : -4.5,
                      right: isDisturb ? -2.5 : -4.5,
                      child: UnconstrainedBox(
                        child: UnreadMessagesBadge(
                            width: isDisturb ? 10 : 18,
                            height: isDisturb ? 10 : 18,
                            unreadCount: isDisturb ? 0 : chat.unread),
                      ),
                    )
                ],
              ),
            ),
          ),
          Expanded(
              child: Container(
            height: 60,
            margin: EdgeInsets.only(left: isDesktopScreen ? 10 : 12),
            padding: const EdgeInsets.only(top: 0, bottom: 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Text(
                      chat.name ?? "",
                      softWrap: true,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        height: 1,
                        color: theme.conversationItemTitleTextColor,
                        fontSize: isDesktopScreen ? 14 : 18,
                        fontWeight: FontWeight.w400,
                      ),
                    )),
                    Text(
                      chat.timestamp ?? "",
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        child: Text(
                      chat.msg ?? "",
                      maxLines: 1,
                      style: Theme.of(Get.context!).textTheme.displaySmall,
                    )),
                    if (isDisturb)
                      SizedBox(
                        width: 18,
                        height: 18,
                        child: Icon(
                          Icons.notifications_off,
                          color: theme.conversationItemNoNotificationIconColor,
                          size: isDesktopScreen ? 14 : 16.0,
                        ),
                      )
                  ],
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }
}
