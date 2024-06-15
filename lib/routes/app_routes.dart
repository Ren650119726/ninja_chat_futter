import 'package:collection/collection.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:chat/page/channel/channel_list_page.dart';
import 'package:chat/routes/routes.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

final appRoutes = [
  GoRoute(
    name: Routes.CHANNEL_LIST_PAGE.name,
    path: Routes.CHANNEL_LIST_PAGE.path,
    builder: (BuildContext context, GoRouterState state) =>
        const ChannelListPage(),
    routes: [

    ],
  ),
];
