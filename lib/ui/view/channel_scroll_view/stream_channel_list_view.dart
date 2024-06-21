import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ninja_chat/ui/utils/extensions.dart';

import '../../core/stream_channel_list_controller.dart';
import '../../entity/conversation.dart';
import '../../misc/stream_svg_icon.dart';
import '../../theme/stream_chat_theme.dart';
import '../paged/paged_value_scroll_view.dart';
import '../stream_scroll_view_empty_widget.dart';
import '../stream_scroll_view_error_widget.dart';
import '../stream_scroll_view_indexed_widget_builder.dart';
import '../stream_scroll_view_load_more_error.dart';
import '../stream_scroll_view_load_more_indicator.dart';
import '../stream_scroll_view_loading_widget.dart';
import 'stream_channel_list_tile.dart';

Widget defaultChannelListViewSeparatorBuilder<T>(
    BuildContext context,
    List<WKUIConversationMsg> items,
    int index,
    ) =>
    const StreamChannelListSeparator();

typedef StreamChannelListViewIndexedWidgetBuilder
= StreamScrollViewIndexedWidgetBuilder<WKUIConversationMsg, StreamChannelListTile>;

class StreamChannelListView<T> extends StatelessWidget {
  const StreamChannelListView({
    Key? key,
    this.itemBuilder,
    required this.controller,
    this.separatorBuilder = defaultChannelListViewSeparatorBuilder,
    this.emptyBuilder,
    this.loadingBuilder,
    this.errorBuilder,
    this.onChannelTap,
    this.onChannelLongPress,
    this.loadMoreTriggerIndex = 3,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.scrollController,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
    this.padding,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.cacheExtent,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
  });
  final StreamChannelListController controller;
  final StreamChannelListViewIndexedWidgetBuilder? itemBuilder;
  final PagedValueScrollViewIndexedWidgetBuilder<WKUIConversationMsg> separatorBuilder;
  final WidgetBuilder? emptyBuilder;
  final WidgetBuilder? loadingBuilder;
  final Widget Function(BuildContext, Exception)? errorBuilder;
  final void Function(T)? onChannelTap;
  final void Function(T)? onChannelLongPress;
  final int loadMoreTriggerIndex;
  final Axis scrollDirection;
  final EdgeInsetsGeometry? padding;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final bool reverse;
  final ScrollController? scrollController;
  final bool? primary;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final double? cacheExtent;
  final DragStartBehavior dragStartBehavior;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;
  final String? restorationId;
  final Clip clipBehavior;


  @override
  Widget build(BuildContext context) {
    return PagedValueListView<int, WKUIConversationMsg>(
      scrollDirection: scrollDirection,
      padding: padding,
      physics: physics,
      reverse: reverse,
      controller: controller,
      scrollController: scrollController,
      primary: primary,
      shrinkWrap: shrinkWrap,
      addAutomaticKeepAlives: addAutomaticKeepAlives,
      addRepaintBoundaries: addRepaintBoundaries,
      addSemanticIndexes: addSemanticIndexes,
      keyboardDismissBehavior: keyboardDismissBehavior,
      restorationId: restorationId,
      dragStartBehavior: dragStartBehavior,
      cacheExtent: cacheExtent,
      clipBehavior: clipBehavior,
      loadMoreTriggerIndex: loadMoreTriggerIndex,
      separatorBuilder: separatorBuilder,
      itemBuilder: (context, channels, index) {
        //每条会话
        final channel = channels[index];
        final onTap = onChannelTap;
        final onLongPress = onChannelLongPress;

        final streamChannelListTile = StreamChannelListTile(
          channel: channel,
          onTap: onTap == null ? null : () => onTap(channel),
          onLongPress: onLongPress == null ? null : () => onLongPress(channel),
        );

        return itemBuilder?.call(
          context,
          channels,
          index,
          streamChannelListTile,
        ) ??
            streamChannelListTile;
      },
      emptyBuilder: (context) {
        final chatThemeData = StreamChatTheme.of(context);
        return emptyBuilder?.call(context) ??
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: StreamScrollViewEmptyWidget(
                  emptyIcon: StreamSvgIcon.message(
                    size: 148,
                    color: chatThemeData.colorTheme.disabled,
                  ),
                  emptyTitle: Text(
                    context.translations.letsStartChattingLabel,
                    style: chatThemeData.textTheme.headline,
                  ),
                ),
              ),
            );
      },
      loadMoreErrorBuilder: (context, error) =>
          StreamScrollViewLoadMoreError.list(
            onTap: controller.retry,
            error: Text(context.translations.loadingChannelsError),
          ),
      loadMoreIndicatorBuilder: (context) => const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: StreamScrollViewLoadMoreIndicator(),
        ),
      ),
      loadingBuilder: (context) =>
      loadingBuilder?.call(context) ??
          const Center(
            child: StreamScrollViewLoadingWidget(),
          ),
      errorBuilder: (context, error) =>
      errorBuilder?.call(context, error) ??
          Center(
            child: StreamScrollViewErrorWidget(
              errorTitle: Text(context.translations.loadingChannelsError),
              onRetryPressed: controller.refresh,
            ),
          ),
    );
  }
}

class StreamChannelListSeparator extends StatelessWidget {
  const StreamChannelListSeparator({Key? key});

  @override
  Widget build(BuildContext context) {
    final effect = StreamChatTheme.of(context).colorTheme.borderBottom;
    return Container(
      height: 1,
      color: effect.color!.withOpacity(effect.alpha ?? 1.0),
    );
  }
}
