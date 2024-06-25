import 'package:ninja_chat/model/user.dart';

class Member {
  String uid;
  String groupNo;
  String name;
  String remark;
  int role;
  int version;
  int isDeleted;
  int status;
  String vercode;
  String inviteUid;
  int robot;
  int forbiddenExpirTime;
  String avatar;

  Member({
    required this.uid,
    required this.groupNo,
    required this.name,
    required this.remark,
    required this.role,
    required this.version,
    required this.isDeleted,
    required this.status,
    required this.vercode,
    required this.inviteUid,
    required this.robot,
    required this.forbiddenExpirTime,
    required this.avatar,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      uid: json['uid'] ?? '',
      groupNo: json['group_no'] ?? '',
      name: json['name'] ?? '',
      remark: json['remark'] ?? '',
      role: json['role'] ?? 0,
      version: json['version'] ?? 0,
      isDeleted: json['is_deleted'] ?? 0,
      status: json['status'] ?? 0,
      vercode: json['vercode'] ?? '',
      inviteUid: json['invite_uid'] ?? '',
      robot: json['robot'] ?? 0,
      forbiddenExpirTime: json['forbidden_expir_time'] ?? 0,
      avatar: json['avatar'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['group_no'] = this.groupNo;
    data['name'] = this.name;
    data['remark'] = this.remark;
    data['role'] = this.role;
    data['version'] = this.version;
    data['is_deleted'] = this.isDeleted;
    data['status'] = this.status;
    data['vercode'] = this.vercode;
    data['invite_uid'] = this.inviteUid;
    data['robot'] = this.robot;
    data['forbidden_expir_time'] = this.forbiddenExpirTime;
    data['avatar'] = this.avatar;
    return data;
  }

  //member转成user
  User toUser() {
    return User(
      uid: uid,
      name: name,
      avatar: avatar,
    );
  }
}
