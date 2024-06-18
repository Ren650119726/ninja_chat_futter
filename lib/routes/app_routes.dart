import 'package:collection/collection.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ninja_chat/page/channel/channel_list_page.dart';
import 'package:ninja_chat/page/channel/channel_page.dart';
import 'package:ninja_chat/routes/routes.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

final appRoutes = [
  GoRoute(
    name: Routes.CHANNEL_LIST_PAGE.name,
    path: Routes.CHANNEL_LIST_PAGE.path,
    builder: (BuildContext context, GoRouterState state) =>
        const ChannelListPage(),
    routes: [
      GoRoute(
        name: Routes.CHANNEL_PAGE.name,
        path: Routes.CHANNEL_PAGE.path,
        builder: (context, state) {
          final channel = StreamChat.of(context)
              .client
              .state
              .channels[state.pathParameters['cid']];
          final messageId = state.uri.queryParameters['mid'];
          final parentId = state.uri.queryParameters['pid'];

          Message? parentMessage;
          if (parentId != null) {
            parentMessage = channel?.state!.messages
                .firstWhereOrNull((it) => it.id == parentId);
          }

          return StreamChannel(
            channel: channel!,
            initialMessageId: messageId,
            child: Builder(
              builder: (context) {
                return ChannelPage(
                  highlightInitialMessage: messageId != null,
                );
              },
            ),
          );
        },
        routes: [
        ],
      ),
    ],
  ),
];
