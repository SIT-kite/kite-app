import 'package:flutter/material.dart';
import 'package:kite/dao/library/book_info.dart';
import 'package:kite/dao/library/book_search.dart';
import 'package:kite/dao/library/holding.dart';
import 'package:kite/dao/library/holding_preview.dart';
import 'package:kite/dao/library/image_search.dart';
import 'package:kite/entity/library/book_info.dart';
import 'package:kite/entity/library/book_search.dart';
import 'package:kite/entity/library/holding_preview.dart';
import 'package:kite/global/session_pool.dart';
import 'package:kite/page/library/search_delegate.dart';
import 'package:kite/service/library.dart';
import 'package:kite/service/library/holding_preview.dart';
import 'package:kite/util/library/search.dart';

import 'component/search_result_item.dart';

class BookInfoPage extends StatefulWidget {
  /// 图书信息访问
  final BookInfoDao bookInfoDao = BookInfoService(SessionPool.librarySession);

  /// 馆藏信息访问
  final HoldingInfoDao holdingInfoDao = HoldingInfoService(SessionPool.librarySession);

  /// 图书
  final BookSearchDao bookSearchDao = BookSearchService(SessionPool.librarySession);

  final BookImageSearchDao bookImageSearchDao = BookImageSearchService(SessionPool.librarySession);

  final HoldingPreviewDao holdingPreviewDao = HoldingPreviewService(SessionPool.librarySession);

  /// 上一层传递进来的数据
  final BookImageHolding bookImageHolding;
  BookInfoPage(this.bookImageHolding, {Key? key}) : super(key: key);

  @override
  _BookInfoPageState createState() => _BookInfoPageState();
}

class _BookInfoPageState extends State<BookInfoPage> {
  Widget buildBookDetail() {
    final bookId = widget.bookImageHolding.book.bookId;
    return FutureBuilder<BookInfo>(
      future: widget.bookInfoDao.query(bookId),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          final BookInfo bookInfo = snapshot.data;
          return Table(
            columnWidths: const {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(3),
            },
            // border: TableBorder.all(color: Colors.red),
            children: bookInfo.rawDetail.entries
                .map(
                  (e) => TableRow(
                    children: [
                      Text(
                        e.key,
                      ),
                      SelectableText(
                        e.value,
                        style: const TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
          );
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget buildHoldingItem(HoldingPreviewItem item) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('索书号：' + item.callNo),
                  Text('所在馆：' + item.currentLocation),
                ],
              ),
            ),
            Text('在馆(${item.loanableCount})/馆藏(${item.copyCount})'),
          ],
        ),
      ),
    );
  }

  Widget buildHolding(List<HoldingPreviewItem> items) {
    return Column(
      children: items.map(buildHoldingItem).toList(),
    );
  }

  Widget buildTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget buildBookItem(String bookId) {
    Future<BookImageHolding> get() async {
      final result = await widget.bookSearchDao.search(
        keyword: bookId,
        rows: 1,
        searchWay: SearchWay.ctrlNo,
      );
      final ret = await BookImageHolding.simpleQuery(
        widget.bookImageSearchDao,
        widget.holdingPreviewDao,
        result.books,
      );
      return ret[0];
    }

    return FutureBuilder<BookImageHolding>(
        future: get(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            final BookImageHolding data = snapshot.data;
            return InkWell(
              child: Card(
                child: BookItemWidget(data),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (BuildContext context) {
                    return BookInfoPage(data);
                  }),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return const CircularProgressIndicator();
        });
  }

  Widget buildNearBooks(String bookId) {
    return FutureBuilder(
      future: widget.holdingInfoDao.searchNearBookIdList(bookId),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List<String> bookIdList = snapshot.data;
          return Column(
            children: bookIdList.sublist(0, 5).map((bookId) {
              return Container(
                child: buildBookItem(bookId),
              );
            }).toList(),
          );
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return const CircularProgressIndicator();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('图书详情'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            BookItemWidget(
              widget.bookImageHolding,
              onAuthorTap: (String key) {
                showSearch(context: context, delegate: SearchBarDelegate(), query: key);
              },
            ),
            const SizedBox(height: 20),
            buildBookDetail(),
            const SizedBox(height: 20),
            buildTitle('馆藏信息'),
            buildHolding(widget.bookImageHolding.holding ?? []),
            const SizedBox(height: 20),
            buildTitle('邻近的书'),
            buildNearBooks(widget.bookImageHolding.book.bookId),
          ]),
        ),
      ),
    );
  }
}
