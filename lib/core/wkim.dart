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

var currentUser = User(uid: '1', name: 'user1');

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
