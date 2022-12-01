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
import 'package:kite/launcher.dart';
import 'package:kite/util/logger.dart';

import 'image_viewer.dart';

class MyHtmlWidget extends StatelessWidget {
  final String html;
  final bool isSelectable;
  final RenderMode renderMode;
  final TextStyle? textStyle;

  const MyHtmlWidget(
    this.html, {
    Key? key,
    this.isSelectable = true,
    this.renderMode = RenderMode.column,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget widget = HtmlWidget(
      html,
      renderMode: renderMode,
      customStylesBuilder: (e) => {"background-color": ""},
      textStyle: textStyle ?? Theme.of(context).textTheme.bodyText2,
      onTapUrl: (url) async {
        await GlobalLauncher.launch(url);
        return true;
      },
      onTapImage: (ImageMetadata image) {
        final url = image.sources.toList()[0].url;
        Log.info('图片被点击: $url');
        MyImageViewer.showNetworkImagePage(context, url);
      },
    );
    if (isSelectable) {
      widget = SelectionArea(child: widget);
    }
    widget = SingleChildScrollView(child: widget);
    return widget;
  }
}
