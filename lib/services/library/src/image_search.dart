import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kite/services/library/src/constants.dart';

import 'book_search.dart';

part 'image_search.g.dart';

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
}

Future<Map<String, BookImage>> searchImageByBookList(
    List<Book> bookList) async {
  return await searchImageByIsbnList(bookList.map((e) => e.isbn).toList());
}

Future<Map<String, BookImage>> searchImageByIsbnList(
    List<String> isbnList) async {
  return await searchImageByIsbnStr(isbnList.join(','));
}

Future<Map<String, BookImage>> searchImageByIsbnStr(String isbnStr) async {
  var response = await Dio().get(Constants.bookImageInfoUrl,
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
