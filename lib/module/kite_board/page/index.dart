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
import 'package:photo_view/photo_view_gallery.dart';
import 'package:rettulf/rettulf.dart';
import 'package:universal_platform/universal_platform.dart';

import '../entity/picture_summary.dart';
import '../init.dart';
import '../service/kite_board.dart';
import '../user_widget/card.dart';
import '../using.dart';

class BoardPage extends StatefulWidget {
  const BoardPage({Key? key}) : super(key: key);

  @override
  State<BoardPage> createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  final BoardService boardService = BoardInit.boardServiceDao;

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

  // TODO: I18n
  Future<bool?> showUploadDialog(List<String> imagePaths) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("请确认是否要上传以下图片"),
          content: SizedBox(
            width: 400,
            height: 400,
            child: PhotoViewGallery(
              pageOptions:
                  imagePaths.map((e) => PhotoViewGalleryPageOptions(imageProvider: FileImage(File(e)))).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("确定"),
              onPressed: () {
                Navigator.of(context).pop(true);
              }, // 关闭对话框
            ),
            TextButton(
              child: const Text("取消"),
              onPressed: () {
                //关闭对话框并返回true
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> onUploadPicture(BuildContext context, OACredential oaCredential) async {
    // 如果用户未同意过, 请求用户确认
    // TODO: I18n
    if (!await signUpIfNecessary(context, oaCredential, '标识图片上传者')) return;
    try {
      final List<String> imagePaths = UniversalPlatform.isDesktopOrWeb
          ? await FileUtils.pickImagesByFilePicker()
          : await FileUtils.pickImagesByImagePicker();
      bool? isUpload = await showUploadDialog(imagePaths);

      if (imagePaths.isEmpty || !isUpload!) return;

      int size = imagePaths.length;
      EasyLoading.instance.userInteractions = false;
      for (int i = 0; i < size; i++) {
        final file = await MultipartFile.fromFile(
          imagePaths[i],
          filename: imagePaths[i].split(Platform.pathSeparator).last,
        );

        await boardService.submitPictures([file], onProgress: (int count, int total) {
          EasyLoading.showProgress(count / total, status: i18n.uploadingCounter(i + 1, size));
        });
      }

      EasyLoading.showSuccess(i18n.uploadDoneTip);
      refresh();
    } catch (e) {
      Log.error(e);
      EasyLoading.showError(i18n.uploadFailedTip);
    } finally {
      EasyLoading.instance.userInteractions = true;
      EasyLoading.dismiss();
    }
  }

  void refresh() {
    loadInitialPicture();
    _scrollController.animateTo(0, duration: const Duration(milliseconds: 500), curve: Curves.fastLinearToSlowEaseIn);
  }

  void loadInitialPicture() async {
    _lastPage = 1;
    _pictures = await boardService.getPictureList();
    _lastPage++;
    if (!mounted) return;
    setState(() {});
  }

  void loadMorePicture() async {
    if (_atEnd) return;

    final lastPictures = await boardService.getPictureList(page: _lastPage);

    if (!mounted) return;
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
          SizedBox(
            height: 40,
            child: Center(child: i18n.kiteBoardReachEndLabel.text()),
          )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final oaCredential = Auth.oaCredential;

    return Scaffold(
      appBar: AppBar(title: i18n.kiteBoardTitle.text()),
      floatingActionButton: oaCredential != null
          ? FloatingActionButton(
              onPressed: () => onUploadPicture(context, oaCredential),
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
