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

import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:kite/abstract/abstract_service.dart';
import 'package:kite/abstract/abstract_session.dart';
import 'package:kite/feature/library/appointment/dao.dart';
import 'package:kite/feature/library/appointment/entity.dart';
import 'package:kite/util/date_format.dart';

class AppointmentService extends AService implements AppointmentDao {
  static const _library = '/library';
  static const _application = '$_library/application';
  static const _notice = '$_library/notice';
  static const _status = '$_library/status';

  AppointmentService(ISession session) : super(session);

  @override
  Future<ApplyResponse> apply(int period) async {
    final response = await session.request(
      _application,
      RequestMethod.post,
      data: {'period': period},
    );
    return ApplyResponse.fromJson(response.data);
  }

  @override
  Future<void> cancelApplication(int applyId) async {
    await session.request('$_application/$applyId', RequestMethod.delete);
  }

  @override
  Future<List<ApplicationRecord>> getApplication({
    int? period,
    String? username,
    DateTime? date,
  }) async {
    Map<String, String> queryParameters = {};
    if (period != null) {
      queryParameters = {'period': period.toString()};
    }
    if (username != null) {
      queryParameters = {'user': username};
    }
    if (date != null) {
      queryParameters['date'] = DateFormat('yyyyMMdd').format(date);
    }
    final response = await session.request('$_application/', RequestMethod.get, queryParameters: queryParameters);
    List raw = response.data;
    return raw.map((e) => ApplicationRecord.fromJson(e)).toList();
  }

  @override
  Future<String> getApplicationCode(int applyId) async {
    final response = await session.request('$_application/$applyId/code', RequestMethod.get);
    return jsonEncode(response.data);
  }

  @override
  Future<Notice?> getNotice() async {
    final response = await session.request(_notice, RequestMethod.get);
    if (response.data == null) return null;
    return Notice.fromJson(response.data);
  }

  @override
  Future<List<PeriodStatusRecord>> getPeriodStatus(DateTime dateTime) async {
    final response = await session.request('$_status/${dateTime.yyyyMMdd}/', RequestMethod.get);
    List raw = response.data;
    return raw.map((e) => PeriodStatusRecord.fromJson(e)).toList();
  }

  @override
  Future<void> updateApplication(int applyId, int status) async {
    await session.request('$_application/$applyId', RequestMethod.patch, data: {'status': status});
  }

  @override
  Future<CurrentPeriodResponse> getCurrentPeriod() async {
    final response = await session.request('$_library/current', RequestMethod.get);
    return CurrentPeriodResponse.fromJson(response.data);
  }

  @override
  Future<String> getRsaPublicKey() async {
    final response = await session.request('$_library/publicKey', RequestMethod.get);
    return response.data;
  }
}
