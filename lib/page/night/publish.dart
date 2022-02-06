/*
 * 上应小风筝(SIT-kite)  便利校园，一步到位
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

class PublishPage extends StatefulWidget {
  const PublishPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PublishPageState();
}

class _PublishPageState extends State<PublishPage> {
  Widget _buildTextField() {
    final textSize = Theme.of(context).textTheme.headline1?.fontSize;
    final textStyle = TextStyle(fontFamily: 'calligraphy', color: Colors.grey, fontSize: textSize);

    return TextField(
      maxLines: null,
      expands: true,
      style: textStyle,
      maxLength: 150,
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: const EdgeInsets.all(10),
        hintStyle: textStyle,
        hintText: '有没有想推荐的歌~\n也可以分享今天感动你的事\n要不，来谈一谈这一刻你的心里话',
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
  }

  Widget _buildButtonBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.send)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('说两句')),
      body: Column(
        children: [
          Expanded(child: _buildTextField()),
          _buildButtonBar(),
        ],
      ),
    );
  }
}
