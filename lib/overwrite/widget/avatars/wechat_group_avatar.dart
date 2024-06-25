import 'package:flutter/material.dart';
import 'package:ninja_chat/overwrite/widget/avatars/user_avatar.dart'; // 根据实际路径修改
import '../../../model/member.dart';
import '../../../model/user.dart'; // 根据实际路径修改

class AppDimens {
  static const ChatItemImageDimens = 44.0;

  static const ChatItemGroupIconPaddingDimes = 2.0;
  static const ChatItemGroupChildIconMarginDimes = 2.0;
}

var row = 0, column = 0;

// 群聊九宫格头像
class WeChatGroupAvatar extends StatelessWidget {
  WeChatGroupAvatar({
    required this.members,
    this.constraints,
    this.onTap,
    this.borderRadius,
    this.selected = false,
    this.selectionColor,
    this.selectionThickness = 4,
  });

  final List<Member> members;
  final BoxConstraints? constraints;
  final VoidCallback? onTap;
  final bool selected;
  final BorderRadius? borderRadius;
  final Color? selectionColor;
  final double selectionThickness;

  @override
  Widget build(BuildContext context) {
    var childCount = members.length;
    var columnMax;
    List<Widget> icons = [];
    List<Widget> stacks = [];
    // 五张图片之后（包含5张），每行的最大列数是3
    var imgWidth;

    if (childCount < 2) {
      return Container(
        width: AppDimens.ChatItemImageDimens,
        height: AppDimens.ChatItemImageDimens,
      );
    }

    if (childCount >= 5) {
      columnMax = 3;
      imgWidth = (AppDimens.ChatItemImageDimens -
              (AppDimens.ChatItemGroupIconPaddingDimes * columnMax) -
              AppDimens.ChatItemGroupChildIconMarginDimes) /
          columnMax;
    } else {
      columnMax = 2;
      imgWidth = (AppDimens.ChatItemImageDimens -
              (AppDimens.ChatItemGroupIconPaddingDimes * columnMax) -
              AppDimens.ChatItemGroupChildIconMarginDimes) /
          columnMax;
    }
    for (var i = 0; i < childCount; i++) {
      icons.add(_weChatGroupChatChildAvatar(members[i].toUser(), imgWidth));
    }
    row = 0;
    column = 0;
    var centerTop = 0.0;
    if (childCount == 2 || childCount == 5 || childCount == 6) {
      centerTop = imgWidth / 2;
    }
    for (var i = 0; i < childCount; i++) {
      var left =
          imgWidth * row + AppDimens.ChatItemGroupIconPaddingDimes * (row + 1);
      var top = imgWidth * column +
          AppDimens.ChatItemGroupIconPaddingDimes * column +
          centerTop;
      switch (childCount) {
        case 3:
        case 7:
          _topOneIcon(stacks, icons[i], childCount, i, imgWidth, left, top);
          break;
        case 5:
        case 8:
          _topTwoIcon(stacks, icons[i], childCount, i, imgWidth, left, top);
          break;
        default:
          _otherIcon(
              stacks, icons[i], childCount, i, imgWidth, left, top, columnMax);
          break;
      }
    }
    return Container(
      width: AppDimens.ChatItemImageDimens,
      height: AppDimens.ChatItemImageDimens,
      padding: EdgeInsets.only(
        top: AppDimens.ChatItemGroupIconPaddingDimes,
      ),
      alignment: AlignmentDirectional.bottomCenter,
      child: Stack(
        children: stacks,
      ),
    );
  }

  _weChatGroupChatChildAvatar(User user, double width) {
    return UserAvatar(
      showOnlineStatus: false,
      user: user,
      borderRadius: borderRadius,
      height: width,
      width: width,
    );
  }
}

_weChatGroupChatChildIcon(String avatar, double width) {
  return Image.network(
    avatar,
    height: width,
    width: width,
    fit: BoxFit.fill,
  );
}



// 顶部为一张图片
_topOneIcon(
    List<Widget> stacks, Widget child, int childCount, i, imgWidth, left, top) {
  if (i == 0) {
    var firstLeft =
        imgWidth / 2 + left + AppDimens.ChatItemGroupChildIconMarginDimes / 2;
    if (childCount == 7) {
      firstLeft = imgWidth + left + AppDimens.ChatItemGroupChildIconMarginDimes;
    }
    stacks.add(Positioned(
      child: child,
      left: firstLeft,
    ));
    row = 0;
    // 换行
    column++;
  } else {
    stacks.add(Positioned(
      child: child,
      left: left,
      top: top,
    ));
    // 换列
    row++;
    if (i == 3) {
      // 第一例
      row = 0;
      // 换行
      column++;
    }
  }
}

// 顶部为两张图片
_topTwoIcon(
    List<Widget> stacks, Widget child, int childCount, i, imgWidth, left, top) {
  if (i == 0 || i == 1) {
    stacks.add(Positioned(
      child: child,
      left:
          imgWidth / 2 + left + AppDimens.ChatItemGroupChildIconMarginDimes / 2,
      top: childCount == 5 ? top : 0.0,
    ));
    row++;
    if (i == 1) {
      row = 0;
      // 换行
      column++;
    }
  } else {
    stacks.add(Positioned(
      child: child,
      left: left,
      top: top,
    ));
    // 换列
    row++;
    if (i == 4) {
      // 第一例
      row = 0;
      // 换行
      column++;
    }
  }
}

_otherIcon(List<Widget> stacks, Widget child, int childCount, i, imgWidth, left,
    top, columnMax) {
  stacks.add(Positioned(
    child: child,
    left: left,
    top: top,
  ));
  // 换列
  row++;
  if ((i + 1) % columnMax == 0) {
    // 第一例
    row = 0;
    // 换行
    column++;
  }
}
