class User {
  String uid;
  String? token;
  String? imToken;
  String? username;
  String name;
  int? sex;
  String? category;
  String? shortNo;
  int? shortStatus;
  String? zone;
  String? phone;
  String? avatar;
  bool? online;
  String? chatPwd;
  String? lockScreenPwd;
  int? lockAfterMinute;
  UserSetting? setting;

  User({
    required this.uid,
    required this.name,
    this.token,
    this.imToken,
    this.username,
    this.sex,
    this.category,
    this.shortNo,
    this.shortStatus,
    this.zone,
    this.phone,
    this.avatar,
    this.online,
    this.chatPwd,
    this.lockScreenPwd,
    this.lockAfterMinute,
    this.setting,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['uid'] ?? '',
      token: json['token'] ?? '',
      imToken: json['im_token'] ?? '',
      username: json['username'] ?? '',
      name: json['name'] ?? '',
      sex: json['sex'] ?? 0,
      category: json['category'] ?? '',
      shortNo: json['short_no'] ?? '',
      shortStatus: json['short_status'] ?? 0,
      zone: json['zone'] ?? '',
      phone: json['phone'] ?? '',
      avatar: json['avatar'] ?? '',
      online: json['online'] ?? false,
      chatPwd: json['chat_pwd'] ?? '',
      lockScreenPwd: json['lock_screen_pwd'] ?? '',
      lockAfterMinute: json['lock_after_minute'] ?? 0,
      setting: UserSetting.fromJson(json['setting'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['token'] = this.token;
    data['im_token'] = this.imToken;
    data['username'] = this.username;
    data['name'] = this.name;
    data['sex'] = this.sex;
    data['category'] = this.category;
    data['short_no'] = this.shortNo;
    data['short_status'] = this.shortStatus;
    data['zone'] = this.zone;
    data['phone'] = this.phone;
    data['avatar'] = this.avatar;
    data['online'] = this.online;
    data['chat_pwd'] = this.chatPwd;
    data['lock_screen_pwd'] = this.lockScreenPwd;
    data['lock_after_minute'] = this.lockAfterMinute;
    data['setting'] = this.setting?.toJson();
    return data;
  }
}

class UserSetting {
  int searchByPhone;
  int searchByShort;
  int newMsgNotice;
  int msgShowDetail;
  int voiceOn;
  int shockOn;
  int deviceLock;
  int offlineProtection;

  UserSetting({
    required this.searchByPhone,
    required this.searchByShort,
    required this.newMsgNotice,
    required this.msgShowDetail,
    required this.voiceOn,
    required this.shockOn,
    required this.deviceLock,
    required this.offlineProtection,
  });

  factory UserSetting.fromJson(Map<String, dynamic> json) {
    return UserSetting(
      searchByPhone: json['search_by_phone'] ?? 0,
      searchByShort: json['search_by_short'] ?? 0,
      newMsgNotice: json['new_msg_notice'] ?? 0,
      msgShowDetail: json['msg_show_detail'] ?? 0,
      voiceOn: json['voice_on'] ?? 0,
      shockOn: json['shock_on'] ?? 0,
      deviceLock: json['device_lock'] ?? 0,
      offlineProtection: json['offline_protection'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['search_by_phone'] = this.searchByPhone;
    data['search_by_short'] = this.searchByShort;
    data['new_msg_notice'] = this.newMsgNotice;
    data['msg_show_detail'] = this.msgShowDetail;
    data['voice_on'] = this.voiceOn;
    data['shock_on'] = this.shockOn;
    data['device_lock'] = this.deviceLock;
    data['offline_protection'] = this.offlineProtection;
    return data;
  }
}
