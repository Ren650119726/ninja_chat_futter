import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart'
    show IterableExtension, ListEquality;
import 'package:rxdart/rxdart.dart';
import 'package:stream_chat/src/client/retry_queue.dart';
import 'package:stream_chat/src/core/util/utils.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:synchronized/synchronized.dart';

/// The maximum time the incoming [Event.typingStart] event is valid before a
/// [Event.typingStop] event is emitted automatically.
const incomingTypingStartEventTimeout = 7;

/// Class that manages a specific channel.
///
/// #### Channel name
///
/// {@template name}
/// If an optional [name] argument is provided in the constructor then it
/// will be set on [extraData] with a key of 'name'.
///
/// ```dart
/// final channel = Channel(client, type, id, name: 'Channel name');
/// print(channel.name == channel.extraData['name']); // true
/// ```
///
/// Before the channel is initialized the name can be set directly:
/// ```dart
/// channel.name = 'New channel name';
/// ```
///
/// To update the name after the channel has been initialized, call:
/// ```dart
/// channel.updateName('Updated channel name');
/// ```
///
/// This will do a partial update to update the name.
/// {@endtemplate}
///
/// #### Channel image
///
/// {@template image}
/// If an optional [image] argument is provided in the constructor then it
/// will be set on [extraData] with a key of 'image'.
///
/// ```dart
/// final channel = Channel(client, type, id, image: 'https://getstream.io/image.png');
/// print(channel.image == channel.extraData['image']); // true
/// ```
///
/// Before the channel is initialized the image can be set directly:
/// ```dart
/// channel.image = 'https://getstream.io/new-image';
/// ```
///
/// To update the image after the channel has been initialized, call:
/// ```dart
/// channel.updateImage('https://getstream.io/new-image');
/// ```
///
/// This will do a partial update to update the image.
/// {@endtemplate}
class Channel {
  /// Class that manages a specific channel.
  ///
  /// Optional [extraData] and [image] properties can be provided. The [image]
  /// is exposed to easily set a key of 'image' on [extraData].
  Channel(
    this._type,
    this._id, {
    String? name,
    String? image,
    Map<String, Object?>? extraData,
  })  : _cid = _id != null ? '$_type:$_id' : null,
        _extraData = {
          ...?extraData,
          if (name != null) 'name': name,
          if (image != null) 'image': image,
        } {
  }

  /// Create a channel client instance from a [ChannelState] object.
  Channel.fromState(ChannelState channelState)
      : assert(
          channelState.channel != null,
          'No channel found inside channel state',
        ),
        _id = channelState.channel!.id,
        _type = channelState.channel!.type,
        _cid = channelState.channel!.cid,
        _extraData = channelState.channel!.extraData {
    state = ChannelClientState(this, channelState);
    _initializedCompleter.complete(true);
  }

  /// This client state
  ChannelClientState? state;

  /// The channel type
  final String _type;

  String? _id;
  String? _cid;
  final Map<String, Object?> _extraData;

  /// Shortcut to set channel name.
  ///
  /// {@macro name}
  set name(String? name) {
    if (_initializedCompleter.isCompleted) {
      throw StateError(
        'Once the channel is initialized you should use `channel.updateName` '
        'to update the channel name',
      );
    }
    _extraData.addAll({'name': name});
  }

  /// Shortcut to set channel image.
  ///
  /// {@macro image}
  set image(String? image) {
    if (_initializedCompleter.isCompleted) {
      throw StateError(
        'Once the channel is initialized you should use `channel.updateImage` '
        'to update the channel image',
      );
    }
    _extraData.addAll({'image': image});
  }

  set extraData(Map<String, Object?> extraData) {
    if (_initializedCompleter.isCompleted) {
      throw StateError(
        'Once the channel is initialized you should use `channel.update` '
        'to update channel data',
      );
    }
    _extraData.addAll(extraData);
  }


  /// True if the channel is a group.
  bool get isGroup => memberCount != 2;

  /// True if the channel is distinct.
  bool get isDistinct => id?.startsWith('!members') == true;

  /// Channel configuration.
  ChannelConfig? get config {
    _checkInitialized();
    return state!._channelState.channel?.config;
  }

  /// Channel configuration as a stream.
  Stream<ChannelConfig?> get configStream {
    _checkInitialized();
    return state!.channelStateStream.map((cs) => cs.channel?.config);
  }

  /// Relationship of the current user to this channel.
  Member? get membership {
    _checkInitialized();
    return state!._channelState.membership;
  }

  /// Relationship of the current user to this channel as a stream.
  Stream<Member?> get membershipStream {
    _checkInitialized();
    return state!.channelStateStream.map((cs) => cs.membership);
  }

  /// Channel user creator.
  User? get createdBy {
    _checkInitialized();
    return state!._channelState.channel?.createdBy;
  }

  /// Channel user creator as a stream.
  Stream<User?> get createdByStream {
    _checkInitialized();
    return state!.channelStateStream.map((cs) => cs.channel?.createdBy);
  }

  /// Channel frozen status.
  bool get frozen {
    _checkInitialized();
    return state!._channelState.channel?.frozen == true;
  }

  /// Channel frozen status as a stream.
  Stream<bool> get frozenStream {
    _checkInitialized();
    return state!.channelStateStream.map((cs) => cs.channel?.frozen == true);
  }

  /// Channel disabled status.
  bool get disabled {
    _checkInitialized();
    return state!._channelState.channel?.disabled == true;
  }

  /// Channel disabled status as a stream.
  Stream<bool> get disabledStream {
    _checkInitialized();
    return state!.channelStateStream.map((cs) => cs.channel?.disabled == true);
  }

  /// Channel hidden status.
  bool get hidden {
    _checkInitialized();
    return state!._channelState.channel?.hidden == true;
  }

  /// Channel hidden status as a stream.
  Stream<bool> get hiddenStream {
    _checkInitialized();
    return state!.channelStateStream.map((cs) => cs.channel?.hidden == true);
  }

  /// The last date at which the channel got truncated.
  DateTime? get truncatedAt {
    _checkInitialized();
    return state!._channelState.channel?.truncatedAt;
  }

  /// The last date at which the channel got truncated as a stream.
  Stream<DateTime?> get truncatedAtStream {
    _checkInitialized();
    return state!.channelStateStream.map((cs) => cs.channel?.truncatedAt);
  }

  /// Cooldown count
  int get cooldown {
    _checkInitialized();
    return state!._channelState.channel?.cooldown ?? 0;
  }

  /// Cooldown count as a stream
  Stream<int> get cooldownStream {
    _checkInitialized();
    return state!.channelStateStream.map((cs) => cs.channel?.cooldown ?? 0);
  }

  /// Stores time at which cooldown was started
  DateTime? cooldownStartedAt;

  /// Channel creation date.
  DateTime? get createdAt {
    _checkInitialized();
    return state!._channelState.channel?.createdAt;
  }

  /// Channel creation date as a stream.
  Stream<DateTime?> get createdAtStream {
    _checkInitialized();
    return state!.channelStateStream.map((cs) => cs.channel?.createdAt);
  }

  /// Channel last message date.
  DateTime? get lastMessageAt {
    _checkInitialized();
    return state!._channelState.channel?.lastMessageAt;
  }

  /// Channel last message date as a stream.
  Stream<DateTime?> get lastMessageAtStream {
    _checkInitialized();
    return state!.channelStateStream.map((cs) => cs.channel?.lastMessageAt);
  }

  /// Channel updated date.
  DateTime? get updatedAt {
    _checkInitialized();
    return state!._channelState.channel?.updatedAt;
  }

  /// Channel updated date as a stream.
  Stream<DateTime?> get updatedAtStream {
    _checkInitialized();
    return state!.channelStateStream.map((cs) => cs.channel?.updatedAt);
  }

  /// Channel deletion date.
  DateTime? get deletedAt {
    _checkInitialized();
    return state!._channelState.channel?.deletedAt;
  }

  /// Channel deletion date as a stream.
  Stream<DateTime?> get deletedAtStream {
    _checkInitialized();
    return state!.channelStateStream.map((cs) => cs.channel?.deletedAt);
  }

  /// Channel member count.
  int? get memberCount {
    _checkInitialized();
    return state!._channelState.channel?.memberCount;
  }

  /// Channel member count as a stream.
  Stream<int?> get memberCountStream {
    _checkInitialized();
    return state!.channelStateStream.map((cs) => cs.channel?.memberCount);
  }

  /// Channel id.
  String? get id => state?._channelState.channel?.id ?? _id;

  /// Channel type.
  String get type => state?._channelState.channel?.type ?? _type;

  /// Channel cid.
  String? get cid => state?._channelState.channel?.cid ?? _cid;

  /// Channel team.
  String? get team {
    _checkInitialized();
    return state!._channelState.channel?.team;
  }

  /// Channel extra data.
  Map<String, Object?> get extraData {
    var data = state?._channelState.channel?.extraData;
    if (data == null || data.isEmpty) {
      data = _extraData;
    }
    return data;
  }

  /// List of user permissions on this channel
  List<String> get ownCapabilities =>
      state?._channelState.channel?.ownCapabilities ?? [];

  /// List of user permissions on this channel
  Stream<List<String>> get ownCapabilitiesStream {
    _checkInitialized();
    return state!.channelStateStream
        .map((cs) => cs.channel?.ownCapabilities ?? [])
        .distinct();
  }

  /// Channel extra data as a stream.
  Stream<Map<String, Object?>> get extraDataStream {
    _checkInitialized();
    return state!.channelStateStream.map(
      (cs) => cs.channel?.extraData ?? _extraData,
    );
  }

  /// Shortcut to get channel name.
  ///
  /// {@macro name}
  String? get name => extraData['name'] as String?;

  /// Channel [name] as a stream.
  ///
  /// The channel needs to be initialized.
  ///
  /// {@macro name}
  Stream<String?> get nameStream {
    _checkInitialized();
    return extraDataStream.map((it) => it['name'] as String?);
  }

  /// Shortcut to get channel image.
  ///
  /// {@macro image}
  String? get image => extraData['image'] as String?;

  /// Channel [image] as a stream.
  ///
  /// The channel needs to be initialized.
  ///
  /// {@macro image}
  Stream<String?> get imageStream {
    _checkInitialized();
    return extraDataStream.map((it) => it['image'] as String?);
  }

  final Completer<bool> _initializedCompleter = Completer();

  /// True if this is initialized.
  ///
  /// Call [watch] to initialize the client or instantiate it using
  /// [Channel.fromState].
  Future<bool> get initialized => _initializedCompleter.future;

  final _cancelableAttachmentUploadRequest = <String, CancelToken>{};
  final _messageAttachmentsUploadCompleter = <String, Completer<Message>>{};

  /// Cancels [attachmentId] upload request. Throws exception if the request
  /// hasn't even started yet, Already completed or Already cancelled.
  ///
  /// Optionally, provide a [reason] for the cancellation.
  void cancelAttachmentUpload(
    String attachmentId, {
    String? reason,
  }) {
    final cancelToken = _cancelableAttachmentUploadRequest[attachmentId];
    if (cancelToken == null) {
      throw const StreamChatError(
        "Upload request for this Attachment hasn't started yet or maybe "
        'Already completed',
      );
    }
    if (cancelToken.isCancelled) {
      throw const StreamChatError('Upload request already cancelled');
    }
    cancelToken.cancel(reason);
  }

  /// Retries the failed [attachmentId] upload request.
  Future<void> retryAttachmentUpload(String messageId, String attachmentId) =>
      _uploadAttachments(messageId, [attachmentId]);

  Future<void> _uploadAttachments(
    String messageId,
    Iterable<String> attachmentIds,
  ) {
    var message = [
      ...state!.messages,
      ...state!.threads.values.expand((messages) => messages),
    ].firstWhereOrNull((it) => it.id == messageId);

    if (message == null) {
      throw const StreamChatError('Error, Message not found');
    }

    final attachments = message.attachments.where((it) {
      if (it.uploadState.isSuccess) return false;
      return attachmentIds.contains(it.id);
    });

    if (attachments.isEmpty) {
      if (message.attachments.every((it) => it.uploadState.isSuccess)) {
        _messageAttachmentsUploadCompleter.remove(messageId)?.complete(message);
      }
      return Future.value();
    }

    void updateAttachment(Attachment attachment, {bool remove = false}) {
      final index = message!.attachments.indexWhere(
            (it) => it.id == attachment.id,
      );
      if (index != -1) {
        // update or remove attachment from message.
        final List<Attachment> newAttachments;
        if (remove) {
          newAttachments = [...message!.attachments]..removeAt(index);
        } else {
          newAttachments = [...message!.attachments]..[index] = attachment;
        }

        final updatedMessage = message!.copyWith(attachments: newAttachments);
        state?.updateMessage(updatedMessage);
        // updating original message for next iteration
        message = message!.merge(updatedMessage);
      }
    }

    return Future.wait(attachments.map((it) {
      final throttledUpdateAttachment = updateAttachment.throttled(
        const Duration(milliseconds: 500),
      );

      void onSendProgress(int sent, int total) {
        throttledUpdateAttachment([
          it.copyWith(
            uploadState: UploadState.inProgress(uploaded: sent, total: total),
          ),
        ]);
      }

      final isImage = it.type == AttachmentType.image;
      final cancelToken = CancelToken();
      Future<SendAttachmentResponse> future;
      if (isImage) {
        future = sendImage(
          it.file!,
          onSendProgress: onSendProgress,
          cancelToken: cancelToken,
          extraData: it.extraData,
        );
      } else {
        future = sendFile(
          it.file!,
          onSendProgress: onSendProgress,
          cancelToken: cancelToken,
          extraData: it.extraData,
        );
      }
      _cancelableAttachmentUploadRequest[it.id] = cancelToken;
      return future.then((response) {
        // If the response is SendFileResponse, then we might also be getting
        // thumbUrl in case of video. So we need to update the attachment with
        // both the assetUrl and thumbUrl.
        if (response is SendFileResponse) {
          updateAttachment(
            it.copyWith(
              assetUrl: response.file,
              thumbUrl: response.thumbUrl,
              uploadState: const UploadState.success(),
            ),
          );
        } else {
          updateAttachment(
            it.copyWith(
              imageUrl: response.file,
              uploadState: const UploadState.success(),
            ),
          );
        }
      }).catchError((e, stk) {
        if (e is StreamChatNetworkError && e.isRequestCancelledError) {
          // remove attachment from message if cancelled.
          updateAttachment(it, remove: true);
          return;
        }

        updateAttachment(
          it.copyWith(uploadState: UploadState.failed(error: e.toString())),
        );
      }).whenComplete(() {
        throttledUpdateAttachment.cancel();
        _cancelableAttachmentUploadRequest.remove(it.id);
      });
    })).whenComplete(() {
      if (message!.attachments.every((it) => it.uploadState.isSuccess)) {
        _messageAttachmentsUploadCompleter.remove(messageId)?.complete(message);
      }
    });
  }


  void _initState(ChannelState channelState) {
    state = ChannelClientState(this, channelState);

    if (cid != null) {
    }
    if (!_initializedCompleter.isCompleted) {
      _initializedCompleter.complete(true);
    }
  }

  void _checkInitialized() {
    assert(
      _initializedCompleter.isCompleted,
      "Channel $cid hasn't been initialized yet. Make sure to call .watch()"
      ' or to instantiate the client using [Channel.fromState]',
    );
  }
}

/// The class that handles the state of the channel listening to the events.
class ChannelClientState {
  /// Creates a new instance listening to events and updating the state.
  ChannelClientState(
    this._channel,
    ChannelState channelState,
    //ignore: unnecessary_parenthesis
  ) : _debouncedUpdatePersistenceChannelState = ((ChannelState state) =>{})
            .debounced(const Duration(seconds: 1)) {

    _channelStateController = BehaviorSubject.seeded(channelState);

    _listenTypingEvents();

    _startCleaningStaleTypingEvents();

    _startCleaningStalePinnedMessages();

  }

  final Channel _channel;
  final _subscriptions = CompositeSubscription();



  void _updateMember(Member member) {
    final currentMembers = [...members];
    final memberIndex = currentMembers.indexWhere(
      (m) => m.userId == member.userId,
    );

    if (memberIndex == -1) return;
    currentMembers[memberIndex] = member;

    updateChannelState(
      channelState.copyWith(
        members: currentMembers,
      ),
    );
  }

  /// Flag which indicates if [ChannelClientState] contain latest/recent messages or not.
  ///
  /// This flag should be managed by UI sdks.
  ///
  /// When false, any new message received by WebSocket event
  /// [EventType.messageNew] will not be pushed on to message list.
  bool get isUpToDate => _isUpToDateController.value;

  set isUpToDate(bool isUpToDate) => _isUpToDateController.add(isUpToDate);

  /// [isUpToDate] flag count as a stream.
  Stream<bool> get isUpToDateStream => _isUpToDateController.stream;
  final _isUpToDateController = BehaviorSubject.seeded(true);

  /// The retry queue associated to this channel.
  late final RetryQueue _retryQueue;

  /// Retry failed message.
  Future<void> retryFailedMessages() async {
    final failedMessages = [...messages, ...threads.values.expand((v) => v)]
        .where((it) => it.state.isFailed);
    _retryQueue.add(failedMessages);
  }


  /// Updates the [message] in the state if it exists. Adds it otherwise.
  void updateMessage(Message message) {
    // Determine if the message should be displayed in the channel view.
    if (message.parentId == null || message.showInChannel == true) {
      // Create a new list of messages to avoid modifying the original
      // list directly.
      var newMessages = [...messages];
      final oldIndex = newMessages.indexWhere((m) => m.id == message.id);

      if (oldIndex != -1) {
        // If the message already exists, prepare it for update.
        final oldMessage = newMessages[oldIndex];
        var updatedMessage = message.syncWith(oldMessage);

        // Preserve quotedMessage if the update doesn't include a new
        // quotedMessage.
        if (message.quotedMessageId != null &&
            message.quotedMessage == null &&
            oldMessage.quotedMessage != null) {
          updatedMessage = updatedMessage.copyWith(
            quotedMessage: oldMessage.quotedMessage,
          );
        }

        // Update the message in the list.
        newMessages[oldIndex] = updatedMessage;

        // Update quotedMessage references in all messages.
        newMessages = newMessages.map((it) {
          // Skip if the current message does not quote the updated message.
          if (it.quotedMessageId != message.id) return it;

          // Update the quotedMessage only if the updatedMessage indicates
          // deletion.
          if (message.type == 'deleted') {
            return it.copyWith(
              quotedMessage: updatedMessage.copyWith(
                type: message.type,
                deletedAt: message.deletedAt,
              ),
            );
          }
          return it;
        }).toList();
      } else {
        // If the message is new, add it to the list.
        newMessages.add(message);
      }

      // Handle updates to pinned messages.
      final newPinnedMessages = _updatePinnedMessages(message);

      // Apply the updated lists to the channel state.
      _channelState = _channelState.copyWith(
        messages: newMessages.sorted(_sortByCreatedAt),
        pinnedMessages: newPinnedMessages,
        channel: _channelState.channel?.copyWith(
          lastMessageAt: message.createdAt,
        ),
      );
    }

    // If the message is part of a thread, update thread information.
    if (message.parentId != null) {
      updateThreadInfo(message.parentId!, [message]);
    }
  }

  /// Updates the list of pinned messages based on the current message's
  /// pinned status.
  List<Message> _updatePinnedMessages(Message message) {
    final newPinnedMessages = [...pinnedMessages];
    final oldPinnedIndex =
        newPinnedMessages.indexWhere((m) => m.id == message.id);

    if (message.pinned) {
      // If the message is pinned, add or update it in the list of pinned
      // messages.
      if (oldPinnedIndex != -1) {
        newPinnedMessages[oldPinnedIndex] = message;
      } else {
        newPinnedMessages.add(message);
      }
    } else {
      // If the message is not pinned, remove it from the list of pinned
      // messages.
      newPinnedMessages.removeWhere((m) => m.id == message.id);
    }

    return newPinnedMessages;
  }

  /// Channel message list.
  List<Message> get messages => _channelState.messages ?? <Message>[];

  /// Channel message list as a stream.
  Stream<List<Message>> get messagesStream => channelStateStream
      .map((cs) => cs.messages ?? <Message>[])
      .distinct(const ListEquality().equals);

  /// Channel pinned message list.
  List<Message> get pinnedMessages =>
      _channelState.pinnedMessages ?? <Message>[];

  /// Channel pinned message list as a stream.
  Stream<List<Message>> get pinnedMessagesStream => channelStateStream
      .map((cs) => cs.pinnedMessages ?? <Message>[])
      .distinct(const ListEquality().equals);

  /// Get channel last message.
  Message? get lastMessage =>
      _channelState.messages != null && _channelState.messages!.isNotEmpty
          ? _channelState.messages!.last
          : null;

  /// Get channel last message.
  Stream<Message?> get lastMessageStream =>
      messagesStream.map((event) => event.isNotEmpty ? event.last : null);

  /// Channel members list.
  List<Member> get members => (_channelState.members ?? <Member>[])
      .map((e) => e.copyWith(user: _channel.state.users[e.user!.id]))
      .toList();

  /// Channel members list as a stream.
  Stream<List<Member>> get membersStream => CombineLatestStream.combine2<
          List<Member?>?, Map<String?, User?>, List<Member>>(
        channelStateStream.map((cs) => cs.members),
        _channel.client.state.usersStream,
        (members, users) =>
            members!.map((e) => e!.copyWith(user: users[e.user!.id])).toList(),
      ).distinct(const ListEquality().equals);

  /// Channel watcher count.
  int? get watcherCount => _channelState.watcherCount;

  /// Channel watcher count as a stream.
  Stream<int?> get watcherCountStream =>
      channelStateStream.map((cs) => cs.watcherCount);

  /// Channel watchers list.
  List<User> get watchers => (_channelState.watchers ?? <User>[])
      .map((e) => _channel.client.state.users[e.id] ?? e)
      .toList();

  /// Channel watchers list as a stream.
  Stream<List<User>> get watchersStream => CombineLatestStream.combine2<
          List<User>?, Map<String?, User?>, List<User>>(
        channelStateStream.map((cs) => cs.watchers),
        _channel.client.state.usersStream,
        (watchers, users) => watchers!.map((e) => users[e.id] ?? e).toList(),
      ).distinct(const ListEquality().equals);

  /// Channel member for the current user.
  Member? get currentUserMember => members.firstWhereOrNull(
        (m) => m.user?.id == _channel.client.state.currentUser?.id,
      );

  /// Channel role for the current user
  String? get currentUserChannelRole => currentUserMember?.channelRole;

  /// Channel read list.
  List<Read> get read => _channelState.read ?? <Read>[];

  /// Channel read list as a stream.
  Stream<List<Read>> get readStream =>
      channelStateStream.map((cs) => cs.read ?? <Read>[]);

  bool _isCurrentUserRead(Read read) =>
      read.user.id == _channel._client.state.currentUser!.id;

  /// Channel read for the logged in user.
  Read? get currentUserRead => read.firstWhereOrNull(_isCurrentUserRead);

  /// Channel read for the logged in user as a stream.
  Stream<Read?> get currentUserReadStream =>
      readStream.map((read) => read.firstWhereOrNull(_isCurrentUserRead));

  /// Unread count getter as a stream.
  Stream<int> get unreadCountStream =>
      currentUserReadStream.map((read) => read?.unreadMessages ?? 0);

  /// Unread count getter.
  int get unreadCount => currentUserRead?.unreadMessages ?? 0;

  /// Setter for unread count.
  set unreadCount(int count) {
    final reads = [...read];
    final currentUserReadIndex = reads.indexWhere(_isCurrentUserRead);

    if (currentUserReadIndex < 0) return;

    reads[currentUserReadIndex] =
        reads[currentUserReadIndex].copyWith(unreadMessages: count);
    _channelState = _channelState.copyWith(read: reads);
  }

  bool _countMessageAsUnread(Message message) {
    final userId = _channel.client.state.currentUser?.id;
    final userIsMuted =
        _channel.client.state.currentUser?.mutes.firstWhereOrNull(
              (m) => m.user.id == message.user?.id,
            ) !=
            null;
    final isThreadMessage = message.parentId != null;

    return !message.silent &&
        !message.shadowed &&
        message.user?.id != userId &&
        !userIsMuted &&
        !isThreadMessage;
  }

  /// Counts the number of unread messages mentioning the current user.
  ///
  /// **NOTE**: The method relies on the [Channel.messages] list and doesn't do
  /// any API call. Therefore, the count might be not reliable as it relies on
  /// the local data.
  int countUnreadMentions() {
    final lastRead = currentUserRead?.lastRead;
    final userId = _channel.client.state.currentUser?.id;

    var count = 0;
    for (final message in messages) {
      if (_countMessageAsUnread(message) &&
          (lastRead == null || message.createdAt.isAfter(lastRead)) &&
          message.mentionedUsers.any((user) => user.id == userId) == true) {
        count++;
      }
    }
    return count;
  }

  /// Update threads with updated information about messages.
  void updateThreadInfo(String parentId, List<Message> messages) {
    final newThreads = Map<String, List<Message>>.from(threads);

    if (newThreads.containsKey(parentId)) {
      newThreads[parentId] = [
        ...messages,
        ...newThreads[parentId]!.where(
          (newMessage) => !messages.any((m) => m.id == newMessage.id),
        ),
      ].sorted(_sortByCreatedAt);
    } else {
      newThreads[parentId] = messages;
    }

  }

  /// Delete all channel messages.
  void truncate() {
    _channelState = _channelState.copyWith(
      messages: [],
    );
  }

  final List<String> _updatedMessagesIds = [];

  /// Update channelState with updated information.
  void updateChannelState(ChannelState updatedState) {
    final _existingStateMessages = [...messages];
    final newMessages = <Message>[
      ..._existingStateMessages.merge(updatedState.messages),
    ].sorted(_sortByCreatedAt);

    final _existingStateWatchers = _channelState.watchers ?? [];
    final _updatedStateWatchers = updatedState.watchers ?? [];
    final newWatchers = <User>[
      ..._updatedStateWatchers,
      ..._existingStateWatchers
          .where((w) =>
              !_updatedStateWatchers.any((newWatcher) => newWatcher.id == w.id))
          .toList(),
    ];

    final newMembers = <Member>[
      ...updatedState.members ?? [],
    ];

    final _existingStateRead = _channelState.read ?? [];
    final _updatedStateRead = updatedState.read ?? [];
    final newReads = <Read>[
      ..._updatedStateRead,
      ..._existingStateRead
          .where((r) =>
              !_updatedStateRead.any((newRead) => newRead.user.id == r.user.id))
          .toList(),
    ];

    _channelState = _channelState.copyWith(
      messages: newMessages,
      channel: _channelState.channel?.merge(updatedState.channel),
      watchers: newWatchers,
      watcherCount: updatedState.watcherCount,
      members: newMembers,
      read: newReads,
      pinnedMessages: updatedState.pinnedMessages,
    );
  }

  int _sortByCreatedAt(Message a, Message b) =>
      a.createdAt.compareTo(b.createdAt);

  /// The channel state related to this client.
  ChannelState get _channelState => _channelStateController.value;

  /// The channel state related to this client as a stream.
  Stream<ChannelState> get channelStateStream => _channelStateController.stream;

  /// The channel state related to this client.
  ChannelState get channelState => _channelStateController.value;
  late BehaviorSubject<ChannelState> _channelStateController;

  final Debounce _debouncedUpdatePersistenceChannelState;

  set _channelState(ChannelState v) {
    _channelStateController.add(v);
    _debouncedUpdatePersistenceChannelState.call([v]);
  }

  /// The channel threads related to this channel.
  Map<String, List<Message>> get threads =>
      _threadsController.value.map(MapEntry.new);

  /// The channel threads related to this channel as a stream.
  Stream<Map<String, List<Message>>> get threadsStream =>
      _threadsController.stream;
  final BehaviorSubject<Map<String, List<Message>>> _threadsController =
      BehaviorSubject.seeded({});


  /// Channel related typing users stream.
  Stream<Map<User, Event>> get typingEventsStream =>
      _typingEventsController.stream;

  /// Channel related typing users last value.
  Map<User, Event> get typingEvents => _typingEventsController.value;
  final _typingEventsController = BehaviorSubject.seeded(<User, Event>{});

  Timer? _staleTypingEventsCleanerTimer;



  Timer? _stalePinnedMessagesCleanerTimer;

  // Checks and removes stale pinned messages that are not valid anymore.
  void _startCleaningStalePinnedMessages() {
    _stalePinnedMessagesCleanerTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) {
        final now = DateTime.now();
        var expiredMessages = channelState.pinnedMessages
            ?.where((m) => m.pinExpires?.isBefore(now) == true)
            .toList();
        if (expiredMessages != null && expiredMessages.isNotEmpty) {
          expiredMessages = expiredMessages
              .map((m) => m.copyWith(
                    pinExpires: null,
                    pinned: false,
                  ))
              .toList();

          updateChannelState(_channelState.copyWith(
            pinnedMessages: pinnedMessages.where(_pinIsValid).toList(),
            messages: expiredMessages,
          ));
        }
      },
    );
  }

  /// Call this method to dispose this object.
  void dispose() {
    _debouncedUpdatePersistenceChannelState.cancel();
    _retryQueue.dispose();
    _subscriptions.cancel();
    _channelStateController.close();
    _isUpToDateController.close();
    _threadsController.close();
    _staleTypingEventsCleanerTimer?.cancel();
    _stalePinnedMessagesCleanerTimer?.cancel();
    _typingEventsController.close();
  }
}

bool _pinIsValid(Message message) {
  final now = DateTime.now();
  return message.pinExpires!.isAfter(now);
}

extension on Iterable<Message> {
  Iterable<Message> merge(Iterable<Message>? other) {
    if (other == null) return this;

    final messageMap = {for (final message in this) message.id: message};

    for (final message in other) {
      messageMap.update(
        message.id,
        message.syncWith,
        ifAbsent: () => message,
      );
    }

    return messageMap.values;
  }
}
