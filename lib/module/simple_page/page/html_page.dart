/*
 *    上应小风筝(SIT-kite)  便利校园，一步到位
 *    Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 *    This program is free software: you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation, either version 3 of the License, or
 *    (at your option) any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../using.dart';

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
    this.title = "",
  }) : super(key: key);

  Future<String> fetchHtmlContent() async {
    if (htmlContent != null) return htmlContent!;
    if (url == null) return i18n.htmlPageNoContent;
    final response = await Dio().get<String>(
      url!,
      onReceiveProgress: (int count, int total) {
        _progressNotifier.value = count / total;
      },
    );
    return response.data ?? i18n.htmlPageNoContent;
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
