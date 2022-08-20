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
import 'package:kite/feature/board/component/card.dart';
import 'package:kite/feature/board/init.dart';
import 'package:kite/feature/board/service.dart';
import 'package:kite/util/file.dart';
import 'package:kite/util/kite_authorization.dart';
import 'package:kite/util/logger.dart';
import 'package:kite/util/user.dart';

import '../entity.dart';

class BoardPage extends StatefulWidget {
  const BoardPage({Key? key}) : super(key: key);

  @override
  State<BoardPage> createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  final BoardService boardService = BoardInitializer.boardServiceDao;

  List<PictureSummary> _pictures = [];

  /// lastPage 记录下一次应该拉取的页号.
  int _lastPage = 1;

  /// 控制 "到底" 提示的显示.
  bool _atEnd = false;

  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        if (!_atEnd) {
          Log.info('Loading more pictures.');
          loadMorePicture();
        }
      } else {
        setState(() {
          _atEnd = false;
        });
      }
    });
    loadInitialPicture();
  }

  Future<void> onUploadPicture(BuildContext context) async {
    // 如果用户未同意过, 请求用户确认
    if (!await signUpIfNecessary(context, '标识图片上传者')) return;
    try {
      final List<String> imagePaths = await FileUtils.pickImagesByFilePicker();
      if (imagePaths.isEmpty) return;

      int size = imagePaths.length;
      EasyLoading.instance.userInteractions = false;
      for (int i = 0; i < size; i++) {
        final file = await MultipartFile.fromFile(
          imagePaths[i],
          filename: imagePaths[i].split(Platform.pathSeparator).last,
        );

        await boardService.submitPictures([file], onProgress: (int count, int total) {
          EasyLoading.showProgress(count / total, status: '正在上传(${i + 1}/$size)');
        });
      }

      EasyLoading.showSuccess('上传成功');
      refresh();
    } catch (e) {
      Log.error(e);
      EasyLoading.showError('上传失败');
    } finally {
      EasyLoading.instance.userInteractions = true;
      EasyLoading.dismiss();
    }
  }

  void refresh() {
    loadInitialPicture();
    _scrollController.animateTo(0, duration: const Duration(milliseconds: 500), curve: Curves.linear);
  }

  void loadInitialPicture() async {
    _lastPage = 1;
    _pictures = await boardService.getPictureList();
    _lastPage++;
    setState(() {});
  }

  void loadMorePicture() async {
    if (_atEnd) return;

    final lastPictures = await boardService.getPictureList(page: _lastPage);
    if (lastPictures.isEmpty) {
      setState(() => _atEnd = true);
      return;
    }

    _lastPage++;
    setState(() => _pictures.addAll(lastPictures));
  }

  Widget buildView(List<PictureSummary> pictures) {
    return Column(
      children: [
        Expanded(
          child: MasonryGridView.count(
            controller: _scrollController,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            crossAxisCount: 2,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            itemBuilder: (context, index) {
              return PictureCard(pictures[index]);
            },
            itemCount: pictures.length,
          ),
        ),
        if (_atEnd)
          const SizedBox(
            height: 40,
            child: Center(child: Text('到底啦')),
          )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool showUpload = AccountUtils.getUserType() != UserType.freshman;

    return Scaffold(
      appBar: AppBar(title: const Text('风筝时刻')),
      floatingActionButton: showUpload
          ? FloatingActionButton(
              onPressed: () => onUploadPicture(context),
              child: const Icon(Icons.upload),
            )
          : null,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
        child: buildView(_pictures),
      ),
    );
  }
}
