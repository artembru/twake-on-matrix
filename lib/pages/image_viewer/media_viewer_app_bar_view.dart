import 'package:fluffychat/pages/image_viewer/image_viewer_style.dart';
import 'package:fluffychat/pages/image_viewer/media_viewer_app_bar.dart';
import 'package:fluffychat/pages/image_viewer/media_viewer_app_bar_style.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/colors/linagora_sys_colors.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:fluffychat/widgets/twake_components/twake_icon_button.dart';
import 'package:fluffychat/resource/image_paths.dart';
import 'package:fluffychat/pages/image_viewer/context_menu_item_image_viewer.dart';

class MediaViewerAppbarView extends StatelessWidget {
  final MediaViewerAppBarController controller;

  const MediaViewerAppbarView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller.showAppbarPreview ?? ValueNotifier(true),
      builder: (context, showAppbarPreview, child) {
        return AnimatedOpacity(
          opacity: showAppbarPreview ? 1 : 0,
          duration: MediaViewewAppbarStyle.opacityAnimationDuration,
          curve: Curves.easeIn,
          child: Container(
            padding: showAppbarPreview
                ? ImageViewerStyle.paddingTopAppBar
                : EdgeInsets.zero,
            height: ImageViewerStyle.appBarHeight,
            width: MediaQuery.sizeOf(context).width,
            color: MediaViewewAppbarStyle.appBarBackgroundColor,
            child: showAppbarPreview
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                          MediaViewerAppBar.responsiveUtils.isMobile(context)
                              ? Icons.arrow_back_rounded
                              : Icons.close,
                          color: LinagoraSysColors.material().onPrimary,
                        ),
                        onPressed: controller.onClose,
                        color: LinagoraSysColors.material().onPrimary,
                        tooltip: L10n.of(context)!.back,
                      ),
                      Row(
                        children: [
                          if (PlatformInfos.isMobile)
                            Builder(
                              builder: (context) => IconButton(
                                onPressed: () =>
                                    controller.shareFileAction(context),
                                tooltip: L10n.of(context)!.share,
                                color: LinagoraSysColors.material().onPrimary,
                                icon: Icon(
                                  Icons.share,
                                  color: LinagoraSysColors.material().onPrimary,
                                ),
                              ),
                            ),
                          if (controller.widget.event != null)
                            IconButton(
                              icon: Icon(
                                Icons.shortcut,
                                color: LinagoraSysColors.material().onPrimary,
                              ),
                              onPressed: controller.forwardAction,
                              color: LinagoraSysColors.material().onPrimary,
                              tooltip: L10n.of(context)!.share,
                            ),
                          if (controller.widget.event != null)
                            Padding(
                              padding: MediaViewewAppbarStyle.paddingRightMenu,
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: MenuAnchor(
                                  style: const MenuStyle(
                                    alignment: Alignment.bottomRight,
                                  ),
                                  controller: controller.menuController,
                                  menuChildren: [
                                    ContextMenuItemImageViewer(
                                      icon: Icons.file_download_outlined,
                                      title: L10n.of(context)!.saveFile,
                                      onTap: controller.saveFileAction,
                                    ),
                                    ContextMenuItemImageViewer(
                                      title: L10n.of(context)!.showInChat,
                                      imagePath: ImagePaths.icShowInChat,
                                      onTap: controller.showInChat,
                                      haveDivider: false,
                                    ),
                                  ],
                                  child: InkWell(
                                    borderRadius: MediaViewewAppbarStyle
                                        .showMoreIconSplashRadius,
                                    onTap: controller.toggleShowMoreActions,
                                    child: Padding(
                                      padding: MediaViewewAppbarStyle
                                          .marginAllShowMoreIcon,
                                      child: TwakeIconButton(
                                        paddingAll: MediaViewewAppbarStyle
                                            .paddingAllShowMoreIcon,
                                        icon: Icons.more_vert,
                                        iconColor: LinagoraSysColors.material()
                                            .onPrimary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  )
                : SizedBox(width: MediaQuery.sizeOf(context).width),
          ),
        );
      },
    );
  }
}
