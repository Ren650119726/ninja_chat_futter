
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ninja_chat/model/chat.dart';


class ChatsController extends GetxController with StateMixin, GetSingleTickerProviderStateMixin{
  late EasyRefreshController refreshController;
  late ScrollController scrollController;

  var data = RxList<Chat>.empty();
  var titleOpacity = 0.0.obs;

  var online = true.obs;

  @override
  void onInit() {
    super.onInit();
    refreshController = EasyRefreshController();
    scrollController = ScrollController()
      ..addListener(() {
        //debugPrint(scrollController.offset.toString());
        // if (scrollController.offset >= 50) {
        //   titleOpacity.value = 1;
        // } else {
        //   if (titleOpacity.value != 0) {
        //     titleOpacity.value = scrollController.offset / 50;
        //   } else {
        //     titleOpacity.value = 0;
        //   }
        // }
      });
    loadData();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future loadData() async {
    await Future.delayed(const Duration(seconds: 1));
    data.clear();
    online.value = true;

    if (true) {
      Chat chat = Chat();
      chat.name = "Dream.Machine";
      chat.online = true;
      chat.msg = "Photo 😻 Love u ❤️";
      chat.timestamp = "2 min ago";
      chat.portrait = "images/img/1.png";
      chat.unread = 4;
      data.add(chat);
    }

    if (true) {
      Chat chat = Chat();
      chat.online = true;
      chat.name = "Spoony";
      chat.msg = "Hello! How are you?";
      chat.timestamp = "15 min ago";
      chat.portrait = "images/img/2.png";
      chat.unread = 99;
      data.add(chat);
    }

    if (true) {
      Chat chat = Chat();
      chat.name = "Emerson Herwitz";
      chat.msg = "Yep, it’ll be awesome. I prom...";
      chat.timestamp = "Yesterday";
      chat.portrait = "images/img/3.jpg";
      chat.unread = 6;
      chat.online = true;
      data.add(chat);
    }

    if (true) {
      Chat chat = Chat();
      chat.name = "Dulce Bator";
      chat.msg = "Bye!";
      chat.timestamp = "Feb 22";
      chat.portrait = "images/img/4.jpg";
      chat.unread = 20;
      data.add(chat);
    }

    if (true) {
      Chat chat = Chat();
      chat.name = "Giana Torff";
      chat.msg = "hot stuff here 🔥ui8.net";
      chat.timestamp = "Feb 16";
      chat.portrait = "images/img/5.jpg";
      data.add(chat);
    }

    if (true) {
      Chat chat = Chat();
      chat.name = "Livia Herwitz";
      chat.msg = "hot stuff here 🔥ui8.net";
      chat.timestamp = "Feb 9";
      chat.portrait = "images/img/6.jpg";
      data.add(chat);
    }

    if (true) {
      Chat chat = Chat();
      chat.name = "Audio message";
      chat.msg = "😱😱😱";
      chat.timestamp = "Feb 2";
      chat.online = true;
      chat.portrait = "images/img/7.png";
      data.add(chat);
    }

    if (true) {
      Chat chat = Chat();
      chat.name = "❤️ Ruben Dias ❤️";
      chat.timestamp = "Jan 27";
      chat.msg = "just a sec";
      chat.portrait = "images/img/8.png";
      data.add(chat);
    }

    if (true) {
      Chat chat = Chat();
      chat.name = "Emerson Herwitz";
      chat.timestamp = "Jan 16";
      chat.online = true;
      chat.msg = "😲😲😲";
      chat.portrait = "images/img/9.jpg";
      data.add(chat);
    }

    if (true) {
      Chat chat = Chat();
      chat.name = "Aspen Last";
      chat.timestamp = "Jan 5";
      chat.msg = "look at this photo";
      chat.portrait = "images/img/10.jpg";
      data.add(chat);
    }
    if (true) {
      Chat chat = Chat();
      chat.name = "Aspen Last";
      chat.timestamp = "Jan 5";
      chat.msg = "look at this photo";
      chat.portrait = "images/img/10.jpg";
      data.add(chat);
    }
    if (true) {
      Chat chat = Chat();
      chat.name = "Aspen Last";
      chat.timestamp = "Jan 5";
      chat.msg = "look at this photo";
      chat.portrait = "images/img/10.jpg";
      data.add(chat);
    }
    if (true) {
      Chat chat = Chat();
      chat.name = "Aspen Last";
      chat.timestamp = "Jan 5";
      chat.msg = "look at this photo";
      chat.portrait = "images/img/10.jpg";
      data.add(chat);
    }

    change(null, status: RxStatus.success());
  }

 


}