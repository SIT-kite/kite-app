/*
 *    上应小风筝(SIT-kite)  便利校园，一步到位
 *    Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 *    This program is free software: you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation, either version 3 of the License, or
 *    (at your option) any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
import 'package:kite/backend.dart';
import 'package:kite/network/session.dart';
import 'package:kite/util/logger.dart';

import 'entity.dart';
import 'interface.dart';

class FunctionOverrideService implements FunctionOverrideServiceDao {
  final ISession session;

  const FunctionOverrideService(this.session);

  @override
  Future<FunctionOverrideInfo> get() async {
    Log.info('获取拉取动态路由配置');
    final response = await session.request('${Backend.kiteStatic}/override.json', ReqMethod.get);
    return FunctionOverrideInfo.fromJson(response.data);
  }
}
