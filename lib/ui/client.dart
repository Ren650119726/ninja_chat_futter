import 'package:collection/collection.dart';
import 'package:ninja_chat/core/wkim.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wukongimfluttersdk/entity/conversation.dart';

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
    required this.wkimUtils,
  }) {
    state.currentUser = OwnUser(
      id: uid,
    );
  }

  final String uid;

  final WKIMUtils wkimUtils;

  final ClientState state = ClientState();


  final _connectionStatusController =
      BehaviorSubject.seeded(ConnectStatus.disconnected);

  ConnectStatus get connectionStatus => _connectionStatusController.value;

  Stream<ConnectStatus> get connectionStatusStream =>
      _connectionStatusController.stream.distinct();

  void setConnectionStatus(ConnectStatus status) {
    _connectionStatusController.add(status);
  }

  Future<List<WKUIConversationMsg>> getConversationList() {
    return wkimUtils.wKim.conversationManager.getAll();
  }


}
