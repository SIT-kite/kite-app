import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:kite/pages/office/browser.dart';
import 'package:kite/services/office/office.dart';
import 'package:kite/utils/url_launcher.dart';

class DetailPage extends StatelessWidget {
  final OfficeSession session;
  final SimpleFunction function;

  final titleStyle = const TextStyle(fontSize: 25, fontWeight: FontWeight.bold);
  final textStyle = const TextStyle(fontSize: 20);

  const DetailPage(this.session, this.function, {Key? key}) : super(key: key);

  Widget buildSection(FunctionDetailSection section) {
    Widget buildHtmlSection(String content) {
      final html = content.replaceAll('../app/files/', 'https://xgfy.sit.edu.cn/app/files/');
      return HtmlWidget(html, textStyle: textStyle, onTapUrl: (url) {
        launchInBrowser(url);
        return true;
      });
    }

    Widget buildJsonSection(String content) {
      final Map kvPairs = jsonDecode(content);
      List<Widget> items = [];
      kvPairs.forEach((key, value) => items.add(Text('$key: $value', style: textStyle)));

      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: items);
    }

    Widget buildOtherSection(String type, String _) {
      return Text('未知类型: $type', style: textStyle);
    }

    late Widget bodyWidget;
    switch (section.type) {
      case 'html':
        bodyWidget = buildHtmlSection(section.content);
        break;
      case 'json':
        bodyWidget = buildJsonSection(section.content);
        break;
      default:
        bodyWidget = buildOtherSection(section.type, section.content);
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(section.section, style: titleStyle),
        bodyWidget,
        const SizedBox(height: 25),
      ],
    );
  }

  Widget buildBody(List<FunctionDetailSection> sections) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: sections.map(buildSection).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(function.name)),
      body: SafeArea(
        child: FutureBuilder<FunctionDetail>(
          future: getFunctionDetail(session, function.id),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              final FunctionDetail function = snapshot.data!;
              return buildBody(function.sections);
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.east),
        onPressed: () {
          // 跳转到申请页面
          final String applyUrl =
              'https://xgfy.sit.edu.cn/unifri-flow/WF/MyFlow.htm?ismobile=1&out=1&FK_Flow=${function.id}';
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (_) => BrowserPage(function.name, applyUrl)));
        },
      ),
    );
  }
}
