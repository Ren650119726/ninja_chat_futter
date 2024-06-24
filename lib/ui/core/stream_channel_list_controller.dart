import 'dart:async';
import 'dart:math';

import '../entity/conversation.dart';
import '../models/channel.dart';
import '../view/paged/paged_value_notifier.dart';

/// The default channel page limit to load.
const defaultChannelPagedLimit = 10;

const _kDefaultBackendPaginationLimit = 30;

/// A controller for a Channel list.
///
/// This class lets you perform tasks such as:
/// * Load initial data.
/// * Use channel events handlers.
/// * Load more data using [loadMore].
/// * Replace the previously loaded channels.
/// * Return/Create a new channel and start watching it.
/// * Pause and Resume all subscriptions added to this composite.
class StreamChannelListController extends PagedValueNotifier<int, Conversation> {
  /// Creates a Stream channel list controller.
  ///
  /// * `client` is the Stream chat client to use for the channels list.
  ///
  /// * `channelEventHandlers` is the channel events to use for the channels
  /// list. This class can be mixed in or extended to create custom overrides.
  /// See [StreamChannelListEventHandler] for advice.
  ///
  /// * `filter` is the query filters to use.
  ///
  /// * `sort` is the sorting used for the channels matching the filters.
  ///
  /// * `presence` sets whether you'll receive user presence updates via the
  /// websocket events.
  ///
  /// * `limit` is the limit to apply to the channel list.
  ///
  /// * `messageLimit` is the number of messages to fetch in each channel.
  ///
  /// * `memberLimit` is the number of members to fetch in each channel.
  StreamChannelListController({
    this.presence = true,
    this.limit = defaultChannelPagedLimit,
    this.messageLimit,
    this.memberLimit,
  }) : super(const PagedValue.loading());

  /// Creates a [StreamChannelListController] from the passed [value].
  StreamChannelListController.fromValue(
    super.value, {
    this.presence = true,
    this.limit = defaultChannelPagedLimit,
    this.messageLimit,
    this.memberLimit,
  });

  /// If true you’ll receive user presence updates via the websocket events
  final bool presence;

  /// The limit to apply to the channel list. The default is set to
  /// [defaultChannelPagedLimit].
  final int limit;

  /// Number of messages to fetch in each channel.
  final int? messageLimit;

  /// Number of members to fetch in each channel.
  final int? memberLimit;

  @override
  Future<void> doInitialLoad() async {
    //todo 实现分页拉取会话列表

    value = PagedValue(
      items: [],
      nextPageKey: 1,
    );
  }

  @override
  Future<void> loadMore(int nextPageKey) async {
    final previousValue = value.asSuccess;
    //todo 实现加载更多拉取会话列表
    value = PagedValue(
      items: [],
      nextPageKey: 1,
    );
  }

  /// Replaces the previously loaded channels with the passed [conversations].
  set conversations(List<Conversation> conversations) {
    if (value.isSuccess) {
      final currentValue = value.asSuccess;
      value = currentValue.copyWith(items: conversations);
    } else {
      value = PagedValue(items: conversations);
    }
  }


  /// Returns/Creates a new Channel and starts watching it.
  Future<WKConversation> getConversation({
    required String id,
    required String type,
  }) async {
    //todo
    return WKConversation();
  }

  /// Leaves the [channel] and updates the list.
  Future<void> leaveChannel(WKConversationMsg channel) async {
    //todo
  }

  /// Deletes the [channel] and updates the list.
  Future<void> deleteChannel(WKConversationMsg channel) async {
    //todo
  }

  /// Mutes the [channel] and updates the list.
  Future<void> muteChannel(WKConversationMsg channel) async {
    //todo
  }

  /// Un-mutes the [channel] and updates the list.
  Future<void> unmuteChannel(WKConversationMsg channel) async {
    //todo
  }

  @override
  Future<void> dispose() async {
    super.dispose();
  }


}
