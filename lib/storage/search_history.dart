import 'dart:convert';

import 'package:kite/dao/library/search_history.dart';
import 'package:kite/entity/library/search_history.dart';
import 'package:kite/util/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 搜索历史的持久化层，记录型数据应当存放在sqlite中
/// 目前暂时使用SP代替
class SearchHistoryStorage implements SearchHistoryDao {
  static final _namespace = Path().forward('library');
  static final _searchHistoryKey = _namespace.forward('searchHistory').toString();
  static final _emptyHistory = jsonEncode(const SearchHistory([]).toJson());

  final SharedPreferences prefs;
  const SearchHistoryStorage(this.prefs);

  @override
  void add(SearchHistoryItem item) {
    delete(item.keyword);
    var all = getAllByTimeDesc();
    all.itemList.add(item);
    _setSearchHistory(all);
  }

  @override
  void delete(String record) {
    _setSearchHistory(
      SearchHistory(
        getAllByTimeDesc().itemList.where(
          (element) {
            return element.keyword != record;
          },
        ).toList(),
      ),
    );
  }

  @override
  void deleteAll() {
    prefs.setString(_searchHistoryKey, _emptyHistory);
  }

  @override
  SearchHistory getAllByTimeDesc() {
    String jsonStr = prefs.getString(_searchHistoryKey) ?? _emptyHistory;
    SearchHistory history = SearchHistory.fromJson(jsonDecode(jsonStr));
    history.itemList.sort((a, b) => b.time.compareTo(a.time));
    return history;
  }

  /// 替换整个搜索历史
  void _setSearchHistory(SearchHistory searchHistory) {
    prefs.setString(_searchHistoryKey, jsonEncode(searchHistory.toJson()));
  }
}
