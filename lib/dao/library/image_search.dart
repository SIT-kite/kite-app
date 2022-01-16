import 'package:kite/entity/library/book_image.dart';
import 'package:kite/entity/library/book_search.dart';

abstract class BookImageSearchDao {
  Future<Map<String, BookImage>> searchByBookList(List<Book> bookList);

  Future<Map<String, BookImage>> searchByIsbnList(List<String> isbnList);
}
