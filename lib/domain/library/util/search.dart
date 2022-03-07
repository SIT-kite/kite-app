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
import 'package:kite/domain/library/dao/holding_preview.dart';
import 'package:kite/domain/library/dao/image_search.dart';
import 'package:kite/domain/library/entity/book_image.dart';
import 'package:kite/domain/library/entity/book_search.dart';
import 'package:kite/domain/library/entity/holding_preview.dart';
import 'package:kite/util/logger.dart';

class BookImageHolding {
  Book book;
  BookImage? image;
  List<HoldingPreviewItem>? holding;

  BookImageHolding(this.book, {this.image, this.holding});

  /// 使得图书列表,图书图片信息,馆藏信息相关联
  static List<BookImageHolding> build(
    List<Book> books,
    Map<String, BookImage> imageMap,
    Map<String, List<HoldingPreviewItem>> holdingMap,
  ) {
    return books.map((book) {
      return BookImageHolding(
        book,
        image: imageMap[book.isbn.replaceAll('-', '')],
        holding: holdingMap[book.bookId],
      );
    }).toList();
  }

  /// 可以很简单地并发查询一批书的图片与馆藏信息并join出结果
  static Future<List<BookImageHolding>> simpleQuery(
    BookImageSearchDao bookImageSearchDao, // 图片搜索服务
    HoldingPreviewDao holdingPreviewDao, // 馆藏检索服务
    List<Book> books, // 图书搜索结果
  ) async {
    Future<Map<String, BookImage>> searchBookImages() async {
      try {
        Log.info('批量查询图书图片信息');
        final isbnList = books.map((e) => e.isbn).toList();
        return await bookImageSearchDao.searchByIsbnList(isbnList);
      } catch (e) {
        // 查询出错
        Log.error('查询图书图片信息错误: $e');
        return {};
      }
    }

    Future<HoldingPreviews> getHoldingPreviews() async {
      try {
        Log.info('批量获取馆藏信息');
        final bookIdList = books.map((e) => e.bookId).toList();
        return await holdingPreviewDao.getHoldingPreviews(bookIdList);
      } catch (e) {
        // 查询出错
        Log.error('获取馆藏信息出错: $e');
        return const HoldingPreviews({});
      }
    }

    final imageHoldingPreview = await Future.wait([
      searchBookImages(),
      getHoldingPreviews(),
    ]);
    final imageResult = imageHoldingPreview[0] as Map<String, BookImage>;
    final holdingPreviewResult = imageHoldingPreview[1] as HoldingPreviews;
    return BookImageHolding.build(
      books,
      imageResult,
      holdingPreviewResult.previews,
    );
  }
}
