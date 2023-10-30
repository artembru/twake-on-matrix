import 'package:fluffychat/widgets/twake_components/twake_icon_button.dart';
import 'package:fluffychat/widgets/video_player.dart';
import 'package:fluffychat/widgets/video_viewer_style.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';
import 'package:media_kit_video/media_kit_video.dart';

class VideoViewerDesktopTheme extends StatelessWidget {
  const VideoViewerDesktopTheme({
    super.key,
    required this.event,
  });

  final Event? event;

  @override
  Widget build(BuildContext context) {
    return MaterialDesktopVideoControlsTheme(
      normal: MaterialDesktopVideoControlsThemeData(
        topButtonBar: [
          TwakeIconButton(
            tooltip: L10n.of(context)!.back,
            icon: Icons.close,
            onTap: () => context.pop(),
            iconColor: Theme.of(context).colorScheme.surface,
          ),
        ],
        seekBarColor: Theme.of(context).colorScheme.onSurfaceVariant,
        seekBarPositionColor: Theme.of(context).colorScheme.primary,
        seekBarHeight: VideoViewerStyle.seekBarHeight,
        seekBarThumbColor: Theme.of(context).colorScheme.primary,
      ),
      fullscreen: MaterialDesktopVideoControlsThemeData(
        seekBarColor: Theme.of(context).colorScheme.onSurfaceVariant,
        seekBarPositionColor: Theme.of(context).colorScheme.primary,
        seekBarHeight: VideoViewerStyle.seekBarHeight,
        seekBarThumbColor: Theme.of(context).colorScheme.primary,
      ),
      child: VideoPlayer(
        event: event,
      ),
    );
  }
}
