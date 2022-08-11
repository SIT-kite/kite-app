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

class FreshmanCacheStorage implements FreshmanCacheDao {
  final Box<dynamic> box;
  FreshmanCacheStorage(this.box);

  void _setModel<T>(
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

  T? _getModel<T>(String key, T Function(Map<String, dynamic>) fromJson) {
    String? json = box.get(key);
    if (json == null) return null;
    return fromJson(jsonDecode(json));
  }

  List<T>? _getModelList<T>(
    String key,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    String? json = box.get(key);
    if (json == null) return null;
    List<dynamic> list = jsonDecode(json);
    return list.map((e) => fromJson(e)).toList();
  }

  void _setModelList<T>(
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

  @override
  Analysis? get analysis => _getModel(FreshmanCacheKeys.analysis, Analysis.fromJson);

  @override
  set analysis(Analysis? foo) => _setModel<Analysis>(FreshmanCacheKeys.analysis, foo, (e) => e.toJson());

  @override
  FreshmanInfo? get basicInfo => _getModel(FreshmanCacheKeys.basicInfo, FreshmanInfo.fromJson);

  @override
  set basicInfo(FreshmanInfo? foo) => _setModel<FreshmanInfo>(FreshmanCacheKeys.basicInfo, foo, (e) => e.toJson());

  @override
  List<Familiar>? get familiars => _getModelList(FreshmanCacheKeys.familiars, Familiar.fromJson);

  @override
  set familiars(List<Familiar>? foo) => _setModelList<Familiar>(FreshmanCacheKeys.familiars, foo, (e) => e.toJson());

  @override
  List<Mate>? get classmates => _getModelList(FreshmanCacheKeys.classmates, Mate.fromJson);

  @override
  set classmates(List<Mate>? foo) => _setModelList<Mate>(FreshmanCacheKeys.classmates, foo, (e) => e.toJson());

  @override
  List<Mate>? get roommates => _getModelList(FreshmanCacheKeys.roommates, Mate.fromJson);

  @override
  set roommates(List<Mate>? foo) => _setModelList<Mate>(FreshmanCacheKeys.roommates, foo, (e) => e.toJson());
}
