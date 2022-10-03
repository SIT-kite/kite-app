/*
 * 上应小风筝  便利校园，一步到位
 * Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:kite/network/session.dart';

import '../dao/hot_search.dart';
import '../entity/hot_search.dart';
import 'constant.dart';

class HotSearchService implements HotSearchDao {
  final ISession session;

  const HotSearchService(this.session);

  HotSearchItem _parse(String rawText) {
    final texts = rawText.split('(').map((e) => e.trim()).toList();
    final title = texts.sublist(0, texts.length - 1).join('(');
    final numWithRight = texts[texts.length - 1];
    final numText = numWithRight.substring(0, numWithRight.length - 1);
    return HotSearchItem(title, int.parse(numText));
  }

  @override
  Future<HotSearch> getHotSearch() async {
    var response = await session.request(Constants.hotSearchUrl, ReqMethod.get);
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
