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
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:kite/launch.dart';
import 'package:kite/util/logger.dart';

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
    return SingleChildScrollView(
      child: HtmlWidget(
        widget.html,
        isSelectable: widget.isSelectable,
        renderMode: widget.renderMode,
        textStyle: Theme.of(context).textTheme.bodyText2,
        onTapUrl: (url) {
          GlobalLauncher.launch(url);
          return true;
        },
        onTapImage: (ImageMetadata image) {
          Log.info('图片被点击: ${image.sources.toList()[0].url}');
        },
      ),
    );
  }
}
