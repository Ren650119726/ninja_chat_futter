import 'package:flutter/material.dart';
import 'package:ninja_chat/common/const.dart';
import 'package:ninja_chat/model/chat.dart';
import 'package:wukongimfluttersdk/entity/conversation.dart';
import 'package:wukongimfluttersdk/entity/reminder.dart';
import 'package:wukongimfluttersdk/type/const.dart';
import 'package:wukongimfluttersdk/wkim.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.redAccent,
      ),
      home: const ListViewShowData(),
    );
  }
}

class ListViewShowData extends StatefulWidget {
  const ListViewShowData({super.key});

  @override
  State<StatefulWidget> createState() {
    return ListViewShowDataState();
  }
}

class ListViewShowDataState extends State<ListViewShowData> {
  List<Chat> msgList = [];

  @override
  void initState() {
    super.initState();
    _getDataList();
    _initListener();
  }

  var _connectionStatusStr = '';

  _initListener() {
    // 监听连接状态事件
    WKIM.shared.connectionManager.addOnConnectionStatus('home',
        (status, reason) {
      if (status == WKConnectStatus.connecting) {
        _connectionStatusStr = '连接中...';
      } else if (status == WKConnectStatus.success) {
        _connectionStatusStr = '最近会话【连接成功】';
      } else if (status == WKConnectStatus.noNetwork) {
        _connectionStatusStr = '网络异常';
      } else if (status == WKConnectStatus.syncMsg) {
        _connectionStatusStr = '同步消息中...';
      } else if (status == WKConnectStatus.kicked) {
        _connectionStatusStr = '未连接，在其他设备登录';
      } else if (status == WKConnectStatus.fail) {
        _connectionStatusStr = '未连接';
      }
      if (mounted) {
        setState(() {});
      }
    });
    WKIM.shared.conversationManager
        .addOnClearAllRedDotListener("chat_conversation", () {
      for (var i = 0; i < msgList.length; i++) {
        msgList[i].unread = 0;
      }
      setState(() {});
    });
    WKIM.shared.conversationManager
        .addOnRefreshMsgListListener('chat_conversation', (msgs) async {
      if (msgs.isEmpty) {
        return;
      }
      List<Chat> list = [];
      for (WKUIConversationMsg msg in msgs) {
        bool isAdd = true;
        for (var i = 0; i < msgList.length; i++) {
          if (msgList[i].channelID == msg.channelID) {
            msgList[i].msg = "";
            isAdd = false;
            break;
          }
        }
        if (isAdd) {
          list.add(await Chat.fromConversation(msg));
        }
      }
      if (list.isNotEmpty) {
        msgList.addAll(list);
      }
      if (mounted) {
        setState(() {});
      }
    });
    // 监听更新消息事件
    // WKIM.shared.conversationManager.addOnRefreshMsgListener('chat_conversation',
    //     (msg, isEnd) async {
    //   bool isAdd = true;
    //   for (var i = 0; i < msgList.length; i++) {
    //     if (msgList[i].msg.channelID == msg.channelID &&
    //         msgList[i].msg.channelType == msg.channelType) {
    //       msgList[i].msg = msg;
    //       msgList[i].lastContent = '';
    //       isAdd = false;
    //       break;
    //     }
    //   }
    //   if (isAdd) {
    //     msgList.add(UIConversation(msg));
    //   }
    //   if (isEnd && mounted) {
    //     setState(() {});
    //   }
    // });
  }

  void _getDataList() {
    Future<List<WKUIConversationMsg>> list =
        WKIM.shared.conversationManager.getAll();
    list.then((result) async {
      for (var i = 0; i < result.length; i++) {
        msgList.add(await Chat.fromConversation(result[i]));
      }

      setState(() {});
    });
  }

  Widget _buildRow(Chat uiMsg) {
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
                        style:
                            const TextStyle(color: Colors.black, fontSize: 18),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_connectionStatusStr),
      ),
      body: ListView.builder(
          shrinkWrap: true,
          itemCount: msgList.length,
          itemBuilder: (context, pos) {
            return GestureDetector(
              onTap: () {},
              child: _buildRow(msgList[pos]),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      persistentFooterButtons: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 240, 117, 2),
          ),
          onPressed: () {
            WKIM.shared.conversationManager.clearAllRedDot();
          },
          child: const Text(
            '清除未读',
            style: TextStyle(color: Colors.white),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 240, 2, 133),
          ),
          onPressed: () {
            if (msgList.isEmpty) {
              return;
            }
          },
          child: const Text(
            '提醒项',
            style: TextStyle(color: Colors.white),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          onPressed: () {
            WKIM.shared.connectionManager.disconnect(false);
          },
          child: const Text(
            '断开',
            style: TextStyle(color: Colors.white),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 31, 27, 239),
          ),
          onPressed: () {
            WKIM.shared.connectionManager.connect();
          },
          child: const Text(
            '重连',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
