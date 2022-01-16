import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:kite/dao/library/hot_search.dart';
import 'package:kite/entity/library/hot_search.dart';
import 'package:kite/services/abstract_service.dart';
import 'package:kite/services/abstract_session.dart';

import 'constants.dart';

class HotSearchService extends AService implements HotSearchDao {
  HotSearchService(ASession session) : super(session);

  HotSearchItem _parse(String rawText) {
    var texts = rawText.split('(').map((e) => e.trim()).toList();
    texts[1] = texts[1].substring(0, texts[1].length - 1);
    return HotSearchItem(texts[0], int.parse(texts[1]));
  }

  @override
  Future<HotSearch> getHotSearch() async {
    var response = await session.get(Constants.hotSearchUrl);
    var fieldsets = BeautifulSoup(response.data).findAll('fieldset');

    List<HotSearchItem> getHotSearchItems(Bs4Element fieldset) {
      return fieldset.findAll('a').map((e) => _parse(e.text)).toList();
    }

    return HotSearch(
      recentMonth: getHotSearchItems(fieldsets[0]),
      totalTime: getHotSearchItems(fieldsets[0]),
    );
  }
}
