// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
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
      extraData: json['extraData'] as Map<String, dynamic>? ?? const {},
      online: json['online'] as bool? ?? false,
      banned: json['banned'] as bool? ?? false,
      banExpires: json['banExpires'] == null
          ? null
          : DateTime.parse(json['banExpires'] as String),
      teams:
          (json['teams'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      language: json['language'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) {
  final val = <String, dynamic>{
    'id': instance.id,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('language', instance.language);
  val['extraData'] = instance.extraData;
  return val;
}
