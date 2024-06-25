import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:ninja_chat/common/const.dart';
import 'package:ninja_chat/core/wkim.dart';
import 'package:ninja_chat/model/chat.dart';
import 'package:ninja_chat/model/user.dart';
import 'package:ninja_chat/overwrite/controller/theme_controller.dart';
import 'package:ninja_chat/overwrite/pages/conversation/conversation_controller.dart';
import 'package:ninja_chat/overwrite/widget/channel_avatar.dart';
import 'package:ninja_chat/overwrite/widget/channel_name.dart';
import 'package:ninja_chat/page/chats/chats_item.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'package:wukongimfluttersdk/wkim.dart';

import '../../../ui/misc/stream_svg_icon.dart';

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
    return AnimatedOpacity(
        opacity: uiMsg.isMuted ? 0.5 : 1,
        duration: const Duration(milliseconds: 300),
        child: ListTile(
            leading: ChannelAvatar(
                members: uiMsg.members,
                currentUser: currentUser,
                channelImage: uiMsg.type == 1 ? uiMsg.portrait! : '',
                borderRadius: BorderRadius.circular(4.8),
                constraints:
                    const BoxConstraints.tightFor(height: 44, width: 44)),
            title: Row(
              children: [
                Expanded(
                  child: ChannelName(
                    currentUser: currentUser,
                    members: uiMsg.members,
                    channelName: uiMsg.name!,
                    textStyle: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                    textOverflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            )));
  }

  Widget _buildRow(Chat uiMsg) {
    print(controller.conversationList.length);
    return Container(
        margin: const EdgeInsets.all(10),
        child: Row(
          children: [
            Container(
              decoration: const BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Colors.blue),
              width: 50,
              alignment: Alignment.center,
              height: 50,
              margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: Image.network(
                uiMsg.portrait!,
                height: 200,
                width: 200,
                fit: BoxFit.cover,
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return Image.asset('assets/ic_default_avatar.png');
                },
              ),
            ),
            Expanded(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        uiMsg.name!,
                        maxLines: 1,
                      ),
                      Expanded(
                        child: Text(
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 16),
                          CommonUtils.formatDateTime(uiMsg.lastMsgTimestamp!),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "",
                        style: const TextStyle(
                            color: Color.fromARGB(255, 247, 2, 2),
                            fontSize: 14),
                        maxLines: 1,
                      ),
                      Text(
                        uiMsg.msg!,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 14),
                        maxLines: 1,
                      ),
                      Expanded(
                        child: Text(
                          style: const TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                          uiMsg.unread.toString(),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  )
                ]))
          ],
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
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 20.0,
                    left: 8,
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          '菜单',
                          style: const TextStyle(
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
                      onTap: () async {},
                      title: Text(
                        '登出',
                        style: const TextStyle(
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
