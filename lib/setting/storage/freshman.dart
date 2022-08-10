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
  static const familiars = '$namespace/familiars';
}

//TODO 修复 List相关序列化Bug

class FreshmanCacheStorage implements FreshmanCacheDao {
  final Box<dynamic> box;
  FreshmanCacheStorage(this.box);

  //抽离get
  dynamic getModel(String key, dynamic model) {
    String? json = box.get(key);
    if (json == null) return null;

    switch (model.runtimeType) {
      case Analysis:
      case FreshmanInfo:
        return model.fromJson(jsonDecode(json));
      case Mate:
      case Familiar:
        List<Map<String, dynamic>> list = jsonDecode(json);
        return list.map((e) => model.fromJson(e)).toList();
      default:
        return null;
    }
  }

  //抽离set
  void setModel(String key, dynamic foo, dynamic model) {
    if (foo == null) {
      box.put(key, null);
      return;
    }
    switch (model.runtimeType) {
      case Analysis:
      case FreshmanInfo:
        String json = jsonEncode(foo.toJson());
        box.put(key, json);
        return;
      case Mate:
      case Familiar:
        List<Map<String, dynamic>> list = foo.map((e) => e.toJson()).toList();
        String json = jsonEncode(list);
        box.put(key, json);
    }
  }

  @override
  Analysis? get analysis => getModel(FreshmanCacheKeys.analysis, Analysis);

  @override
  set analysis(Analysis? foo) => setModel(FreshmanCacheKeys.analysis, foo, Analysis());

  @override
  FreshmanInfo? get basicInfo => getModel(FreshmanCacheKeys.basicInfo, FreshmanInfo);

  @override
  set basicInfo(FreshmanInfo? foo) => setModel(FreshmanCacheKeys.basicInfo, foo, FreshmanInfo);

  @override
  List<Familiar>? get familiars {
    String? json = box.get(FreshmanCacheKeys.familiars);
    if (json == null) return null;
    print(jsonDecode(json));
    return null;
  }

  @override
  set familiars(List<Familiar>? foo) {
    if (foo == null) {
      box.put(FreshmanCacheKeys.familiars, null);
      return;
    }
    List<Map<String, dynamic>> list = foo.map((e) => e.toJson()).toList();
    String json = jsonEncode(list);
    box.put(FreshmanCacheKeys.familiars, json);
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
