import 'package:dio/dio.dart';
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import './constants.dart';

class HotSearchItem {
  String hotSearchWord;
  int count;
  HotSearchItem(this.hotSearchWord, this.count);

  static HotSearchItem parse(String rawText) {
    var texts = rawText.split('(').map((e) => e.trim()).toList();
    texts[1] = texts[1].substring(0, texts[1].length - 1);
    return HotSearchItem(texts[0], int.parse(texts[1]));
  }

  Map<String, dynamic> toMap() {
    return {'hotSearchWord': hotSearchWord, 'count': count};
  }
}

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
          .map((e) => HotSearchItem.parse(e.text!))
          .toList();
    }

    return HotSearch(
        getHotSearchItems(fieldsets[0]), getHotSearchItems(fieldsets[0]));
  }

  Map<String, dynamic> toMap() {
    return {
      'recentMonth': recentMonth.map((e) => e.toMap()).toList(),
      'totalTime': totalTime.map((e) => e.toMap()).toList(),
    };
  }
}
