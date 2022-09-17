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
import 'package:kite/abstract/abstract_service.dart';
import 'package:kite/abstract/abstract_session.dart';

import 'dao.dart';
import 'entity.dart';

class ElectricityService extends AService implements ElectricityServiceDao {
  static const String _baseUrl = '/electricity/room';

  ElectricityService(ISession session) : super(session);

  @override
  Future<Balance> getBalance(String room) async {
    final response =
        await session.request('$_baseUrl/$room', RequestMethod.get);

    Balance balance = Balance.fromJson(response.data);

    return balance;
  }

  @override
  Future<List<DailyBill>> getDailyBill(String room) async {
    final response =
        await session.request('$_baseUrl/$room/bill/days', RequestMethod.get);
    List<dynamic> list = response.data;
    return list.map((e) => DailyBill.fromJson(e)).toList();
  }

  @override
  Future<List<HourlyBill>> getHourlyBill(String room) async {
    final response =
        await session.request('$_baseUrl/$room/bill/hours', RequestMethod.get);
    List<dynamic> list = response.data;
    return list.map((e) => HourlyBill.fromJson(e)).toList();
  }

  @override
  Future<Rank> getRank(String room) async {
    final response =
        await session.request('$_baseUrl/$room/rank', RequestMethod.get);
    final rank = Rank.fromJson(response.data);

    return rank;
  }
}
