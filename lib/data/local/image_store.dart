import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// Keeps user-supplied images where they will still be there tomorrow.
///
/// Both the camera and the photo picker hand back a file in a cache directory
/// that the system is free to delete. A cover the user photographed has to
/// outlive that, so it is copied into the app's own documents directory and
/// only the copy is recorded.
class ImageStore {
  const ImageStore();

  static const _folder = 'covers';

  Future<Directory> _directory() async {
    final documents = await getApplicationDocumentsDirectory();
    final dir = Directory('${documents.path}/$_folder');
    if (!dir.existsSync()) await dir.create(recursive: true);
    return dir;
  }

  /// Copies [sourcePath] into the app's storage and returns the new path.
  Future<String> save(String sourcePath) async {
    final dir = await _directory();
    final extension = _extensionOf(sourcePath);
    final name = '${DateTime.now().microsecondsSinceEpoch}$extension';
    final target = '${dir.path}/$name';
    await File(sourcePath).copy(target);
    return target;
  }

  /// Deletes a stored image. Missing files are not an error — the record may
  /// simply have outlived the file.
  Future<void> delete(String? path) async {
    if (path == null || path.isEmpty) return;
    try {
      final file = File(path);
      if (file.existsSync()) await file.delete();
    } on FileSystemException {
      // Nothing to clean up.
    }
  }

  static String _extensionOf(String path) {
    final dot = path.lastIndexOf('.');
    if (dot == -1 || path.length - dot > 6) return '.jpg';
    return path.substring(dot).toLowerCase();
  }
}
