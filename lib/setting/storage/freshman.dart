import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:kite/feature/freshman/entity.dart';
import 'package:kite/setting/dao/freshman.dart';

class FreshmanCacheKeys {
  static const namespace = '/freshman';
  static const basicInfo = '$namespace/basicInfo';
  static const classmates = '$namespace/classmates';
  static const roommates = '$namespace/roommates';
  static const analysis = '$namespace/analysis';
}

class FreshmanCacheStorage implements FreshmanCacheDao {
  final Box<dynamic> box;
  FreshmanCacheStorage(this.box);

  @override
  Analysis? get analysis {
    String? json = box.get(FreshmanCacheKeys.analysis);
    if (json == null) return null;
    return Analysis.fromJson(jsonDecode(json));
  }

  @override
  set analysis(Analysis? foo) {
    if (foo == null) {
      box.put(FreshmanCacheKeys.analysis, null);
      return;
    }
    String json = jsonEncode(foo.toJson());
    box.put(FreshmanCacheKeys.analysis, json);
  }

  @override
  FreshmanInfo? get basicInfo {
    String? json = box.get(FreshmanCacheKeys.basicInfo);
    if (json == null) return null;
    return FreshmanInfo.fromJson(jsonDecode(json));
  }

  @override
  set basicInfo(FreshmanInfo? foo) {
    if (foo == null) {
      box.put(FreshmanCacheKeys.basicInfo, null);
      return;
    }
    // 不为空时
    String json = jsonEncode(foo.toJson());
    box.put(FreshmanCacheKeys.basicInfo, json);
  }

  List<Mate>? _getMates(String key) {
    String? json = box.get(key);
    if (json == null) return null;
    List<Map<String, dynamic>> list = jsonDecode(json);
    return list.map((e) => Mate.fromJson(e)).toList();
  }

  void _setMates(String key, List<Mate>? foo) {
    if (foo == null) {
      box.put(key, null);
      return;
    }
    // 不为空时
    List<Map<String, dynamic>> list = foo.map((e) => e.toJson()).toList();
    String json = jsonEncode(list);
    box.put(key, json);
  }

  @override
  List<Mate>? get classmates => _getMates(FreshmanCacheKeys.classmates);

  @override
  set classmates(List<Mate>? foo) => _setMates(FreshmanCacheKeys.classmates, foo);

  @override
  List<Mate>? get roommates => _getMates(FreshmanCacheKeys.roommates);

  @override
  set roommates(List<Mate>? foo) => _setMates(FreshmanCacheKeys.roommates, foo);
}
