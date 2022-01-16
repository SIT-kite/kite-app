import 'package:flutter/material.dart';
import 'package:kite/dao/library/book_search.dart';
import 'package:kite/dao/library/image_search.dart';
import 'package:kite/services/library/book_search.dart';
import 'package:kite/services/library/image_search.dart';
import 'package:kite/services/session_pool.dart';
import 'package:kite/utils/library/search_util.dart';

class BookSearchResultWidget extends StatefulWidget {
  final String keyword;
  // final BookSearchDao bookSearchDao = BookSearchMock();
  final BookSearchDao bookSearchDao = BookSearchService(SessionPool.librarySession);
  final BookImageSearchDao bookImageSearchDao = BookImageSearchService(SessionPool.librarySession);

  BookSearchResultWidget(this.keyword, {Key? key}) : super(key: key);

  @override
  _BookSearchResultWidgetState createState() => _BookSearchResultWidgetState();
}

class _BookSearchResultWidgetState extends State<BookSearchResultWidget> {
  static const defaultBookCover = Icon(
    Icons.library_books_sharp,
    size: 40,
  );
  Image buildBookCover(String imageUrl) {
    return Image(
      image: NetworkImage(imageUrl),
    );
  }

  Widget buildListTile(BookWithImage bi) {
    var e = bi.book;
    var image = bi.image?.resourceLink;
    return ListTile(
      title: Text(e.title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(e.author),
          Text(e.callNo),
        ],
      ),
      leading: image == null ? defaultBookCover : buildBookCover(image),
      trailing: Column(
        verticalDirection: VerticalDirection.up,
        children: [
          ColoredBox(
            color: Colors.black12,
            child: Container(
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
              // width: 80,
              // height: 20,
              child: const Text('馆藏(3)/在馆(1)'),
            ),
          )
        ],
      ),
    );
  }

  /// 获得搜索结果
  Future<List<BookWithImage>> get(int rows, int page) async {
    var searchResult = await widget.bookSearchDao.search(keyword: widget.keyword, rows: rows, page: page);
    var imageResult = await widget.bookImageSearchDao.searchByBookList(searchResult.books);

    return BookWithImage.buildByJoin(searchResult.books, imageResult);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BookWithImage>>(
        future: get(30, 1),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            List<BookWithImage> searchResult = snapshot.data;
            return ListView(
              children: searchResult
                  .map((e) => [
                        buildListTile(e),
                        const SizedBox(
                          height: 1,
                          child: ColoredBox(color: Colors.grey),
                        ),
                      ])
                  .expand((element) => element)
                  .toList(),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
