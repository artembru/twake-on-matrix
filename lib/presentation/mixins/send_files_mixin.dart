import 'package:file_picker/file_picker.dart';
import 'package:fluffychat/di/global/get_it_initializer.dart';
import 'package:fluffychat/domain/model/extensions/platform_file/platform_file_extension.dart';
import 'package:fluffychat/domain/model/extensions/xfile_extension.dart';
import 'package:fluffychat/domain/usecase/send_file_interactor.dart';
import 'package:fluffychat/domain/usecase/send_images_interactor.dart';
import 'package:fluffychat/pages/chat/chat_actions.dart';
import 'package:fluffychat/presentation/model/file/file_asset_entity.dart';
import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/images_picker/images_picker.dart';
import 'package:file_selector/file_selector.dart';
import 'package:matrix/matrix.dart';
import 'package:path_provider/path_provider.dart';

mixin SendFilesMixin {
  Future<void> sendMedia(
    ImagePickerGridController imagePickerController, {
    String? caption,
    Room? room,
  }) async {
    if (room == null) {
      return;
    }
    final selectedAssets = imagePickerController.sortedSelectedAssets;
    final sendMediaInteractor = getIt.get<SendMediaInteractor>();
    await sendMediaInteractor.execute(
      room: room,
      caption: caption,
      entities: selectedAssets.map<FileAssetEntity>((entity) {
        return FileAssetEntity.createAssetEntity(entity.asset);
      }).toList(),
    );
  }

  void sendFileAction(
    BuildContext context, {
    Room? room,
    List<FileInfo>? fileInfos,
  }) async {
    if (room == null) {}
    final sendFileInteractor = getIt.get<SendFileInteractor>();
    Navigator.pop(context);
    final result = await FilePicker.platform.pickFiles(
      withReadStream: true,
      allowMultiple: true,
    );
    final temporaryDirectory = await getTemporaryDirectory();
    fileInfos ??= result?.files
        .map(
          (xFile) => FileInfo.fromMatrixFile(
            xFile.toMatrixFileOnMobile(
              temporaryDirectoryPath: temporaryDirectory.path,
            ),
          ),
        )
        .toList();

    if (fileInfos == null || fileInfos.isEmpty == true) return;

    sendFileInteractor.execute(room: room!, fileInfos: fileInfos);
  }

  Future<List<MatrixFile>> pickFilesFromSystem() async {
    final result = await FilePicker.platform.pickFiles(
      withData: false,
      allowMultiple: true,
      withReadStream: true,
    );
    if (result == null || result.files.isEmpty) return [];
    return result.files.map((file) => file.toMatrixFileOnWeb()).toList();
  }

  Future<List<MatrixFile>> pickFilesFromDesktop() async {
    final String initialDirectory =
        (await getApplicationDocumentsDirectory()).path;
    final List<XFile> xFiles =
        await openFiles(initialDirectory: initialDirectory);

    if (xFiles.isEmpty) return [];

    final matrixFiles = <MatrixFile>[];

    for (final xFile in xFiles) {
      final matrixFile = await xFile.toMatrixFile();
      matrixFiles.add(matrixFile);
    }

    return matrixFiles;
  }

  void onPickerTypeClick({
    required BuildContext context,
    Room? room,
    required PickerType type,
  }) async {
    switch (type) {
      case PickerType.gallery:
        break;
      case PickerType.documents:
        sendFileAction(context, room: room);
        break;
      case PickerType.location:
        break;
      case PickerType.contact:
        break;
    }
  }
}
