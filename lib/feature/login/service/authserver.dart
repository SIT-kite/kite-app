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
import 'package:kite/abstract/abstract_session.dart';

class AuthServerService {
  final ISession session;

  const AuthServerService(this.session);

  Future<String> getPersonName() async {
    final response = await session.request(
      'https://authserver.sit.edu.cn/authserver/index.do',
      RequestMethod.get,
      options: MyOptions(
        headers: {
          'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:46.0) Gecko/20100101 Firefox/46.0',
        },
      ),
    );
    final result = BeautifulSoup(response.data).find('div', class_: 'auth_username')?.text;
    if (result != null) {
      return result.trim();
    }
    throw Exception('无法获取用户姓名');
  }
}
