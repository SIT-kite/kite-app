import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:kite/global/session_pool.dart';
import 'package:kite/service/library.dart';

class BookInfoPage extends StatefulWidget {
  final String bookId;
  const BookInfoPage(this.bookId, {Key? key}) : super(key: key);

  @override
  _BookInfoPageState createState() => _BookInfoPageState();
}

class _BookInfoPageState extends State<BookInfoPage> {
  LinkedHashMap detail = LinkedHashMap();
  List<String> nearBookId = [];
  @override
  void initState() {
    super.initState();
    BookInfoService(SessionPool.librarySession).query(widget.bookId).then((value) {
      setState(() {
        detail = value.rawDetail;
      });
    });
    HoldingInfoService(SessionPool.librarySession).searchNearBookIdList(widget.bookId).then((value) {
      setState(() {
        nearBookId = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('图书详情'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text('图书详情'),
            Text(detail.entries.map((e) => '${e.key}: ${e.value}').join('\n')),
            Text('邻近的书'),
            Text(nearBookId.join('\n')),
          ],
        ),
      ),
    );
  }
}
