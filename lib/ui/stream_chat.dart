import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:jiffy/jiffy.dart';

import 'client.dart';
import 'models/user.dart';
import 'stream_chat_configuration.dart';
import 'theme/stream_chat_theme.dart';
import 'utils/device_segmentation.dart';

/// {@template streamChat}
/// Widget used to provide information about the chat to the widget tree
///
/// class MyApp extends StatelessWidget {
///   final StreamChatClient client;
///
///   MyApp(this.client);
///
///   @override
///   Widget build(BuildContext context) {
///     return MaterialApp(
///       home: Container(
///         child: StreamChat(
///           client: client,
///           child: ChannelListPage(),
///         ),
///       ),
///     );
///   }
/// }
///
/// Use [StreamChat.of] to get the current [StreamChatState] instance.
/// {@endtemplate}
class StreamChat extends StatefulWidget {
  /// {@macro streamChat}
  const StreamChat({
    super.key,
    required this.child,
    required this.client,
    this.streamChatThemeData,
    this.streamChatConfigData,
    this.backgroundKeepAlive = const Duration(minutes: 1),
    this.useMaterial3 = false,
  });

  /// Child which inherits details
  final Widget? child;

  final Client client;

  /// Theme to pass on
  final StreamChatThemeData? streamChatThemeData;

  /// Non-theme related UI configuration options.
  final StreamChatConfigurationData? streamChatConfigData;

  /// The amount of time that will pass before disconnecting the client
  /// in the background
  final Duration backgroundKeepAlive;

  /// Whether to use material 3 or not (default is false)
  /// See our [docs](https://getstream.io/chat/docs/sdk/flutter/stream_chat_flutter/stream_chat_and_theming)
  final bool useMaterial3;

  @override
  StreamChatState createState() => StreamChatState();

  /// Use this method to get the current [StreamChatState] instance
  static StreamChatState of(BuildContext context) {
    StreamChatState? streamChatState;

    streamChatState = context.findAncestorStateOfType<StreamChatState>();

    if (streamChatState == null) {
      throw Exception(
        'You must have a StreamChat widget at the top of your widget tree',
      );
    }

    return streamChatState;
  }
}

/// The current state of the StreamChat widget
class StreamChatState extends State<StreamChat> {

  /// Gets configuration options from widget
  StreamChatConfigurationData get streamChatConfigData =>
      widget.streamChatConfigData ?? StreamChatConfigurationData();

  @override
  void initState() {
    super.initState();
    // Ensures that VLC only initializes in real desktop environments
    if (!isTestEnvironment && isDesktopVideoPlayerSupported) {
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = _getTheme(context, widget.streamChatThemeData);
    return Theme(
      data: Theme.of(context).copyWith(
        // ignore: deprecated_member_use
        useMaterial3: widget.useMaterial3,
      ),
      child: Portal(
        child: StreamChatConfiguration(
          data: streamChatConfigData,
          child: StreamChatTheme(
            data: theme,
            child: Builder(
              builder: (context) {
                final materialTheme = Theme.of(context);
                final streamTheme = StreamChatTheme.of(context);
                return Theme(
                  data: materialTheme.copyWith(
                    primaryIconTheme: streamTheme.primaryIconTheme,
                    colorScheme: materialTheme.colorScheme.copyWith(
                      secondary: streamTheme.colorTheme.accentPrimary,
                    ),
                  ),
                  child: Builder(
                    builder: (context) {
                      return widget.child ?? const Offstage();
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  StreamChatThemeData _getTheme(
    BuildContext context,
    StreamChatThemeData? themeData,
  ) {
    final appBrightness = Theme.of(context).brightness;
    final defaultTheme = StreamChatThemeData(brightness: appBrightness);
    return defaultTheme.merge(themeData);
  }

  /// The current user
  User? get currentUser => widget.client.state.currentUser;

  /// The current user as a stream
  Stream<User?> get currentUserStream => widget.client.state.currentUserStream;

  @override
  void didChangeDependencies() {
    final currentLocale = Localizations.localeOf(context).toString();
    final availableLocales = Jiffy.getSupportedLocales();
    if (availableLocales.contains(currentLocale)) {
      Jiffy.setLocale(currentLocale);
    }
    super.didChangeDependencies();
  }
}
