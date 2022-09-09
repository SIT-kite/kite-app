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

import '../dao/electricity.dart';
import '../entity/electricity.dart';

class ElectricityService extends AService implements ElectricityServiceDao {
  static const String _baseUrl = '/electricity/room';

  ElectricityService(ASession session) : super(session);

  @override
  Future<Balance> getBalance(String room) async {
    final response = await session.get('$_baseUrl/$room');

    Balance balance = Balance.fromJson(response.data);

    return balance;
  }

  @override
  Future<List<Bill>> getDailyBill(String room) async {
    final response = await session.get('$_baseUrl/$room/bill/days');
    List<dynamic> list = response.data;
    return list.map((e) => Bill.fromJson(e)).toList();
  }

  @override
  Future<List<Bill>> getHourlyBill(String room) async {
    final response = await session.get('$_baseUrl/$room/bill/hours');
    List<dynamic> list = response.data;
    return list.map((e) => Bill.fromJson(e)).toList();
  }

  @override
  Future<Rank> getRank(String room) async {
    final response = await session.get('$_baseUrl/$room/rank');
    final rank = Rank.fromJson(response.data);

    return rank;
  }
}
