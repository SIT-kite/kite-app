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
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';
import '../using.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!UniversalPlatform.isDesktop) {
      return SimpleWebViewPage(
        initialUrl: R.kiteAboutUrl,
        fixedTitle: i18n.about,
      );
    }

    final controller = MyFutureBuilderController();
    return Scaffold(
      appBar: AppBar(
        title: i18n.about.txt,
        actions: [
          IconButton(
            onPressed: () => controller.refresh(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: MyFutureBuilder<Response<String>>(
        controller: controller,
        enablePullRefresh: true,
        future: Dio().get(R.kiteAboutUrl),
        builder: (ctx, data) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
            child: MyHtmlWidget(data.data.toString()),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => GlobalLauncher.launch(R.kiteAboutUrl),
        child: const Icon(Icons.open_in_browser),
      ),
    );
  }
}
