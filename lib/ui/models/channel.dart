import 'package:collection/collection.dart';
import 'package:ninja_chat/ui/models/user.dart';
import 'package:rxdart/rxdart.dart';

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
  WKUIConversationMsg? conversation;
  late Client client;

  Conversation({
    this.conversation,
    required this.client,
  });

  bool get isMuted => conversation?.wkChannel?.mute == 1;

  final _muteController = BehaviorSubject<bool>();

  set muted(bool value) {
    _muteController.add(value);
  }

  Stream<bool> get isMutedStream => _muteController.stream;

  final _conversationStateController = BehaviorSubject<Channel>();

  set conversationState(Channel value) {
    _conversationStateController.add(value);
  }

  get channelStateStream => _conversationStateController.stream;

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
}
