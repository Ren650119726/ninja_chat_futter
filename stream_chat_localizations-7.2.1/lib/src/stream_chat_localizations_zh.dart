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
  String get launchUrlError => '自定义错误';

  @override
  String get loadingUsersError => '加载用户出错';

  @override
  String get noUsersLabel => '当前没有用户';

  @override
  String get noPhotoOrVideoLabel => '没有照片或视频';

  @override
  String get retryLabel => '重试';

  @override
  String get userLastOnlineText => '上次在线';

  @override
  String get userOnlineText => '在线';

  @override
  String userTypingText(Iterable<User> users) {
    if (users.isEmpty) return '';
    final first = users.first;
    if (users.length == 1) {
      return '${first.name} 正在输入';
    }
    return '${first.name} 和其他 ${users.length - 1} 人正在输入';
  }

  @override
  String get threadReplyLabel => '回复线程';

  @override
  String get onlyVisibleToYouText => '仅你可见';

  @override
  String threadReplyCountText(int count) => '$count 条回复';

  @override
  String attachmentsUploadProgressText({
    required int remaining,
    required int total,
  }) =>
      '正在上传 $remaining/$total ...';

  @override
  String pinnedByUserText({
    required User pinnedBy,
    required User currentUser,
  }) {
    final pinnedByCurrentUser = currentUser.id == pinnedBy.id;
    if (pinnedByCurrentUser) return '你置顶了';
    return '${pinnedBy.name} 置顶了';
  }

  @override
  String get sendMessagePermissionError =>
      '您没有发送消息的权限';

  @override
  String get emptyMessagesText => '当前没有消息';

  @override
  String get genericErrorText => '出了点问题';

  @override
  String get loadingMessagesError => '加载消息出错';

  @override
  String resultCountText(int count) => '$count 条结果';

  @override
  String get messageDeletedText => '此消息已删除。';

  @override
  String get messageDeletedLabel => '消息已删除';

  @override
  String get messageReactionsLabel => '消息反应';

  @override
  String get emptyChatMessagesText => '暂无聊天...';

  @override
  String threadSeparatorText(int replyCount) {
    if (replyCount == 1) return '1 条回复';
    return '$replyCount 条回复';
  }

  @override
  String get connectedLabel => '已连接';

  @override
  String get disconnectedLabel => '未连接';

  @override
  String get reconnectingLabel => '重新连接中...';

  @override
  String get alsoSendAsDirectMessageLabel => '同时发送为直接消息';

  @override
  String get addACommentOrSendLabel => '添加评论或发送';

  @override
  String toggleDeleteRetryDeleteMessageText({required bool isDeleteFailed}) {
    if (isDeleteFailed) return '重试删除消息';
    return '删除消息';
  }

  @override
  String get copyMessageLabel => '复制消息';

  @override
  String get editMessageLabel => '编辑消息';

  @override
  String toggleResendOrResendEditedMessage({required bool isUpdateFailed}) {
    if (isUpdateFailed) return '重新发送编辑后的消息';
    return '重新发送';
  }

  @override
  String get photosLabel => '照片';

  String _getDay(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    final date = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (date == today) {
      return '今天';
    } else if (date == yesterday) {
      return '昨天';
    } else {
      return '${Jiffy.parseFromDateTime(date).MMMd} 发送';
    }
  }

  @override
  String sentAtText({required DateTime date, required DateTime time}) {
    final atTime = Jiffy.parseFromDateTime(time.toLocal());
    return '${_getDay(date)} ${atTime.jm} 发送';
  }

  @override
  String get todayLabel => '今天';

  @override
  String get yesterdayLabel => '昨天';

  @override
  String get channelIsMutedText => '频道已静音';

  @override
  String get noTitleText => '无标题';

  @override
  String get letsStartChattingLabel => '让我们开始聊天吧！';

  @override
  String get sendingFirstMessageLabel =>
      '发送你的第一条消息给一个朋友吧！';

  @override
  String get startAChatLabel => '开始聊天';

  @override
  String get loadingChannelsError => '加载频道出错';

  @override
  String get deleteConversationLabel => '删除对话';

  @override
  String get deleteConversationQuestion =>
      '确定要删除此对话吗？';

  @override
  String get streamChatLabel => '聊天';

  @override
  String get searchingForNetworkText => '正在搜索网络';

  @override
  String get offlineLabel => '离线...';

  @override
  String get tryAgainLabel => '重试';

  @override
  String membersCountText(int count) {
    if (count == 1) return '1 位成员';
    return '$count 位成员';
  }

  @override
  String watchersCountText(int count) {
    if (count == 1) return '1 位在线';
    return '$count 位在线';
  }

  @override
  String get viewInfoLabel => '查看信息';

  @override
  String get leaveGroupLabel => '退出群组';

  @override
  String get leaveLabel => '退出';

  @override
  String get leaveConversationLabel => '离开对话';

  @override
  String get leaveConversationQuestion =>
      '确定要离开此对话吗？';

  @override
  String get showInChatLabel => '在聊天中显示';

  @override
  String get saveImageLabel => '保存图片';

  @override
  String get saveVideoLabel => '保存视频';

  @override
  String get uploadErrorLabel => '上传错误';

  @override
  String get giphyLabel => 'Giphy';

  @override
  String get shuffleLabel => '洗牌';

  @override
  String get sendLabel => '发送';

  @override
  String get withText => '和';

  @override
  String get inText => '在';

  @override
  String get youText => '你';

  @override
  String galleryPaginationText({
    required int currentPage,
    required int totalPages,
  }) =>
      '$currentPage / $totalPages';

  @override
  String get fileText => '文件';

  @override
  String get replyToMessageLabel => '回复消息';

  @override
  String attachmentLimitExceedError(int limit) =>
      '附件超过限制，限制：$limit';

  @override
  String get slowModeOnLabel => '慢模式开启';

  @override
  String get downloadLabel => '下载';

  @override
  String toggleMuteUnmuteUserText({required bool isMuted}) {
    if (isMuted) {
      return '取消静音用户';
    } else {
      return '静音用户';
    }
  }

  @override
  String toggleMuteUnmuteGroupQuestion({required bool isMuted}) {
    if (isMuted) {
      return '确定要取消静音此群组吗？';
    } else {
      return '确定要静音此群组吗？';
    }
  }

  @override
  String toggleMuteUnmuteUserQuestion({required bool isMuted}) {
    if (isMuted) {
      return '确定要取消静音此用户吗？';
    } else {
      return '确定要静音此用户吗？';
    }
  }

  @override
  String toggleMuteUnmuteAction({required bool isMuted}) {
    if (isMuted) {
      return '取消静音';
    } else {
      return '静音';
    }
  }

  @override
  String toggleMuteUnmuteGroupText({required bool isMuted}) {
    if (isMuted) {
      return '取消静音群组';
    } else {
      return '静音群组';
    }
  }

  @override
  String get linkDisabledDetails =>
      '此对话中禁止发送链接。';

  @override
  String get linkDisabledError => '链接已禁用';

  @override
  String get viewLibrary => '查看库';

  @override
  String unreadMessagesSeparatorText() => '新消息';

  @override
  String get enableFileAccessMessage => '继续，请允许文件访问';

  @override
  String get allowFileAccessMessage => '允许访问文件';

  @override
  String get markAsUnreadLabel => '标记为未读';

  @override
  String unreadCountIndicatorLabel({required int unreadCount}) {
    return '$unreadCount 条未读';
  }


}

