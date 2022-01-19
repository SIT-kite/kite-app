import 'package:hive/hive.dart';
import 'package:kite/dao/library/search_history.dart';
import 'package:kite/entity/library/search_history.dart';

class SearchHistoryStorage implements SearchHistoryDao {
  final Box<LibrarySearchHistoryItem> box;
  const SearchHistoryStorage(this.box);

  @override
  void add(LibrarySearchHistoryItem item) {
    box.put(item.keyword, item);
  }

  @override
  void delete(String record) {
    box.delete(record);
  }

  @override
  void deleteAll() {
    box.deleteAll(box.keys);
  }

  @override
  List<LibrarySearchHistoryItem> getAllByTimeDesc() {
    var result = box.values.toList();
    result.sort((a, b) => b.time.compareTo(a.time));
    return result;
  }
}
