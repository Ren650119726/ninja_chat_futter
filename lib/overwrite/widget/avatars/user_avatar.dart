import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ninja_chat/ui/utils/typedefs.dart';

import '../../../model/user.dart';
import 'gradient_avatar.dart';

typedef UserAvatarBuilder = Widget Function(
  BuildContext context,
  User user,
  // ignore: avoid_positional_boolean_parameters
  bool isSelected,
);

typedef OnUserAvatarPress = void Function(User);
typedef PlaceholderUserImage = Widget Function(BuildContext, User);

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    required this.user,
    this.constraints,
    this.onlineIndicatorConstraints,
    this.onTap,
    this.onLongPress,
    this.showOnlineStatus = true,
    this.borderRadius,
    this.onlineIndicatorAlignment = Alignment.topRight,
    this.selected = false,
    this.selectionColor,
    this.selectionThickness = 4,
    this.placeholder,
    this.width = 44,
    this.height = 44,
  });

  final User user;
  final Alignment onlineIndicatorAlignment;
  final BoxConstraints? constraints;
  final BorderRadius? borderRadius;
  final BoxConstraints? onlineIndicatorConstraints;
  final OnUserAvatarPress? onTap;
  final OnUserAvatarPress? onLongPress;
  final bool showOnlineStatus;
  final bool selected;
  final Color? selectionColor;
  final double selectionThickness;
  final PlaceholderUserImage? placeholder;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final hasImage = user.avatar != null && user.avatar!.isNotEmpty;

    final placeholder = this.placeholder;

    final backupGradientAvatar = ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: _defaultUserImage(context, user),
    );

    Widget avatar = FittedBox(
      fit: BoxFit.cover,
      child: Container(
        width: width,
        height: height,
        constraints: constraints,
        child: hasImage
            ? CachedNetworkImage(
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
                imageUrl: user.avatar!,
                errorWidget: (context, __, ___) => backupGradientAvatar,
                placeholder: placeholder != null
                    ? (context, __) => placeholder(context, user)
                    : null,
                imageBuilder: (context, imageProvider) => DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: borderRadius,
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              )
            : backupGradientAvatar,
      ),
    );

    if (selected) {
      avatar = ClipRRect(
        borderRadius: (borderRadius ?? BorderRadius.zero) +
            BorderRadius.circular(selectionThickness),
        child: Container(
          constraints: constraints,
          color: selectionColor,
          child: Padding(
            padding: EdgeInsets.all(selectionThickness),
            child: avatar,
          ),
        ),
      );
    }
    return GestureDetector(
      onTap: onTap != null ? () => onTap!(user) : null,
      onLongPress: onLongPress != null ? () => onLongPress!(user) : null,
      child: Stack(
        children: <Widget>[
          avatar,
          if (showOnlineStatus && user.online!)
            Positioned.fill(
              child: Align(
                alignment: onlineIndicatorAlignment,
                child: Material(
                  type: MaterialType.circle,
                  child: Container(
                    margin: const EdgeInsets.all(2),
                    constraints: onlineIndicatorConstraints ??
                        const BoxConstraints.tightFor(
                          width: 8,
                          height: 8,
                        ),
                    child: Material(
                      shape: const CircleBorder(),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  static Widget _defaultUserImage(BuildContext context, User user) => Center(
        child: GradientAvatar(
          name: user.name,
          userId: user.uid,
        ),
      );
}
