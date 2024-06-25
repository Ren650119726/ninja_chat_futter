import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class StreamChannelListHeader extends StatelessWidget
    implements PreferredSizeWidget {
  /// {@macro streamChannelListHeader}
  const StreamChannelListHeader({
    super.key,
    this.titleBuilder,
    this.onUserAvatarTap,
    this.onNewChatButtonTap,
    this.showConnectionStateTile = false,
    this.preNavigationCallback,
    this.subtitle,
    this.centerTitle,
    this.leading,
    this.actions,
    this.backgroundColor,
    this.elevation = 1,
    this.currentUser,
  });

 final OwnUser? currentUser;

  /// {@macro channelListHeaderTitleBuilder}
  final ChannelListHeaderTitleBuilder? titleBuilder;

  /// The action to perform when pressing the user avatar button.
  ///
  /// By default it calls `Scaffold.of(context).openDrawer()`.
  final Function(User)? onUserAvatarTap;

  /// The action to perform when pressing the "new chat" button.
  final VoidCallback? onNewChatButtonTap;

  /// Whether to show the connection state tile
  final bool showConnectionStateTile;

  /// The function to execute before navigation is performed
  final VoidCallback? preNavigationCallback;

  /// Subtitle widget
  final Widget? subtitle;

  /// Whether the title should be centered
  final bool? centerTitle;

  /// Leading widget
  ///
  /// By default it shows the logged in user's avatar
  final Widget? leading;

  /// {@macro flutter.material.appbar.actions}
  ///
  /// The "new chat" button is shown by default.
  final List<Widget>? actions;

  /// The background color for this [StreamChannelListHeader].
  final Color? backgroundColor;

  /// The elevation for this [StreamChannelListHeader].
  final double elevation;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final chatThemeData = StreamChatTheme.of(context);
    final channelListHeaderThemeData =
    StreamChannelListHeaderTheme.of(context);
    final theme = Theme.of(context);

    return StreamConnectionStatusBuilder(
      statusBuilder: (context, status) {
        var statusString = '';
        var showStatus = true;

        switch (status) {
          case ConnectionStatus.connected:
            statusString = context.translations.connectedLabel;
            showStatus = false;
            break;
          case ConnectionStatus.connecting:
            statusString = context.translations.reconnectingLabel;
            break;
          case ConnectionStatus.disconnected:
            statusString = context.translations.disconnectedLabel;
            break;
        }

        return StreamInfoTile(
          showMessage: showConnectionStateTile && showStatus,
          message: statusString,
          child: AppBar(
            toolbarTextStyle: theme.textTheme.bodyMedium,
            titleTextStyle: theme.textTheme.titleLarge,
            systemOverlayStyle: theme.brightness == Brightness.dark
                ? SystemUiOverlayStyle.light
                : SystemUiOverlayStyle.dark,
            elevation: elevation,
            backgroundColor:
            backgroundColor ?? channelListHeaderThemeData.color,
            centerTitle: centerTitle,
            leading: leading ??
                Center(
                  child: StreamUserAvatar(
                    user: currentUser!,
                    showOnlineStatus: false,
                    onTap: onUserAvatarTap ??
                            (_) {
                          preNavigationCallback?.call();
                          Scaffold.of(context).openDrawer();
                        },
                    borderRadius:
                    channelListHeaderThemeData.avatarTheme?.borderRadius,
                    constraints:
                    channelListHeaderThemeData.avatarTheme?.constraints,
                  ),
                ),
            actions: actions ??
                [
                  StreamNeumorphicButton(
                    child: IconButton(
                      icon: StreamConnectionStatusBuilder(
                        statusBuilder: (context, status) {
                          Color? color;
                          switch (status) {
                            case ConnectionStatus.connected:
                              color = chatThemeData.colorTheme.accentPrimary;
                              break;
                            case ConnectionStatus.connecting:
                              color = Colors.grey;
                              break;
                            case ConnectionStatus.disconnected:
                              color = Colors.grey;
                              break;
                          }
                          return SvgPicture.asset(
                            'svgs/icon_pen_write.svg',
                            package: 'stream_chat_flutter',
                            width: 24,
                            height: 24,
                            colorFilter: ColorFilter.mode(
                              color,
                              BlendMode.srcIn,
                            ),
                          );
                        },
                      ),
                      onPressed: onNewChatButtonTap,
                    ),
                  ),
                ],
            title: Column(
              children: [
                Builder(
                  builder: (context) {
                    if (titleBuilder != null) {
                      return titleBuilder!(
                          context, status, StreamChat.of(context).client);
                    }
                    switch (status) {
                      case ConnectionStatus.connected:
                        return _ConnectedTitleState();
                      case ConnectionStatus.connecting:
                        return _ConnectingTitleState();
                      case ConnectionStatus.disconnected:
                        return _DisconnectedTitleState();
                      default:
                        return const Offstage();
                    }
                  },
                ),
                subtitle ?? const Offstage(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ConnectedTitleState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final chatThemeData = StreamChatTheme.of(context);
    return Text(
      context.translations.streamChatLabel,
      style: chatThemeData.textTheme.headlineBold.copyWith(
        color: chatThemeData.colorTheme.textHighEmphasis,
      ),
    );
  }
}

class _ConnectingTitleState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
          style: StreamChannelListHeaderTheme.of(context).titleStyle?.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _DisconnectedTitleState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final chatThemeData = StreamChatTheme.of(context);
    final channelListHeaderTheme = StreamChannelListHeaderTheme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          context.translations.offlineLabel,
          style: channelListHeaderTheme.titleStyle?.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: () => StreamChat.of(context).client
            ..closeConnection()
            ..openConnection(),
          child: Text(
            context.translations.tryAgainLabel,
            style: channelListHeaderTheme.titleStyle?.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: chatThemeData.colorTheme.accentPrimary,
            ),
          ),
        ),
      ],
    );
  }
}