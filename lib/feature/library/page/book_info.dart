/*
 * 上应小风筝  便利校园，一步到位
 * Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
import 'package:flutter/material.dart';
import 'package:kite/component/future_builder.dart';

import '../entity/book_info.dart';
import '../entity/book_search.dart';
import '../entity/holding_preview.dart';
import '../init.dart';
import '../util/search.dart';
import 'component/search_result_item.dart';
import 'search_delegate.dart';

class BookInfoPage extends StatefulWidget {
  /// 上一层传递进来的数据
  final BookImageHolding bookImageHolding;

  const BookInfoPage(this.bookImageHolding, {Key? key}) : super(key: key);

  @override
  _BookInfoPageState createState() => _BookInfoPageState();
}

class _BookInfoPageState extends State<BookInfoPage> {
  Widget buildBookDetail() {
    final bookId = widget.bookImageHolding.book.bookId;
    return MyFutureBuilder<BookInfo>(
      future: LibraryInitializer.bookInfo.query(bookId),
      builder: (BuildContext context, BookInfo data) {
        return Table(
          columnWidths: const {
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(3),
          },
          // border: TableBorder.all(color: Colors.red),
          children: data.rawDetail.entries
              .map((e) => TableRow(
                    children: [
                      Text(e.key, style: Theme.of(context).textTheme.headline5),
                      SelectableText(e.value, style: Theme.of(context).textTheme.bodyText2),
                    ],
                  ))
              .toList(),
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

  /// 构造馆藏信息列表
  Widget buildHolding(List<HoldingPreviewItem> items) {
    return Column(
      children: items.map(buildHoldingItem).toList(),
    );
  }

  /// 构造标题样式的文本
  Widget buildTitle(String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.headline1,
    );
  }

  /// 构造邻近的书
  Widget buildBookItem(String bookId) {
    Future<BookImageHolding> get() async {
      final result = await LibraryInitializer.bookSearch.search(
        keyword: bookId,
        rows: 1,
        searchWay: SearchWay.ctrlNo,
      );
      final ret = await BookImageHolding.simpleQuery(
        LibraryInitializer.bookImageSearch,
        LibraryInitializer.holdingPreview,
        result.books,
      );
      return ret[0];
    }

    return MyFutureBuilder<BookImageHolding>(
      future: get(),
      builder: (BuildContext context, BookImageHolding data) {
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
      },
    );
  }

  Widget buildNearBooks(String bookId) {
    return MyFutureBuilder<List<String>>(
      future: LibraryInitializer.holdingInfo.searchNearBookIdList(bookId),
      builder: (BuildContext context, List<String> data) {
        return Column(
          children: data.sublist(0, 5).map((bookId) {
            return Container(
              child: buildBookItem(bookId),
            );
          }).toList(),
        );
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
