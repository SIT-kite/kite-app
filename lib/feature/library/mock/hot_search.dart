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
import '../dao/hot_search.dart';

import '../entity/hot_search.dart';

class HotSearchMock implements HotSearchDao {
  @override
  Future<HotSearch> getHotSearch() async {
    // 模拟需要1s才能拿到数据的场景
    await Future.delayed(const Duration(seconds: 1));
    return HotSearch(
      recentMonth: [
        HotSearchItem('hotSearch1', 99),
        HotSearchItem('hotSearch2', 98),
        HotSearchItem('hotSearch3', 97),
        HotSearchItem('hotSearch4', 96),
      ],
      totalTime: [
        HotSearchItem('hotSearch1', 99),
        HotSearchItem('hotSearch2', 98),
        HotSearchItem('hotSearch3', 97),
        HotSearchItem('hotSearch4', 96),
      ],
    );
  }
}
