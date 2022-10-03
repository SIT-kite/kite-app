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

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../entity/picture_summary.dart';
import '../page/view.dart';

class PictureCard extends StatelessWidget {
  final PictureSummary picture;

  const PictureCard(this.picture, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          GestureDetector(
              child: CachedNetworkImage(imageUrl: picture.thumbnail),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => ViewPage(picture.origin)));
              }),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(8),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(picture.publisher),
              const SizedBox(
                width: 40,
              ),
              const Icon(Icons.thumb_up),
              const SizedBox(width: 10),
              const Icon(Icons.delete)
            ]),
          )
        ],
      ),
    );
  }
}
