import 'package:hive/hive.dart';
import 'package:kite/global/hive_type_id_pool.dart';

part 'search_history.g.dart';

@HiveType(typeId: HiveTypeIdPool.librarySearchHistoryItem)
class LibrarySearchHistoryItem extends HiveObject {
  @HiveField(0)
  String keyword = '';

  @HiveField(1)
  DateTime time = DateTime.now();

  @override
  String toString() {
    return 'SearchHistoryItem{keyword: $keyword, time: $time}';
  }
}
