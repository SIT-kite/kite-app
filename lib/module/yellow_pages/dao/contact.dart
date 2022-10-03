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
import '../entity/contact.dart';

/// 远程的常用电话数据访问层的接口
abstract class ContactRemoteDao {
  /// 拉取常用电话列表
  Future<List<ContactData>> getAllContacts();
}

/// 本地的常用电话数据访问接口
abstract class ContactStorageDao {
  /// 添加常用电话记录
  void add(ContactData data);

  /// 批量添加电话记录
  void addAll(List<ContactData> data);

  /// 获取所有常用电话记录
  List<ContactData> getAllContacts();

  /// 清除本地存储的常用电话记录
  void clear();
}
