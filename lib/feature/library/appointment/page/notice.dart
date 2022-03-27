import 'package:flutter/material.dart';
import 'package:kite/component/html_widget.dart';

import '../entity.dart';

class LibraryNoticePage extends StatelessWidget {
  final Notice notice;
  const LibraryNoticePage(this.notice, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('图书馆通知'),
      ),
      body: MyHtmlWidget(notice.html),
    );
  }
}
