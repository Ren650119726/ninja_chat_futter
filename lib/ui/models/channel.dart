import 'package:collection/collection.dart';
import 'package:ninja_chat/ui/models/user.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wukongimfluttersdk/entity/msg.dart';

import '../client.dart';
import '../entity/conversation.dart';
import 'member.dart';
import 'own_user.dart';

class Channel {
  String? id;
  String? name;
  String? image;
  String? description;
  String? url;
  String? category;
  String? language;
  String? country;
  String? urls;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  //频道成员，包含单聊、群聊
  List<Member>? members;

  Channel({
    this.id,
    this.name,
    this.image,
    this.description,
    this.url,
    this.category,
    this.language,
    this.country,
    this.urls,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.members,
  });
}

class Conversation {
  WKConversation? wkConversation;
  late Client client;

  Conversation({
    this.wkConversation,
    required this.client,
  }) {
    if (wkConversation != null) {
      _conversationStateController.add(wkConversation!);
      if (wkConversation?.wkChannel?.mute == 1) {
        _muteController.add(true);
      }
    }
  }

  bool get isMuted => wkConversation?.wkChannel?.mute == 1;

  final _muteController = BehaviorSubject<bool>.seeded(false);

  Stream<bool> get isMutedStream => _muteController.stream;

  final _conversationStateController = BehaviorSubject<WKConversation>();

  WKConversation get _channelState => _conversationStateController.value;

  get channelStateStream => _conversationStateController.stream;

  List<Member> get members => (_channelState.members ?? <Member>[])
      .map((e) => e.copyWith(user: client.state.currentUser))
      .toList();

  Stream<List<Member>> get membersStream => CombineLatestStream.combine2<
      List<Member?>?, User?, List<Member>>(
    channelStateStream.map((cs) => cs.members),
    client.state.currentUserStream,
        (members, currentUser) {
      final usersMap = {currentUser?.id: currentUser};
      return members
          ?.where((member) => member != null && usersMap.containsKey(member.userId))
          .map((member) => member!.copyWith(user: usersMap[member.userId]))
          .toList() ??
          [];
    },
  ).distinct(const ListEquality().equals);


  /// Channel last message date.
  DateTime? get lastMessageAt {
    return DateTime.fromMillisecondsSinceEpoch(wkConversation?.wkMsg?.timestamp ?? 0);
  }

  /// Channel last message date as a stream.
  Stream<DateTime?> get lastMessageAtStream {
    return channelStateStream.map((cs) => DateTime.fromMillisecondsSinceEpoch(cs.wkMsg?.timestamp ?? 0));
  }


  /// Channel message list.
  WKMsg? get messages => _channelState.wkMsg;

  /// Channel message list as a stream.
  Stream<WKMsg> get messagesStream => channelStateStream
      .map((cs) => cs.wkMsg ?? WKMsg())
      .distinct(const ListEquality().equals);
}
