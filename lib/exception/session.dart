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
// TODO: I18n msg?
/// 认证失败
class CredentialsInvalidException implements Exception {
  final String msg;

  const CredentialsInvalidException({this.msg = ''});

  @override
  String toString() {
    return msg;
  }
}

/// 操作之前需要先登录
class NeedLoginException implements Exception {
  final String msg;
  final String url;

  const NeedLoginException({this.msg = '目标操作需要登录', this.url = ''});

  @override
  String toString() {
    return msg;
  }
}

/// 未知的验证错误
class UnknownAuthException implements Exception {
  final String msg;

  const UnknownAuthException({this.msg = '未知验证错误'});

  @override
  String toString() {
    return msg;
  }
}

/// 超过最大重试次数
class MaxRetryExceedException implements Exception {
  final String msg;

  const MaxRetryExceedException({this.msg = '未知验证错误'});

  @override
  String toString() {
    return msg;
  }
}

