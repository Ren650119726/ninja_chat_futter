import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template streamChannelInfo}
/// Displays information about the current [Channel].
/// {@endtemplate}
class StreamChannelInfo extends StatelessWidget {
  /// {@macro streamChannelInfo}
  const StreamChannelInfo({
    Key? key,
    this.textStyle,
    this.showTypingIndicator = true,
    this.members,
    this.status = ConnectionStatus.connected,
    this.parentId,
    this.onRetry,
  }) : super(key: key);

  /// The style of the text displayed
  final TextStyle? textStyle;

  /// Whether to show the typing indicator
  ///
  /// Defaults to `true`
  final bool showTypingIndicator;

  /// The list of members in the channel
  final List<Member>? members;

  /// The connection status of the channel
  final ConnectionStatus status;

  /// The ID of the parent message (in the case of a thread)
  final String? parentId;

  /// Callback to retry connecting to the channel
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    Widget buildConnectedState() {
      Widget? alternativeWidget;

      if (members != null && members!.length > 2) {
        var text = context.translations.membersCountText(members!.length);
        final onlineCount =
            members!.where((m) => m.user?.online == true).length;
        if (onlineCount > 0) {
          text += ', ${context.translations.watchersCountText(onlineCount)}';
        }
        alternativeWidget = Text(
          text,
          style: StreamChannelHeaderTheme.of(context).subtitleStyle,
        );
      } else {
        final userId = StreamChat.of(context).currentUser?.id;
        final otherMember = members?.firstWhereOrNull(
              (element) => element.userId != userId,
        );

        if (otherMember != null) {
          if (otherMember.user?.online == true) {
            alternativeWidget = Text(
              context.translations.userOnlineText,
              style: textStyle,
            );
          } else {
            final lastActive = otherMember.user?.lastActive ?? DateTime.now();
            alternativeWidget = Text(
              '${context.translations.userLastOnlineText} '
                  '${Jiffy.parseFromDateTime(lastActive).fromNow()}',
              style: textStyle,
            );
          }
        }
      }

      if (!showTypingIndicator) {
        return alternativeWidget ?? const Offstage();
      }

      return StreamTypingIndicator(
        parentId: parentId,
        alternativeWidget: alternativeWidget,
        style: textStyle,
      );
    }

    Widget buildConnectingState() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 16,
            width: 16,
            child: Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            context.translations.searchingForNetworkText,
            style: textStyle,
          ),
        ],
      );
    }

    Widget buildDisconnectedState() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            context.translations.offlineLabel,
            style: textStyle,
          ),
          TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: const VisualDensity(
                horizontal: VisualDensity.minimumDensity,
                vertical: VisualDensity.minimumDensity,
              ),
            ),
            onPressed: onRetry,
            child: Text(
              context.translations.tryAgainLabel,
              style: textStyle?.copyWith(
                color: StreamChatTheme.of(context).colorTheme.accentPrimary,
              ),
            ),
          ),
        ],
      );
    }

    Widget buildStatusWidget() {
      switch (status) {
        case ConnectionStatus.connected:
          return buildConnectedState();
        case ConnectionStatus.connecting:
          return buildConnectingState();
        case ConnectionStatus.disconnected:
          return buildDisconnectedState();
        default:
          return const Offstage();
      }
    }

    return buildStatusWidget();
  }
}
