part of 'stream_chat_localizations.dart';


/// A custom set of localizations for the 'nn' locale. In this example, only
/// the value for launchUrlError was modified to use a custom message as
/// an example. Everything else uses the American English (en_US) messages
/// and formatting.
class StreamChatLocalizationsZh extends GlobalStreamChatLocalizations {
  /// Create an instance of the translation bundle for Portuguese.
  const StreamChatLocalizationsZh({super.localeName = 'zh'});


  @override
  String get ndLabel => '添加评论或发送';

  @override
  String get searchGifLabel => '搜索GIF';

  @override
  String get writeAMessageLabel => '编写消息';

  @override
  String get instantCommandsLabel => '即时命令';

  @override
  String fileTooLargeAfterCompressionError(double limitInMB) =>
      '文件太大无法上传。文件大小限制为$limitInMB MB。我们尝试压缩，但仍然不够。';

  @override
  String fileTooLargeError(double limitInMB) =>
      '文件太大无法上传。文件大小限制为$limitInMB MB。';

  @override
  String get couldNotReadBytesFromFileError => '无法从文件读取字节。';

  @override
  String get addAFileLabel => '添加文件';

  @override
  String get photoFromCameraLabel => '从相机拍摄照片';

  @override
  String get uploadAFileLabel => '上传文件';

  @override
  String get uploadAPhotoLabel => '上传照片';

  @override
  String get uploadAVideoLabel => '上传视频';

  @override
  String get videoFromCameraLabel => '从相机拍摄视频';

  @override
  String get okLabel => '确定';

  @override
  String get somethingWentWrongError => '出错了';

  @override
  String get addMoreFilesLabel => '添加更多文件';

  @override
  String get enablePhotoAndVideoAccessMessage =>
      '请允许访问您的照片和视频，以便与朋友分享。';

  @override
  String get allowGalleryAccessMessage => '允许访问您的相册';

  @override
  String get flagMessageLabel => '标记消息';

  @override
  String get flagMessageQuestion =>
      '您是否要将此消息的副本发送给版主进行进一步调查？';

  @override
  String get flagLabel => '标记';

  @override
  String get cancelLabel => '取消';

  @override
  String get flagMessageSuccessfulLabel => '消息已标记';

  @override
  String get flagMessageSuccessfulText =>
      '该消息已报告给版主。';

  @override
  String get deleteLabel => '删除';

  @override
  String get deleteMessageLabel => '删除消息';

  @override
  String get deleteMessageQuestion =>
      '您确定要永久删除这条消息吗？';

  @override
  String get operationCouldNotBeCompletedText =>
      '操作无法完成。';

  @override
  String get replyLabel => '回复';

  @override
  String togglePinUnpinText({required bool pinned}) {
    return pinned ? '从对话中取消固定' : '固定到对话';
  }

  // ...剩余的转换省略，遵循同样的模式...

  // 示例继续直到最后一个覆盖方法
  @override
  String get markUnreadError =>
      '标记消息未读时出错。无法标记最新100条频道消息之外的消息为未读。';

  @override
  String get launchUrlError => 'Custom error';

  @override
  String get loadingUsersError => 'Error loading users';

  @override
  String get noUsersLabel => 'There are no users currently';

  @override
  String get noPhotoOrVideoLabel => 'There is no photo or video';

  @override
  String get retryLabel => 'Retry';

  @override
  String get userLastOnlineText => 'Last online';

  @override
  String get userOnlineText => 'Online';

  @override
  String userTypingText(Iterable<User> users) {
    if (users.isEmpty) return '';
    final first = users.first;
    if (users.length == 1) {
      return '${first.name} is typing';
    }
    return '${first.name} and ${users.length - 1} more are typing';
  }

  @override
  String get threadReplyLabel => 'Thread Reply';

  @override
  String get onlyVisibleToYouText => 'Only visible to you';

  @override
  String threadReplyCountText(int count) => '$count Thread Replies';

  @override
  String attachmentsUploadProgressText({
    required int remaining,
    required int total,
  }) =>
      'Uploading $remaining/$total ...';

  @override
  String pinnedByUserText({
    required User pinnedBy,
    required User currentUser,
  }) {
    final pinnedByCurrentUser = currentUser.id == pinnedBy.id;
    if (pinnedByCurrentUser) return 'Pinned by You';
    return 'Pinned by ${pinnedBy.name}';
  }

  @override
  String get sendMessagePermissionError =>
      "You don't have permission to send messages";

  @override
  String get emptyMessagesText => 'There are no messages currently';

  @override
  String get genericErrorText => 'Something went wrong';

  @override
  String get loadingMessagesError => 'Error loading messages';

  @override
  String resultCountText(int count) => '$count results';

  @override
  String get messageDeletedText => 'This message is deleted.';

  @override
  String get messageDeletedLabel => 'Message deleted';

  @override
  String get messageReactionsLabel => 'Message Reactions';

  @override
  String get emptyChatMessagesText => 'No chats here yet...';

  @override
  String threadSeparatorText(int replyCount) {
    if (replyCount == 1) return '1 Reply';
    return '$replyCount Replies';
  }

  @override
  String get connectedLabel => '已连接';

  @override
  String get disconnectedLabel => 'Disconnected';

  @override
  String get reconnectingLabel => '连接中...';

  @override
  String get alsoSendAsDirectMessageLabel => 'Also send as direct message';

  @override
  String get addACommentOrSendLabel => 'Add a comment or send';

  @override
  String toggleDeleteRetryDeleteMessageText({required bool isDeleteFailed}) {
    if (isDeleteFailed) return 'Retry Deleting Message';
    return 'Delete Message';
  }

  @override
  String get copyMessageLabel => 'Copy Message';

  @override
  String get editMessageLabel => 'Edit Message';

  @override
  String toggleResendOrResendEditedMessage({required bool isUpdateFailed}) {
    if (isUpdateFailed) return 'Resend Edited Message';
    return 'Resend';
  }

  @override
  String get photosLabel => 'Photos';

  String _getDay(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    final date = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (date == today) {
      return 'today';
    } else if (date == yesterday) {
      return 'yesterday';
    } else {
      return 'on ${Jiffy.parseFromDateTime(date).MMMd}';
    }
  }

  @override
  String sentAtText({required DateTime date, required DateTime time}) {
    final atTime = Jiffy.parseFromDateTime(time.toLocal());
    return 'Sent ${_getDay(date)} at ${atTime.jm}';
  }

  @override
  String get todayLabel => 'Today';

  @override
  String get yesterdayLabel => 'Yesterday';

  @override
  String get channelIsMutedText => 'Channel is muted';

  @override
  String get noTitleText => 'No title';

  @override
  String get letsStartChattingLabel => 'Let’s start chatting!';

  @override
  String get sendingFirstMessageLabel =>
      'How about sending your first message to a friend?';

  @override
  String get startAChatLabel => 'Start a chat';

  @override
  String get loadingChannelsError => 'Error loading channels';

  @override
  String get deleteConversationLabel => 'Delete Conversation';

  @override
  String get deleteConversationQuestion =>
      'Are you sure you want to delete this conversation?';

  @override
  String get streamChatLabel => '聊天';

  @override
  String get searchingForNetworkText => 'Searching for Network';

  @override
  String get offlineLabel => 'Offline...';

  @override
  String get tryAgainLabel => 'Try Again';

  @override
  String membersCountText(int count) {
    if (count == 1) return '1 Member';
    return '$count Members';
  }

  @override
  String watchersCountText(int count) {
    if (count == 1) return '1 Online';
    return '$count Online';
  }

  @override
  String get viewInfoLabel => 'View Info';

  @override
  String get leaveGroupLabel => 'Leave Group';

  @override
  String get leaveLabel => 'LEAVE';

  @override
  String get leaveConversationLabel => 'Leave conversation';

  @override
  String get leaveConversationQuestion =>
      'Are you sure you want to leave this conversation?';

  @override
  String get showInChatLabel => 'Show in Chat';

  @override
  String get saveImageLabel => 'Save Image';

  @override
  String get saveVideoLabel => 'Save Video';

  @override
  String get uploadErrorLabel => 'UPLOAD ERROR';

  @override
  String get giphyLabel => 'Giphy';

  @override
  String get shuffleLabel => 'Shuffle';

  @override
  String get sendLabel => 'Send';

  @override
  String get withText => 'with';

  @override
  String get inText => 'in';

  @override
  String get youText => 'You';

  @override
  String galleryPaginationText({
    required int currentPage,
    required int totalPages,
  }) =>
      '$currentPage of $totalPages';

  @override
  String get fileText => 'File';

  @override
  String get replyToMessageLabel => 'Reply to Message';

  @override
  String attachmentLimitExceedError(int limit) =>
      'Attachment limit exceeded, limit: $limit';

  @override
  String get slowModeOnLabel => 'Slow mode ON';

  @override
  String get downloadLabel => 'Download';

  @override
  String toggleMuteUnmuteUserText({required bool isMuted}) {
    if (isMuted) {
      return 'Unmute User';
    } else {
      return 'Mute User';
    }
  }

  @override
  String toggleMuteUnmuteGroupQuestion({required bool isMuted}) {
    if (isMuted) {
      return 'Are you sure you want to unmute this group?';
    } else {
      return 'Are you sure you want to mute this group?';
    }
  }

  @override
  String toggleMuteUnmuteUserQuestion({required bool isMuted}) {
    if (isMuted) {
      return 'Are you sure you want to unmute this user?';
    } else {
      return 'Are you sure you want to mute this user?';
    }
  }

  @override
  String toggleMuteUnmuteAction({required bool isMuted}) {
    if (isMuted) {
      return 'UNMUTE';
    } else {
      return 'MUTE';
    }
  }

  @override
  String toggleMuteUnmuteGroupText({required bool isMuted}) {
    if (isMuted) {
      return 'Unmute Group';
    } else {
      return 'Mute Group';
    }
  }

  @override
  String get linkDisabledDetails =>
      'Sending links is not allowed in this conversation.';

  @override
  String get linkDisabledError => 'Links are disabled';

  @override
  String get viewLibrary => 'View library';

  @override
  String unreadMessagesSeparatorText() => 'New messages';

  @override
  String get enableFileAccessMessage => 'Enable file access to continue';

  @override
  String get allowFileAccessMessage => 'Allow access to files';

  @override
  String get markAsUnreadLabel => 'Mark as unread';

  @override
  String unreadCountIndicatorLabel({required int unreadCount}) {
    return '$unreadCount unread';
  }

}

