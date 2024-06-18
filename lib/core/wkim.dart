import 'dart:io';

import 'package:rxdart/rxdart.dart';
import 'package:wukongimfluttersdk/common/options.dart';
import 'package:wukongimfluttersdk/wkim.dart';

import 'http_client.dart';

const api = "https://api.githubim.com";

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




}
