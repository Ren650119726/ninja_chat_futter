import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../model/member.dart';
import '../../../model/user.dart';
import '../avatars/group_avatar.dart';
import '../avatars/user_avatar.dart';
import '../avatars/wechat_group_avatar.dart';

/// WidgetBuilder for [UserAvatar].
typedef UserAvatarBuilder = Widget Function(
  BuildContext context,
  User user,
  bool isSelected,
);

/// WidgetBuilder for [GroupAvatar].
typedef GroupAvatarBuilder = Widget Function(
  BuildContext context,
  List<Member> members,
  bool isSelected,
);

class ChannelAvatar extends StatelessWidget {
  ChannelAvatar({
    super.key,
    required this.channelImage,
    this.constraints,
    this.onTap,
    this.borderRadius,
    this.selected = false,
    this.selectionColor,
    this.selectionThickness = 4,
    this.ownSpaceAvatarBuilder,
    this.oneToOneAvatarBuilder,
    this.groupAvatarBuilder,
    this.members,
    this.currentUser,
  });

  /// The URL of the channel's avatar image.
  final String channelImage;

  /// [BorderRadius] to display the widget.
  late final BorderRadius? borderRadius;

  /// The diameter of the image.
  late final BoxConstraints? constraints;

  /// The function called when the image is tapped.
  final VoidCallback? onTap;

  /// If the image is selected.
  final bool selected;

  /// Selection color for the image.
  final Color? selectionColor;

  /// Thickness of the selection image.
  final double selectionThickness;

  /// Builder to create avatar for own space channel.
  final UserAvatarBuilder? ownSpaceAvatarBuilder;

  /// Builder to create avatar for one to one channel.
  final UserAvatarBuilder? oneToOneAvatarBuilder;

  /// Builder to create avatar for group channel.
  final GroupAvatarBuilder? groupAvatarBuilder;

  final List<Member>? members;

  final User? currentUser;

  @override
  Widget build(BuildContext context) {
    Widget child = ClipRRect(
      borderRadius: borderRadius!,
      child: Container(
        constraints: constraints,
        decoration: BoxDecoration(),
        child: InkWell(
          onTap: onTap,
          child: CachedNetworkImage(
            imageUrl: channelImage,
            errorWidget: (_, __, ___) => Center(
              child: Text(
                'Default', // Display default text if image fails to load
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );

    if (selected) {
      child = ClipRRect(
        key: const Key('selectedImage'),
        borderRadius:
            BorderRadius.circular(selectionThickness) + (BorderRadius.zero),
        child: Container(
          constraints: constraints,
          color: selectionColor,
          child: Padding(
            padding: EdgeInsets.all(selectionThickness),
            child: child,
          ),
        ),
      );
    }
    if (channelImage.isNotEmpty) {
      return child;
    } else {
      final otherMembers = members!
          .where((it) => it.uid != currentUser?.uid)
          .toList(growable: false);
      if (otherMembers.isEmpty) {
        return _buildOwnSpaceAvatar(context, currentUser!);
      } else if (otherMembers.length == 1) {
        return _buildOneToOneAvatar(context, currentUser!);
      } else {
        return _buildGroupAvatar(context, otherMembers);
      }
    }
  }

  Widget _buildOwnSpaceAvatar(BuildContext context, User user) {
    final builder = ownSpaceAvatarBuilder ?? _defaultUserAvatarBuilder;
    return builder(context, user, selected);
  }

  Widget _buildOneToOneAvatar(BuildContext context, User user) {
    final builder = oneToOneAvatarBuilder ?? _defaultUserAvatarBuilder;
    return builder(context, user, selected);
  }

  Widget _buildGroupAvatar(BuildContext context, List<Member> members) {
    final builder = groupAvatarBuilder ?? _defaultGroupAvatarBuilder;
    return builder(context, members, selected);
  }

  Widget _defaultUserAvatarBuilder(
      BuildContext context, User user, bool selected) {
    return UserAvatar(
      borderRadius: borderRadius,
      user: user,
      constraints: constraints,
      onTap: onTap != null ? (_) => onTap!() : null,
      selected: selected,
      selectionColor: selectionColor ?? const Color(0xff337eff),
      selectionThickness: selectionThickness,
    );
  }

  Widget _defaultGroupAvatarBuilder(
      BuildContext context, List<Member> members, bool selected) {
    // return GroupAvatar(
    //   members: members,
    //   borderRadius: borderRadius,
    //   constraints: constraints,
    //   onTap: onTap,
    //   selected: selected,
    //   selectionColor: selectionColor ?? const Color(0xff337eff),
    //   selectionThickness: selectionThickness,
    // );
    return WeChatGroupAvatar(
        members: members,
        borderRadius: borderRadius,
        constraints: constraints,
        onTap: onTap,
        selected: selected,
        selectionColor: selectionColor ?? const Color(0xff337eff),
        selectionThickness: selectionThickness,
    );
  }
}
