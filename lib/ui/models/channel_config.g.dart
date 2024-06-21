// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChannelConfig _$ChannelConfigFromJson(Map<String, dynamic> json) =>
    ChannelConfig(
      automod: json['automod'] as String? ?? 'flag',
      commands: (json['commands'] as List<dynamic>?)
              ?.map((e) => Command.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      connectEvents: json['connectEvents'] as bool? ?? false,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      maxMessageLength: (json['maxMessageLength'] as num?)?.toInt() ?? 0,
      messageRetention: json['messageRetention'] as String? ?? '',
      mutes: json['mutes'] as bool? ?? false,
      reactions: json['reactions'] as bool? ?? false,
      readEvents: json['readEvents'] as bool? ?? false,
      replies: json['replies'] as bool? ?? false,
      search: json['search'] as bool? ?? false,
      typingEvents: json['typingEvents'] as bool? ?? false,
      uploads: json['uploads'] as bool? ?? false,
      urlEnrichment: json['urlEnrichment'] as bool? ?? false,
    );

Map<String, dynamic> _$ChannelConfigToJson(ChannelConfig instance) =>
    <String, dynamic>{
      'automod': instance.automod,
      'commands': instance.commands,
      'connectEvents': instance.connectEvents,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'maxMessageLength': instance.maxMessageLength,
      'messageRetention': instance.messageRetention,
      'mutes': instance.mutes,
      'reactions': instance.reactions,
      'readEvents': instance.readEvents,
      'replies': instance.replies,
      'search': instance.search,
      'typingEvents': instance.typingEvents,
      'uploads': instance.uploads,
      'urlEnrichment': instance.urlEnrichment,
    };
