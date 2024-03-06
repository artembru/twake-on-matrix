import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluffychat/di/global/get_it_initializer.dart';
import 'package:fluffychat/domain/model/extensions/platform_file/platform_file_extension.dart';
import 'package:fluffychat/domain/usecase/send_file_interactor.dart';
import 'package:fluffychat/domain/usecase/send_images_interactor.dart';
import 'package:fluffychat/pages/chat/chat_actions.dart';
import 'package:fluffychat/presentation/model/file/file_asset_entity.dart';
import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/images_picker/images_picker.dart';
import 'package:matrix/matrix.dart';
import 'package:path_provider/path_provider.dart';

mixin SendFilesMixin {
  Future<void> sendMedia(
    ImagePickerGridController imagePickerController, {
    String? caption,
    Room? room,
    CancelToken? cancelToken,
  }) async {
    if (room == null) {
      return;
    }
    final selectedAssets = imagePickerController.sortedSelectedAssets;
    final sendMediaInteractor = getIt.get<SendMediaInteractor>();
    await sendMediaInteractor.execute(
      room: room,
      caption: caption,
      cancelToken: cancelToken,
      entities: selectedAssets.map<FileAssetEntity>((entity) {
        return FileAssetEntity.createAssetEntity(entity.asset);
      }).toList(),
    );
  }

  void sendFileAction(
    BuildContext context, {
    Room? room,
    List<FileInfo>? fileInfos,
    CancelToken? cancelToken,
  }) async {
    if (room == null) {}
    final sendFileInteractor = getIt.get<SendFileInteractor>();
    Navigator.pop(context);
    final result = await FilePicker.platform.pickFiles(
      withReadStream: true,
    );
    fileInfos ??= result?.files
        .map(
          (xFile) => FileInfo(
            xFile.name,
            xFile.path ?? '${getTemporaryDirectory()}/${xFile.name}',
            xFile.size,
            readStream: xFile.readStream,
          ),
        )
        .toList();

    if (fileInfos == null || fileInfos.isEmpty == true) return;

    sendFileInteractor.execute(
      room: room!,
      fileInfos: fileInfos,
      cancelToken: cancelToken,
    );
  }

  Future<List<MatrixFile>> pickFilesFromSystem() async {
    final result = await FilePicker.platform.pickFiles(
      withData: false,
      allowMultiple: true,
      withReadStream: true,
    );
    if (result == null || result.files.isEmpty) return [];
    return result.files.map((file) => file.toMatrixFile()).toList();
  }

  void onPickerTypeClick({
    required BuildContext context,
    Room? room,
    required PickerType type,
    CancelToken? cancelToken,
  }) async {
    switch (type) {
      case PickerType.gallery:
        break;
      case PickerType.documents:
        sendFileAction(
          context,
          room: room,
          cancelToken: cancelToken,
        );
        break;
      case PickerType.location:
        break;
      case PickerType.contact:
        break;
    }
  }
}
