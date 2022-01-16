import 'package:kite/dao/library/book_search.dart';
import 'package:kite/entity/library/book_search.dart';

class BookSearchMock implements BookSearchDao {
  @override
  Future<BookSearchResult> search({
    String keyword = '',
    int rows = 10,
    int page = 1,
    SearchWay searchWay = SearchWay.title,
    SortWay sortWay = SortWay.matchScore,
    SortOrder sortOrder = SortOrder.desc,
  }) {
    // TODO: implement search
    throw UnimplementedError();
  }
}
