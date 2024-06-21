// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Member _$MemberFromJson(Map<String, dynamic> json) => Member(
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      inviteAcceptedAt: json['inviteAcceptedAt'] == null
          ? null
          : DateTime.parse(json['inviteAcceptedAt'] as String),
      inviteRejectedAt: json['inviteRejectedAt'] == null
          ? null
          : DateTime.parse(json['inviteRejectedAt'] as String),
      invited: json['invited'] as bool? ?? false,
      channelRole: json['channelRole'] as String?,
      userId: json['userId'] as String?,
      isModerator: json['isModerator'] as bool? ?? false,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      banned: json['banned'] as bool? ?? false,
      banExpires: json['banExpires'] == null
          ? null
          : DateTime.parse(json['banExpires'] as String),
      shadowBanned: json['shadowBanned'] as bool? ?? false,
    );

Map<String, dynamic> _$MemberToJson(Member instance) => <String, dynamic>{
      'user': instance.user,
      'inviteAcceptedAt': instance.inviteAcceptedAt?.toIso8601String(),
      'inviteRejectedAt': instance.inviteRejectedAt?.toIso8601String(),
      'invited': instance.invited,
      'channelRole': instance.channelRole,
      'userId': instance.userId,
      'isModerator': instance.isModerator,
      'banned': instance.banned,
      'banExpires': instance.banExpires?.toIso8601String(),
      'shadowBanned': instance.shadowBanned,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
