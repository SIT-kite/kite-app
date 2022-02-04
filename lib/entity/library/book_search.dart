/*
 *    上应小风筝(SIT-kite)  便利校园，一步到位
 *    Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 *    This program is free software: you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation, either version 3 of the License, or
 *    (at your option) any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
enum SearchWay {
  // 按任意词查询
  any,
  // 标题名
  title,
  // 正题名：一本书的主要名称
  titleProper,
  // ISBN号
  isbn,
  // 著者
  author,
  // 主题词
  subjectWord,
  // 分类号
  classNo,
  // 控制号(就是搜索结果的bookId图书号)
  ctrlNo,
  // 订购号
  orderNo,
  // 出版社
  publisher,
  // 索书号
  callNo,
}

enum SortWay {
  // 匹配度
  matchScore,
  // 出版日期
  publishDate,
  // 主题词
  subject,
  // 标题名
  title,
  // 作者
  author,
  // 索书号
  callNo,
  // 标题名拼音
  pinyin,
  // 借阅次数
  loanCount,
  // 续借次数
  renewCount,
  // 题名权重
  titleWeight,
  // 正题名权重
  titleProperWeight,
  // 卷册号
  volume,
}

enum SortOrder {
  asc,
  desc,
}

class Book {
  String bookId;
  String isbn;
  String title;
  String author;
  String publisher;
  String publishDate;
  String callNo;

  Book(this.bookId, this.isbn, this.title, this.author, this.publisher, this.publishDate, this.callNo);

  @override
  String toString() {
    return 'Book{bookId: $bookId, isbn: $isbn, title: $title, author: $author, publisher: $publisher, publishDate: $publishDate, callNo: $callNo}';
  }
}

class BookSearchResult {
  int resultCount;
  double useTime;
  int currentPage;
  int totalPages;
  List<Book> books;

  BookSearchResult(this.resultCount, this.useTime, this.currentPage, this.totalPages, this.books);

  @override
  String toString() {
    return 'BookSearchResult{resultCount: $resultCount, useTime: $useTime, currentPage: $currentPage, totalPages: $totalPages, books: $books}';
  }
}
