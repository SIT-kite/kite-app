/*
 *    上应小风筝(SIT-kite)  便利校园，一步到位
 *    Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 *    This program is free software: you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation, either version 3 of the License, or
 *    (at your option) any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
import 'package:kite/entity/library/search_history.dart';

abstract class SearchHistoryDao {
  // 添加搜索记录
  void add(LibrarySearchHistoryItem item);

  // 删除指定搜索记录
  void delete(String record);

  // 删除所有搜索记录
  void deleteAll();

  // 按时间降序获取所有搜索记录
  List<LibrarySearchHistoryItem> getAllByTimeDesc();
}
