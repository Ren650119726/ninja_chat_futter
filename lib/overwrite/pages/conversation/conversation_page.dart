import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:ninja_chat/core/wkim.dart';
import 'package:ninja_chat/model/chat.dart';
import 'package:ninja_chat/model/message.dart';
import 'package:ninja_chat/overwrite/controller/theme_controller.dart';
import 'package:ninja_chat/overwrite/pages/conversation/conversation_controller.dart';
import 'package:ninja_chat/overwrite/widget/channel/channel_avatar.dart';
import 'package:ninja_chat/overwrite/widget/channel/channel_name.dart';
import 'package:ninja_chat/routes/routes.dart';
import 'package:ninja_chat/utils/time_ago.dart';
import 'package:ninja_chat/widget/unread_message.dart';
import 'package:wukongimfluttersdk/wkim.dart';

import '../../../ui/misc/stream_svg_icon.dart';
import '../../widget/channel/message_preview_text.dart';

class ConversationPage extends GetView<ConversationController> {
  const ConversationPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ConversationController());
    return Scaffold(
        appBar: AppBar(
          title: Text("会话"),
          centerTitle: true,
        ),
        drawer: LeftDrawer(),
        body: Obx(() => ListView.builder(
            shrinkWrap: true,
            itemCount: controller.conversationList.length,
            itemBuilder: (context, pos) {
              return GestureDetector(
                onTap: () {},
                child: _buildItem(controller.conversationList[pos]),
              );
            })),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: _navBarItems,
          onTap: (index) {
            print(index);
          },
        ));
  }

  List<BottomNavigationBarItem> get _navBarItems {
    return <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Stack(
          clipBehavior: Clip.none,
          children: [
            StreamSvgIcon.message(
              color: Colors.grey,
            ),
            const Positioned(
              top: -3,
              right: -16,
              // child: StreamUnreadIndicator(),
              child: SizedBox(),
            ),
          ],
        ),
        label: "聊天",
      ),
      BottomNavigationBarItem(
        icon: Stack(
          clipBehavior: Clip.none,
          children: [
            StreamSvgIcon.mentions(
              color: Colors.grey,
            ),
          ],
        ),
        label: "提及",
      ),
    ];
  }

  Widget _buildItem(Chat uiMsg) {
    bool isDisturb = false;
    return AnimatedOpacity(
        opacity: uiMsg.isMuted ? 0.5 : 1,
        duration: const Duration(milliseconds: 300),
        child: ListTile(
          leading: GetBuilder<ConversationController>(builder: (controller) {
            return ChannelAvatar(
                members: uiMsg.members,
                currentUser: currentUser,
                channelImage: uiMsg.type == 1 ? uiMsg.portrait! : '',
                borderRadius: BorderRadius.circular(3.6),
                constraints:
                    const BoxConstraints.tightFor(height: 44, width: 44));
          }),
          title: Row(
            children: [
              Expanded(
                child:
                    GetBuilder<ConversationController>(builder: (controller) {
                  return ChannelName(
                    currentUser: currentUser,
                    members: uiMsg.members,
                    channelName: uiMsg.name ?? uiMsg.channelID!,
                    textStyle: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                    textOverflow: TextOverflow.ellipsis,
                  );
                }),
              ),
              if (uiMsg.unread != 0)
                UnconstrainedBox(
                  child:
                      GetBuilder<ConversationController>(builder: (controller) {
                    return UnreadMessagesBadge(
                        width: isDisturb ? 10 : 18,
                        height: isDisturb ? 10 : 18,
                        unreadCount: isDisturb ? 0 : uiMsg.unread);
                  }),
                ),
            ],
          ),
          subtitle: Row(
            children: [
              Expanded(
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: GetBuilder<ConversationController>(
                        builder: (controller) {
                      return ChannelLastMessageText(
                        message: uiMsg.wkMsg!,
                        textStyle: const TextStyle(fontSize: 14),
                      );
                    })),
              ),
              GetBuilder<ConversationController>(builder: (controller) {
                return ChannelLastMessageDate(
                    lastMsgTimestamp: uiMsg.lastMsgTimestamp!);
              })
            ],
          ),
          onTap: () {
            Get.toNamed(
                '${Routes.CHAT_PAGE.name}/${uiMsg.channelID}/${uiMsg.type}');
          },
        ));
  }
}

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).viewPadding.top + 8,
            ),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(
                    bottom: 20.0,
                    left: 8,
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 16.0),
                        child: Text(
                          '菜单',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: ListTile(
                      onTap: () {
                        WKIM.shared.connectionManager.disconnect(true);
                        Get.toNamed(Routes.LOGIN.name);
                      },
                      title: const Text(
                        '登出',
                        style: TextStyle(
                          fontSize: 14.5,
                        ),
                      ),
                      trailing: IconButton(
                        icon: StreamSvgIcon.iconMoon(
                          size: 24,
                        ),
                        onPressed: () async {
                          //切换主题
                          Get.find<ThemeController>().changeThemeMode();
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChannelLastMessageDate extends StatelessWidget {
  const ChannelLastMessageDate({
    super.key,
    required this.lastMsgTimestamp,
    this.textStyle,
  });

  /// The channel to display the last message date for.
  final int lastMsgTimestamp;

  /// The style of the text displayed
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    var stringDate = TimeAgo().getTimeStringForChat(lastMsgTimestamp) ?? "";

    return Text(
      stringDate,
      style: textStyle,
    );
  }
}

class ChannelLastMessageText extends StatefulWidget {
  ChannelLastMessageText({
    super.key,
    required this.message,
    this.textStyle,
  });

  Message message;

  final TextStyle? textStyle;

  @override
  State<ChannelLastMessageText> createState() => _ChannelLastMessageTextState();
}

class _ChannelLastMessageTextState extends State<ChannelLastMessageText> {
  @override
  Widget build(BuildContext context) {
    return MessagePreviewText(
      message: widget.message,
      textStyle: widget.textStyle,
    );
  }
}
