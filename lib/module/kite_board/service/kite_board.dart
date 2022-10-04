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

import 'package:dio/dio.dart';

import '../../../network/session.dart';
import '../dao/kite_board.dart';
import '../entity/picture_summary.dart';

class BoardService implements BoardDao {
  static const _boardUrl = '/board';

  final ISession session;
  BoardService(this.session);

  @override
  Future<List<PictureSummary>> getPictureList({int page = 1, int count = 20}) async {
    final response = await session.request('$_boardUrl/?index=$page&count=$count', ReqMethod.get);
    final List pictureList = response.data;

    List<PictureSummary> result = pictureList.map((e) => PictureSummary.fromJson(e)).toList();
    return result;
  }

  Future<void> submitPictures(List<MultipartFile> files, {ProgressCallback? onProgress}) async {
    int sc = 0, st = 0;
    await session.request(
      '$_boardUrl/new',
      ReqMethod.post,
      data: FormData.fromMap(
        files.asMap().map((key, value) => MapEntry(key.toString(), value)),
      ),
      onSendProgress: (c, t) {
        sc = c;
        st = t;
        if (onProgress != null) onProgress(sc, st);
      },
      onReceiveProgress: (c, t) {
        if (onProgress != null) onProgress(sc + c, st + t);
      },
    );
  }
}
