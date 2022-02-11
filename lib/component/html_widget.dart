import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:kite/util/url_launcher.dart';

class MyHtmlWidget extends StatefulWidget {
  final String html;
  final bool isSelectable;
  final RenderMode renderMode;
  const MyHtmlWidget(
    this.html, {
    Key? key,
    this.isSelectable = true,
    this.renderMode = RenderMode.column,
  }) : super(key: key);

  @override
  _MyHtmlWidgetState createState() => _MyHtmlWidgetState();
}

class _MyHtmlWidgetState extends State<MyHtmlWidget> {
  @override
  Widget build(BuildContext context) {
    return HtmlWidget(
      widget.html,
      isSelectable: widget.isSelectable,
      renderMode: widget.renderMode,
      onTapUrl: (url) {
        launchInBrowser(url);
        return true;
      },
    );
  }
}
