import 'package:hive/hive.dart';

part 'search_history.g.dart';

@HiveType(typeId: 1)
class SearchHistoryItem {
  @HiveField(0)
  String keyword = '';

  @HiveField(1)
  DateTime time = DateTime.now();

  @override
  String toString() {
    return 'SearchHistoryItem{keyword: $keyword, time: $time}';
  }
}
