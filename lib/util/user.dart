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
import 'package:kite/storage/init.dart';

enum UserType {
  /// 本、专科生（10位学号）
  undergraduate,

  /// 研究生（9位学号）
  postgraduate,

  /// 教师（4位工号）
  teacher,

  /// 未入学的新生
  freshman,
  offline,
}

class AccountUtils {
  static final RegExp reUndergraduateId = RegExp(r'^(\d{6}[YGHE\d]\d{3})$');
  static final RegExp rePostgraduateId = RegExp(r'^(\d{2}6\d{6})$');
  static final RegExp reTeacherId = RegExp(r'^(\d{4})$');

  static UserType? guessUserType(String username) {
    if (username.length == 10 && reUndergraduateId.hasMatch(username.toUpperCase())) {
      return UserType.undergraduate;
    } else if (username.length == 9 && rePostgraduateId.hasMatch(username)) {
      return UserType.postgraduate;
    } else if (username.length == 4 && reTeacherId.hasMatch(username)) {
      return UserType.teacher;
    }
    return null;
  }

  static UserType? getAuthUserType() {
    final username = Kv.auth.currentUsername;
    final ssoPassword = Kv.auth.ssoPassword;
    // 若用户名存在
    if (username != null && ssoPassword != null) {
      // 已登录用户, 账号格式一定是合法的
      return guessUserType(username)!;
    }
    // 若用户名不存在且新生用户存在
    if (Kv.freshman.freshmanAccount != null) {
      return UserType.freshman;
    }
    return null;
  }

  static UserType getUserType() {
    return getAuthUserType() ?? UserType.offline;
  }
}
