import 'dart:io';

import 'package:ninja_chat/model/member.dart';
import 'package:ninja_chat/ui/entity/conversation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wukongimfluttersdk/common/options.dart';
import 'package:wukongimfluttersdk/entity/channel_member.dart';
import 'package:wukongimfluttersdk/entity/conversation.dart';
import 'package:wukongimfluttersdk/wkim.dart';

import '../model/user.dart';
import 'http_client.dart';

const api = "https://api.githubim.com";

var currentUser = User(uid: '333', name: '333',online: true,avatar: 'https://q9.itc.cn/q_70/images03/20240423/cd1a8cb841594416a20f21b49c784647.jpeg');

class WKIMUtils {
  late String apiURL;

  late WKIM wKim;

  WKIMUtils(String apiURL) {
    if (apiURL.isNotEmpty) {
      apiURL = api;
      this.apiURL = apiURL;
      WKHttpClient.apiURL = apiURL;
    }
  }

  Future<bool> initIM(String uid, String token) async {
    bool result = await WKIM.shared.setup(Options.newDefault(uid, token));
    WKIM.shared.options.getAddr = (Function(String address) complete) async {
      String ip = await WKHttpClient.getIP();
      complete(ip);
    };
    wKim = WKIM.shared;
    if (result) {
      WKIM.shared.connectionManager.connect();
    }
    return result;
  }

  static Future<String> getMemberName(
      String channelID, int channelType, String uid) async {
    var wkChannelMember = await WKIM.shared.channelMemberManager
        .getMember(channelID, channelType, uid);
    if (wkChannelMember == null) {
      return "";
    }
    return wkChannelMember.memberName;
  }
}
