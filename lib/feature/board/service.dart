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

import 'package:kite/feature/board/entity.dart';

import '../../abstract/abstract_service.dart';
import '../../abstract/abstract_session.dart';
import 'dao.dart';

class BoardService extends AService implements BoardDao {
  static const _boardUrl = "/board";

  BoardService(ASession session) : super(session);

  @override
  Future<List<PictureSummary>> getPictureList(
      {int page = 1, int count = 20}) async {
    final response = await session.get(_boardUrl);
    final List pictureList = response.data;

    List<PictureSummary> result =
        pictureList.map((e) => PictureSummary.fromJson(e)).toList();
    return result;
  }
}
