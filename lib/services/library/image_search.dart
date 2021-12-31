class BookImage {
  final String isbn;
  final String coverLink;
  final String resourceLink;
  final int status;

  const BookImage(this.isbn, this.coverLink, this.resourceLink, this.status);
}

Future<Map<String, BookImage>> searchImage() async {
  return {};
}
