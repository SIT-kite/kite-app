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
// Rule of student id.
final RegExp reStudentId = RegExp(r'^((\d{9})|(\d{6}[YGHE\d]\d{3}))$');

String? studentIdValidator(String? username) {
  if (username != null && username.isNotEmpty) {
    // When user complete his input, check it.
    if (((username.length == 9 || username.length == 10) && !reStudentId.hasMatch(username)) || username.length > 10) {
      return '学号格式不正确';
    }
  }
  return null;
}

/// 代理配置的正则匹配式. 格式为 (域名|IP):端口
/// 注意此处端口没有限制为 0-65535.
final RegExp reProxyString = RegExp(
    r'(([a-zA-Z0-9][-a-zA-Z0-9]{0,62}(.[a-zA-Z0-9][-a-zA-Z0-9]{0,62})+.?)|(((25[0-5])|(2[0-4]d)|(1dd)|([1-9]d)|d)(.((25[0-5])|(2[0-4]d)|(1dd)|([1-9]d)|d)){3})):\d{1,5}');

String? proxyValidator(String? proxy) {
  if (proxy != null && proxy.isNotEmpty) {
    if (!reProxyString.hasMatch(proxy)) {
      return '代理地址格式不正确';
    }
  }
  return null;
}
