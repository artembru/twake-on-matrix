import 'package:fluffychat/pages/chat_details/chat_details_page_view/chat_details_page_enum.dart';
import 'package:fluffychat/pages/chat_details/chat_details_page_view/files/chat_details_files_page.dart';
import 'package:fluffychat/pages/chat_details/chat_details_page_view/links/chat_details_links_page.dart';
import 'package:fluffychat/pages/chat_details/chat_details_page_view/media/chat_details_media_page.dart';
import 'package:fluffychat/pages/chat_profile_info/chat_profile_info_shared/chat_profile_info_shared_view.dart';
import 'package:fluffychat/presentation/mixins/handle_video_download_mixin.dart';
import 'package:fluffychat/presentation/mixins/play_video_action_mixin.dart';
import 'package:fluffychat/presentation/model/chat_details/chat_details_page_model.dart';
import 'package:fluffychat/presentation/same_type_events_builder/same_type_events_controller.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/event_extension.dart';
import 'package:fluffychat/utils/scroll_controller_extension.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';

class ChatProfileInfoShared extends StatefulWidget {
  final String roomId;
  final VoidCallback? closeRightColumn;

  const ChatProfileInfoShared({
    super.key,
    required this.roomId,
    this.closeRightColumn,
  });

  @override
  State<ChatProfileInfoShared> createState() =>
      ChatProfileInfoSharedController();
}

class ChatProfileInfoSharedController extends State<ChatProfileInfoShared>
    with
        HandleVideoDownloadMixin,
        PlayVideoActionMixin,
        SingleTickerProviderStateMixin {
  static const _mediaFetchLimit = 20;

  static const _linksFetchLimit = 20;

  static const _filesFetchLimit = 20;

  SameTypeEventsBuilderController? mediaListController;

  SameTypeEventsBuilderController? linksListController;

  SameTypeEventsBuilderController? filesListController;

  TabController? tabController;

  Timeline? _timeline;

  final GlobalKey<NestedScrollViewState> nestedScrollViewState = GlobalKey();

  final List<ChatDetailsPage> profileSharedPageView = [
    ChatDetailsPage.media,
    ChatDetailsPage.links,
    ChatDetailsPage.files,
  ];

  Future<Timeline> getTimeline() async {
    _timeline ??= await room!.getTimeline();
    return _timeline!;
  }

  Room? get room => Matrix.of(context).client.getRoomById(widget.roomId);

  List<ChatDetailsPageModel> profileSharedPages() => profileSharedPageView.map(
        (page) {
          switch (page) {
            case ChatDetailsPage.media:
              return ChatDetailsPageModel(
                page: page,
                child: mediaListController == null
                    ? const SizedBox()
                    : ChatDetailsMediaPage(
                        key: const PageStorageKey(
                          'ChatProfileInfoSharedMedia',
                        ),
                        controller: mediaListController!,
                        handleDownloadVideoEvent: _handleDownloadAndPlayVideo,
                        closeRightColumn: widget.closeRightColumn,
                      ),
              );
            case ChatDetailsPage.links:
              return ChatDetailsPageModel(
                page: page,
                child: linksListController == null
                    ? const SizedBox()
                    : ChatDetailsLinksPage(
                        key: const PageStorageKey(
                          'ChatProfileInfoSharedLinks',
                        ),
                        controller: linksListController!,
                      ),
              );
            case ChatDetailsPage.files:
              return ChatDetailsPageModel(
                page: page,
                child: filesListController == null
                    ? const SizedBox()
                    : ChatDetailsFilesPage(
                        key: const PageStorageKey(
                          'ChatProfileInfoSharedFiles',
                        ),
                        controller: filesListController!,
                      ),
              );
            default:
              return ChatDetailsPageModel(
                page: page,
                child: const SizedBox(),
              );
          }
        },
      ).toList();

  Future<String> _handleDownloadAndPlayVideo(Event event) {
    return handleDownloadVideoEvent(
      event: event,
      playVideoAction: (path) => playVideoAction(
        context,
        path,
        event: event,
      ),
    );
  }

  void _listenerInnerController() {
    Logs().d("ChatDetails::currentTab - ${tabController?.index}");
    if (nestedScrollViewState.currentState?.innerController.shouldLoadMore ==
            true &&
        tabController?.index != null) {
      switch (profileSharedPageView[tabController!.index]) {
        case ChatDetailsPage.media:
          mediaListController?.loadMore();
          break;
        case ChatDetailsPage.links:
          linksListController?.loadMore();
          break;
        case ChatDetailsPage.files:
          filesListController?.loadMore();
          break;
        default:
          break;
      }
    }
  }

  void _refreshDataInTabviewInit() {
    linksListController?.refresh();
    mediaListController?.refresh();
    filesListController?.refresh();
  }

  @override
  void initState() {
    tabController = TabController(
      length: profileSharedPageView.length,
      vsync: this,
    );
    mediaListController = SameTypeEventsBuilderController(
      getTimeline: getTimeline,
      searchFunc: (event) => event.isVideoOrImage,
      limit: _mediaFetchLimit,
    );
    linksListController = SameTypeEventsBuilderController(
      getTimeline: getTimeline,
      searchFunc: (event) => event.isContainsLink,
      limit: _linksFetchLimit,
    );
    filesListController = SameTypeEventsBuilderController(
      getTimeline: getTimeline,
      searchFunc: (event) => event.isAFile,
      limit: _filesFetchLimit,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      nestedScrollViewState.currentState?.innerController.addListener(
        _listenerInnerController,
      );
      _refreshDataInTabviewInit();
    });
    super.initState();
  }

  @override
  void dispose() {
    tabController?.dispose();
    mediaListController?.dispose();
    linksListController?.dispose();
    filesListController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChatProfileInfoSharedView(
      controller: this,
    );
  }
}
