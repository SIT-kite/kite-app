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
abstract class NetworkSettingDao {
  // 代理服务器地址
  String get proxy;

  set proxy(String foo);

  // 是否启用代理
  bool get useProxy;

  set useProxy(bool foo);

  // 全局模式（无视 dio 初始化时的代理规则）
  bool get isGlobalProxy;

  set isGlobalProxy(bool foo);
}
