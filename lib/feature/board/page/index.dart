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

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:kite/component/future_builder.dart';
import 'package:kite/feature/board/init.dart';
import 'package:kite/feature/board/service.dart';
import 'package:kite/util/file.dart';
import 'package:kite/util/kite_authorization.dart';
import 'package:kite/util/logger.dart';
import 'package:kite/util/user.dart';

import '../entity.dart';

class BoardPage extends StatelessWidget {
  final BoardService boardService = BoardInitializer.boardServiceDao;
  BoardPage({Key? key}) : super(key: key);

  Widget buildView(List<PictureSummary> pictures) {
    return GridView(
      gridDelegate: SliverWovenGridDelegate.count(
        crossAxisCount: 2,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
        pattern: [
          const WovenGridTile(1),
          const WovenGridTile(
            13 / 16,
            crossAxisRatio: 0.9,
            alignment: AlignmentDirectional.center,
          ),
        ],
      ),
      children: pictures.map((e) {
        return Column(
          children: [
            Text(e.id),
            Text(e.publisher),
            Text(e.ts),
            Image.network(e.thumbnail),
          ],
        );
      }).toList(),
    );
  }

  Future<void> onUploadPicture(BuildContext context) async {
    // 如果用户未同意过, 请求用户确认
    if (!await signUpIfNecessary(context, '标识图片上传者')) return;

    try {
      final String? imagePath = await FileUtils.pickImageByFilePicker();
      if (imagePath == null) return;
      final multipartFile = await MultipartFile.fromFile(
        imagePath,
        filename: imagePath.split(Platform.pathSeparator).last,
      );
      EasyLoading.show(status: '正在上传');
      await boardService.submitPicture('Snapshot', multipartFile);
      EasyLoading.showSuccess('上传成功');
    } catch (e) {
      Log.info(e);
      EasyLoading.showError('上传失败');
    } finally {
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool showUpload = AccountUtils.getUserType() != UserType.freshman;

    return Scaffold(
      appBar: AppBar(
        title: const Text('风景墙'),
      ),
      floatingActionButton: showUpload
          ? FloatingActionButton(
              onPressed: () => onUploadPicture(context),
              child: const Icon(Icons.upload),
            )
          : null,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
        child: MyFutureBuilder<List<PictureSummary>>(
          future: boardService.getPictureList(),
          builder: (ctx, data) {
            return buildView(data);
          },
        ),
      ),
    );
  }
}
