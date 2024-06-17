import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:ninja_chat/config/app_config.dart';
import 'package:ninja_chat/page/splash_screen.dart';
import 'package:ninja_chat/routes/app_routes.dart';
import 'package:ninja_chat/routes/routes.dart';
import 'package:ninja_chat/state/init_data.dart';
import 'package:ninja_chat/utils/localizations.dart';
import 'package:provider/provider.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_chat_persistence/stream_chat_persistence.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import 'firebase_options.dart';

class StreamChatSampleApp extends StatefulWidget {
  const StreamChatSampleApp({super.key});

  @override
  State<StreamChatSampleApp> createState() => _StreamChatSampleAppState();
}

const kStreamApiKey = 'STREAM_API_KEY';
const kStreamUserId = 'STREAM_USER_ID';
const kStreamToken = 'STREAM_TOKEN';

class _StreamChatSampleAppState extends State<StreamChatSampleApp>
    with SplashScreenStateMixin, TickerProviderStateMixin {
  final InitNotifier _initNotifier = InitNotifier();

  Future<InitData> _initConnection() async {
    String? apiKey, userId, token;

    if (!kIsWeb) {
      const secureStorage = FlutterSecureStorage();
      apiKey = await secureStorage.read(key: kStreamApiKey);
      userId = await secureStorage.read(key: kStreamUserId);
      token = await secureStorage.read(key: kStreamToken);
    }
    final client = buildStreamChatClient(apiKey ?? kDefaultStreamApiKey);
    final users = defaultUsers;
    //取user中第一个值
    var firstEntry = users.entries.first;
    token = firstEntry.key;
    userId = firstEntry.value.id;

    if (userId != null && token != null) {
      await client.connectUser(
        User(id: userId),
        token,
      );
    }

    final prefs = await StreamingSharedPreferences.instance;

    return InitData(client, prefs);
  }
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();

  GoRouter _setupRouter() {

    return GoRouter(
      refreshListenable: _initNotifier,
      initialLocation: Routes.CHANNEL_LIST_PAGE.path,
      navigatorKey: _navigatorKey,
      routes: appRoutes,
    );
  }



  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        if (_initNotifier.initData != null)
          ChangeNotifierProvider.value(
            value: _initNotifier,
            builder: (context, child) => Builder(
              builder: (context) {
                context.watch<InitNotifier>(); // rebuild on change
                return PreferenceBuilder<int>(
                  preference: _initNotifier.initData!.preferences.getInt(
                    'theme',
                    defaultValue: 0,
                  ),
                  builder: (context, snapshot) => MaterialApp.router(
                    theme: ThemeData.light(),
                    darkTheme: ThemeData.dark(),
                    themeMode: const {
                      -1: ThemeMode.dark,
                      0: ThemeMode.system,
                      1: ThemeMode.light,
                    }[snapshot],
                    supportedLocales: const [
                      Locale('en'),
                      Locale('it'),
                    ],
                    localizationsDelegates: const [
                      AppLocalizationsDelegate(),
                    ],
                    builder: (context, child) => StreamChat(
                      client: _initNotifier.initData!.client,
                      child: child,
                    ),
                    routerConfig: _setupRouter(),
                  ),
                );
              },
            ),
          ),
        if (!animationCompleted) buildAnimation(),
      ],
    );
  }

  @override
  void initState() {
    final timeOfStartMs = DateTime.now().millisecondsSinceEpoch;

    _initConnection().then(
          (initData) {
        setState(() {
          _initNotifier.initData = initData;
        });

        final now = DateTime.now().millisecondsSinceEpoch;

        if (now - timeOfStartMs > 1500) {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            forwardAnimations();
          });
        } else {
          Future.delayed(const Duration(milliseconds: 1500)).then((value) {
            forwardAnimations();
          });
        }
      },
    );
    super.initState();
  }
}


StreamChatClient buildStreamChatClient(String apiKey) {
  late Level logLevel;
  if (kDebugMode) {
    logLevel = Level.INFO;
  } else {
    logLevel = Level.SEVERE;
  }
  return StreamChatClient(
    apiKey,
    logLevel: logLevel,
    logHandlerFunction: _sampleAppLogHandler,
  )..chatPersistenceClient = chatPersistentClient;
}

final chatPersistentClient = StreamChatPersistenceClient(
  logLevel: Level.SEVERE,
  connectionMode: ConnectionMode.regular,
);

void _sampleAppLogHandler(LogRecord record) async {
  if (kDebugMode) StreamChatClient.defaultLogHandler(record);
}

typedef OnRemoteMessage = Future<void> Function(RemoteMessage);

extension on List<StreamSubscription> {
  void cancelAll() {
    for (final subscription in this) {
      unawaited(subscription.cancel());
    }
    clear();
  }
}