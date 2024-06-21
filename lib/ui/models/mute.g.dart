// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mute.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Mute _$MuteFromJson(Map<String, dynamic> json) => Mute(
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      target: User.fromJson(json['target'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      expires: json['expires'] == null
          ? null
          : DateTime.parse(json['expires'] as String),
    );
