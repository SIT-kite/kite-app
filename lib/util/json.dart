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
import 'dart:convert';

extension JsonConverterJson2ObjEx on String {
  T? toObject<T>(T Function(Map<String, dynamic>) fromJson) {
    try {
      return fromJson(jsonDecode(this));
    } on Exception {
      return null;
    }
  }

  List<T>? toList<T>(T Function(Map<String, dynamic>) fromJson) {
    List<dynamic> list = jsonDecode(this);
    try {
      return list.map((e) => fromJson(e)).toList();
    } on Exception {
      return null;
    }
  }
}

extension JsonConverterObj2JsonEx<T> on T {
  String toJson(Map<String, dynamic> Function(T e) toJson) {
    if (this is List) {
      List<Map<String, dynamic>> list = (this as List).map((e) => toJson(e)).toList();
      return jsonEncode(list);
    } else {
      return jsonEncode(toJson(this));
    }
  }
}
