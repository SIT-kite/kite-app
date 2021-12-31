import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:kite/services/library/constants.dart';
import 'package:dio/dio.dart';

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
}

class BookSearchResult {
  int resultCount;
  double useTime;
  int currentPage;
  int totalPages;
  List<Book> books;
  BookSearchResult(this.resultCount, this.useTime, this.currentPage,
      this.totalPages, this.books);
}

class SearchLibraryRequest {
  // 搜索关键字
  String keyword;
  // 搜索结果数量
  int rows;
  // 搜索分页号
  int page;
  // 搜索方式
  SearchWay searchWay;
  // 搜索结果的排序方式
  SortWay sortWay;
  // 搜索结果的升降序方式
  SortOrder sortOrder;

  SearchLibraryRequest({
    this.keyword = '',
    this.rows = 10,
    this.page = 1,
    this.searchWay = SearchWay.any,
    this.sortWay = SortWay.matchScore,
    this.sortOrder = SortOrder.asc,
  });

  Future<BookSearchResult> request() async {
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
      String getBookInfo(String selector) {
        return e.find(selector)!.text!.trim();
      }

      var bookCoverImage = e.find('.bookcover_img')!;
      var author = getBookInfo('.author-link');
      var bookId = bookCoverImage.attributes['bookrecno']!;
      var isbn = bookCoverImage.attributes['isbn']!;
      var callNo = getBookInfo('.callnosSpan');
      var publishDate =
          getBookInfo('td:nth-child(4) > div:nth-child(1) > div:nth-child(3)')
              .split('出版日期:')[1];
      var publisher = getBookInfo('.publisher-link');
      var title = getBookInfo('.title-link');
      return Book(bookId, isbn, title, author, publisher, publishDate, callNo);
    }

    var htmlElement = BeautifulSoup(response.data);

    var currentPage = 0;
    var resultNumAndTime =
        htmlElement.find('#search_meta > div:nth-child(1)')!.text;
    print(resultNumAndTime);
    var totalPages =
        htmlElement.find('div.meneame:nth-child(4) > span:nth-child(1)')!.text;
    print(totalPages);

    return BookSearchResult(
        1,
        0,
        currentPage,
        0,
        htmlElement
            .findAll('.resultTable > tbody:nth-child(1) > tr')
            .map((e) => parseBook(e))
            .toList());
  }
}
