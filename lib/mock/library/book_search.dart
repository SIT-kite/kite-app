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
import 'dart:math';

import 'package:kite/dao/library/book_search.dart';
import 'package:kite/entity/library/book_search.dart';

class BookSearchMock implements BookSearchDao {
  @override
  Future<BookSearchResult> search({
    String keyword = '',
    int rows = 10,
    int page = 1,
    SearchWay searchWay = SearchWay.title,
    SortWay sortWay = SortWay.matchScore,
    SortOrder sortOrder = SortOrder.desc,
  }) async {
    await Future.delayed(const Duration(microseconds: 300));
    var length = 100;
    return BookSearchResult(
        length,
        Random.secure().nextDouble(),
        page,
        length ~/ rows,
        List.generate(
          length,
          (index) {
            var i = index;
            return Book('id$i', 'isbn$i', 'title$i', 'author$i', 'publisher$i', 'pubDate$i', 'callNo$i');
          },
        ));
  }
}
