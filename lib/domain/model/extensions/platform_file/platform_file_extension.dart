import 'package:file_picker/file_picker.dart';
import 'package:matrix/matrix.dart';

extension PlatformFileListExtension on PlatformFile {
  MatrixFile toMatrixFileOnMobile({
    required String temporaryDirectoryPath,
  }) {
    return MatrixFile.fromMimeType(
      bytes: bytes,
      name: name,
      filePath: path ?? '$temporaryDirectoryPath/$name',
      readStream: readStream,
      sizeInBytes: size,
    );
  }

  MatrixFile toMatrixFileOnWeb() {
    return MatrixFile.fromMimeType(
      bytes: bytes,
      name: name,
      filePath: '',
      readStream: readStream,
      sizeInBytes: size,
    );
  }

  FileInfo toFileInfo({
    required String temporaryDirectoryPath,
  }) {
    return FileInfo(
      name,
      path ?? '$temporaryDirectoryPath/$name',
      size,
      readStream: readStream,
    );
  }
}
