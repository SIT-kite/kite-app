import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:kite/entity/office/index.dart';
import 'package:kite/page/office/browser.dart';
import 'package:kite/service/office/index.dart';
import 'package:kite/util/url_launcher.dart';

class DetailPage extends StatelessWidget {
  final OfficeSession session;
  final SimpleFunction function;

  const DetailPage(this.session, this.function, {Key? key}) : super(key: key);

  Widget buildSection(BuildContext context, FunctionDetailSection section) {
    final titleStyle = Theme.of(context).textTheme.headline2;
    final textStyle = Theme.of(context).textTheme.bodyText2;

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

    return Card(
      margin: const EdgeInsets.all(5),
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(section.section, style: titleStyle),
              bodyWidget,
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBody(BuildContext context, List<FunctionDetailSection> sections) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: sections.map((e) => buildSection(context, e)).toList(),
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
              return buildBody(context, function.sections);
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
