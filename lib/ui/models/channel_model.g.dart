// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChannelModel _$ChannelModelFromJson(Map<String, dynamic> json) => ChannelModel(
      id: json['id'] as String?,
      type: json['type'] as String?,
      cid: json['cid'] as String?,
      ownCapabilities: (json['ownCapabilities'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      config: json['config'] == null
          ? null
          : ChannelConfig.fromJson(json['config'] as Map<String, dynamic>),
      createdBy: json['createdBy'] == null
          ? null
          : User.fromJson(json['createdBy'] as Map<String, dynamic>),
      frozen: json['frozen'] as bool? ?? false,
      lastMessageAt: json['lastMessageAt'] == null
          ? null
          : DateTime.parse(json['lastMessageAt'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
      memberCount: (json['memberCount'] as num?)?.toInt() ?? 0,
      extraData: json['extraData'] as Map<String, dynamic>? ?? const {},
      team: json['team'] as String?,
      cooldown: (json['cooldown'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ChannelModelToJson(ChannelModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'frozen': instance.frozen,
      'cooldown': instance.cooldown,
      'extraData': instance.extraData,
    };
