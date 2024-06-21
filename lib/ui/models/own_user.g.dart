// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'own_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OwnUser _$OwnUserFromJson(Map<String, dynamic> json) => OwnUser(
      devices: (json['devices'] as List<dynamic>?)
              ?.map((e) => Device.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      mutes: (json['mutes'] as List<dynamic>?)
              ?.map((e) => Mute.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      totalUnreadCount: (json['totalUnreadCount'] as num?)?.toInt() ?? 0,
      unreadChannels: (json['unreadChannels'] as num?)?.toInt() ?? 0,
      channelMutes: (json['channelMutes'] as List<dynamic>?)
              ?.map((e) => ChannelMute.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      id: json['id'] as String,
      role: json['role'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      lastActive: json['lastActive'] == null
          ? null
          : DateTime.parse(json['lastActive'] as String),
      online: json['online'] as bool? ?? false,
      extraData: json['extraData'] as Map<String, dynamic>? ?? const {},
      banned: json['banned'] as bool? ?? false,
      banExpires: json['banExpires'] == null
          ? null
          : DateTime.parse(json['banExpires'] as String),
      teams:
          (json['teams'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      language: json['language'] as String?,
    );
