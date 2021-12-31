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
  return {SearchWay.any: ''}[sw]!;
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
  return {SortWay.matchScore: 'score'}[sw]!;
}

enum SortOrder {
  asc,
  desc,
}

String sortOrderToString(SortOrder sw) {
  return {SortOrder.asc: 'asc', SortOrder.desc: 'desc'}[sw]!;
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
}
