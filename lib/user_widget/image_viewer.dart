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

class MyImageViewer extends StatelessWidget {
  final ImageProvider image;

  const MyImageViewer({required this.image, Key? key}) : super(key: key);

  Widget buildImageWidget() {
    return Image(
      image: image,
      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) return child;
        int currentLength = loadingProgress.cumulativeBytesLoaded;
        int? totalLength = loadingProgress.expectedTotalBytes;
        return Center(
          child: CircularProgressIndicator(value: totalLength != null ? currentLength / totalLength : null),
        );
      },
    );
  }

  Widget buildBody(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: InteractiveViewer(
        minScale: 1,
        maxScale: 10.0,
        child: buildImageWidget(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(child: buildBody(context));
  }

  static Future<void> showNetworkImagePage(BuildContext context, String url) async {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return Scaffold(
        body: MyImageViewer(
          image: CachedNetworkImageProvider(url),
        ),
      );
    }));
  }
}
