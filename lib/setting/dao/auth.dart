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

enum UserType {
  /// 本、专科生（10位学号）
  undergraduate,

  /// 研究生（9位学号）
  postgraduate,

  /// 教师（4位工号）
  teacher,

  /// 未入学的新生
  freshman,
}

abstract class AuthSettingDao {
  /// 获取当前登录用户的用户名
  String? get currentUsername;

  /// 设置一个null表示退出登录当前用户
  set currentUsername(String? foo);

  /// 获取当前登录用户的用户名
  String? get ssoPassword;

  /// 设置一个null表示退出登录当前用户
  set ssoPassword(String? foo);

  /// 获取用户姓名信息
  String? get personName;

  /// 设置用户姓名
  set personName(String? foo);

  /// 计算用户类型
  UserType? get userType;
}
