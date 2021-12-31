import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:kite/services/library/book_search.dart';
import 'package:kite/services/library/image_search.dart';
import 'package:logger/logger.dart';

void main() {
  var logger = Logger();
  test('search test', () async {
    var books = await searchBook(keyword: 'Java');
    var result = await searchImageByBookList(books.books);
    logger.d(result);
  });
}
