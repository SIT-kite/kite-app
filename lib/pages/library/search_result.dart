import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kite/dao/library/book_search.dart';
import 'package:kite/entity/library/book_search.dart';
import 'package:kite/services/library/book_search.dart';
import 'package:kite/services/session_pool.dart';

class BookSearchResultWidget extends StatefulWidget {
  final String keyword;
  // final BookSearchDao bookSearchDao = BookSearchMock();
  final BookSearchDao bookSearchDao = BookSearchService(SessionPool.librarySession);

  BookSearchResultWidget(this.keyword, {Key? key}) : super(key: key);

  @override
  _BookSearchResultWidgetState createState() => _BookSearchResultWidgetState();
}

class _BookSearchResultWidgetState extends State<BookSearchResultWidget> {
  Widget buildListTile(Book e) {
    return ListTile(
      title: Text(e.title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(e.author),
          Text(e.callNo),
        ],
      ),
      leading: const Icon(
        Icons.library_books_sharp,
        size: 40,
      ),
      trailing: Column(
        verticalDirection: VerticalDirection.up,
        children: [
          ColoredBox(
            color: Colors.black12,
            child: Container(
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
              // width: 80,
              // height: 20,
              child: Text('馆藏(3)/在馆(1)'),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BookSearchResult>(
        future: widget.bookSearchDao.search(
          keyword: widget.keyword,
        ),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            BookSearchResult searchResult = snapshot.data;
            return ListView(
              children: searchResult.books
                  .map((e) => [
                        buildListTile(e),
                        SizedBox(
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
