import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:kite/entity/library/book_image.dart';
import 'package:kite/entity/library/book_search.dart';
import 'package:kite/services/abstract_session.dart';
import 'package:kite/services/library/constants.dart';

import '../abstract_service.dart';

/// 本类提供了一系列，通过查询图书图片的方法，返回结果类型为字典，以ISBN为键
class BookImageSearchService extends AService {
  BookImageSearchService(ASession session) : super(session);

  Future<Map<String, BookImage>> searchByBookList(List<Book> bookList) async {
    return await searchByIsbnList(bookList.map((e) => e.isbn).toList());
  }

  Future<Map<String, BookImage>> searchByIsbnList(List<String> isbnList) async {
    return await searchByIsbnStr(isbnList.join(','));
  }

  Future<Map<String, BookImage>> searchByIsbnStr(String isbnStr) async {
    var response = await session.get(
      Constants.bookImageInfoUrl,
      queryParameters: {
        'glc': 'U1SH021060',
        'cmdACT': 'getImages',
        'type': '0',
        'isbns': isbnStr,
      },
      responseType: ResponseType.plain,
    );
    var responseStr = (response.data as String).trim();
    responseStr = responseStr.substring(1, responseStr.length - 1);
    var result = <String, BookImage>{};
    (jsonDecode(responseStr)['result'] as List<dynamic>)
        .map((e) => BookImage.fromJson(e))
        .forEach(
      (e) {
        result[e.isbn] = e;
      },
    );
    return result;
  }
}
