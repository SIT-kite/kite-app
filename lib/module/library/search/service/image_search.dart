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
import 'dart:convert';

import '../../using.dart';

import '../dao/image_search.dart';
import '../entity/book_image.dart';
import 'constant.dart';

/// 本类提供了一系列，通过查询图书图片的方法，返回结果类型为字典，以ISBN为键
class BookImageSearchService implements BookImageSearchDao {
  final ISession session;

  const BookImageSearchService(this.session);

  @override
  Future<Map<String, BookImage>> searchByIsbnList(List<String> isbnList) async {
    return await searchByIsbnStr(isbnList.join(','));
  }

  Future<Map<String, BookImage>> searchByIsbnStr(String isbnStr) async {
    var response = await session.request(
      Constants.bookImageInfoUrl,
      ReqMethod.get,
      queryParameters: {
        'glc': 'U1SH021060',
        'cmdACT': 'getImages',
        'type': '0',
        'isbns': isbnStr,
      },
      options: SessionOptions(responseType: SessionResType.plain),
    );
    var responseStr = (response.data as String).trim();
    responseStr = responseStr.substring(1, responseStr.length - 1);
    // Log.info(responseStr);
    var result = <String, BookImage>{};
    (jsonDecode(responseStr)['result'] as List<dynamic>).map((e) => BookImage.fromJson(e)).forEach(
      (e) {
        result[e.isbn] = e;
      },
    );
    return result;
  }
}
