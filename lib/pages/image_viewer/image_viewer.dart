import 'dart:typed_data';

import 'package:fluffychat/pages/forward/forward.dart';
import 'package:fluffychat/pages/image_viewer/image_viewer_view.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/event_extension.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';

class ImageViewer extends StatefulWidget {
  final Event event;
  final Uint8List? imageData;
  final String? filePath;

  const ImageViewer(
    this.event, {
    Key? key,
    this.imageData,
    this.filePath,
  }) : super(key: key);

  @override
  ImageViewerController createState() => ImageViewerController();
}

class ImageViewerController extends State<ImageViewer> {
  late TransformationController transformationController;
  TapDownDetails? tapDownDetails;

  final ValueNotifier<bool> showAppbarPreview = ValueNotifier(true);

  @override
  void initState() {
    super.initState();
    transformationController = TransformationController();
  }

  @override
  void dispose() {
    transformationController.dispose();
    super.dispose();
  }

  /// Forward this image to another room.
  void forwardAction() async {
    Matrix.of(context).shareContent = widget.event.content;
    await showDialog(
      context: context,
      useSafeArea: false,
      useRootNavigator: false,
      builder: (c) => const Forward(),
    );
  }

  void toggleAppbarPreview() {
    showAppbarPreview.value = !showAppbarPreview.value;
  }

  /// Save this file with a system call.
  void saveFileAction(BuildContext context) => widget.event.saveFile(context);

  /// Save this file with a system call.
  void shareFileAction(BuildContext context) => widget.event.shareFile(context);

  static const maxScaleFactor = 1.5;

  /// Go back if user swiped it away
  void onInteractionEnds(ScaleEndDetails endDetails) {
    if (PlatformInfos.usesTouchscreen == false) {
      if (endDetails.velocity.pixelsPerSecond.dy >
          MediaQuery.of(context).size.height * maxScaleFactor) {
        Navigator.of(context, rootNavigator: false).pop();
      }
    }
  }

  void onDoubleTap() {
    final position = tapDownDetails!.localPosition;

    const double scale = 3;
    final offset = Offset(
      position.dx * (1 - scale),
      position.dy * (1 - scale),
    );
    final zoomed = Matrix4.identity()
      ..translate(offset.dx, offset.dy)
      ..scale(scale);

    final value = transformationController.value.isIdentity()
        ? zoomed
        : Matrix4.identity();
    transformationController.value = value;
  }

  void onDoubleTapDown(TapDownDetails details) {
    tapDownDetails = details;
  }

  @override
  Widget build(BuildContext context) => ImageViewerView(
        this,
        imageData: widget.imageData,
        filePath: widget.filePath,
      );
}
