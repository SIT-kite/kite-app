import 'package:flutter/material.dart';

class BookInfoPage extends StatefulWidget {
  final String bookId;
  const BookInfoPage(this.bookId, {Key? key}) : super(key: key);

  @override
  _BookInfoPageState createState() => _BookInfoPageState();
}

class _BookInfoPageState extends State<BookInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('图书详情'),
      ),
      body: Text(widget.bookId),
    );
  }
}
