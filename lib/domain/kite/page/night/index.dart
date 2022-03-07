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
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'constant.dart';
import 'publish.dart';

class NightPage extends StatelessWidget {
  const NightPage({Key? key}) : super(key: key);

  Widget _buildMessage(BuildContext context, String content, [String author = '小风筝']) {
    final contentStyle = Theme.of(context).textTheme.headline1?.copyWith(fontFamily: 'calligraphy');
    final authorStyle = Theme.of(context).textTheme.headline6?.copyWith(fontFamily: 'calligraphy');

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 0.75.sw),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(content + '\n晚安！', style: contentStyle),
          const SizedBox(height: 30),
          Text(author, style: authorStyle),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('晚安'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.create),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PublishPage()));
        },
      ),
      body: Stack(children: [
        // Background image.
        SizedBox(
            width: 1.sw,
            height: 1.sh,
            child: const Image(image: AssetImage('assets/night/paper.jpg'), fit: BoxFit.cover)),
        _buildMessage(context, getRandomly()),
      ]),
    );
  }
}
