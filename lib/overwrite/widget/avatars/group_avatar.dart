import 'package:flutter/material.dart';
import 'package:ninja_chat/overwrite/widget/avatars/user_avatar.dart';

import '../../../model/member.dart';

typedef GroupAvatarBuilder = Widget Function(
    BuildContext context,
    List<Member> members,
    // ignore: avoid_positional_boolean_parameters
    bool isSelected,
    );


class GroupAvatar<T> extends StatelessWidget {
  const GroupAvatar({
    super.key,
    required this.members,
    this.constraints,
    this.onTap,
    this.borderRadius,
    this.selected = false,
    this.selectionColor,
    this.selectionThickness = 4,
  });

  /// The list of members in the group whose avatars should be displayed.
  final List<Member> members;

  /// Constraints on the widget
  final BoxConstraints? constraints;

  /// The action to perform when the widget is tapped
  final VoidCallback? onTap;

  /// If `true`, this widget should be highlighted.
  ///
  /// Defaults to `false`.
  final bool selected;

  /// [BorderRadius] to pass to the widget
  final BorderRadius? borderRadius;

  /// The color to highlight the widget with if [selected] is `true`
  final Color? selectionColor;

  /// The value to use for the border thickness and padding of the
  /// selected image
  final double selectionThickness;

  @override
  Widget build(BuildContext context) {

    Widget avatar = GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius:
        borderRadius ??  BorderRadius.zero,
        child: Container(
          constraints: constraints,
          decoration: BoxDecoration(),
          child: Flex(
            direction: Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(
                fit: FlexFit.tight,
                child: Flex(
                  direction: Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: members
                      .take(2)
                      .map(
                        (member) => Flexible(
                      fit: FlexFit.tight,
                      child: FittedBox(
                        fit: BoxFit.cover,
                        clipBehavior: Clip.antiAlias,
                        child: Transform.scale(
                          scale: 1.2,
                          child: UserAvatar(
                            showOnlineStatus: false,
                            user: member.toUser(),
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                      ),
                    ),
                  )
                      .toList(),
                ),
              ),
              if (members.length > 2)
                Flexible(
                  fit: FlexFit.tight,
                  child: Flex(
                    direction: Axis.horizontal,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: members
                        .skip(2)
                        .take(2)
                        .map(
                          (member) => Flexible(
                        fit: FlexFit.tight,
                        child: FittedBox(
                          fit: BoxFit.cover,
                          clipBehavior: Clip.antiAlias,
                          child: Transform.scale(
                            scale: 1.2,
                            child: UserAvatar(
                              showOnlineStatus: false,
                              user: member.toUser(),
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                        ),
                      ),
                    )
                        .toList(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );

    if (selected) {
      avatar = ClipRRect(
        borderRadius: BorderRadius.circular(selectionThickness) +
            (borderRadius ?? BorderRadius.zero),
        child: Container(
          constraints: constraints,
          color: selectionColor ?? const Color(0xff337eff),
          child: Padding(
            padding: EdgeInsets.all(selectionThickness),
            child: avatar,
          ),
        ),
      );
    }

    return avatar;
  }
}
