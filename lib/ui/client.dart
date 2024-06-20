import 'package:rxdart/rxdart.dart';

import 'models/own_user.dart';

enum ConnectStatus {
  connected,
  connecting,
  disconnected,
}

class ClientState {
  final _totalUnreadCountController = BehaviorSubject<int>.seeded(0);
  final _unreadChannelsController = BehaviorSubject<int>.seeded(0);
  final _currentUserController = BehaviorSubject<OwnUser?>();

  //设置当前用户
  set currentUser(OwnUser? user) {
    _computeUnreadCounts(user);
    _currentUserController.add(user);
  }

  // 未读数
  void _computeUnreadCounts(OwnUser? user) {
    final totalUnreadCount = user?.totalUnreadCount;
    if (totalUnreadCount != null) {
      _totalUnreadCountController.add(totalUnreadCount);
    }

    final unreadChannels = user?.unreadChannels;
    if (unreadChannels != null) {
      _unreadChannelsController.add(unreadChannels);
    }
  }

  /// The current user
  OwnUser? get currentUser => _currentUserController.valueOrNull;

  /// The current user as a stream
  Stream<OwnUser?> get currentUserStream => _currentUserController.stream;

  /// The current unread channels count
  int get unreadChannels => _unreadChannelsController.value;

  /// The current unread channels count as a stream
  Stream<int> get unreadChannelsStream => _unreadChannelsController.stream;

  /// The current total unread messages count
  int get totalUnreadCount => _totalUnreadCountController.value;

  /// The current total unread messages count as a stream
  Stream<int> get totalUnreadCountStream => _totalUnreadCountController.stream;

  void dispose() {
    _currentUserController.close();
    _unreadChannelsController.close();
    _totalUnreadCountController.close();
  }
}

class Client {
  Client({
    required this.uid,
  }) {
    state.currentUser = OwnUser(
      id: uid,
    );
  }

  final String uid;

  final ClientState state = ClientState();

 /* /// Returns true if the channel is muted.
  bool get isMuted =>
      state.currentUser?.channelMutes
          .any((element) => element.channel.cid == cid) ==
          true;

  /// Returns true if the channel is muted, as a stream.
  Stream<bool> get isMutedStream => state.currentUserStream
      .map((event) =>
  event?.channelMutes.any((element) => element.channel.cid == cid) ==
      true)
      .distinct();*/

  final _connectionStatusController =
      BehaviorSubject.seeded(ConnectStatus.disconnected);

  ConnectStatus get connectionStatus => _connectionStatusController.value;

  Stream<ConnectStatus> get connectionStatusStream =>
      _connectionStatusController.stream.distinct();

  void setConnectionStatus(ConnectStatus status) {
    _connectionStatusController.add(status);
  }
}
