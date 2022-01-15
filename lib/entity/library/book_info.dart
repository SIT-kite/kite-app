import 'dart:collection';

class BookInfo {
  final String title;
  final String isbn;
  final String price;
  final LinkedHashMap<String, String> rawDetail;

  const BookInfo(this.title, this.isbn, this.price, this.rawDetail);

  @override
  String toString() {
    return 'BookInfo{title: $title, isbn: $isbn, price: $price, rawDetail: $rawDetail}';
  }
}
