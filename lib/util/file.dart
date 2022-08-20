/*
 * 上应小风筝  便利校园，一步到位
 * Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
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

  static Future<String?> pickImageByFilePicker() async {
    final pfs = await pickFiles(
      dialogTitle: '选择图片',
      type: FileType.image,
    );

    return pfs != null && pfs.isNotEmpty ? pfs[0] : null;
  }

  static Future<List<String>> pickImagesByFilePicker() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? images = await picker.pickMultiImage();

    if (images != null) {
      return images.map((e) => e.path).toList();
    }
    return [];
  }

  static Future<XFile?> pickImageByImagePicker() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    return image;
  }

  static Future<List<String>?> pickFiles({
    String? dialogTitle,
    String? initialDirectory,
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    bool allowMultiple = false,
  }) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      dialogTitle: dialogTitle,
      initialDirectory: initialDirectory,
      type: type,
      allowedExtensions: allowedExtensions,
      allowMultiple: allowMultiple,
    );

    if (result == null) return null;
    return result.files //
        .map((e) => e.path) // 获取路径
        .where((e) => e != null) // 过滤掉所有的null
        .map((e) => e!) // 强制String?转String
        .toList(); // 输出列表
  }
}
