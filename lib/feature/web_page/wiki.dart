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
import 'dart:async';

import 'package:fk_user_agent/fk_user_agent.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kite/component/webview.dart';
import 'package:kite/component/webview_page.dart';
import 'package:kite/util/rule.dart';
import 'package:webview_flutter/webview_flutter.dart';

const String _defaultWikiUrl = 'https://kite.sunnysab.cn/wiki/';

class WikiPage extends StatelessWidget {
  final _controller = Completer<WebViewController>();
  final String? customWikiUrl;

  WikiPage({this.customWikiUrl, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleWebViewPage(
      initialUrl: customWikiUrl ?? _defaultWikiUrl,
      fixedTitle: '上应 Wiki',
      injectJsRules: [
        InjectJsRuleItem(
          rule: FunctionalRule((url) => url.startsWith(_defaultWikiUrl)),
          asyncJavascript: rootBundle.loadString('assets/wiki/inject.js'),
          injectTime: InjectJsTime.onPageStarted,
        ),
      ],
      onWebViewCreated: (WebViewController webViewController) {
        _controller.complete(webViewController);
      },
      userAgent: '${(() {
            try {
              return FkUserAgent.webViewUserAgent;
            } catch (e) {
              return '';
            }
          })() ?? ''} KiteApp',
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.menu),
        onPressed: () async {
          final controller = await _controller.future;
          const String js = '''
            menuButton = document.querySelector('label.md-header__button:nth-child(2)');
            menuButton !== null && menuButton.click();
          ''';
          controller.runJavascript(js);
        },
      ),
    );
  }
}
