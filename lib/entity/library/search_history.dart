import 'package:json_annotation/json_annotation.dart';

part 'search_history.g.dart';

@JsonSerializable()
class SearchHistoryItem {
  final String keyword;
  final DateTime time;
  const SearchHistoryItem(this.keyword, this.time);

  factory SearchHistoryItem.fromJson(Map<String, dynamic> json) =>
      _$SearchHistoryItemFromJson(json);

  Map<String, dynamic> toJson() => _$SearchHistoryItemToJson(this);

  @override
  String toString() {
    return 'SearchHistoryItem{keyword: $keyword, time: $time}';
  }
}

@JsonSerializable()
class SearchHistory {
  final List<SearchHistoryItem> itemList;
  const SearchHistory(this.itemList);

  factory SearchHistory.fromJson(Map<String, dynamic> json) =>
      _$SearchHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$SearchHistoryToJson(this);

  @override
  String toString() {
    return 'SearchHistory{itemList: $itemList}';
  }
}
