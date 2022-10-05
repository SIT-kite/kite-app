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

import 'entity.dart';

abstract class AppointmentDao {
  /// 获取图书馆公告
  /// 返回一个 html 文档
  Future<Notice?> getNotice();

  /// 查询图书馆某日场次和剩余座位情况
  Future<List<PeriodStatusRecord>> getPeriodStatus(DateTime dateTime);

  /// 查询自己的所有预约记录
  Future<List<ApplicationRecord>> getApplication({int? period, String? username, DateTime? date});

  /// 查询预约凭证
  Future<String> getApplicationCode(int applyId);

  /// 获取RSA加密公钥
  Future<String> getRsaPublicKey();

  /// 申请座位
  /// 返回applyId
  Future<ApplyResponse> apply(int period);

  /// 更新预约状态
  Future<void> updateApplication(int applyId, int status);

  /// 取消预约状态
  Future<void> cancelApplication(int applyId);

  /// 获取当前开放场次
  Future<CurrentPeriodResponse> getCurrentPeriod();
}
