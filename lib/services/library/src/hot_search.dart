import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';

import 'constants.dart';

part 'hot_search.g.dart';

@JsonSerializable()
class HotSearchItem {
  String hotSearchWord;
  int count;
  HotSearchItem(this.hotSearchWord, this.count);

  static HotSearchItem parse(String rawText) {
    var texts = rawText.split('(').map((e) => e.trim()).toList();
    texts[1] = texts[1].substring(0, texts[1].length - 1);
    return HotSearchItem(texts[0], int.parse(texts[1]));
  }

  factory HotSearchItem.fromJson(Map<String, dynamic> json) =>
      _$HotSearchItemFromJson(json);
  Map<String, dynamic> toJson() => _$HotSearchItemToJson(this);
}

@JsonSerializable()
class HotSearch {
  List<HotSearchItem> recentMonth = [];
  List<HotSearchItem> totalTime = [];
  HotSearch(this.recentMonth, this.totalTime);

  static Future<HotSearch> request() async {
    var response = await Dio().get(Constants.hotSearchUrl);
    var fieldsets = BeautifulSoup(response.data).findAll('fieldset');

    List<HotSearchItem> getHotSearchItems(Bs4Element fieldset) {
      return fieldset
          .findAll('a')
          .map((e) => HotSearchItem.parse(e.text))
          .toList();
    }

    return HotSearch(
        getHotSearchItems(fieldsets[0]), getHotSearchItems(fieldsets[0]));
  }

  factory HotSearch.fromJson(Map<String, dynamic> json) =>
      _$HotSearchFromJson(json);
  Map<String, dynamic> toJson() => _$HotSearchToJson(this);
}
