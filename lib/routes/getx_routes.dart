import 'package:get/get.dart';
import 'package:ninja_chat/overwrite/pages/chat/chat_page.dart';
import 'package:ninja_chat/overwrite/pages/conversation/conversation_page.dart';
import 'package:ninja_chat/overwrite/pages/login/login/login_page.dart';
import 'package:ninja_chat/routes/routes.dart';

List<GetPage> routers = [
  GetPage(
    name: Routes.LOGIN.path,
    page: () => const LoginPage(),
  ),
  GetPage(
    name: Routes.CONVERSATION_PAGE.path,
    page: () => const ConversationPage(),
  ),
  GetPage(
    name: Routes.CHAT_PAGE.path,
    page: () => ChatPage(),
  ),
];
