import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kite/services/library/src/constants.dart';

import 'book_search.dart';

part 'image_search.g.dart';

/// 本类提供了一系列，通过查询图书图片的方法，返回结果类型为字典，以ISBN为键
@JsonSerializable()
class BookImage {
  final String isbn;
  @JsonKey(name: 'coverlink')
  final String coverLink;
  final String resourceLink;
  final int status;

  const BookImage(this.isbn, this.coverLink, this.resourceLink, this.status);

  factory BookImage.fromJson(Map<String, dynamic> json) =>
      _$BookImageFromJson(json);

  Map<String, dynamic> toJson() => _$BookImageToJson(this);

  static Future<Map<String, BookImage>> searchByBookList(
    List<Book> bookList, {
    Dio? dio,
  }) async {
    return await searchByIsbnList(
      bookList.map((e) => e.isbn).toList(),
      dio: dio,
    );
  }

  static Future<Map<String, BookImage>> searchByIsbnList(
    List<String> isbnList, {
    Dio? dio,
  }) async {
    return await searchByIsbnStr(
      isbnList.join(','),
      dio: dio,
    );
  }

  static Future<Map<String, BookImage>> searchByIsbnStr(
    String isbnStr, {
    Dio? dio,
  }) async {
    var response = await (dio ?? Dio()).get(Constants.bookImageInfoUrl,
        queryParameters: {
          'glc': 'U1SH021060',
          'cmdACT': 'getImages',
          'type': '0',
          'isbns': isbnStr,
        },
        options: Options(responseType: ResponseType.plain));
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
