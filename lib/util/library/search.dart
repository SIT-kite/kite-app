import 'package:kite/entity/library/book_image.dart';
import 'package:kite/entity/library/book_search.dart';
import 'package:kite/entity/library/holding_preview.dart';

class BookImageHolding {
  Book book;
  BookImage? image;
  List<HoldingPreviewItem>? holding;

  BookImageHolding(this.book, {this.image, this.holding});

  /// 使得图书列表,图书图片信息,馆藏信息相关联
  static List<BookImageHolding> build(
    List<Book> books,
    Map<String, BookImage> imageMap,
    Map<String, List<HoldingPreviewItem>> holdingMap,
  ) {
    return books.map((book) {
      return BookImageHolding(
        book,
        image: imageMap[book.isbn.replaceAll('-', '')],
        holding: holdingMap[book.bookId],
      );
    }).toList();
  }
}
