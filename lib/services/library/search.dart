import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kite/services/library/constants.dart';
import 'package:dio/dio.dart';

part 'search.g.dart';

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
  // 控制号
  ctrlNo,
  // 订购号
  orderNo,
  // 出版社
  publisher,
  // 索书号
  callNo,
}

String searchWayToString(SearchWay sw) {
  return {
    SearchWay.any: '',
    SearchWay.title: 'title',
    SearchWay.titleProper: 'title200a',
    SearchWay.isbn: 'isbn',
    SearchWay.author: 'author',
    SearchWay.subjectWord: 'subject',
    SearchWay.classNo: 'class',
    SearchWay.ctrlNo: 'ctrlno',
    SearchWay.orderNo: 'orderno',
    SearchWay.publisher: 'publisher',
    SearchWay.callNo: 'callno',
  }[sw]!;
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

String sortWayToString(SortWay sw) {
  return {
    SortWay.matchScore: 'score',
    SortWay.publishDate: 'pubdate_sort',
    SortWay.subject: 'subject_sort',
    SortWay.title: 'title_sort',
    SortWay.author: 'author_sort',
    SortWay.callNo: 'callno_sort',
    SortWay.pinyin: 'pinyin_sort',
    SortWay.loanCount: 'loannum_sort',
    SortWay.renewCount: 'renew_sort',
    SortWay.titleWeight: 'title200Weight',
    SortWay.titleProperWeight: 'title200aWeight',
    SortWay.volume: 'title200h',
  }[sw]!;
}

enum SortOrder {
  asc,
  desc,
}

String sortOrderToString(SortOrder sw) {
  return {
    SortOrder.asc: 'asc',
    SortOrder.desc: 'desc',
  }[sw]!;
}

@JsonSerializable()
class Book {
  String bookId;
  String isbn;
  String title;
  String author;
  String publisher;
  String publishDate;
  String callNo;
  Book(this.bookId, this.isbn, this.title, this.author, this.publisher,
      this.publishDate, this.callNo);

  factory Book.fromJson(Map<String, dynamic> json) => _$BookFromJson(json);
  Map<String, dynamic> toJson() => _$BookToJson(this);
}

@JsonSerializable()
class BookSearchResult {
  int resultCount;
  double useTime;
  int currentPage;
  int totalPages;
  List<Book> books;
  BookSearchResult(this.resultCount, this.useTime, this.currentPage,
      this.totalPages, this.books);

  factory BookSearchResult.fromJson(Map<String, dynamic> json) =>
      _$BookSearchResultFromJson(json);
  Map<String, dynamic> toJson() => _$BookSearchResultToJson(this);
}

Future<BookSearchResult> searchBook({
  String keyword = '',
  int rows = 10,
  int page = 1,
  SearchWay searchWay = SearchWay.title,
  SortWay sortWay = SortWay.matchScore,
  SortOrder sortOrder = SortOrder.desc,
}) async {
  var response = await Dio().get(
    Constants.searchUrl,
    queryParameters: {
      'q': keyword,
      'searchType': 'standard',
      'isFacet': 'true',
      'view': 'standard',
      'searchWay': searchWayToString(searchWay),
      'rows': rows.toString(),
      'sortWay': sortWayToString(sortWay),
      'sortOrder': sortOrderToString(sortOrder),
      'hasholding': '1',
      'searchWay0': 'marc',
      'logical0': 'AND',
      'page': page.toString(),
    },
  );

  Book parseBook(Bs4Element e) {
    // 获得图书信息
    String getBookInfo(String name, String selector) {
      return e.find(name, selector: selector)!.text.trim();
    }

    var bookCoverImage = e.find('img', class_: 'bookcover_img')!;
    var author = getBookInfo('a', '.author-link');
    var bookId = bookCoverImage.attributes['bookrecno']!;
    var isbn = bookCoverImage.attributes['isbn']!;
    var callNo = getBookInfo('span', '.callnosSpan');
    var publishDate =
        getBookInfo('div', 'div').split('出版日期:')[1].split('\n')[0].trim();

    var publisher = getBookInfo('a', '.publisher-link');
    var title = getBookInfo('a', '.title-link');
    return Book(bookId, isbn, title, author, publisher, publishDate, callNo);
  }

  var htmlElement = BeautifulSoup(response.data);

  var currentPage =
      htmlElement.find('b', selector: '.meneame > b')!.text.trim();
  var resultNumAndTime = htmlElement
      .find(
        'div',
        selector: '#search_meta > div:nth-child(1)',
      )!
      .text;
  var resultCount = int.parse(RegExp(r'检索到: (\S*) 条结果')
      .allMatches(resultNumAndTime)
      .first
      .group(1)!
      .replaceAll(',', ''));
  var useTime = double.parse(
      RegExp(r'检索时间: (\S*) 秒').allMatches(resultNumAndTime).first.group(1)!);
  var totalPages = htmlElement
      .find('div', class_: 'meneame')!
      .find('span', class_: 'disabled')!
      .text
      .trim();

  return BookSearchResult(
      resultCount,
      useTime,
      int.parse(currentPage),
      int.parse(totalPages.substring(1, totalPages.length - 1).trim()),
      htmlElement
          .find('table', class_: 'resultTable')!
          .findAll('tr')
          .map((e) => parseBook(e))
          .toList());
}
