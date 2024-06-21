// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_mute.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChannelMute _$ChannelMuteFromJson(Map<String, dynamic> json) => ChannelMute(
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      channel: ChannelModel.fromJson(json['channel'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      expires: json['expires'] == null
          ? null
          : DateTime.parse(json['expires'] as String),
    );
