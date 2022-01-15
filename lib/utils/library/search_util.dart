import 'package:kite/entity/library/book_image.dart';
import 'package:kite/entity/library/book_search.dart';

class BookWithImage {
  Book book;
  BookImage? image;

  BookWithImage(this.book, {this.image});

  /// 使得独立的图书列表与图书图片信息相关联
  static List<BookWithImage> buildByJoin(
      List<Book> books, Map<String, BookImage> imageMap) {
    return books
        .map((book) =>
            BookWithImage(book, image: imageMap[book.isbn.replaceAll('-', '')]))
        .toList();
  }
}
