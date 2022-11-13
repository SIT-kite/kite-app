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

import 'dao.dart';
import 'entity.dart';
import '../using.dart';

class AppointmentService implements AppointmentDao {
  static const _library = '/library';
  static const _application = '$_library/application';
  static const _notice = '$_library/notice';
  static const _status = '$_library/status';
  final ISession session;

  const AppointmentService(this.session);

  @override
  Future<ApplyResponse> apply(int period) async {
    final response = await session.request(
      _application,
      ReqMethod.post,
      data: {'period': period},
    );
    return ApplyResponse.fromJson(response.data);
  }

  @override
  Future<void> cancelApplication(int applyId) async {
    await session.request('$_application/$applyId', ReqMethod.delete);
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
    final response = await session.request('$_application/', ReqMethod.get, para: queryParameters);
    List raw = response.data;
    return raw.map((e) => ApplicationRecord.fromJson(e)).toList();
  }

  @override
  Future<String> getApplicationCode(int applyId) async {
    final response = await session.request('$_application/$applyId/code', ReqMethod.get);
    return jsonEncode(response.data);
  }

  @override
  Future<Notice?> getNotice() async {
    final response = await session.request(_notice, ReqMethod.get);
    if (response.data == null) return null;
    return Notice.fromJson(response.data);
  }

  @override
  Future<List<PeriodStatusRecord>> getPeriodStatus(DateTime dateTime) async {
    final response = await session.request('$_status/${dateTime.yyyyMMdd}/', ReqMethod.get);
    List raw = response.data;
    return raw.map((e) => PeriodStatusRecord.fromJson(e)).toList();
  }

  @override
  Future<void> updateApplication(int applyId, int status) async {
    await session.request('$_application/$applyId', ReqMethod.patch, data: {'status': status});
  }

  @override
  Future<CurrentPeriodResponse> getCurrentPeriod() async {
    final response = await session.request('$_library/current', ReqMethod.get);
    return CurrentPeriodResponse.fromJson(response.data);
  }

  @override
  Future<String> getRsaPublicKey() async {
    final response = await session.request('$_library/publicKey', ReqMethod.get);
    return response.data;
  }
}
