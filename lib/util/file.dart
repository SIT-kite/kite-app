import 'dart:io';

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'logger.dart';
import 'permission.dart';

class FileUtils {
  static Future<void> writeToFile({
    required dynamic content,
    required String filepath,
  }) async {
    final isPermissionGranted = await ensurePermission(Permission.storage);
    if (!isPermissionGranted) {
      throw '无写入文件权限';
    }

    final file = File(filepath);

    if (!await file.exists()) {
      await file.create(recursive: true);
    }
    if (content is String) {
      await file.writeAsString(content);
    } else {
      await file.writeAsBytes(content);
    }
  }

  static Future<void> writeToTempFileAndOpen({
    required dynamic content,
    required String filename,
    required String type,
  }) async {
    final path = '${(await getTemporaryDirectory()).path}/$filename';
    await writeToFile(content: content, filepath: path);
    Log.info('保存文件$filename到 $path');
    OpenFile.open(path, type: type);
  }
}
