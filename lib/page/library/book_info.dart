import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:kite/dao/library/book_info.dart';
import 'package:kite/dao/library/holding.dart';
import 'package:kite/global/session_pool.dart';
import 'package:kite/page/library/search_delegate.dart';
import 'package:kite/service/library.dart';
import 'package:kite/util/library/search.dart';

import 'component/search_result_item.dart';

class BookInfoPage extends StatefulWidget {
  /// 图书信息访问
  final BookInfoDao bookInfoDao = BookInfoService(SessionPool.librarySession);

  /// 馆藏信息访问
  final HoldingInfoDao holdingInfoDao = HoldingInfoService(SessionPool.librarySession);

  /// 上一层传递进来的数据
  final BookImageHolding bookImageHolding;
  BookInfoPage(this.bookImageHolding, {Key? key}) : super(key: key);

  @override
  _BookInfoPageState createState() => _BookInfoPageState();
}

class _BookInfoPageState extends State<BookInfoPage> {
  LinkedHashMap detail = LinkedHashMap();
  List<String> nearBookId = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('图书详情'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BookItemWidget(
              widget.bookImageHolding,
              onAuthorTap: (String key) {
                showSearch(
                  context: context,
                  delegate: SearchBarDelegate(),
                  query: key,
                );
              },
            ),
            Table(
              columnWidths: {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(3),
              },
              border: TableBorder.all(
                color: Colors.red,
              ),
              children: detail.entries
                  .map((e) => TableRow(
                        children: [
                          Text(e.key),
                          Text(e.value),
                        ],
                      ))
                  .toList(),
            ),
            Text('馆藏'),
            Text('邻近的书'),
            Text(nearBookId.join('\n')),
          ],
        ),
      ),
    );
  }
}
