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
import 'dart:collection';

import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:kite/service/abstract_service.dart';
import 'package:kite/session/abstract_session.dart';

import '../dao/book_info.dart';
import '../entity/book_info.dart';
import '../service/constant.dart';

class BookInfoService extends AService implements BookInfoDao {
  BookInfoService(ASession session) : super(session);

  BookInfo _createBookInfo(LinkedHashMap<String, String> rawDetail) {
    final isbnAndPriceStr = rawDetail['ISBN']!;
    final isbnAndPrice = isbnAndPriceStr.split('价格：');
    final isbn = isbnAndPrice[0];
    final price = isbnAndPrice[1];

    return BookInfo()
      ..title = rawDetail.entries.first.value
      ..isbn = isbn
      ..price = price
      ..rawDetail = rawDetail;
  }

  @override
  Future<BookInfo> query(String bookId) async {
    final response = await session.get(Constants.bookUrl + '/$bookId');
    final html = response.data;

    final detailItems = BeautifulSoup(html)
        .find('table', id: 'bookInfoTable')!
        .findAll('tr')
        .map(
          (e) => e
              .findAll('td')
              .map(
                (e) => e.text.replaceAll(RegExp(r'\s*'), ''),
              )
              .toList(),
        )
        .where(
      (element) {
        if (element.isEmpty) {
          return false;
        }
        String e1 = element[0];

        // 过滤包含这些关键字的条目
        for (final keyword in ['分享', '相关', '随书']) {
          if (e1.contains(keyword)) return false;
        }

        return true;
      },
    ).toList();

    final rawDetail = LinkedHashMap.fromEntries(
      detailItems.sublist(1).map(
            (e) => MapEntry(
              e[0].substring(0, e[0].length - 1),
              e[1],
            ),
          ),
    );
    return _createBookInfo(rawDetail);
  }
}
