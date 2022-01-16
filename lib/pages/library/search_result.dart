import 'package:flutter/material.dart';
import 'package:kite/dao/library/book_search.dart';
import 'package:kite/dao/library/image_search.dart';
import 'package:kite/pages/library/book_info.dart';
import 'package:kite/services/library/book_search.dart';
import 'package:kite/services/library/image_search.dart';
import 'package:kite/services/session_pool.dart';
import 'package:kite/utils/flash_utils.dart';
import 'package:kite/utils/library/search_util.dart';
import 'package:kite/utils/logger.dart';

class BookSearchResultWidget extends StatefulWidget {
  final String keyword;
  final BookSearchDao bookSearchDao = BookSearchService(SessionPool.librarySession);
  final BookImageSearchDao bookImageSearchDao = BookImageSearchService(SessionPool.librarySession);

  BookSearchResultWidget(this.keyword, {Key? key}) : super(key: key);

  @override
  _BookSearchResultWidgetState createState() => _BookSearchResultWidgetState();
}

class _BookSearchResultWidgetState extends State<BookSearchResultWidget> {
  static const defaultBookCover = Icon(
    Icons.library_books_sharp,
    size: 30,
  );

  final _scrollController = ScrollController();
  Image buildBookCover(String imageUrl) {
    return Image(
      height: 40,
      width: 40,
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
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) {
            return BookInfoPage(bi.book.bookId);
          }),
        );
      },
    );
  }

  var useTime = 0.0;
  var searchResultCount = 0;

  /// 获得搜索结果
  Future<List<BookWithImage>> get(int rows, int page) async {
    var searchResult = await widget.bookSearchDao.search(
      keyword: widget.keyword,
      rows: rows,
      page: page,
    );
    useTime = searchResult.useTime;
    searchResultCount = searchResult.resultCount;
    Log.info(searchResult);
    var imageResult = await widget.bookImageSearchDao.searchByBookList(searchResult.books);
    Log.info(imageResult);
    return BookWithImage.buildByJoin(searchResult.books, imageResult);
  }

  int currentPage = 1;
  List<BookWithImage> dataList = [];
  bool isLoading = false;

  Future<void> getData() async {
    var firstPage = await get(10, currentPage);
    setState(() {
      dataList = firstPage;
    });
  }

  Future<void> getMore() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      showBasicFlash(context, Text('加载更多'));
      var nextPage = await get(10, currentPage + 1);
      if (nextPage.isNotEmpty) {
        setState(() {
          dataList.addAll(nextPage);
          currentPage++;
          isLoading = false;
        });
      } else {
        showBasicFlash(context, Text('找不到更多了。。。'));
        isLoading = false;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        Log.info('页面滑动到底部');
        getMore();
      }
    });
  }

  Widget? a;
  @override
  Widget build(BuildContext context) {
    Log.info('初始化列表');
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('搜索结果数: $searchResultCount  用时: $useTime'),
        Expanded(
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return buildListTile(dataList[index]);
            },
            itemCount: dataList.length,
            controller: _scrollController,
          ),
        ),
      ],
    );
  }
}
