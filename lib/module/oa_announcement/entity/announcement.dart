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
import 'attachment.dart';

class AnnounceDetail {
  /// 标题
  String title = '';

  /// 发布时间
  DateTime dateTime = DateTime.now();

  /// 发布部门
  String department = '';

  /// 发布者
  String author = '';

  /// 阅读人数
  int readNumber = 0;

  /// 内容(html格式)
  String content = '';

  /// 附件
  List<Attachment> attachments = [];

  @override
  String toString() {
    return 'BulletinDetail{title: $title, dateTime: $dateTime, department: $department, author: $author, readNumber: $readNumber, content: $content, attachments: $attachments}';
  }
}

/// 通知分类
class AnnounceCatalogue {
  /// 分类名
  final String name;

  /// 分类代号(OA上命名为pen，以pe打头)
  final String id;

  const AnnounceCatalogue(this.name, this.id);
}

/// 某篇通知的记录信息，根据该信息可寻找到对应文章
class BulletinRecord {
  /// 标题
  String title = '';

  /// 文章id
  String uuid = '';

  /// 目录id
  String bulletinCatalogueId = '';

  /// 发布时间
  DateTime dateTime = DateTime.now();

  /// 发布部门
  String department = '';

  @override
  String toString() {
    return 'BulletinRecord{title: $title, uuid: $uuid, bulletinCatalogueId: $bulletinCatalogueId, dateTime: $dateTime, department: $department}';
  }
}
