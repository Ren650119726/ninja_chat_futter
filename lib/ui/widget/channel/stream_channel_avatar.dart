import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ninja_chat/ui/avatars/group_avatar.dart';
import 'package:ninja_chat/ui/avatars/user_avatar.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart'
    show Member, OwnUser, StreamChatTheme, User;

/// {@template streamChannelAvatar}
/// Displays the avatar image for a chat channel.
///
/// By default, it loads the channel's image using CachedNetworkImage.
/// This widget provides customization options for tapping, selection,
/// and avatar builders for different channel types.
/// {@endtemplate}
class StreamChannelAvatar extends StatelessWidget {
  /// {@macro streamChannelAvatar}
  StreamChannelAvatar({
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
    this.user,
    this.currentUser,
  });

  /// The URL of the channel's avatar image.
  final String channelImage;

  /// [BorderRadius] to display the widget.
  final BorderRadius? borderRadius;

  /// The diameter of the image.
  final BoxConstraints? constraints;

  /// The function called when the image is tapped.
  final VoidCallback? onTap;

  /// If the image is selected.
  final bool selected;

  /// Selection color for the image.
  final Color? selectionColor;

  /// Thickness of the selection image.
  final double selectionThickness;

  /// Builder to create avatar for own space channel.
  final StreamUserAvatarBuilder? ownSpaceAvatarBuilder;

  /// Builder to create avatar for one to one channel.
  final StreamUserAvatarBuilder? oneToOneAvatarBuilder;

  /// Builder to create avatar for group channel.
  final StreamGroupAvatarBuilder? groupAvatarBuilder;

  final List<Member>? members;

  final User? user;

  final User? currentUser;


  @override
  Widget build(BuildContext context) {
    final chatThemeData = StreamChatTheme.of(context);
    final colorTheme = chatThemeData.colorTheme;
    final previewTheme = chatThemeData.channelPreviewTheme.avatarTheme;

    Widget child = ClipRRect(
      borderRadius:
          borderRadius ?? previewTheme?.borderRadius ?? BorderRadius.zero,
      child: Container(
        constraints: constraints ?? previewTheme?.constraints,
        decoration: BoxDecoration(color: colorTheme.accentPrimary),
        child: InkWell(
          onTap: onTap,
          child: CachedNetworkImage(
            imageUrl: channelImage,
            errorWidget: (_, __, ___) => Center(
              child: Text(
                'Default', // Display default text if image fails to load
                style: TextStyle(
                  color: colorTheme.barsBg,
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
        borderRadius: BorderRadius.circular(selectionThickness) +
            (borderRadius ?? previewTheme?.borderRadius ?? BorderRadius.zero),
        child: Container(
          constraints: constraints ?? previewTheme?.constraints,
          color: selectionColor ?? colorTheme.accentPrimary,
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
          .where((it) => it.userId != currentUser?.id)
          .toList(growable: false);
      if (otherMembers.isEmpty) {
        return _buildOwnSpaceAvatar(context, currentUser!);
      } else if (otherMembers.length == 1) {
        return _buildOneToOneAvatar(context, otherMembers.first);
      } else {
        return _buildGroupAvatar(context, otherMembers);
      }
    }
  }

  Widget _buildOwnSpaceAvatar(BuildContext context, User user) {
    final builder = ownSpaceAvatarBuilder ?? _defaultUserAvatarBuilder;
    return builder(context, user, selected);
  }

  Widget _buildOneToOneAvatar(BuildContext context, Member member) {
    final builder = oneToOneAvatarBuilder ?? _defaultUserAvatarBuilder;
    return builder(context, member.user!, selected);
  }

  Widget _buildGroupAvatar(BuildContext context, List<Member> members) {
    final builder = groupAvatarBuilder ?? _defaultGroupAvatarBuilder;
    return builder(context, members, selected);
  }

  Widget _defaultUserAvatarBuilder(
      BuildContext context, User user, bool selected) {
    final previewTheme =
        StreamChatTheme.of(context).channelPreviewTheme.avatarTheme;
    return StreamUserAvatar(
      borderRadius: borderRadius ?? previewTheme?.borderRadius,
      user: user,
      constraints: constraints ?? previewTheme?.constraints,
      onTap: onTap != null ? (_) => onTap!() : null,
      selected: selected,
      selectionColor: selectionColor ??
          StreamChatTheme.of(context).colorTheme.accentPrimary,
      selectionThickness: selectionThickness,
    );
  }

  Widget _defaultGroupAvatarBuilder(
      BuildContext context, List<Member> members, bool selected) {
    final previewTheme =
        StreamChatTheme.of(context).channelPreviewTheme.avatarTheme;
    return StreamGroupAvatar(
      members: members,
      borderRadius: borderRadius ?? previewTheme?.borderRadius,
      constraints: constraints ?? previewTheme?.constraints,
      onTap: onTap,
      selected: selected,
      selectionColor: selectionColor ??
          StreamChatTheme.of(context).colorTheme.accentPrimary,
      selectionThickness: selectionThickness,
    );
  }
}
