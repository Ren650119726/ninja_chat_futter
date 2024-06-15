import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ninja_chat/page/chats/chats_page.dart';
import 'package:ninja_chat/page/frame/frame_controller.dart';
import 'package:ninja_chat/styles/colors.dart';
import 'package:ninja_chat/widget/common_widget.dart';

class FramePage extends GetView<FrameController> {
  const FramePage({super.key});

  void initPage(BuildContext context) async {
    EasyRefresh.defaultHeaderBuilder = () => const ClassicHeader(
          dragText: '下拉刷新',
          armedText: '释放开始',
          readyText: '刷新中...',
          processingText: '刷新中...',
          processedText: '刷新完成',
          noMoreText: '没有更多',
          failedText: '刷新失败',
          messageText: '最后更新于 %T',
          // safeArea: true,
          // position: IndicatorPosition.locator,
        );
    EasyRefresh.defaultFooterBuilder = () => const ClassicFooter(
          dragText: '上拉加载',
          armedText: '释放开始',
          readyText: '加载中...',
          processingText: '加载中...',
          processedText: '加载完成',
          noMoreText: '没有更多',
          failedText: '加载失败',
          messageText: '最后更新于 %T',
          triggerWhenReach: false,
          triggerWhenRelease: false,
          triggerOffset: 0,
          // safeArea: false,
          // position: IndicatorPosition.locator,
        );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(FrameController());
    initPage(context);
    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.selectPageIndex.value,
          children: const [
            ChatsPage(),
            ChatsPage(),
            ChatsPage(),
          ],
        ),
      ),
      extendBody: true,
      bottomNavigationBar: getFilterWidget(
        hasColor: false,
        child: Obx(
          () => BottomNavigationBar(
            onTap: (index) {
              controller.selectPageIndex.value = index;
            },
            backgroundColor: AlColors.glassColor,
            currentIndex: controller.selectPageIndex.value,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: [
              BottomNavigationBarItem(
                activeIcon:
                    SvgPicture.asset("images/frame/frame_chat_active.svg"),
                icon: SvgPicture.asset("images/frame/frame_chat.svg"),
                label: "CHAT",
              ),
              BottomNavigationBarItem(
                activeIcon:
                    SvgPicture.asset("images/frame/frame_contacts_active.svg"),
                icon: SvgPicture.asset("images/frame/frame_contacts.svg"),
                label: "Contacts",
              ),
              BottomNavigationBarItem(
                activeIcon:
                    SvgPicture.asset("images/frame/frame_settings_active.svg"),
                icon: SvgPicture.asset("images/frame/frame_settings.svg"),
                label: "SETTING",
              )
            ],
          ),
        ),
      ),
    );
  }
}
