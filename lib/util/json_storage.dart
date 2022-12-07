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

import 'package:hive/hive.dart';

class JsonStorage {
  final Box<dynamic> box;

  JsonStorage(this.box);

  void setModel<T>(
    String key,
    T? model,
    Map<String, dynamic> Function(T e) toJson,
  ) {
    if (model == null) {
      box.put(key, null);
      return;
    }
    box.put(key, jsonEncode(toJson(model)));
  }

  T? getModel<T>(String key, T Function(Map<String, dynamic>) fromJson) {
    String? json = box.get(key);
    if (json == null) return null;
    try {
      return fromJson(jsonDecode(json));
    } on Exception {
      return null;
    }
  }

  List<T>? getModelList<T>(
    String key,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    String? json = box.get(key);
    if (json == null) return null;
    List<dynamic> list = jsonDecode(json);
    try {
      return list.map((e) => fromJson(e)).toList();
    } on Exception {
      return null;
    }
  }

  void setModelList<T>(
    String key,
    List<T>? foo,
    Map<String, dynamic> Function(T e) toJson,
  ) {
    if (foo == null) {
      box.put(key, null);
      return;
    }
    // 不为空时
    List<Map<String, dynamic>> list = foo.map((e) => toJson(e)).toList();
    String json = jsonEncode(list);
    box.put(key, json);
  }
}
