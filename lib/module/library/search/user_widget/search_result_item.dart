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

import '../util/search.dart';

typedef KeyClickCallback = void Function(String key);

class BookItemWidget extends StatelessWidget {
  final BookImageHolding bookImageHolding;

  final KeyClickCallback? onAuthorTap;

  const BookItemWidget(this.bookImageHolding, {Key? key, this.onAuthorTap}) : super(key: key);

  /// 构造图书封皮预览图片
  Widget buildBookCover(String? imageUrl) {
    const def = Icon(Icons.library_books_sharp, size: 100);
    if (imageUrl == null) {
      return def;
    }

    return Image.network(
      imageUrl,
      // fit: BoxFit.fill,
      errorBuilder: (
        BuildContext context,
        Object error,
        StackTrace? stackTrace,
      ) {
        return def;
      },
    );
  }

  /// 构造一个图书项
  Widget buildListTile(BuildContext context, BookImageHolding bi) {
    final screenHeight = MediaQuery.of(context).size.height;
    final book = bi.book;
    final holding = bi.holding ?? [];
    // 计算总共馆藏多少书
    int copyCount = holding.map((e) => e.copyCount).reduce((value, element) => value + element);
    // 计算总共可借多少书
    int loanableCount = holding.map((e) => e.loanableCount).reduce((value, element) => value + element);
    final row = Row(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            padding: const EdgeInsets.all(5),
            height: screenHeight / 5,
            child: buildBookCover(bi.image?.resourceLink),
          ),
        ),
        Expanded(
          flex: 7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(book.title, style: Theme.of(context).textTheme.headline3, softWrap: true),
              onAuthorTap == null
                  ? Text('作者:  ${book.author}')
                  : Row(
                      children: [
                        const Text('作者:  '),
                        InkWell(
                          child: Text(book.author, style: const TextStyle(color: Colors.blue)),
                          onTap: () {
                            onAuthorTap!(book.author);
                          },
                        ),
                      ],
                    ),
              Text('索书号:  ${book.callNo}'),
              Text('ISBN:  ${book.isbn}'),
              Text('${book.publisher}  ${book.publishDate}'),
              Row(
                children: [
                  const Expanded(child: Text(' ')),
                  ColoredBox(
                    color: Colors.black12,
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
                      // width: 80,
                      // height: 20,
                      child: Text('馆藏($copyCount)/在馆($loanableCount)'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
    return row;
  }

  @override
  Widget build(BuildContext context) {
    return buildListTile(context, bookImageHolding);
  }
}
