import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kite/component/html_widget.dart';

class SimpleHtmlPage extends StatelessWidget {
  final ValueNotifier<double> _progressNotifier = ValueNotifier<double>(0);
  final ValueNotifier<String> _contentNotifier = ValueNotifier<String>("");
  final String? url;
  final String? htmlContent;
  final String title;
  SimpleHtmlPage({
    Key? key,
    this.url,
    this.htmlContent,
    this.title = '简单富文本预览页',
  }) : super(key: key);

  Future<String> fetchHtmlContent() async {
    if (htmlContent != null) return htmlContent!;
    if (url == null) return '无内容';
    final response = await Dio().get<String>(
      url!,
      onReceiveProgress: (int count, int total) {
        _progressNotifier.value = count / total;
      },
    );
    return response.data ?? '无内容';
  }

  PreferredSizeWidget buildTopIndicator() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(3.0),
      child: ValueListenableBuilder<double>(
        valueListenable: _progressNotifier,
        builder: (context, data, child) {
          return LinearProgressIndicator(
            backgroundColor: Colors.white70.withOpacity(0),
            value: data,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
          );
        },
      ),
    );
  }

  Widget buildHtmlWidget() {
    return ValueListenableBuilder<String>(
      valueListenable: _contentNotifier,
      builder: (context, data, child) {
        return MyHtmlWidget(data);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    fetchHtmlContent().then((value) => _contentNotifier.value = value);
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        children: [
          buildTopIndicator(),
          Expanded(child: buildHtmlWidget()),
        ],
      ),
    );
  }
}
