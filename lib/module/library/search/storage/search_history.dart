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
import '../../using.dart';
import '../dao/search_history.dart';
import '../entity/search_history.dart';

class SearchHistoryStorage implements SearchHistoryDao {
  final Box<LibrarySearchHistoryItem> box;

  const SearchHistoryStorage(this.box);

  @override
  void add(LibrarySearchHistoryItem item) {
    box.put(item.keyword.hashCode, item);
  }

  /// 根据搜索文字删除
  @override
  void delete(String record) {
    box.delete(record.hashCode);
  }

  @override
  void deleteAll() {
    box.deleteAll(box.keys.map((e) => e.hashCode));
  }

  /// 按时间降序获取所有
  @override
  List<LibrarySearchHistoryItem> getAllByTimeDesc() {
    var result = box.values.toList();
    result.sort((a, b) => b.time.compareTo(a.time));
    return result;
  }
}
