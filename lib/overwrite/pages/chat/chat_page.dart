import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ninja_chat/overwrite/widget/voice/voice.dart';

import 'chat_controller.dart';

class ChatPage extends GetView<ChatController> {
  late String channelID;
  late int channelType;

  ChatPage({super.key});

  FocusNode _focusNode = FocusNode(); // 初始化一个FocusNode控件

  //控制是否显示相册的工具栏
  bool _isShowExpaned = false;

  //控制是否显示emoji
  bool _isShowEmoji = false;

  bool _isShowVoice = true;

  //弹起工具栏的高度
  double _expandedPanelHeight = 200;

  //添加图片滑动的距离
  double _imageScrollHeight = 220;
  List _iconbuttons = [
    {'name': '相册', 'icon': Icons.photo_size_select_actual},
    {'name': '视频', 'icon': Icons.video_label},
    {'name': '拍摄', 'icon': Icons.camera_alt},
    {'name': '视频通话', 'icon': Icons.videocam},
    {'name': '位置', 'icon': Icons.location_on},
    {'name': '名片', 'icon': Icons.person},
    {'name': '文件', 'icon': Icons.folder},
  ];

  @override
  Widget build(BuildContext context) {
    channelID = Get.parameters['channelID']!;
    channelType = int.parse(Get.parameters['channelType']!);
    Get.put(ChatController(channelID: channelID, channelType: channelType));
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Obx(() => Text(controller.title.value.tr)),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Stack(
                children: <Widget>[
                  Obx(() => Text(controller.title.value.tr)),
                  Divider(height: 1.0),
                  Container(
                    child: _buildInputTextComposer(context),
                    decoration:
                    BoxDecoration(color: Color.fromRGBO(241, 243, 244, 0.9)),
                  ),
                  Divider(height: 1.0),
                  !_isShowEmoji
                      ? SizedBox()
                      : Container(
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(241, 243, 244, 0.9)),
                      child: _buildEmojiPanelComposer()),
                  !_isShowExpaned
                      ? SizedBox()
                      : Container(
                      height: _expandedPanelHeight,
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(241, 243, 244, 0.9)),
                      child: _buildExpandedPanelComposer()),
                ],
              ),
            )
          ],
        ));
  }

  /*
 * 文字输入框
 */
  Widget _buildInputTextComposer(BuildContext context) {
    return IconTheme(
      data: IconThemeData(color: Color.fromRGBO(241, 243, 244, 0.9)),
      child: Container(
        alignment: Alignment.center,
        height: 40.0,
        margin: const EdgeInsets.only(top: 5, bottom: 5),
        child: Row(
          children: <Widget>[
            _isShowVoice
                ? GestureDetector(
                    onTap: () => _openVoiceAction(context),
                    child: Container(
                        margin: const EdgeInsets.only(left: 10, right: 10),
                        child: Image.asset(
                          'assets/images/voice.png',
                          height: 24,
                          width: 24,
                        )),
                  )
                : GestureDetector(
                    onTap: () => _openKeyboardAction(context),
                    child: Container(
                        margin: const EdgeInsets.only(left: 8, right: 8),
                        child: Image.asset(
                          'assets/images/keyboard.png',
                          height: 28,
                          width: 28,
                        )),
                  ),
            _isShowVoice
                ? Flexible(
                    child: Container(
                      margin: const EdgeInsets.only(top: 2, bottom: 2),
                      child: TextField(
                        textInputAction: TextInputAction.send,
                        // controller: _textController,
                        focusNode: _focusNode,
                        // onSubmitted: _submitMsg,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                        ),
                      ),
                    ),
                  )
                : Expanded(
                    child: VoiceWidget(
                      startRecord: () {},
                      stopRecord: (path, length) {},
                    ),
                  ),
            GestureDetector(
              onTap: () => _openEmojiAction(context),
              child: Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: Image.asset('assets/images/emoji.png',
                      height: 29, width: 29, color: Colors.black)),
            ),
            GestureDetector(
              onTap: () => _openExpandedAction(context),
              child: Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  child: Image.asset('assets/images/more.png',
                      height: 24, width: 24, color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }

  /*
 * 下方的弹出emoji
 */
  Widget _buildEmojiPanelComposer() {
    // return EmojiPicker(
    //   rows: 3,
    //   columns: 7,
    //   recommendKeywords: ["racing", "horse"],
    //   numRecommended: 10,
    //   onEmojiSelected: (emoji, category) {
    //   },
    // );
    //todo 表情
    return Container();
  }


  /*
   * 点击 + 图标
   */
  void _openExpandedAction(BuildContext context) {
    if (_focusNode.hasFocus) {
      FocusScope.of(context).requestFocus(FocusNode());

      //Focus和setState冲突，延迟执行setState
      Future.delayed(Duration(milliseconds: 100), () {
        _isShowExpaned = !_isShowExpaned;
        _isShowEmoji = false;
        _isShowVoice = false;
      });
    } else {
      _isShowExpaned = !_isShowExpaned;
      _isShowEmoji = false;
      _isShowVoice = false;
    }
  }

  /*
   * 点击 emoji 图标
   */
  void _openEmojiAction(BuildContext context) {
    if (_focusNode.hasFocus) {
      FocusScope.of(context).requestFocus(FocusNode());

      //Focus和setState冲突，延迟执行setState
      Future.delayed(Duration(milliseconds: 100), () {
        _isShowEmoji = !_isShowEmoji;
        _isShowExpaned = false;
        _isShowVoice = true;
      });
    } else {
      _isShowEmoji = !_isShowEmoji;
      _isShowExpaned = false;
      _isShowVoice = true;
    }
  }

  /*
   * 点击 键盘 图标
   */
  void _openKeyboardAction(BuildContext context) {
    _isShowExpaned = false;
    _isShowEmoji = false;
    _isShowVoice = true;

    Future.delayed(Duration(milliseconds: 100), () {
      if (!_focusNode.hasFocus) {
        FocusScope.of(context).requestFocus(_focusNode);
      }
    });
  }

  /*
   * 点击 语音 图标
   */
  void _openVoiceAction(BuildContext context) {
    _isShowExpaned = false;
    _isShowEmoji = false;
    _isShowVoice = false;
    if (_focusNode.hasFocus) {
      FocusScope.of(context).requestFocus(FocusNode());
    }
  }

  /*
 * 下方的弹出工具栏
 */
  Widget _buildExpandedPanelComposer() {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 40.0,
            childAspectRatio: 0.8),
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
        scrollDirection: Axis.vertical,
        itemCount: _iconbuttons.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildIconButton(
              _iconbuttons[index]['name'], _iconbuttons[index]['icon']);
        });
  }

  /*
   * 工具栏中的图标
   */
  Widget _buildIconButton(String buttonName, IconData icon) {
    return Column(
      children: <Widget>[
        GestureDetector(
          excludeFromSemantics: true,
          onTap: () {
            _openExpandedIcon(buttonName);
          },
          child: Container(
            width: 60.0,
            height: 60.0,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
            child: Icon(
              icon,
              size: 28.0,
            ),
          ),
        ),
        Container(
            margin: EdgeInsets.only(top: 3.0),
            child: Text(buttonName,
                style: TextStyle(fontSize: 12.0, color: Colors.grey[600])))
      ],
    );
  }

  void _openExpandedIcon(String iconName) async {
    final picker = ImagePicker();
    if (iconName == '相册') {
      var image = await picker.pickImage(source: ImageSource.gallery);
    } else if (iconName == '视频') {
      var video = await picker.pickVideo(source: ImageSource.gallery);
    } else if (iconName == '拍摄') {
      var image = await picker.pickImage(source: ImageSource.camera);
    }
  }
}
